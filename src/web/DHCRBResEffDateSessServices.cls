Class web.DHCRBResEffDateSessServices Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Delete(RowId As %String) As %String
{
	&SQL(Delete From SQLUser.RB_ResEffDateSessServices Where SER_RowId=:RowId )
	Q SQLCODE
}

ClassMethod GetResServicesExecute(ByRef qHandle As %Binary, ResRowId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCRBResEffDateSessServices","GetResServices","")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if ResRowId="" {
		do ResetVariables1
		Do OutputRow1
	}else{
		s res=ResRowId
		s doctor=$p($g(^RB("RES",+res)),"^",2)
		s loc1=$p($g(^RB("RES",+res)),"^",1)
		s equip=$p($g(^RB("RES",+res)),"^",3)
		;get type of services from resource
		s servtype=$$servtype(res)

		i res,servtype="LOC" s loc=loc1
		;get services from resource
		i res,servtype="CTCP" {
		s SerRowid=0  f  s SerRowid=$O(^RBC("SER",0,"CTCP",doctor,SerRowid)) q:SerRowid=""  d
		.s ARCIMRowid=$P(^RBC("SER",SerRowid),"^",1)
		.s ARCOSRowid=$P(^RBC("SER",SerRowid),"^",2)
		.s SerDesc=$P(^RBC("SER",SerRowid),"^",6)
		.d OutputRow1
		}else{
		i res,servtype="EQ" d  q 0
		.s SerRowid=0  f  s SerRowid=$O(^RBC("SER",0,"EQ",doctor,SerRowid)) q:SerRowid=""  d
		..s ARCIMRowid=$P(^RBC("SER",SerRowid),"^",1)
		..s ARCOSRowid=$P(^RBC("SER",SerRowid),"^",2)
		..s SerDesc=$P(^RBC("SER",SerRowid),"^",6)
		..d OutputRow1
		}
	} 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(SerRowid,SerDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
ResetVariables1
	set (SerRowid,SerDesc)=""
	quit
servtype(res) ;check how service is defined for resource(for location/doctor/equipment)
	s ctcp1=$p($g(^RB("RES",+res)),"^",2)
	s loc1=$p($g(^RB("RES",+res)),"^",1)
	s equip1=$p($g(^RB("RES",+res)),"^",3)
	;first check doctor/equipment
	s found=0
	i ctcp1 d  q:found "CTCP"
	.s ser="" f  s ser=$o(^RBC("SER",0,"CTCP",+ctcp1,ser)) q:ser=""  q:found  d
	..;check if service is active
	..i $p($g(^RBC("SER",+ser)),"^",10)="N" q
	..q:$$valser(ser)  s found=1
	i equip1 d  q:found "EQ"
	.s ser="" f  s ser=$o(^RBC("SER",0,"EQ",+equip1,ser)) q:ser=""  q:found  d
	..;b
	..;check if service is active
	..i $p($g(^RBC("SER",+ser)),"^",10)="N" q
	..q:$$valser(ser)  s found=1
	;b
	q "LOC"
valser(service) ;validate service
	;check if service has service group

	;0-valid,1-invalid
	s arcim=$p($g(^RBC("SER",+service)),"^",1)
	s arcos=$p($g(^RBC("SER",+service)),"^",2)
	;filter services without service group
	q '$$chkall(arcos,arcim)
chkarcos(row) 
	i $$servgrp'="Y" q 1
	i $p($g(^ARCOS(+row)),"^",12) q 1
	q 0
chkarcim(row) 
	;q 1
	i $$servgrp'="Y" q 1
	i $p($g(^ARCIM(+row,1,8)),"^",7) q 1
	q 0
chkall(arcos,arcim) ;check both
	q ($$chkarcos(arcos)+$$chkarcim(arcim))
servgrp() ;get service restricted by service group flag
	s flag=$p($g(^CF("RB",1)),"^",14)
	s:flag="" flag="Y"
	q flag
}

