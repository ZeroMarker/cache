Class web.DHCApptScheduleLines Extends DHCDoc.Util.RegisteredObject
{

Query RBScheduleLinesList(HospID = "") As %Query(ROWSPEC = "RSLRowId:%String,Code:%String,Desc:%String,StartDate:%String,EndDate:%String,Notes:%String,AddUser:%String,AddLoc:%String,AddDate:%String,AddTime:%String,Default:%String")
{
}

ClassMethod RBScheduleLinesListExecute(ByRef qHandle As %Binary, HospID = "") As %Status
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s repid=$I(^CacheTemp)
	s ind=1
	s RSLRowId=0
	f  s RSLRowId=$o(^RB("RSL",RSLRowId)) q:RSLRowId=""  d
	.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_ResScheduleLines",RSLRowId,HospID)
	.s Code=$p(^RB("RSL",RSLRowId),"^",1)
	.s Desc=$p(^RB("RSL",RSLRowId),"^",2)
	.s StartDate=..%ZD($p(^RB("RSL",RSLRowId),"^",3))
	.s EndDate=..%ZD($p(^RB("RSL",RSLRowId),"^",4))
	.s Notes=$p(^RB("RSL",RSLRowId),"^",5)
	.s AddUserDr=$p(^RB("RSL",RSLRowId),"^",6)
	.s AddUser=$p($g(^SSU("SSUSR",AddUserDr)),"^",2)
	.s AddLocDr=$p(^RB("RSL",RSLRowId),"^",7)
	.s AddLoc=$p(^CTLOC(AddLocDr),"^",2)
	.s AddDate=..%ZD($p(^RB("RSL",RSLRowId),"^",8))
	.s AddTime=..%ZT($p(^RB("RSL",RSLRowId),"^",9),1)
	.s Default=$p(^RB("RSL",RSLRowId),"^",10)
	.d OutputRow
	s qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRow
    set Data=$lb(RSLRowId,Code,Desc,StartDate,EndDate,Notes,AddUser,AddLoc,AddDate,AddTime,Default)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod RBScheduleLinesListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RBScheduleLinesListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 }
	 Else      {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod RBScheduleLinesListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RBScheduleLinesListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod Save(RSLRowId As %String, para As %String, HospID = "") As %String
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("RB_ResScheduleLines",HospID)
	TS	
	s RSLCode=$p(para,"^",1)
	s RSLDesc=$p(para,"^",2)
	s RSLStartDate=$p(para,"^",3)
	if (RSLStartDate'="") s RSLStartDate=..%ZDH(RSLStartDate)
	s RSLEndDate=$p(para,"^",4)
	if (RSLEndDate'="") s RSLEndDate=..%ZDH(RSLEndDate)
	s RSLNotes=$p(para,"^",5)
	s RSLAddUserDR=$p(para,"^",6)
	s RSLAddLocDR=$p(para,"^",7)
	s Default=$p(para,"^",8)
	if (Default="Y"){
		&sql(update SQLUser.RB_ResScheduleLines set RSL_Default='N')
	}
	if (RSLRowId=""){
		Set object = ##class(User.RBResScheduleLines).%New()
		Do object.RSLAddUserDRSetObjectId(RSLAddUserDR)
		Do object.RSLAddLocDRSetObjectId(RSLAddLocDR)
		s object.RSLAddDate=..%SysDate()
		s object.RSLAddTime=..%SysTime()
	}else{
		Set object = ##class(User.RBResScheduleLines).%OpenId(RSLRowId)
	}
	s object.RSLCode=RSLCode
	s object.RSLDesc=RSLDesc
	s object.RSLStartDate=RSLStartDate
	s object.RSLEndDate=RSLEndDate
	s object.RSLNotes=RSLNotes
	s object.RSLDefault=Default
	S sc = object.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	if RSLRowId=""{
		d ##class(DHCDoc.Common.Hospital).SaveHOSP("RB_ResScheduleLines",object.%Id(),HospID)
	}
	d object.%Close()
	Tc
	Q 0
}

ClassMethod Delete(RSLRowId As %String) As %String
{
	&sql(delete from SQLUser.RB_ResScheduleLines where RSL_RowId=:RSLRowId)
	d ##class(DHCDoc.Common.Hospital).DeleteHospitals("RB_ResScheduleLines",RSLRowId)
	Q SQLCODE
}

}
