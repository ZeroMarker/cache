Class web.DHCEmReg Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query FindAdmReg(fromDate As %String, toDate As %String, ctLocId As %String, admType As %String) As %Query(ROWSPEC = "ctLoc:%String,dayTime:%String,sNight:%String,bNight:%String,total:%String")
{
}

ClassMethod FindAdmRegExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, ctLocId As %String, admType As %String = "E") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	i admType="" s admType="E"
	i toDate<fromDate s toDate=+$H,fromDate=+$H
	i (toDate="")||(fromDate="")  s toDate=+$H,fromDate=+$H
 	k ^DHCEmRegTemp
 	i toDate=fromDate s fromDate=fromDate-1
	f curDate=fromDate:1:toDate d
	.s admID="" 
	.f  s admID=$O(^PAADMi("PAADM_AdmDate",curDate,admID))  q:admID=""  d
	..s patType=$p($g(^PAADM(admID)),"^",2)
	..q:admType'[patType
	..s paVisit=$p($g(^PAADM(admID)),"^",20)
	..i "AD"'[paVisit q
	..s admLocId=$p($G(^PAADM(admID)),"^",4)
	..q:(ctLocId'="")&(ctLocId'=admLocId)
	..s admTime=$p($G(^PAADM(admID)),"^",7)
	..q:(curDate=fromDate)&(admTime<28200)
	..q:(curDate=toDate)&(admTime>28201)
	..i (admTime>28200)&(admTime<55801) s admRang="dayTime"
	..i (admTime>55800)&(admTime<79201) s admRang="sNight"
	..i (admTime<28201)||(admTime>79200) s admRang="bNight"
	..i $G(^DHCEmRegTemp(admLocId,admRang))="" s ^DHCEmRegTemp(admLocId,admRang)=1
	..e  s ^DHCEmRegTemp(admLocId,admRang)=^DHCEmRegTemp(admLocId,admRang)+1
    
    s (allCtLoc,allDayTime,allSNight,allBNight,allTotal)=0
    s locId=""
    f  s locId=$O(^DHCEmRegTemp(locId)) q:locId=""  d
    .s ctLoc=$P($G(^CTLOC(locId)),"^",2)
    .s (dayTime,sNight,bNight,total)=0
    .s rang=""
    .f  s rang=$O(^DHCEmRegTemp(locId,rang)) q:rang=""  d
    ..i rang="dayTime" s dayTime=$G(^DHCEmRegTemp(locId,rang))
    ..i rang="sNight" s sNight=$G(^DHCEmRegTemp(locId,rang))
    ..i rang="bNight" s bNight=$G(^DHCEmRegTemp(locId,rang))
    .s total=dayTime+sNight+bNight
    .s allDayTime=dayTime+allDayTime
    .s allSNight=allSNight+sNight
    .s allBNight=allBNight+bNight
    .s allTotal=allTotal+total
    .d OutEmReg
	s allCtLoc="总合计"
	s ctLoc=allCtLoc
	s dayTime=allDayTime
	s sNight=allSNight
	s bNight=allBNight
	s total=allTotal
	d OutEmReg
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutEmReg
	s Data=$lb(ctLoc,dayTime,sNight,bNight,total)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	quit
}

ClassMethod FindAdmRegFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmRegExecute ]
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

ClassMethod FindAdmRegClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmRegExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/*科室  */
ClassMethod GetDeptStr(AdmType As %String = "E") As %String
{
	;w ##class(web.DHCEmReg).GetDeptStr("E")
	s rset=##class(%ResultSet).%New("web.DHCEmReg:DeptList")
	s ret=""
	i AdmType=""  s AdmType="E"
	do rset.Execute(AdmType)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
		e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
	}	
	d rset.Close()
	q ret
}

Query DeptList(AdmType As %String) As %Query(ROWSPEC = "CTCode:%String,CTDesc:%String,CTAlias:%String")
{
}

ClassMethod DeptListExecute(ByRef qHandle As %Binary, AdmType As %String = "E") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	i AdmType="" s AdmType="E"
	s admlocId=""
	f  s admlocId=$o(^PAC("ADMLOC",admlocId)) q:admlocId=""  d
	.i AdmType'[$p(^PAC("ADMLOC",admlocId),"^") q
	.s ctlocId=$p(^PAC("ADMLOC",admlocId),"^",2)
	.s CTDesc=$P($p($g(^CTLOC(ctlocId)),"^",2),"-",2)
	.s CTAlias=$P($p($g(^CTLOC(ctlocId)),"^",2),"-",1)
	.s CTRowId=ctlocId
	.Do OutputRow1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(CTRowId,CTDesc,CTAlias)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod DeptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptListExecute ]
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

ClassMethod DeptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