ClassMethod GetResServicesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResServicesExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetResServicesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResServicesExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetResServicesStr(ResRowId As %String) As %String
{
	s ret=""
	Set rset=##class(%ResultSet).%New("web.DHCBL.BaseReg.BaseDataQuery:SeviceQuery")
	do rset.Execute()
	While (rset.Next()) {
		if ret="" s ret=rset.Data("ID")_$C(1)_rset.Data("Desc")
		e  s ret=ret_"^"_rset.Data("ID")_$C(1)_rset.Data("Desc")
	}
	d rset.Close()
	Q ret
	
	/*
	s ret=""
	Set rset=##class(%ResultSet).%New("web.DHCRBResEffDateSessServices:GetResServices")
	do rset.Execute(ResRowId)
	While (rset.Next()) {
		if ret="" s ret=rset.Data("Rowid")_$C(1)_rset.Data("Desc")
		e  s ret=ret_"^"_rset.Data("Rowid")_$C(1)_rset.Data("Desc")
	}
	d rset.Close()
	Q ret
	*/
}

ClassMethod GetServicePrice(ResSessRowId As %String) As %Float
{
	s TotalPrice=0
	s ResRowId=$P(ResSessRowId,"||",1)
	s DateRowId=$P(ResSessRowId,"||",2)
	s SessRowId=$P(ResSessRowId,"||",3)
	s SerRowId=0  f  s SerRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId,"SER",SerRowId)) Q:SerRowId=""  d
	.s SERRBCServiceDR=$P(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId,"SER",SerRowId),"^",1)
	.i SERRBCServiceDR'="" d
	..s ArcimRowid=$P(^RBC("SER",SERRBCServiceDR),"^",1)
	..i ArcimRowid'="" d
	...s SttDate=..%SysDate()
	...s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice("", "", ArcimRowid, SttDate, "", "", "", "")
	...s Price=$P(retPrice,"^",1)
	...s TotalPrice=TotalPrice+Price 
	Q $fn(TotalPrice,"",4)
}

ClassMethod Insert(ResSessRowId As %String, Para As %String) As %String
{
	s SERRBCServiceDR=$P(Para,"^",1)
	s SERReminderDays=$P(Para,"^",2)
	s ResRowId=$P(ResSessRowId,"||",1)
	s DateRowId=$P(ResSessRowId,"||",2)
	s SessRowId=$P(ResSessRowId,"||",3)
	s SERCTLOCDR=$p($g(^RB("RES",ResRowId)),"^",1)
	S SERDayOfWeekDR=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",2)
	S SERStartTime=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",4)
	Set PLIST(0)=ResSessRowId
	Set PLIST(3)=SERRBCServiceDR
	Set PLIST(4)=SERCTLOCDR
	Set PLIST(5)=ResRowId
	Set PLIST(6)=SERDayOfWeekDR
	Set PLIST(7)=SERStartTime
	Set PLIST(12)=SERReminderDays

	&SQL(Insert Into SQLUser.RB_ResEffDateSessServices values :PLIST())
	Q SQLCODE
}

ClassMethod Update(Para As %String) As %String
{
	s SerRowid=$P(Para,"^",1)
	s SERRBCServiceDR=$P(Para,"^",2)
	s SERReminderDays=$P(Para,"^",3)
	s SERDesc=$P(^RBC("SER",SERRBCServiceDR),"^",6)
	s ARCIM=$P(^RBC("SER",SERRBCServiceDR),"^",1)
	s ARCOS=$P(^RBC("SER",SERRBCServiceDR),"^",2)
	s SERARCIMARCOS=ARCIM_"&"_ARCOS
	Set object = ##class(User.RBResEffDateSessServices).%OpenId(SerRowid)
	 d object.SERRBCServiceDRSetObjectId(SERRBCServiceDR)
	 s object.SERReminderDays=SERReminderDays
	 Set sc = object.%Save()
	 If $$$ISERR(sc) {
		 Do $System.Status.DisplayError()
		 Quit 100
	 }
	 i val=1 {s val="挂号费"} else {if (val="2") {s val="诊查费"} else{if (val="3"){s val="假日费"} else {if val=4{s val="预约费"}}}}
	 d object.%Close()
	 Q 0
}

Query GetResServices(ResRowId As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "Rowid:%String,Desc:%String")
{
}

Query GetSessServices(ResSessRowId As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "SerRowid:%String,SerDesc:%String,SerRBCServiceDR:%String,SerReminderDays:%String")
{
	Select SER_Rowid,SER_Desc,Ser_RBC_Service_DR,SER_ReminderDays From SQLUser.RB_ResEffDateSessServices Where SER_ParRef=:ResSessRowId
}

}
