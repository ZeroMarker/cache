Import SQLUser

Class web.DHCOPBillReasonRefInv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillReasonRefInv","FindReasonRefInv","2")
Query FindReasonRefInv(hospId As %String) As websys.Query(ROWSPEC = "Tindex:%String,TADMReason:%String,TSareUseFareType:%String,TSareUseDept:%String,TSarePrintTemp:%String,TRowid:%String,TAdmDescDr:%String")
{
}

ClassMethod FindReasonRefInvExecute(ByRef qHandle As %Binary, hospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set SareRowID=0
	while($o(^DHCSOPADMRExp(SareRowID))) {
		set SareRowID=$o(^DHCSOPADMRExp(SareRowID))
		set HospDR=$p(^DHCSOPADMRExp(SareRowID),"^",8)
		continue:(hospId'=HospDR)
		set SareADMReasonDR=$p(^DHCSOPADMRExp(SareRowID),"^",1)
		set ADMReason=$s((SareADMReasonDR'=""):$p($g(^PAC("ADMREA",SareADMReasonDR)),"^",2),1:"")
		set UseTypeCode=$p(^DHCSOPADMRExp(SareRowID),"^",2)
		set UseTypeDR=$s((UseTypeCode'=""):$o(^DHCJFBILLADMREACON(0,UseTypeCode,0)),1:"")
		set UseTypeDesc=$s((+UseTypeDR'=0):$p(^DHCJFBILLADMREACON(UseTypeDR),"^",2),1:"")
		set SareUseDept=$p(^DHCSOPADMRExp(SareRowID),"^",3)
		set SareUseDept=$case(SareUseDept,"O":"门诊","I":"住院","R":"挂号",:"")
		set SarePrintTemp=$p(^DHCSOPADMRExp(SareRowID),"^",4)
		do OutputFR
	}
	
	quit $$$OK
OutputFR
	set Data=$lb(ind,ADMReason,UseTypeDesc,SareUseDept,SarePrintTemp,SareRowID,SareADMReasonDR)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

ClassMethod InsertReasonExp(AdmReasonRr As %String, FareType As %String, UseDept As %String, PrintTemp As %String, HospId As %String) As %String
{
	n (AdmReasonRr, FareType, UseDept, PrintTemp, HospId)
	k PLIST
	s PLIST(2)=AdmReasonRr
	s PLIST(3)=FareType
	s PLIST(4)=UseDept
	s PLIST(5)=PrintTemp
	s PLIST(9)=HospId
	s $zt="ERROR^DHCSSERR" 
	d ..tb()
	&sql(INSERT INTO DHC_SOPADMReasonExp VALUES PLIST())
	d ..tc()
	q SQLCODE
}

ClassMethod DeleteReasonExp(RowId)
{
	s $zt="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_SOPADMReasonExp WHERE SARE_RowID=:RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillReasonRefInv","ReadAdmReason","2")
Query ReadAdmReason(HospId As %String) As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod ReadAdmReasonExecute(ByRef qHandle As %Binary, HospId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	set rowId=0
	while($o(^PAC("ADMREA",rowId))) {
		set rowId=$o(^PAC("ADMREA",rowId))
		set data=$g(^PAC("ADMREA",rowId))
		continue:(data="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("PAC_AdmReason", rowId, HospId)
		continue:(showFlag="N")
		set dateFrom=$p(data,"^",3)
   		set dateTo=$p(data,"^",4)
   		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set reaDesc=$p(data,"^",2)
		do OutputAdmReason
	}
	
	quit $$$OK
OutputAdmReason
	set Data=$lb(rowId,reaDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillReasonRefInv","InvType")
Query InvType() As websys.Query(ROWSPEC = "id:%String,value:%String,text:%String")
{
}

ClassMethod InvTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
 	set id=0
 	while($o(^DHCJFBILLADMREACON(id))) {
	 	set id=$o(^DHCJFBILLADMREACON(id))
	 	set data=$g(^DHCJFBILLADMREACON(id))
		continue:(data="")
	 	set text=$p(data,"^",2)
		set value=$p(data,"^",3)
		do OutputInvType
	}
	
	quit $$$OK
    
OutputInvType
	set Data=$lb(id,value,text)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// 判断记录是否存在
/// zhli
/// 17.9.26
/// 0:存在 1:不存在
ClassMethod CheckInfo(AdmReasonRr As %String, FareType As %String, UseDept As %String, HospId As %String) As %String
{
	n (AdmReasonRr, FareType, UseDept, HospId)
	s rtn=0
	s ADMRERowId=0
	f  s ADMRERowId=$o(^DHCSOPADMRExp(ADMRERowId)) q:((ADMRERowId="")||(+rtn))  d
	.s HospDR=$p(^DHCSOPADMRExp(ADMRERowId),"^",8)
	.q:(HospId'=HospDR)
	.s AdmReaDR=$p(^DHCSOPADMRExp(ADMRERowId),"^",1)
	.q:(AdmReasonRr'=AdmReaDR)
	.s myFareType=$p(^DHCSOPADMRExp(ADMRERowId),"^",2)
	.q:(FareType'=myFareType)
	.s myUseDept=$p(^DHCSOPADMRExp(ADMRERowId),"^",3)
	.q:(UseDept'=myUseDept)
	.s rtn=1
	
	q rtn
}

}
