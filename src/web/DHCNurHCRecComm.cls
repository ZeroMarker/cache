Class web.DHCNurHCRecComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetCareRecCommExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^TMP("parr")=parr

    //s parr="316213^2010-09-21^00:00^2010-09-22^00:00^DHCNUR6"
 	//d ##class(%ResultSet).RunQuery("web.DHCNurseRecordComm","GetCareRecComm","")
 	s Adm=$P(parr,"^",1)
 	s stdate=$P(parr,"^",2)
 	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
 	s eddate=$P(parr,"^",4)
 	s eddate=##class(websys.Conversions).DateHtmlToLogical(eddate)
 	//s stdate=$ZDH($P(parr,"^",2),3)
 	//s eddate=$ZDH($P(parr,"^",4),3)
 	s StTime=$ZTH($P(parr,"^",3))
 	s EndTime=$ZTH($P(parr,"^",5))
 	s stdatetime=..GetAbsTime(stdate_","_StTime)
 	s endatetime=..GetAbsTime(eddate_","_EndTime)
 	s RecTyp=$P(parr,"^",6)
 	s RecTyp=$ZConvert(RecTyp,"U")
 	s IfCancelRec=$P(parr,"^",7)
 	s HeadDR=$P(parr,"^",8)
 	//s dep=parr
	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
    if par=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
	//分项统计对应列
	s ret=##class(Nur.DHCNurseRecSet).getSet(RecTyp)
	s PartInProperty=$P(ret,"^",3)
	s PartInNameProperty=$P(PartInProperty,"&",1)
	s PartInAmountProperty=$P(PartInProperty,"&",2)
	s PartOutProperty=$P(ret,"^",4)
	s PartOutNameProperty=$P(PartOutProperty,"&",1)
	s PartOutAmountProperty=$P(PartOutProperty,"&",2)
	
	f date=eddate:-1:stdate
	{
        s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_HeadDR,date,tim),-1) q:tim=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_HeadDR,date,tim,par,rw),-1) q:rw=""  d
        ..s arr=$G(^Nur.DHCNurseRecSubD(par,rw))
        ..s tmp=""
        ..s tmp("rw")=rw,tmp("par")=par
        ..s a=##class(Nur.DHCNurseRecSub).getVal(par_"||"_rw,.tmp)
        ..s cdate=tmp("CareDate"),ctime=tmp("CareTime")
        ..s cdatetime=..GetAbsTime(cdate_","_ctime)
        ..//s ^objcyf(cdatetime)=stdatetime_"^"_endatetime
        ..q:((cdatetime>endatetime)!(cdatetime<stdatetime))
        ..b //hh
		..s cdate=$ZD(cdate,3),ctime=$ZT(ctime,2)
		..s CaseMeasure=tmp("CaseMeasure")
		..s tmp("CareDate")=cdate,tmp("CareTime")=ctime
		..s recuserId=tmp("RecUser")
		..i recuserId'="" s tmp("User")=$p($g(^SSU("SSUSR",recuserId)),"^",2)
		..e  s tmp("User")=""
		..s recaudituserId=tmp("RecAuditUser")
		..i recaudituserId'="" s AuditUser=$p($g(^SSU("SSUSR",recaudituserId)),"^",2)
		..e  s AuditUser=""
		..i AuditUser'="" d
		...s tmp("User")=tmp("User")_" "_AuditUser
		..s reccanceluserId=tmp("RecCancelUser")
		..q:(IfCancelRec="true")&(reccanceluserId="")
		..q:(IfCancelRec'="true")&(reccanceluserId'="")
		..i reccanceluserId'="" d
		...s CancelUser=$p($g(^SSU("SSUSR",reccanceluserId)),"^",2)
		...s reccanceldate=tmp("RecCancelDate")
		...i reccanceldate'="" s reccanceldate=##class(websys.Conversions).DateLogicalToHtml(reccanceldate)
		...s reccanceltime=tmp("RecCancelTime")
		...i reccanceltime'="" s reccanceltime=$ZT(reccanceltime)
		...s tmp("User")=tmp("User")_" 作废记录:"_CancelUser_" "_reccanceldate_" "_reccanceltime
		..s tmp("par")=par
		..s tmp("rw")=rw
		..s aa=..getRet(.tmp)
		..d OutRowtyp
	 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

 
OutRowtyp
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCareRecCommFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCareRecCommExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCareRecCommClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCareRecCommExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCareRecComm(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetAbsTime(dt As %String) As %String
{
 //将日期时间转换成秒
  //n (dt)
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

ClassMethod getRet(tmp) As %String
{
	s k=""
	s ret=""
	f {
	s k=$O(tmp(k))
	q:k=""
	s ret=ret_k_"|"_tmp(k)_"^"

	}
 q ret
}

/// 
/// 科室下拉框   
Query SearchWardCode(ward = "") As %Query(ROWSPEC = "ctlocDesc,CtLocDr")
{
}

ClassMethod SearchWardCodeExecute(ByRef qHandle As %Binary, ward = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1 
 	s ward=$TR($ZConvert(ward,"U")," ","")
 	s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
 	.s a=$P(^CTLOC(rw),"^")
 	.s CtLocDr=rw
 	.s ctlocDesc=$P(^CTLOC(rw),"^",2)
 	.s cname=$P(^CTLOC(rw),"^",43)
 	.q:(ward'="")&&(cname'[ward)
 	.s dateFrom=$P(^CTLOC(rw),"^",24)
 	.s dateTo=$P(^CTLOC(rw),"^",25)
 	.s h=+$h
 	.q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
 	.q:ctlocDesc=""
    .d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchWardCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchWardCodeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchWardCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchWardCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 病区科室下拉框   
Query Wardgetloc(ward = "") As %Query(ROWSPEC = "ctlocDesc,CtLocDr")
{
}

ClassMethod WardgetlocExecute(ByRef qHandle As %Binary, ward = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1 
 	s ward=$TR($ZConvert(ward,"U")," ","")
 	s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
 	.s a=$P(^CTLOC(rw),"^")
 	.s CtLocDr=rw
 	.s ctlocDesc=$P(^CTLOC(rw),"^",2)
 	.s cname=$P(^CTLOC(rw),"^",43)
 	.q:(ward'="")&&(cname'[ward)
 	.q:ctlocDesc'["护理单元"
    .q:ctlocDesc["工作量用"
    .q:ctlocDesc["停用"
 	.s dateFrom=$P(^CTLOC(rw),"^",24)
 	.s dateTo=$P(^CTLOC(rw),"^",25)
 	.s h=+$h
 	.q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
 	.q:ctlocDesc=""
    .d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod WardgetlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WardgetlocExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod WardgetlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WardgetlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
