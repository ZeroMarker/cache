/// Descriptions:
/// Date:2018-03-08
/// Creator:gzj
Class web.NurMgLeaveComm Extends %RegisteredObject
{

/// creator: gzj
/// createDate: 2018-03-08
/// description: 查询护士请假申请名单列表
/// table: 
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgLeaveComm","FindLeaveNurses","")
Query FindLeaveNurses(role As %String, nurseid As %String, parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLeaveNursesExecute(ByRef qHandle As %Binary, role As %String, nurseid As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ward=parr
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s rw="" f  s rw=$O(^DHCNMG.DB.MgWardI("Spell",spell,rw)) q:rw=""  d
	..s RowID="" f  s RowID=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_rw,RowID)) q:RowID=""  d
	...s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	...q:(obj.PerCareType'="N") //医生过滤掉
	...q:(obj.PerTypeDR'="N") //非正式的护士过滤掉
	...s curward=##class(web.NurMgHRComm).GetCurrentWard(RowID,+$H)
	...q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))
	...q:(ward'="")&&(ward'=curward)
	...s NurseID=obj.PerID
	...s NurseName=obj.PerName_"("_NurseID_")"
	...s ret="NurseName|"_NurseName_"^NurseID|"_NurseID_"^RowID|"_RowID
	...d OutNurses
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurses
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLeaveNursesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLeaveNursesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLeaveNursesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLeaveNursesExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetNurseCardId(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret="NurseCardID|"_obj.PerCardId
	q ret
}

/// Creator:gzj
/// Date:2019-06-26
/// 
ClassMethod IsExistDateRec(parr As %String, type As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=0
	s stdate=$g(tmp("LeaveStDate"))
	s enddate=$g(tmp("LeaveEndDate"))
	i ((stdate'="")&&(stdate["-")) s stdate=$zdh(stdate,3)
	i ((enddate'="")&&(enddate["-")) s enddate=$zdh(enddate,3)
	s firstdate="" f  s firstdate=$o(^DHCNMG.Arg.MgNurLeaveAppI("date",$g(tmp("NurseName")),firstdate)) q:firstdate=""!flag=1  d
	.s secondDate="" f  s secondDate=$o(^DHCNMG.Arg.MgNurLeaveAppI("date",$g(tmp("NurseName")),firstdate,secondDate)) q:secondDate=""!flag=1  d
	..s row="" f  s row=$o(^DHCNMG.Arg.MgNurLeaveAppI("date",$g(tmp("NurseName")),firstdate,secondDate,row)) q:(row=""!flag=1)  d
	...i (((stdate>=firstdate)&&(stdate<=secondDate))!((enddate>=firstdate)&&(enddate<=secondDate))&&($g(tmp("RowID"))'=row)) s flag=1
	...e  i ((firstdate>stdate)&&(secondDate<enddate)&&($g(tmp("RowID"))'=row)) s flag=1
	q flag
}

/// Description:保存护士请假申请记录
/// Date:2018-03-09
/// Creator:guozj
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod SaveLeaveData(parr As %String, type As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=..IsExistDateRec(parr,type)
	q:flag=1 "该日期已经存在请假"
	s id=$g(tmp("RowID"))
	s warnRet=""
	i id'="" d
	.s oldStatus=..GetLeaveFlag(id)
	.i type="Y" d
	..s:(oldStatus="Y") warnRet="禁止重复提交"
	..s:(oldStatus="NH") warnRet="护士长已审核不能提交"
	..s:(oldStatus="HH") warnRet="护理部已审核不能提交"
	.e  d
	..s:(oldStatus="Y") warnRet="已提交不可修改"
	..s:(oldStatus="NH") warnRet="护士长已审核不能修改"
	..s:(oldStatus="HH") warnRet="护理部已审核不能修改"
	q:warnRet'="" warnRet
	i id="" s obj=##class(DHCNMG.Arg.MgNurLeaveApp).%New()
	e  s obj=##class(DHCNMG.Arg.MgNurLeaveApp).%OpenId(id)
	i $g(tmp("FillDate"))'="" s obj.FillDate=$zdh($tr($g(tmp("FillDate"))," ",""),3)
	e  s obj.FillDate=""
	i $g(tmp("NurseName"))'="" s obj.NurseName=##class(DHCNMG.HR.MgPersons).%OpenId($tr($g(tmp("NurseName"))," ",""))
	e  s obj.NurseName=""
	i $g(tmp("LeaveWard"))'="" s obj.LeaveWard=##class(DHCNMG.DB.MgWard).%OpenId($tr($g(tmp("LeaveWard"))," ",""))
	e  s obj.LeaveWard=""
	i $g(tmp("NurseCardID"))'="" s obj.NurseCardID=$tr($g(tmp("NurseCardID"))," ","")
	e  s obj.NurseCardID=""
	i $g(tmp("LeaveType"))'="" s obj.LeaveType=$tr($g(tmp("LeaveType"))," ","")
	e  s obj.LeaveType=""
	i $g(tmp("LeaveCause"))'="" s obj.LeaveCause=$tr($g(tmp("LeaveCause"))," ","")
	e  s obj.LeaveCause=""
	i $g(tmp("LeaveStDate"))'="" s obj.LeaveStDate=$zdh($tr($g(tmp("LeaveStDate"))," ",""),3)
	e  s obj.LeaveStDate=""
	i $g(tmp("LeaveEndDate"))'="" s obj.LeaveEndDate=$zdh($tr($g(tmp("LeaveEndDate"))," ",""),3)
	e  s obj.LeaveEndDate=""
	i $g(tmp("LeaveDays"))'="" s obj.LeaveDays=$tr($g(tmp("LeaveDays"))," ","")
	e  s obj.LeaveDays=""
	i $g(tmp("NursePhone"))'="" s obj.NursePhone=$tr($g(tmp("NursePhone"))," ","")
	e  s obj.NursePhone=""
	i $g(tmp("LeaveTrustee"))'="" s obj.LeaveTrustee=$tr($g(tmp("LeaveTrustee"))," ","")
	e  s obj.LeaveTrustee=""
	s obj.Accepter=$tr($g(tmp("Accepter"))," ","")
	s obj.LeaveStatus=type
	s sc= obj.%Save()
	if $$$ISOK(sc){
	 	q 1	
	}else{
		q 0	
	}
}

ClassMethod GetLeaveData(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgNurLeaveApp).%OpenId(id)
	i obj.FillDate'="" s FillDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.FillDate)
	e  s FillDate=""
	i obj.NurseName'="" s NurseName=obj.NurseName.%Id()
	e  s NurseName=""
	i obj.LeaveWard'="" s LeaveWard=obj.LeaveWard.%Id()
	e  s LeaveWard=""
	s NurseCardID=obj.NurseCardID
	s LeaveType=obj.LeaveType
	s LeaveCause=obj.LeaveCause
	i obj.LeaveStDate'="" s LeaveStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.LeaveStDate)
	e  s LeaveStDate=""
	i obj.LeaveEndDate'="" s LeaveEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.LeaveEndDate)
	e  s LeaveEndDate=""
	s LeaveDays=obj.LeaveDays
	s NursePhone=obj.NursePhone
	s LeaveTrustee=obj.LeaveTrustee
	s Accepter=obj.Accepter
	s NurHeadSign=""
	i obj.NurHeadSign'="" s NurHeadSign=..GetNurHeadName(obj.NurHeadSign)
	s LocHeadSign=""
	i obj.LocHeadSign'="" s LocHeadSign=..GetNurHeadName(obj.LocHeadSign)
	s ret="^FillDate|"_FillDate_"^NurseName|"_NurseName_"^LeaveWard|"_LeaveWard_"^NurseCardID|"_NurseCardID_"^LeaveType|"_LeaveType_"^LeaveCause|"_LeaveCause_"^LeaveStDate|"_LeaveStDate_"^LeaveEndDate|"_LeaveEndDate_"^LeaveDays|"_LeaveDays_"^NursePhone|"_NursePhone_"^LeaveTrustee|"_LeaveTrustee_"^RowID|"_id_"^NurHeadSign|"_NurHeadSign_"^LocHeadSign|"_LocHeadSign_"^Accepter|"_Accepter
	q ret
}

ClassMethod GetLeaveFlag(id As %String) As %String
{
	q:id="" ""
	s flag=""
	s obj=##class(DHCNMG.Arg.MgNurLeaveApp).%OpenId(id)
	s flag=obj.LeaveStatus
	q flag
}

/// creator: gzj
/// createDate: 2018-03-10
/// description: 查询护士请假申请记录
/// table: 
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgLeaveComm","FindLeaveLists","0","0","^^2015-05-01^2019-05-13")
Query FindLeaveLists(role As %String, nurseid As %String, parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLeaveListsExecute(ByRef qHandle As %Binary, role As %String, nurseid As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret1=""
	s schward=$P(parr,"^",1)
	s schstatus=$p(parr,"^",2)
	s stdate=$p(parr,"^",3)
	i stdate'="" s stdate=$zdh(stdate,3)
	s enddate=$p(parr,"^",4)
	i enddate'="" s enddate=$zdh(enddate,3)
	s tmpWard=""
	s isHLB=0,isNurHead=0 
	i role'=0 {
		f i=1:1:$l(role,"^") d
		.s trole=$p(role,"^",i)
		.q:trole=""
		.i trole'=0 d
		..s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId(trole)
		..i $IsObject(roleObj) d
		...s code=$zcvt(roleObj.RoleCode,"U")
		...;超级管理员，管理员，(code="ADMIN")||(code="MANAGER")||护理部主任;护理部人员
		...i ((code="HLBZR")||(code="HLB"))  d
		....s isHLB=1
		...i ((code="ZNURHEAD")||(code="NURHEAD")) d
		....s isNurHead=1
		.s rolerw="" f  s rolerw=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_trole," "_nurseid,rolerw)) q:rolerw=""  d
		..s roledeprw="" f  s roledeprw=$O(^DHCNMG.DB.MgDataLimitSubD(rolerw,roledeprw)) q:roledeprw=""  d
		...s roledepobj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rolerw_"||"_roledeprw)
		...s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
		....s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
		.....q:(id'=roledepobj.SubWard)
		.....s tmpWard(id)=id
		s curward=##class(web.NurMgHRComm).GetCurrentWard(nurseid,+$h)
		s:(curward'="")&&('$d(tmpWard(curward))) tmpWard(curward)=curward
	}
	s tmp=""
	s date="" f  s date=$O(^DHCNMG.Arg.MgNurLeaveAppI("SSDEP",date)) q:date=""  d
	.q:(((stdate'="")&&(date<stdate))!((enddate'="")&&(date>enddate)))
	.s roleward="" f  s roleward=$O(^DHCNMG.Arg.MgNurLeaveAppI("SSDEP",date,roleward)) q:roleward=""  d
	..q:(schward'="")&&(schward'=roleward)
	..s nurserw="" f  s nurserw=$O(^DHCNMG.Arg.MgNurLeaveAppI("SSDEP",date,roleward,nurserw)) q:nurserw=""  d
	...q:(role'=0)&&(('$d(tmpWard(roleward)))&&(nurserw'=nurseid))
	...q:(role'=0)&&(isHLB=0)&&(isNurHead=0)&&(nurserw'=nurseid)
	...s appid="" f  s appid=$O(^DHCNMG.Arg.MgNurLeaveAppI("SSDEP",date,roleward,nurserw,appid)) q:appid=""  d
	....s obj=##class(DHCNMG.Arg.MgNurLeaveApp).%OpenId(appid)
	....q:'$IsObject(obj)
	....s isExist=0
	....i (role'=0)&&(nurserw'=nurseid) d
	.....i obj.LeaveStatus="N" s isExist=1
	.....e  i (obj.LeaveStatus="Y") s:(isNurHead=0) isExist=1
	....q:isExist=1
	....q:((schstatus'="")&&(obj.LeaveStatus'=schstatus))
	....i obj.LeaveStatus="N" s leaveStatus="未提交"
	....e  i obj.LeaveStatus="Y" s leaveStatus="提交"
	....e  i obj.LeaveStatus="NH" s leaveStatus="护士长已审核"
	....e  i obj.LeaveStatus="HH" s leaveStatus="护理部已审核"
	....e  s leaveStatus=""
	....i obj.FillDate'="" s fillDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.FillDate)
	....e  s fillDate=""
	....s leaveWard=""
	....i obj.LeaveWard'="" d
	.....s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.LeaveWard.%Id())
	.....q:'$IsObject(WardObj)
	.....s leaveWard=WardObj.WardDesc
	....e  s leaveWard=""
	....s leaveName=""
	....i obj.NurseName'="" d
	.....s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.NurseName.%Id())
	.....q:'$IsObject(PerObj)
	.....s leaveName=PerObj.PerName_"("_PerObj.PerID_")"
	....e  s leaveName=""
	....s nurseCardID=obj.NurseCardID
	....s leaveType=obj.LeaveType
	....i obj.LeaveType'="" d
	.....s leaveTypeObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(obj.LeaveType)
	.....i $IsObject(leaveTypeObj) s leaveType=leaveTypeObj.PostDesc
	....s leaveCause=obj.LeaveCause
	....s leaveDate="",leaveDays=""
	....i ((obj.LeaveStDate'="")&&(obj.LeaveEndDate'="")) d
	.....s leaveDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.LeaveStDate)_"--"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.LeaveEndDate)
	.....s leaveDays=obj.LeaveEndDate-obj.LeaveStDate+1
	....s nursePhone=obj.NursePhone
	....s leaveTrustee=obj.LeaveTrustee
	....s nurHeadSign=obj.NurHeadSign
	....i nurHeadSign=0 s nurHeadSign="管理员"
	....e  d
	.....s nurHeadObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurHeadSign)
	.....s:$IsObject(nurHeadObj) nurHeadSign=nurHeadObj.PerName
	....s nurseDepartSign=obj.NurseDepartSign
	....s statusCode=obj.LeaveStatus
	....s ret1="leaveStatus|"_leaveStatus_"^fillDate|"_fillDate_"^leaveWard|"_leaveWard_"^leaveName|"_leaveName_"^nurseCardID|"_nurseCardID_"^leaveType|"_leaveType_"^leaveCause|"_leaveCause_"^leaveDate|"_leaveDate_"^leaveDays|"_leaveDays_"^nursePhone|"_nursePhone_"^leaveTrustee|"_leaveTrustee_"^rowid|"_appid_"^nurHeadSign|"_nurHeadSign_"^nurseDepartSign|"_nurseDepartSign_"^statusCode|"_statusCode
	....s tmp(obj.NurseName.%Id(),obj.FillDate,appid)=ret1
	s tmpRw="" f  s tmpRw=$o(tmp(tmpRw)) q:tmpRw=""  d
	.s tmpDate="" f  s tmpDate=$o(tmp(tmpRw,tmpDate)) q:tmpDate=""  d
	..s tmpid="" f  s tmpid=$o(tmp(tmpRw,tmpDate,tmpid)) q:tmpid=""  d
	...s ret=tmp(tmpRw,tmpDate,tmpid)
	...d OutLeaveList
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutLeaveList
	
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLeaveListsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLeaveListsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLeaveListsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLeaveListsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetNurHeadName(id As %String) As %String
{
	q:id="" ""
	q:id="0" "管理员"
	s ret=""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret=obj.PerName
	q ret
}

/// Descriptions:护士长、护理部审核
/// Date:2018-03-12
/// Creator:gzj
/// Table:
/// Input:
/// Output:
/// Other
ClassMethod AuditLeaveRec(id As %String, nurseid As %String = "")
{
	q:id="" 0
	s obj=##class(DHCNMG.Arg.MgNurLeaveApp).%OpenId(id)
	q:'$IsObject(obj) 0
	s isHead=##class(web.NurMgSetComm).IsNurInRole(nurseid,"nurhead,znurhead")
	s isHLB=##class(web.NurMgSetComm).IsNurInRole(nurseid,"hlb,hlbzr")
	s oldStatus=obj.LeaveStatus
	q:oldStatus="N" "未提交不可审核"
	s type="NH"
	i (oldStatus="Y") s type="NH"
	e  i oldStatus="NH" s type="HH"
	q:type="" 0
	s warnRet=""
	i type="NH" d
	.s:isHead'=1 warnRet="无权限审核"
	.s:(oldStatus="NH") warnRet="护士长已审核不能重复审核"
	.s:(oldStatus="HH") warnRet="护理部已审核不可再审核"
	e  d
	.s:isHLB'=1 warnRet="无权限审核"
	.s:(oldStatus'="NH") warnRet="护士长未审核不能审核"
	.s:(oldStatus="HH") warnRet="护理部已审核不能重复审核"
	q:warnRet'="" warnRet
	s obj.LeaveStatus=type
	i type="NH" d
	.s obj.NurHeadSign=nurseid
	.s obj.NurHeadSignDate=+$h
	i type="HH" d
	.s obj.NurseDepartSign=nurseid
	.s obj.NurseDepartSignDate=+$h
	s sc= obj.%Save()
	if $$$ISOK(sc) {
		q 1	
	}else{
		q 0	
	}
}

ClassMethod GetLeavePrintData(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgNurLeaveApp).%OpenId(id)
	q:'$IsObject(obj) ""
	i obj.FillDate'="" s FillDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.FillDate)
	e  s FillDate=""
	i obj.NurseName'="" s NurseName=obj.NurseName.PerName
	e  s NurseName=""
	i obj.LeaveWard'="" s LeaveWard=obj.LeaveWard.WardDesc
	e  s LeaveWard=""
	s NurseCardID=obj.NurseCardID
	s LeaveType=obj.LeaveType
	s LeaveCause=obj.LeaveCause
	i obj.LeaveStDate'="" s LeaveStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.LeaveStDate)
	e  s LeaveStDate=""
	i obj.LeaveEndDate'="" s LeaveEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.LeaveEndDate)
	e  s LeaveEndDate=""
	s LeaveDays=obj.LeaveDays
	s NursePhone=obj.NursePhone
	s LeaveTrustee=obj.LeaveTrustee
	s NurHeadSign=obj.NurHeadSign
	s LocHeadSign=obj.LocHeadSign
	s NurseDepartSign=obj.NurseDepartSign
	s Accepter=obj.Accepter
	s ret="^FillDate|"_FillDate_"^NurseName|"_NurseName_"^LeaveWard|"_LeaveWard_"^NurseCardID|"_NurseCardID_"^LeaveType|"_LeaveType_"^LeaveCause|"_LeaveCause_"^LeaveStDate|"_LeaveStDate_"^LeaveEndDate|"_LeaveEndDate_"^LeaveDays|"_LeaveDays_"^NursePhone|"_NursePhone_"^LeaveTrustee|"_LeaveTrustee_"^NurHeadSign|"_NurHeadSign_"^LocHeadSign|"_LocHeadSign_"^NurseDepartSign|"_NurseDepartSign_"^Accepter|"_Accepter
	q ret
}

/// creator: gzj
/// createDate: 2018-03-14
/// description: 查询护士长名单
/// table: 
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgLeaveComm","FindNurHeadList","")
Query FindNurHeadList(role As %String, nurseid As %String, parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurHeadListExecute(ByRef qHandle As %Binary, role As %String, nurseid As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s RowID="" f  s RowID=$O(^DHCNMG.HR.MgPersonsD(RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(RowID)
	.s curward=##class(web.NurMgHRComm).GetCurrentWard(RowID,+$H)
	.q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))
	.q:(obj.PerCareType'="N") //医生过滤掉
	.q:(obj.PerTypeDR'="N") //非正式的护士过滤掉
	.s flag=..IsNurHeadFlag(RowID)
	.q:((flag'=1)&&(flag'=2)) //等于1 存在护士长 2 存在科护士长角色
	.s NurseID=obj.PerID
	.s NurseName=obj.PerName_"("_NurseID_")"
	.s ret="NurseName|"_NurseName_"^NurseID|"_NurseID_"^RowID|"_RowID
	.d OutHeadList
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutHeadList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurHeadListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurHeadListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurHeadListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurHeadListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod IsNurHeadFlag(nurseid As %String) As %String
{
	s flag=0
	s roleid="" f  s roleid=$O(^DHCNMG.HR.MgNurRoleI("role",nurseid,roleid)) q:roleid=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.HR.MgNurRoleI("role",nurseid,roleid,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.HR.MgNurRole).%OpenId(rowid)
	..q:'$IsObject(obj)
	..q:(obj.RoleStDate="")||(obj.RoleStDate>+$H)
	..q:(obj.RoleEndDate'="")&&(obj.RoleEndDate<+$H)
	..s role=obj.RoleID
	..s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId(role)
	..q:'$IsObject(roleObj)
	..s code=roleObj.RoleCode
	..i code="nurhead" s flag=1
	..i code="znurhead" s flag=2
	q flag
}

/// Descriptions:获取护士手机号信息
/// Creator:gzj
/// Date:2018-03-15
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod GetNurHeadPhone(id As %String) As %String
{
	q:id="" ""
	s phone=""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
	q:'$IsObject(obj) ""
	s phone=obj.PerPhone
	q "ResponsePhone|"_phone
}

ClassMethod IsExistNurHeadRec(parr As %String, type As %String, nurseid As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s flag=0
	s stdate=$g(tmp("LeaveStDate"))
	s enddate=$g(tmp("LeaveEndDate"))
	i ((stdate'="")&&(stdate["-")) s stdate=$zdh(stdate,3)
	i ((enddate'="")&&(enddate["-")) s enddate=$zdh(enddate,3)
	s firstDate="" f  s firstDate=$o(^DHCNMG.Arg.MgNurNurHeadAppI("date",$g(tmp("NurseName")),firstDate)) q:(firstDate=""!flag=1)  d
	.s secondDate="" f  s secondDate=$o(^DHCNMG.Arg.MgNurNurHeadAppI("date",$g(tmp("NurseName")),firstDate,secondDate)) q:(secondDate=""!flag=1)  d
	..s row="" f  s row=$o(^DHCNMG.Arg.MgNurNurHeadAppI("date",$g(tmp("NurseName")),firstDate,secondDate,row)) q:(row=""!flag=1)  d
	...i (((stdate>=firstDate)&&(stdate<=secondDate))!((enddate>=firstDate)&&(enddate<=secondDate))&&($g(tmp("RowID"))'=row)) s flag=1
	...e  i ((firstDate>stdate)&&(secondDate<enddate)&&($g(tmp("RowID"))'=row)) s flag=1
	q flag
}

ClassMethod SaveNurHeadLeave(parr As %String, type As %String, nurseid As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s flag=..IsExistNurHeadRec(parr,type,nurseid)
	q:flag=1 "该日期已经存在请假"
	s warnRet="",category=""
	s isNurHead=##class(web.NurMgSetComm).IsNurInRole(nurseid,"nurhead")
	s isZNurHead=##class(web.NurMgSetComm).IsNurInRole(nurseid,"znurhead")
	i isNurHead s category="H"
	e  s category="C"
	q:category="" "无权限"
	;广州河源两种是同一个类型皆可用科护士长签字
	;s category="C"
	i id="" s obj=##class(DHCNMG.Arg.MgNurNurHeadApp).%New()
	e  d
	.s obj=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(id)
	.i obj.LeaveStatus="Y" s warnRet=$case(type,"N":"已提交不能修改",:"禁止重复提交")
	.e  i obj.LeaveStatus="HC" s warnRet="科护士长已审核不能"_$case(type,"N":"修改",:"重复提交")
	.e  i obj.LeaveStatus="HH" s warnRet="护理部已经审核不能"_$case(type,"N":"修改",:"重复提交")
	.e  i obj.NurseName.%Id()'=nurseid s warnRet="非本人不可操作"
	q:warnRet'="" warnRet
	i $g(tmp("FillDate"))'="" s obj.FillDate=$zdh($tr($g(tmp("FillDate"))," ",""),3)
	e  s obj.FillDate=""
	i $g(tmp("NurseName"))'="" s obj.NurseName=##class(DHCNMG.HR.MgPersons).%OpenId($tr($g(tmp("NurseName"))," ",""))
	e  s obj.NurseName=""
	i $g(tmp("LeaveWard"))'="" s obj.LeaveWard=##class(DHCNMG.DB.MgWard).%OpenId($tr($g(tmp("LeaveWard"))," ",""))
	e  s obj.LeaveWard=""
	i $g(tmp("WardTelphone"))'="" s obj.WardTelphone=$tr($g(tmp("WardTelphone"))," ","")
	e  s obj.WardTelphone=""
	i $g(tmp("LeaveType"))'="" s obj.LeaveType=$tr($g(tmp("LeaveType"))," ","")
	e  s obj.LeaveType=""
	i $g(tmp("LeaveCause"))'="" s obj.LeaveCause=$tr($g(tmp("LeaveCause"))," ","")
	e  s obj.LeaveCause=""
	i $g(tmp("LeaveStDate"))'="" s obj.LeaveStDate=$zdh($tr($g(tmp("LeaveStDate"))," ",""),3)
	e  s obj.LeaveStDate=""
	i $g(tmp("LeaveEndDate"))'="" s obj.LeaveEndDate=$zdh($tr($g(tmp("LeaveEndDate"))," ",""),3)
	e  s obj.LeaveEndDate=""
	i $g(tmp("LeaveDays"))'="" s obj.LeaveDays=$tr($g(tmp("LeaveDays"))," ","")
	e  s obj.LeaveDays=""
	s obj.TmpResponse=$tr($g(tmp("TmpResponse"))," ","")
#;	i $g(tmp("TmpResponse"))'="" s obj.TmpResponse=##class(DHCNMG.HR.MgPersons).%OpenId($tr($g(tmp("TmpResponse"))," ",""))
#;	e  s obj.TmpResponse=""
	s obj.ResponsePhone=$tr($g(tmp("ResponsePhone"))," ","")
	s obj.LeavePlace=$tr($g(tmp("LeavePlace"))," ","")
	s obj.LeaveRemark=$tr($g(tmp("LeaveRemark"))," ","")
	s obj.LeaveStatus=type
	s obj.LeaveCategory=category
	s sc= obj.%Save()
	if $$$ISOK(sc){
		q 1	
	}else{
		q "保存失败"	
	}
}

/// creator: gzj
/// createDate: 2018-03-16
/// description: 查询护士长、科护士长请假备案
/// table: 
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgLeaveComm","FindNurHeadLeave","0","0","^^2019-08-01^2019-08-23")
Query FindNurHeadLeave(role As %String, nurseid As %String, parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurHeadLeaveExecute(ByRef qHandle As %Binary, role As %String, nurseid As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s schward=$P(parr,"^",1)
	s schstatus=$p(parr,"^",2)
	s stdate=$p(parr,"^",3)
	i stdate'="" s stdate=$zdh(stdate,3)
	s enddate=$p(parr,"^",4)
	i enddate'="" s enddate=$zdh(enddate,3)
	s tmpWard=""
	s isHLB=0,isNurHead=0 
	i role'=0 
	{
		f i=1:1:$l(role,"^") d
		.s trole=$p(role,"^",i)
		.q:trole=""
		.i trole'=0 d
		..s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId(trole)
		..i $IsObject(roleObj) d
		...s code=$zcvt(roleObj.RoleCode,"U")
		...;超级管理员，管理员，(code="ADMIN")||(code="MANAGER")||护理部主任;护理部人员
		...;广州河源只要hlbzr
		...;i ((code="HLBZR"))  d
		...i ((code="HLBZR")||(code="HLB")||(code="ADMIN")||(code="MANAGER"))  d
		....s isHLB=1
		...i (code="ZNURHEAD") d
		....s isNurHead=1
		.s rolerw="" f  s rolerw=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_trole," "_nurseid,rolerw)) q:rolerw=""  d
		..s roledeprw="" f  s roledeprw=$O(^DHCNMG.DB.MgDataLimitSubD(rolerw,roledeprw)) q:roledeprw=""  d
		...s roledepobj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rolerw_"||"_roledeprw)
		...s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
		....s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
		.....q:(id'=roledepobj.SubWard)
		.....s tmpWard(id)=id
		s curward=##class(web.NurMgHRComm).GetCurrentWard(nurseid,+$h)
		s:(curward'="")&&('$d(tmpWard(curward))) tmpWard(curward)=curward
	}
	s date="" f  s date=$O(^DHCNMG.Arg.MgNurNurHeadAppI("SSDEP",date)) q:date=""  d
	.q:(((stdate'="")&&(date<stdate))!((enddate'="")&&(date>enddate)))
	.s roleward="" f  s roleward=$O(^DHCNMG.Arg.MgNurNurHeadAppI("SSDEP",date,roleward)) q:roleward=""  d
	..q:((schward'="")&&(schward'=roleward)&&($g(isHLB)'=1))
	..s nurserw="" f  s nurserw=$O(^DHCNMG.Arg.MgNurNurHeadAppI("SSDEP",date,roleward,nurserw)) q:nurserw=""  d
	...q:((role'=0)&&(('$d(tmpWard(roleward)))&&(nurserw'=nurseid))&&($g(isHLB)'=1)) ;非本病区或本人不可查看
	...;广州河源只要hlbzr
	...;q:(role'=0)&&(isHLB=0)&&(nurserw'=nurseid) ;非护理部主任、本人不可查看
	...q:(role'=0)&&(isHLB=0)&&(isNurHead=0)&&(nurserw'=nurseid) ;非护理部、护士长、本人不可查看
	...s appid="" f  s appid=$O(^DHCNMG.Arg.MgNurNurHeadAppI("SSDEP",date,roleward,nurserw,appid)) q:appid=""  d
	....s obj=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(appid)
	....s isExist=0
	....i ((role'=0)&&(nurserw'=nurseid)) d ;非本人
	.....i obj.LeaveStatus="N" s isExist=1  ;未提交他人不可看
	.....e  i ((obj.LeaveStatus="Y")&&(obj.LeaveCategory="H")) s:(isNurHead=0) isExist=1 ;护士长提交非科护士长不可看.广州河源注释掉
	....q:isExist=1
	....q:((schstatus'="")&&(obj.LeaveStatus'=schstatus))
	....d OutHeadLeave
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutHeadLeave
	s ret=""
	i obj.LeaveStatus="N" s leaveStatus="未提交"
	e  i obj.LeaveStatus="Y" s leaveStatus="提交"
	e  i obj.LeaveStatus="HC" s leaveStatus="科护士长已审核"
	e  i obj.LeaveStatus="HH" s leaveStatus="护理部已审核"
	e  s leaveStatus=""
	i obj.FillDate'="" s fillDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.FillDate)
	e  s fillDate=""
	s leaveWard=""
	i obj.LeaveWard'="" d
	.s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.LeaveWard.%Id())
	.q:'$IsObject(WardObj)
	.s leaveWard=WardObj.WardDesc
	e  s leaveWard=""
	s WardTelphone=obj.WardTelphone
	s leaveName=""
	i obj.NurseName'="" d
	.s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.NurseName.%Id())
	.q:'$IsObject(PerObj)
	.s leaveName=PerObj.PerName_"("_PerObj.PerID_")"
	e  s leaveName=""
	s leaveType=obj.LeaveType
	i obj.LeaveType'="" d
	.s leaveTypeObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(obj.LeaveType)
	.i $IsObject(leaveTypeObj) s leaveType=leaveTypeObj.PostDesc
	s leaveCause=obj.LeaveCause
	s leaveDate="",leaveDays=""
	i ((obj.LeaveStDate'="")&&(obj.LeaveEndDate'="")) d
	.s leaveDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.LeaveStDate)_"--"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.LeaveEndDate)
	.s leaveDays=obj.LeaveEndDate-obj.LeaveStDate+1
	s tmpResponse=obj.TmpResponse
	;i obj.TmpResponse'="" s tmpResponse=obj.TmpResponse.PerName
	s responsePhone=obj.ResponsePhone
	s leavePlace=obj.LeavePlace
	s nurHeadSign=obj.NurHeadSign
	i nurHeadSign'="" d
	.i nurHeadSign=0 s nurHeadSign="管理员"
	.e  d
	..s nurHeadObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurHeadSign)
	..i $IsObject(nurHeadObj) s nurHeadSign=nurHeadObj.PerName
	s nurseDepartSign=obj.NurseDepartSign
	i nurseDepartSign'="" d
	.i nurseDepartSign=0 s nurseDepartSign="管理员"
	.e  d
	..s nurseDepartObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseDepartSign)
	..i $IsObject(nurseDepartObj) s nurseDepartSign=nurseDepartObj.PerName
	s leavecategory=obj.LeaveCategory
	s leaveRemark=obj.LeaveRemark
	s ret="leaveStatus|"_leaveStatus_"^fillDate|"_fillDate_"^leaveWard|"_leaveWard_"^wardTelPhone|"_WardTelphone_"^leaveName|"_leaveName_"^leaveType|"_leaveType_"^leaveCause|"_leaveCause_"^leaveDate|"_leaveDate_"^leaveDays|"_leaveDays_"^tmpResponse|"_tmpResponse_"^responsePhone|"_responsePhone_"^leavePlace|"_leavePlace_"^nurHeadSign|"_nurHeadSign_"^nurseDepartSign|"_nurseDepartSign_"^rowid|"_appid_"^leavecategory|"_leavecategory_"^leaveRemark|"_leaveRemark
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurHeadLeaveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurHeadLeaveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurHeadLeaveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurHeadLeaveExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetNurHeadLeave(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(id)
	i obj.FillDate'="" s FillDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.FillDate)
	e  s FillDate=""
	i obj.NurseName'="" s NurseName=obj.NurseName.%Id()
	e  s NurseName=""
	i obj.LeaveWard'="" s LeaveWard=obj.LeaveWard.%Id()
	e  s LeaveWard=""
	s WardTelphone=obj.WardTelphone
	s LeaveType=obj.LeaveType
	s LeaveCause=obj.LeaveCause
	i obj.LeaveStDate'="" s LeaveStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.LeaveStDate)
	e  s LeaveStDate=""
	i obj.LeaveEndDate'="" s LeaveEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.LeaveEndDate)
	e  s LeaveEndDate=""
	s LeaveDays=obj.LeaveDays
	s TmpResponse=obj.TmpResponse
	;i obj.TmpResponse'="" s TmpResponse=obj.TmpResponse.%Id()
	;e  s TmpResponse=""
	s ResponsePhone=obj.ResponsePhone
	s LeavePlace=obj.LeavePlace
	s LocHeadSign=obj.LocHeadSign
	s nurHeadSign=obj.NurHeadSign
	i nurHeadSign'="" d
	.i nurHeadSign=0 s nurHeadSign="管理员"
	.e  d
	..s nurHeadObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurHeadSign)
	..i $IsObject(nurHeadObj) s nurHeadSign=nurHeadObj.PerName
	s nurseDepartSign=obj.NurseDepartSign
	i nurseDepartSign'="" d
	.i nurseDepartSign=0 s nurseDepartSign="管理员"
	.e  d
	..s nurseDepartObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseDepartSign)
	..i $IsObject(nurseDepartObj) s nurseDepartSign=nurseDepartObj.PerName
	s LeaveRemark=obj.LeaveRemark
	
	s ret="^FillDate|"_FillDate_"^NurseName|"_NurseName_"^LeaveWard|"_LeaveWard_"^WardTelphone|"_WardTelphone_"^LeaveType|"_LeaveType_"^LeaveCause|"_LeaveCause_"^LeaveStDate|"_LeaveStDate_"^LeaveEndDate|"_LeaveEndDate_"^LeaveDays|"_LeaveDays_"^TmpResponse|"_TmpResponse_"^ResponsePhone|"_ResponsePhone_"^LeavePlace|"_LeavePlace_"^RowID|"_id_"^LocHeadSign|"_LocHeadSign_"^NurseDepartSign|"_nurseDepartSign_"^LeaveRemark|"_LeaveRemark_"^NurHeadSign|"_nurHeadSign
	q ret
}

ClassMethod GetNurLeaveFlag(id As %String) As %String
{
	q:id="" ""
	s flag=""
	s obj=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(id)
	s flag=obj.LeaveStatus
	q flag
}

ClassMethod GetLeaveCategory(id As %String) As %String
{
	s flag=""
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(id)
	q:'$IsObject(obj)
	s flag=obj.LeaveCategory
	q flag
}

ClassMethod AuditHeadLeave(id As %String, nurseid As %String) As %String
{
	q:id="" "无效数据请先保存提交"
	s obj=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(id)
	s type=""
	q:'$IsObject(obj) "无效数据请刷新界面重试"
	q:obj.LeaveStatus="N" "未提交，请先提交"
	q:obj.LeaveStatus="HH" "护理部已审核不可操作"
	i obj.LeaveStatus="Y" d
	.i (obj.LeaveCategory="C") s type="HH"
	.e  s type="HC"
	e  s type="HH"
	s isLocHead=##class(web.NurMgSetComm).IsNurInRole(nurseid,"znurhead")
	s isHLB=##class(web.NurMgSetComm).IsNurInRole(nurseid,"hlb,hlbzr")
	;广州河源只要护理部主任审核
	;s isHLB=##class(web.NurMgSetComm).IsNurInRole(nurseid,",hlbzr")
	q:type="" "审核状态出现错误请联系开发"
	q:(type="HC")&&(isLocHead'=1) "无大科护士长权限不可操作"
	q:(type="HH")&&(isHLB'=1) "无护理部权限不可操作"
	s obj.LeaveStatus=type
	i type="HC" d
	.s obj.NurHeadSign=$tr(nurseid," ","")
	.s obj.NurHeadSignDate=+$h
	i type="HH" d
	.s obj.NurseDepartSign=$tr(nurseid," ","")
	.s obj.NurseDepartSignDate=+$h
	d obj.%Save()
	q obj.%Id()
}

ClassMethod GetHeadLeavePrintData(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(id)
	q:'$IsObject(obj) ""
	i obj.FillDate'="" s FillDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.FillDate)
	e  s FillDate=""
	i obj.NurseName'="" s NurseName=obj.NurseName.PerName
	e  s NurseName=""
	i obj.LeaveWard'="" s LeaveWard=obj.LeaveWard.WardDesc
	e  s LeaveWard=""
	s WardTelphone=obj.WardTelphone
	s LeaveType=obj.LeaveType
	s LeaveCause=obj.LeaveCause
	i obj.LeaveStDate'="" s LeaveStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.LeaveStDate)
	e  s LeaveStDate=""
	i obj.LeaveEndDate'="" s LeaveEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.LeaveEndDate)
	e  s LeaveEndDate=""
	s LeaveDays=obj.LeaveDays
	s TmpResponse=obj.TmpResponse
	;i obj.TmpResponse'="" s TmpResponse=obj.TmpResponse.PerName
	;e  s TmpResponse=""
	s ResponsePhone=obj.ResponsePhone
	s LeavePlace=obj.LeavePlace
	s LeaveRemark=obj.LeaveRemark
	s NurHeadSign=obj.NurHeadSign
	s LocHeadSign=obj.LocHeadSign
	s NurseDepartSign=obj.NurseDepartSign
	s ret="^FillDate|"_FillDate_"^NurseName|"_NurseName_"^LeaveWard|"_LeaveWard_
	"^WardTelphone|"_WardTelphone_"^LeaveType|"_LeaveType_"^LeaveCause|"_LeaveCause_
	"^LeaveStDate|"_LeaveStDate_"^LeaveEndDate|"_LeaveEndDate_"^LeaveDays|"_LeaveDays_
	"^TmpResponse|"_TmpResponse_"^ResponsePhone|"_ResponsePhone_"^LeavePlace|"_LeavePlace
	_"^NurHeadSign|"_NurHeadSign_"^LocHeadSign|"_LocHeadSign_"^NurseDepartSign|"_NurseDepartSign_
	"^LeaveRemark|"_LeaveRemark
	q ret
}

/// creator: guozj
/// createDate: 2018-03-22
/// description: 查询护士长请假汇总
/// table: 
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgLeaveComm","FindLeaveSummary","")
Query FindLeaveSummary(role As %String, nurseid As %String, parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLeaveSummaryExecute(ByRef qHandle As %Binary, role As %String, nurseid As %String, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s schward=$P(parr,"^",1)
	s schname=$zcvt($p(parr,"^",2),"U")
	s tmp="",tmpward="",isAll=0,num=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,0,.tmpward)
	b ;1110
	s date="" f  s date=$O(^DHCNMG.Arg.MgNurNurHeadAppI("SSDEP",date)) q:date=""  d
	.s roleward="" f  s roleward=$O(^DHCNMG.Arg.MgNurNurHeadAppI("SSDEP",date,roleward)) q:roleward=""  d
	..q:((schward'="")&&(schward'=roleward)&&(isAll'=1))
	..s nurserw="" f  s nurserw=$O(^DHCNMG.Arg.MgNurNurHeadAppI("SSDEP",date,roleward,nurserw)) q:nurserw=""  d
	...q:((role'=0)&&(('$d(tmpward(roleward)))&&(nurserw'=nurseid))&&(isAll'=1))
	...s appid="" f  s appid=$O(^DHCNMG.Arg.MgNurNurHeadAppI("SSDEP",date,roleward,nurserw,appid)) q:appid=""  d
	....s obj=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(appid)
	....q:obj.LeaveCategory'="H"
	....q:obj.LeaveStatus'="HH"
	....s shortName=##class(web.NurMgVueComm).ToChineseSpell(obj.NurseName.PerName)
	....q:((schname'="")&&(shortName_obj.NurseName.PerName'[schname))
	....;s num=num+obj.LeaveDays
	....s tmp(obj.NurseName.%Id(),appid)=+$g(tmp(obj.NurseName.%Id(),appid))+obj.LeaveDays
	s tnursename="" f  s tnursename=$O(tmp(tnursename)) q:tnursename=""  d
	.s trowid="" f  s trowid=$O(tmp(tnursename,trowid)) q:trowid=""  d
	..s tnum=tmp(tnursename,trowid) //总记录的请假天数
	..s tobj=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(trowid)
	..s leaveName=tobj.NurseName.PerName
	..s leaveWard=tobj.LeaveWard.WardDesc
	..s leaveDays=tobj.LeaveDays
	..i tobj.LeaveStDate'="" s LeaveStDate=##class(web.NurMgHISComm).DateLogicalToHtml(tobj.LeaveStDate)
	..e  s LeaveStDate=""
	..i tobj.LeaveEndDate'="" s LeaveEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(tobj.LeaveEndDate)
	..e  s LeaveEndDate=""
	..s leaveDate=LeaveStDate_"---"_LeaveEndDate
	..s leaveCause=tobj.LeaveCause
	..s leavePlace=tobj.LeavePlace
	..s tmpResponse=tobj.TmpResponse_"["_tobj.ResponsePhone_"]"
	..s cumulative=tnum
	..s ret="leaveName|"_leaveName_"^leaveWard|"_leaveWard_"^leaveDays|"_leaveDays_"^leaveDate|"_leaveDate_"^leaveCause|"_leaveCause_"^leavePlace|"_leavePlace_"^tmpResponse|"_tmpResponse_"^cumulative|"_cumulative
 	..d OutLeaveSummaryList
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutLeaveSummaryList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLeaveSummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLeaveSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLeaveSummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLeaveSummaryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod UpLoadSickImg(parr As %String) As %String
{
	s rowid=$p(parr,"^",1)
	s imgsrc=$p(parr,"^",2)
	q:rowid="" ""
	s obj=##class(DHCNMG.Arg.MgNurLeaveApp).%OpenId(rowid)
	q:'$IsObject(obj) ""
	s obj.SickLeaveImg=imgsrc
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod GetSickLeaveImg(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s obj=##class(DHCNMG.Arg.MgNurLeaveApp).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret=obj.SickLeaveImg
	q ret
}

/// Creator:gzj
/// Date:2020-02-05
/// Description:
/// 
ClassMethod IsRoleInLimit(roles As %String) As %String
{
	q:roles="" -1
	s flag=-1
	q:roles=0 1
	s len=$l(roles,"^")
	f i=1:1:len
	{
		s itm=$p(roles,"^",i)
		i itm="" continue
		s codeObj=##class(DHCNMG.Set.MgRoles).%OpenId(itm)
		i '$IsObject(obj) continue
		i ((codeObj.RoleCode="admin")!(codeObj.RoleCode="manager")!(codeObj.RoleCode="hlbzr")!(codeObj.RoleCode="hlb")) s flag=1
	}
	q flag
}

}
