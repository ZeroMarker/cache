/// creator:xbl
/// createdate:2017-06-26
/// description:排班公共类
Class web.NurMgArgComm Extends %RegisteredObject
{

/// creator:xbl
/// createdate:20180828
/// description: 保存护士请假申请
/// table:DHCNMG.Arg.MgAskLeave
/// input:
/// output:
/// other: w ##class(web.NurMgArgComm).SaveAskLeave("LeavePerDR|3^LeaveWardDR|1^LeaveHolidayDR|7^LeaveStDate|2017-11-17^LeaveEndDate|2017-11-18^LeaveReason|测试^rw|^")
ClassMethod SaveAskLeave(parr As %String) As %String
{
	q:parr="" ""
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Arg.MgAskLeave).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Arg.MgAskLeave).%New()
	.s obj.LeaveStatus="N"
	i $g(tmp("LeavePerDR"))'="" d
	.s obj.LeavePerDR=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("LeavePerDR"))
	e  s obj.LeavePerDR=""
	i $g(tmp("LeaveWardDR"))'="" d
	.s obj.LeaveWardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("LeaveWardDR"))
	e  s obj.LeaveWardDR=""
	i $g(tmp("LeaveHolidayDR"))'="" d
	.s obj.LeaveHolidayDR=##class(DHCNMG.DB.MgArgWardPost).%OpenId(tmp("LeaveHolidayDR"))
	e  s obj.LeaveHolidayDR=""
	i $g(tmp("LeaveStDate"))'="" s obj.LeaveStDate=$zdh(tmp("LeaveStDate"),3)
	e  s obj.LeaveStDate=""
	i $g(tmp("LeaveStTime"))'="" s obj.LeaveStTime=$zth(tmp("LeaveStTime"),1)
	e  s obj.LeaveStTime=""
	i $g(tmp("LeaveEndDate"))'="" s obj.LeaveEndDate=$zdh(tmp("LeaveEndDate"),3)
	e  s obj.LeaveEndDate=""
	i $g(tmp("LeaveEndTime"))'="" s obj.LeaveEndTime=$zth(tmp("LeaveEndTime"),1)
	e  s obj.LeaveEndTime=""
	s obj.LeaveDays=##class(web.NurMgVueComm).timeDifference(tmp("LeaveStDate"),$g(tmp("LeaveStTime")),tmp("LeaveEndDate"),$g(tmp("LeaveEndTime")))
	s obj.LeaveReason=$g(tmp("LeaveReason"))
	i $d(tmp("BackReason")) s obj.BackReason=$g(tmp("BackReason"))
	i $d(tmp("LeaveReplaceDR")) d 
	.s per=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("LeaveReplaceDR"))
	.s:$IsObject(per) obj.ReplacePerDR=per
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator:xbl
/// createdate:20180828
/// description: 获取护士请假申请
/// table:DHCNMG.Arg.MgAskLeave
/// input:
/// output:
/// other: w ##class(web.NurMgArgComm).GetAskLeave(1)
ClassMethod GetAskLeave(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgAskLeave).%OpenId(id)
	s ret="rw|"_id
	i obj.LeavePerDR'="" d
	.s ret=ret_"^LeavePerDR|"_obj.LeavePerDR.%Id()
	.s ret=ret_"^PerID|"_obj.LeavePerDR.PerID
	.s ret=ret_"^PerName|"_obj.LeavePerDR.PerName
	i obj.LeaveWardDR'="" d
	.s ret=ret_"^LeaveWardDR|"_obj.LeaveWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.LeaveWardDR.WardDesc
	i obj.LeaveHolidayDR'="" d
	.s ret=ret_"^LeaveHolidayDR|"_obj.LeaveHolidayDR.%Id()
	.s ret=ret_"^PostDesc|"_obj.LeaveHolidayDR.PostDesc
	i obj.LeaveStDate'="" d
	.s ret=ret_"^LeaveStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.LeaveStDate)
	i obj.LeaveStTime'="" d
	.s ret=ret_"^LeaveStTime|"_$zt(obj.LeaveStTime,1)
	i obj.LeaveEndDate'="" d
	.s ret=ret_"^LeaveEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.LeaveEndDate)
	i obj.LeaveEndTime'="" d
	.s ret=ret_"^LeaveEndTime|"_$zt(obj.LeaveEndTime,1)
	s ret=ret_"^LeaveDays|"_obj.LeaveDays
	s ret=ret_"^LeaveReason|"_obj.LeaveReason
	s ret=ret_"^LeaveStatus|"_obj.LeaveStatus
	s statusDesc=##class(web.NurMgSetComm).GetParamSubByCode("StatusSet",obj.LeaveStatus,"SubDesc")
	s ret=ret_"^StatusDesc|"_statusDesc
	s ret=ret_"^BackReason|"_obj.BackReason
	i (obj.LeavePerDR'="")&&(obj.LeaveWardDR'="")&&(obj.LeaveStDate'="")&&(obj.LeaveStDate'="") d
	.s LeaveArgDesc=..getNurDateArg(obj.LeaveWardDR.%Id()_"^"_obj.LeavePerDR.%Id()_"^"_$zd(obj.LeaveStDate,3)_"^"_$zd(obj.LeaveEndDate,3))
	.s ret=ret_"^LeaveArgDesc|"_LeaveArgDesc
	i obj.ReplacePerDR'="" d
	.s ret=ret_"^LeaveReplaceDR|"_obj.ReplacePerDR.%Id()
	q ret
}

/// creator:xbl
/// createdate:20180828
/// description: 设置护士请假申请记录状态
/// table:DHCNMG.Arg.MgAskLeave
/// input:
/// output:
/// other:w ##class(web.NurMgArgComm).SetLeaveStatus("8,","W");
ClassMethod SetLeaveStatus(ids As %String, status As %String) As %String
{
	q:(ids="")!(status="") ""
	s flag=1
	Ts
	f i=1:1:$L(ids,",") q:flag=0  d
	.s id=$P(ids,",",i)
	.q:id=""
	.s obj=##class(DHCNMG.Arg.MgAskLeave).%OpenId(id)
	.q:'$IsObject(obj)
	.i (status="W")&&(obj.ReplacePerDR'="") d 
	..q:'$IsObject(obj.LeaveWardDR)
	..q:'$IsObject(obj.LeavePerDR)
	..q:'$IsObject(obj.ReplacePerDR)
	..s stdate=obj.LeaveStDate
	..s enddate=obj.LeaveEndDate
	..s wardid=obj.LeaveWardDR.%Id()
	..s perid=obj.LeavePerDR.%Id()
	..;审核存在替班做一些操作，病区循环排班。循环排班行找到替班人和被踢人。更新替班状态
	..s date="" f  s date=$o(^DHCNMG.Arg.MgArrangeSubI("WardPerDate",wardid,perid,date)) q:(date="")||(flag=0)  d
	...q:(stdate'="")&&(stdate>date)
	...q:(enddate'="")&&(enddate<date)
	...s subid="" f  s subid=$O(^DHCNMG.Arg.MgArrangeSubI("WardPerDate",wardid,perid,date,subid)) q:(subid="")||(flag=0)  d
	....s argSubObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(subid)
	....q:'$IsObject(argSubObj)
	....q:'$IsObject(argSubObj.ArgPostDR)
	....q:'$IsObject(argSubObj.ArrangeDR)
	....q:((argSubObj.ArrangeDR.ArgStatus'="R")&&(argSubObj.ArrangeDR.ArgStatus'="A"))
	....;修改休假人班次替班状态和替班人
	....s argSubObj.ArgIsReplace=1
	....s argSubObj.ArgReplaceDR=obj.ReplacePerDR
	....s sc=argSubObj.%Save()
	....i $$$ISERR(sc) s flag=0
	....q:flag=0
	....;增加替班人班次
	....s argSubNewId=##class(DHCNMG.Arg.MgArrangeSub).CopyArgToNew(argSubObj.%Id())
	....i argSubNewId=0 s flag=0
	....q:flag=0
	....s argSubObjNew=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argSubNewId)
	....s argrowid=$o(^DHCNMG.Arg.MgArrangeRowI("ArgPerson",argSubObj.ArrangeDR.%Id(),obj.ReplacePerDR.%Id(),""))
	....s argRow=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(argrowid)
	....s:'$IsObject(argRow) flag=0
	....q:flag=0
	....s argSubObjNew.ArgRowDR=argRow
	....s argSubObjNew.ArgPerDR=obj.ReplacePerDR
	....s argSubObjNew.ArgEditDate=+$h
	....s argSubObjNew.ArgEditTime=$p($h,"^",2)
	....s argSubObjNew.ArgIsReplace=2
	....s argSubObjNew.ArgReplaceDR=obj.LeavePerDR
	....s sc=argSubObjNew.%Save()
	....i $$$ISERR(sc) s flag=0
	....q:flag=0
	.s obj.LeaveStatus=status
	.s sc=obj.%Save()
	.i $$$ISERR(sc) s flag=0
	if flag=1{
		TC	
	}else{
		Tro	
	}
	q flag
}

/// creator:xbl
/// createdate:20180828
/// description: 删除护士请假申请记录
/// table:DHCNMG.Arg.MgAskLeave
/// input:
/// output:
/// other:
ClassMethod DeleteAskLeave(ids As %String) As %String
{
	q:(ids="") ""
	s flag=1
	f i=1:1:$L(ids,",") d
	.s id=$P(ids,",",i)
	.q:id=""
	.s obj=##class(DHCNMG.Arg.MgAskLeave).%OpenId(id)
	.s sc=obj.%DeleteId(id)
	q 1
}

/// creator:xbl
/// createdate:20180828
/// description: 获取护士请假申请记录
/// table:DHCNMG.Arg.MgAskLeave
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgArgComm","FindAskLeaveList","","")
Query FindAskLeaveList(parr As %String = "", input As %String = "", role As %String, nurseid As %String, rolecode As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindAskLeaveListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String, nurseid As %String, rolecode As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s id="" f  s id=$O(^DHCNMG.Arg.MgAskLeaveD(id)) q:id=""  d
	.s obj=##class(DHCNMG.Arg.MgAskLeave).%OpenId(id)
	.q:'$IsObject(obj)
	.q:'$IsObject(obj.LeaveWardDR)
	.;q:(level="H")&&(obj.LeaveStatus'="W")
	.q:((obj.LeaveStatus="B")||(obj.LeaveStatus="N"))&&(obj.LeavePerDR.%Id()'=nurseid)
	.q:'$IsObject(obj.LeaveWardDR)
	.q:(isAll=0)&&((obj.LeavePerDR.%Id()'=nurseid)||('$d(tmpWard(obj.LeaveWardDR.%Id())))) 
	.q:(ward'="")&&(obj.LeaveWardDR.%Id()'=ward)
	.q:((stdate'="")&&(obj.LeaveEndDate'="")&&(obj.LeaveEndDate<stdate))
	.q:((enddate'="")&&(obj.LeaveStDate'="")&&(obj.LeaveStDate>enddate))
	.i obj.LeavePerDR'="" d
	..s pershort=##class(web.NurMgVueComm).ToChineseSpell(obj.LeavePerDR.PerName)
	..s info=$zcvt(obj.LeavePerDR.PerName_"^"_obj.LeavePerDR.PerID_"^"_pershort,"U")
	.q:(input'="")&&($d(info))&&(info'[$zcvt(input,"U"))
	.s ret=..GetAskLeave(id)
	.d OutAskLeave
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutAskLeave
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAskLeaveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAskLeaveListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAskLeaveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAskLeaveListExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 20170901
/// description: 保存排班记录
/// table: DHCNMG.Arg.MgArrange
/// input:
/// output:
/// other: w ##class(web.NurMgArgComm).SaveArrange("ArgListNo|201708281^ArgWardDR|1^ArgStDate|2017-08-28^ArgEndDate|2017-09-03^ArgRemark|^ArgCrtUser|45")
ClassMethod SaveArrange(parr As %String) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	i +$g(tmp("ArgCrtUser"))=0 s tmp("ArgCrtUser")=""
	s ward=$g(tmp("ArgWardDR"))
	s stdate=$g(tmp("ArgStDate"))
	q:(ward="")!(stdate="") 0
	s:stdate["-" stdate=$zdh(stdate,3)
	i $g(tmp("rw"))="" s tmp("rw")=$O(^DHCNMG.Arg.MgArrangeI("ListNo"," "_$zd(stdate,8)_ward,""))
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Arg.MgArrange).%OpenId(tmp("rw"))
	.i $g(tmp("ArgStatus"))'="" s obj.ArgStatus=tmp("ArgStatus")
	.i $g(tmp("ArgStatus"))="R" d
	..s obj.ArgSubmitDate=+$h
	..s obj.ArgSubmitTime=$p($h,",",2)
	e  d	
	.s obj=##class(DHCNMG.Arg.MgArrange).%New()
	.s obj.ArgWardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("ArgWardDR"))
	.s obj.ArgStatus="N"
	.i $g(tmp("ArgStatus"))'="" s obj.ArgStatus=tmp("ArgStatus")
	.s obj.ArgCrtDate=+$h
	.s obj.ArgCrtTime=$P($h,",",2)
	.s obj.ArgEditFlag="N"
	i $g(tmp("ArgListNo"))'="" s obj.ArgListNo=$g(tmp("ArgListNo"))
	e  s obj.ArgListNo=$zd(stdate,8)_ward
	i $g(tmp("ArgStDate"))'="" d
	.s obj.ArgStDate=$zdh(tmp("ArgStDate"),3)
	e  s obj.ArgStDate=""
	i $g(tmp("ArgEndDate"))'="" d
	.s obj.ArgEndDate=$zdh(tmp("ArgEndDate"),3)
	e  s obj.ArgEndDate=""
	s obj.ArgRemarks=$tr($g(tmp("ArgRemarks"))," ","")
	i $g(tmp("ArgCrtUser"))'="" d
	.s obj.ArgCrtUser=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("ArgCrtUser"))
	e  s obj.ArgCrtUser=""
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20170901
/// description: 获取排班记录
/// table: DHCNMG.Arg.MgArrange
/// input:
/// output:
/// other: w ##class(web.NurMgArgComm).GetArrange(22)
ClassMethod GetArrange(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgArrange).%OpenId(id)
	s ret="rw|"_id
	s ret=ret_"^ArgListNo|"_obj.ArgListNo
	i obj.ArgWardDR'="" d
	.s ret=ret_"^ArgWardDR|"_obj.ArgWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.ArgWardDR.WardDesc
	i obj.ArgStDate'="" s ret=ret_"^ArgStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ArgStDate)
	i obj.ArgEndDate'="" s ret=ret_"^ArgEndDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ArgEndDate)
	s ArgRemarks=""
	i ((obj.ArgRemarks="")&&(obj.ArgStatus="N")) d
	.s lastWeek=obj.ArgStDate-1
	.s lastRw=$o(^DHCNMG.Arg.MgArrangeI("WardEndDate",obj.ArgWardDR.%Id(),lastWeek,""))
	.i lastRw'="" d
	..s lastObj=##class(DHCNMG.Arg.MgArrange).%OpenId(lastRw)
	..q:'$IsObject(lastObj)
	..s ArgRemarks=lastObj.ArgRemarks
	e  s ArgRemarks=obj.ArgRemarks
	s ret=ret_"^ArgRemarks|"_ArgRemarks
	s ret=ret_"^ArgStatus|"_obj.ArgStatus
	s ret=ret_"^StatusDesc|"_$case(obj.ArgStatus,"N":"草稿","S":"保存","R":"提交","B":"驳回",:"")
	i obj.ArgCrtUser'="" d
	.s ret=ret_"^ArgCrtUser|"_obj.ArgCrtUser.%Id()
	.s ret=ret_"^CrtUserName|"_obj.ArgCrtUser.PerName
	e  d
	.s ret=ret_"^ArgCrtUser|0"
	.s ret=ret_"^CrtUserName|管理员"
	i obj.ArgCrtDate'="" s ret=ret_"^ArgCrtDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ArgCrtDate)
	i obj.ArgCrtTime'="" s ret=ret_"^ArgCrtTime|"_$zt(obj.ArgCrtTime,1)
	s ret=ret_"^ArgEditFlag|"_obj.ArgEditFlag
	s ret=ret_"^EditFlagDesc|"_$case(obj.ArgEditFlag,"S":"申请","A":"批准",:"")
	i obj.ArgAuthorDate'="" s ret=ret_"^ArgAuthorDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ArgAuthorDate)
	i obj.ArgAuthorTime'="" s ret=ret_"^ArgAuthorTime|"_$zt(obj.ArgAuthorTime,1)
	s ret=ret_"^ArgAuthorHours|"_obj.ArgAuthorHours
	i obj.ArgSubmitDate'="" s ret=ret_"^ArgSubmitDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ArgSubmitDate)
	i obj.ArgSubmitTime'="" s ret=ret_"^ArgSubmitTime|"_$zt(obj.ArgSubmitTime,1)
	s ArgCurrentWeek=""
	i obj.ArgStDate'="" s ArgCurrentWeek="第"_$fn($zd(obj.ArgStDate,14)/7,"",0)_"周"
	s ret=ret_"^ArgCurrentWeek|"_ArgCurrentWeek
	i obj.ArgSubmitDate'="" s ArgSubmitDate=$zd(obj.ArgSubmitDate,3)
	e  s ArgSubmitDate=""
	s ArgCrtUpdateLog="否"
	i $D(^DHCNMG.Arg.MgArrangeLogI("Arrange",obj.%Id())) s ArgCrtUpdateLog="是"
	s ret=ret_"^ArgCrtUpdateLog|"_ArgCrtUpdateLog
	q ret
}

/// creator: xbl
/// createdate: 20170901
/// description: 删除排班记录
/// table: DHCNMG.Arg.MgArrange
/// input:
/// output:
/// other:
ClassMethod DeleteArrange(id As %String) As %String
{
	q:id="" ""
	TStart
	s sc=##class(DHCNMG.Arg.MgArrange).%DeleteId(id)
	i $$$ISOK(sc) 
	{	
		s flag=0
		s rid=$O(^DHCNMG.Arg.MgArrangeRowI("Arrange",id,""))
		f {
			q:rid=""
			s rsc=##class(DHCNMG.Arg.MgArrangeRow).%DeleteId(rid)
			i $$$ISERR(rsc) s flag=1 d $System.Status.DisplayError(rsc) w !,"r"
			q:$$$ISERR(rsc)
			s rid=$O(^DHCNMG.Arg.MgArrangeRowI("Arrange",id,rid))
		}
		q:flag=1
		s sid=$O(^DHCNMG.Arg.MgArrangeSubI("Arg",id,""))
		f {
			q:sid=""
			s ssc=##class(DHCNMG.Arg.MgArrangeSub).%DeleteId(sid) 
			i $$$ISERR(ssc) s flag=1 d $System.Status.DisplayError(ssc) w !,"s"_sid
			q:$$$ISERR(ssc)
			s sid=$O(^DHCNMG.Arg.MgArrangeSubI("Arg",id,sid))
		}
		q:flag=1
		s gid=$O(^DHCNMG.Arg.MgArrangeGroupI("Arrange",id,""))
		f {
			q:gid=""
			s gsc=##class(DHCNMG.Arg.MgArrangeGroup).%DeleteId(gid)
			i $$$ISERR(gsc) s flag=1 d $System.Status.DisplayError(gsc) w !,"g"
			q:$$$ISERR(gsc)
			s gid=$O(^DHCNMG.Arg.MgArrangeGroupI("Arrange",id,gid))
		}
		TCommit
		q 1
	}
	TRollback
	q 0
}

///  creator: xbl
///  createdate: 20170901
///  description: 排班记录列表
///  table: DHCNMG.Arg.MgArrange
///  input:
///  output:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgArgComm","FindArrangeList","^2017-10-01^2017-11-30^","")
Query FindArrangeList(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArrangeListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s creator=$P(parr,"^",4)
	s status=$P(parr,"^",5)
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s listno="" f  s listno=$O(^DHCNMG.Arg.MgArrangeI("ListNo",listno),-1) q:listno=""  d
	.s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeI("ListNo",listno,id),-1) q:id=""  d
	..s obj=##class(DHCNMG.Arg.MgArrange).%OpenId(id)
	..q:(isAll=0)&&(('$IsObject(obj.ArgWardDR))||('$d(tmpWard(obj.ArgWardDR.%Id()))))
	..q:(ward'="")&&(obj.ArgWardDR'="")&&(ward'=obj.ArgWardDR.%Id())
	..q:((stdate'="")&&(obj.ArgEndDate'="")&&(stdate>obj.ArgEndDate))||((enddate'="")&&(obj.ArgStDate'="")&&(enddate<obj.ArgStDate))
	..q:(status'="")&&(obj.ArgStatus'=status)
	..i obj.ArgCrtUser'="" d
	...s perid=obj.ArgCrtUser.PerID,pername=obj.ArgCrtUser.PerName
	...s pershort=##class(web.NurMgVueComm).ToChineseSpell(pername)
	...s perinfo=$zcvt(perid_pername_pershort,"U")
	..q:(creator'="")&&(obj.ArgCrtUser'="")&&(perinfo'[$zcvt(creator,"U"))
	..s ret=..GetArrange(id)
	..d OutArrange
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutArrange
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArrangeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArrangeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArrangeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArrangeListExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 20170902
/// description: 创建人员分组
/// table: DHCNMG.Arg.MgArrangeGroup
/// input: 
/// output:
/// other: w ##class(web.NurMgArgComm).SaveArgGroup(^tmpArg("parr1"),^tmpArg("parr2"))
ClassMethod SaveArgGroup(parr1 As %String, parr2 As %String) As %String
{
	q:(parr1="")!(parr2="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	d ##class(web.NurMgVueComm).SplitStr(parr2,"^","|",.tmp)
	q:$g(tmp("GroupCode"))="" 0
	i $g(tmp("rw"))="" s tmp("rw")=$O(^DHCNMG.Arg.MgArrangeGroupI("ArgCode",argid," "_$zcvt(tmp("GroupCode"),"U"),""))
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Arg.MgArrangeGroup).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Arg.MgArrangeGroup).%New()
	i argid'="" d
	.s obj.ArrangeDR=##class(DHCNMG.Arg.MgArrange).%OpenId(argid)
	e  d
	.s obj.ArrangeDR=""
	s obj.GroupCode=$g(tmp("GroupCode"))
	s obj.GroupDesc=$g(tmp("GroupDesc"))
	i $g(tmp("GroupMaster"))'="" d
	.s obj.GroupMaster=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("GroupMaster"))
	e  s obj.GroupMaster=""
	s obj.GroupRemark=$g(tmp("GroupRemark"))
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20170902
/// description: 创建人员分组
/// table: DHCNMG.Arg.MgArrangeGroup
/// input: 
/// output:
/// other: w ##class(web.NurMgArgComm).SaveArgGroup(^tmpArg("parr1"),^tmpArg("parr2"))
ClassMethod SaveArgGroups(parr1 As %String, parr2 As %String, parr3 As %String) As %String
{
	q:(parr1="")!(parr2="")!(parr3="") 0
	s arggrpid=..SaveArgGroup(parr1,parr2)
	q:+arggrpid=0 0
	s flag=1
	f i=1:1:$L(parr3,"@") d
	.s parr=$P(parr3,"@",i)
	.q:parr=""
	.s parr=parr_"^ArgGroupDR|"_arggrpid
	.s argrowid=..SaveArgRow(parr1,parr)
	.i +argrowid=0 s flag=0
	q flag
}

/// creator: xbl
/// createdate: 20171202
/// description: 获取护士所在分组
/// table:DHCNMG.Arg.MgArrangeGroup
/// input:
/// output:
/// return:
/// other: w ##class(web.NurMgArgComm).GetPerGroup(1,"2017-12-11","2017-12-17",1537)
ClassMethod GetPerGroup(ward As %String, stdate As %String, enddate As %String, perdr As %String) As %String
{
	q:(ward="")!(stdate="")!(enddate="")!(perdr="") ""
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s argid=$O(^DHCNMG.Arg.MgArrangeI("WardDate",ward,stdate,enddate,""))
	q:argid="" ""
	s id=""
	s rowid="" f  s rowid=$O(^DHCNMG.Arg.MgArrangeRowI("Arrange",argid,rowid)) q:(rowid="")||(id'="")  d
	.s rowobj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(rowid)
	.q:(rowobj.ArgPerDR'="")&&(rowobj.ArgPerDR.%Id()'=perdr)
	.q:rowobj.ArgGroupDR=""
	.s id=rowobj.ArgGroupDR.%Id()
	q:id'="" id
	s grpid="" f  s grpid=$O(^DHCNMG.Arg.MgNurGroupI("Ward",ward,grpid)) q:(grpid="")||(id'="")  d
	.s grpobj=##class(DHCNMG.Arg.MgNurGroup).%OpenId(grpid)
	.s:(($IsObject(grpobj.GroupMaster))&&(grpobj.GroupMaster.%Id()=perdr)) id=grpid
	.q:grpobj.GroupMember.Find(perdr)=""
	.s id=grpid
	q:id="" ""
	s grpobj=##class(DHCNMG.Arg.MgNurGroup).%OpenId(id)
	s id=$O(^DHCNMG.Arg.MgArrangeGroupI("ArgCode",argid," "_$zcvt(grpobj.GroupDesc,"U"),""))
	q:id'="" id
	s obj=##class(DHCNMG.Arg.MgArrangeGroup).%New()
	s obj.ArrangeDR=##class(DHCNMG.Arg.MgArrange).%OpenId(argid)
	s obj.GroupCode=grpobj.GroupDesc
	s obj.GroupDesc=grpobj.GroupDesc
	s obj.GroupMaster=grpobj.GroupMaster
	s obj.GroupRemark=grpobj.GroupRemark
	s obj.GroupBedGroup=grpobj.GroupBedGroup
	d obj.GroupResBeds.Clear()
	s GroupResBeds=##class(web.NurMgHISComm).GetBedIdByGroup(grpobj.GroupBedGroup)
	i GroupResBeds'="" d
	.f i=1:1:$L(GroupResBeds,",") d
	..s bedid=$P(GroupResBeds,",",i)
	..q:bedid=""
	..s bedid=$tr(bedid,"__","||")
	..d obj.GroupResBeds.Insert(bedid)
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q ""
}

/// creator: xbl
/// createdate: 20170902
/// description: 排班记录行
/// table: DHCNMG.Arg.MgArrangeSub
/// input:
/// output:
/// other: w ##class(web.NurMgArgComm).SaveArgRow(^tmpArg("parr1"),^tmpArg("parr2"))
ClassMethod SaveArgRow(parr1 As %String, parr2 As %String) As %String
{
	q:(parr1="")||(parr2="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	d ##class(web.NurMgVueComm).SplitStr(parr2,"^","|",.tmp)
	q:$g(tmp("ArgPerDR"))="" 0
	i $g(tmp("rw"))="" s tmp("rw")=$O(^DHCNMG.Arg.MgArrangeRowI("ArgPerson",argid,tmp("ArgPerDR"),""))
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Arg.MgArrangeRow).%New()
	i argid'="" d
	.s obj.ArrangeDR=##class(DHCNMG.Arg.MgArrange).%OpenId(argid)
	e  s obj.ArrangeDR=""
	i $g(tmp("ArgPerDR"))'="" d
	.s obj.ArgPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("ArgPerDR"))
	e  s obj.ArgPerDR=""
	s obj.ArgPerSort=$g(tmp("ArgPerSort"))
	s obj.ArgWorkRemark=$g(tmp("ArgWorkRemark"))
	i $g(tmp("ArgGroupDR"))'="" d
	.i $g(tmp("ArgGroupDR"))="-" s obj.ArgGroupDR=""
	.e  d
	..s ArgGroupObj=##class(DHCNMG.Arg.MgArrangeGroup).%OpenId(tmp("ArgGroupDR"))
	..i ($IsObject(ArgGroupObj))&&(ArgGroupObj.ArrangeDR.%Id()=argid) s obj.ArgGroupDR=ArgGroupObj
	..e  d
	...s grpid=..GetPerGroup(obj.ArrangeDR.ArgWardDR.%Id(),obj.ArrangeDR.ArgStDate,obj.ArrangeDR.ArgEndDate,tmp("ArgPerDR"))
	...i grpid="" s obj.ArgGroupDR=""
	...e  s obj.ArgGroupDR=##class(DHCNMG.Arg.MgArrangeGroup).%OpenId(grpid)
	e  d
	.s grpid=..GetPerGroup(obj.ArrangeDR.ArgWardDR.%Id(),obj.ArrangeDR.ArgStDate,obj.ArrangeDR.ArgEndDate,tmp("ArgPerDR"))
	.i grpid="" s obj.ArgGroupDR=""
	.e  s obj.ArgGroupDR=##class(DHCNMG.Arg.MgArrangeGroup).%OpenId(grpid)
	i $g(tmp("rw"))="" d
	.i $g(tmp("ArgPerAddFlag"))="" s obj.ArgPerAddFlag="N"
	.e  s obj.ArgPerAddFlag=tmp("ArgPerAddFlag")
	i ($IsObject(obj.ArrangeDR))&&(obj.ArrangeDR.ArgStatus'="N")&&(obj.ArgPerDR'="") d
	.s obj.ArgPerCode=obj.ArgPerDR.PerPostName
	s obj.ArgPerBeds=$g(tmp("ArgPerBeds"))
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20170902
/// description: 排班记录行
/// table: DHCNMG.Arg.MgArrangeSub
/// input:
/// output:
/// other: w ##class(web.NurMgArgComm).SaveArgRows(^tmpArg("parr1"),^tmpArg("parr2"))
ClassMethod SaveArgRows(parr1 As %String, parr2 As %String) As %String
{
	
	;s ^tmpArg("parr1")=parr1,^tmpArg("parr2")=parr2
	q:(parr1="")||(parr2="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s flag=1
	f i=1:1:$L(parr2,"@") d
	.s parr=$P(parr2,"@",i)
	.q:parr=""
	.s parm="ArgPerDR|"_$P(parr,"^",1)_"^ArgPerSort|"_$P(parr,"^",2)_"^ArgWorkRemark|"_$P(parr,"^",3)_"^ArgGroupDR|"_$P(parr,"^",4)_"^rw|"_$P(parr,"^",5)_"^ArrangeDR|"_argid_"^ArgPerBeds|"_$P(parr,"^",6)
	.s argrowid=..SaveArgRow(parr1,parm)
	.i +argrowid=0 s flag=0
	q flag
}

/// Date:20200415
/// Creator:gzj
/// Description:判断减班是不是在合理的时间范围内
ClassMethod CheckReducePost(parr As %String) As %String
{
	q:parr="" 0
	s flag=0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s curStTime1=$g(tmp("ArgStTime1")) ;|00:00^ArgEndTime1|00:10
	i curStTime1'="" s curStTime1=$zth(curStTime1,1)
	s curEndTime1=$g(tmp("ArgEndTime1"))
	i curEndTime1'="" s curEndTime1=$zth(curEndTime1,1)
	s argRow=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",tmp("ArgPerDR"),$zdh($g(tmp("ArgDate")),3),""))
	q:argRow="" 0 //如果没有排班记录 则返回0 不允许减班操作
	s flag=1
	s ArgRow="" f  s ArgRow=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",tmp("ArgPerDR"),$zdh($g(tmp("ArgDate")),3),ArgRow)) q:((ArgRow="")||(flag=-1))  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(ArgRow)
	.q:'$IsObject(obj)
	.q:(obj.%Id()=$g(tmp("rw")))
	.s stTime1=obj.ArgStTime1
	.i stTime1'="" s stTime1=$zth(stTime1,1)
	.s endTime1=obj.ArgEndTime1
	.i endTime1["次日" s endTime1=86400+$zth($p(endTime1,"次日",2),1)
	.e  i ((endTime1'="")&&(endTime1'["次日")) s endTime1=$zth(endTime1,1)
	.s stTime2=obj.ArgStTime2
	.i stTime2'="" s stTime2=$zth(stTime2,1)
	.s endTime2=obj.ArgEndTime2
	.i endTime2["次日" s endTime2=86400+$zth($p(endTime2,"次日",2),1)
	.e  i ((endTime2'="")&&(endTime2'["次日"))  s endTime2=$zth(endTime2,1)
	.s stTime3=obj.ArgStTime3
	.i stTime3'="" s stTime3=$zth(stTime3,1)
	.s endTime3=obj.ArgEndTime3
	.i endTime3["次日" s endTime3=86400+$zth($p(endTime3,"次日",2),1)
	.e  i ((endTime3'="")&&(endTime3'["次日")) s endTime3=$zth(endTime3,1)
	.i ((stTime1'="")&&(endTime1'="")&&(curStTime1'="")&&(curStTime1'="")&&((curEndTime1<stTime1)||(curStTime1>endTime1)||((curStTime1<stTime1)&&(curEndTime1>=stTime1))||(curStTime1>=endTime1)||((curStTime1<=endTime1)&&(curEndTime1>endTime1)))) s flag=-1
	.i ((stTime2'="")&&(endTime2'="")&&(curStTime1'="")&&(curStTime1'="")&&((curStTime1<stTime2)||(curStTime1>endTime2)||((curStTime1<stTime2)&&(curEndTime1>=stTime2))||(curStTime1>=endTime2)||((curStTime1<=endTime2)&&(curEndTime1>endTime2)))) s flag=-1
	.i ((stTime3'="")&&(endTime3'="")&&(curStTime1'="")&&(curStTime1'="")&&((curStTime1<stTime3)||(curStTime1>endTime3)||((curStTime1<stTime3)&&(curEndTime1>=stTime3))||(curStTime1>=endTime3)||((curStTime1<=endTime3)&&(curEndTime1>endTime3)))) s flag=-1
	q flag
}

/// Creator:gzj
/// Date:2018-12-08
/// Description:检查人员当天的班次是否有重复的班次 或者时间段是否有重复
/// Input:
ClassMethod CheckRepeat(parr) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	
	q:$g(tmp("ArgDate"))="" 0
	s reduceFlag=1
	i $g(tmp("ArgType"))="N" s reduceFlag=..CheckReducePost(parr)
	q:(($g(tmp("ArgType"))="N")&&(reduceFlag=0)) "没有排班不能添加减班"
	q:(($g(tmp("ArgType"))="N")&&(reduceFlag=-1)) "不能在排班时间外添加减班"
	q:(($g(tmp("ArgType"))="N")&&(reduceFlag=1)) 0
	s curStTime1=$g(tmp("ArgStTime1"))
	i curStTime1'="" s curStTime1=$zth(curStTime1,1)
	s curEndTime1=$g(tmp("ArgEndTime1"))
	i ((curEndTime1'="")&&(curEndTime1'["次日")) s curEndTime1=$zth(curEndTime1,1)
	e  i ((curEndTime1'="")&&(curEndTime1["次日")) s curEndTime1=86400+$zth($p(curEndTime1,"次日",2),1)
	s curStTime2=$g(tmp("ArgStTime2"))
	i curStTime2'="" s curStTime2=$zth(curStTime2,1)
	s curEndTime2=$g(tmp("ArgEndTime2"))
	i (curEndTime2'="")&&(curEndTime2["次日") s curEndTime2=86400+$zth($p(curEndTime2,"次日",2),1)
	e  i (curEndTime2'="")&&(curEndTime2'["次日") s curEndTime2=$zth(curEndTime2,1)
	s curStTime3=$g(tmp("ArgStTime3"))
	i curStTime3'="" s curStTime3=$zth(curStTime3,1)
	s curEndTime3=$g(tmp("ArgEndTime3"))
	i ((curEndTime3'="")&&(curEndTime3["次日")) s curEndTime3=86400+$zth($p(curEndTime3,"次日",2),1)
	e  i ((curEndTime3'="")&&(curEndTime3'["次日")) s curEndTime3=$zth(curEndTime3,1)
	
	s flag=0
	s ArgRow="" f  s ArgRow=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",tmp("ArgPerDR"),$zdh($g(tmp("ArgDate")),3),ArgRow)) q:((ArgRow="")||(flag=1))  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(ArgRow)
	.q:'$IsObject(obj)
	.q:obj.%Id()=$g(tmp("rw"))
	.s stTime1=obj.ArgStTime1
	.i stTime1'="" s stTime1=$zth(stTime1,1)
	.s endTime1=obj.ArgEndTime1
	.i endTime1["次日" s endTime1=86400+$zth($p(endTime1,"次日",2),1)
	.e  i ((endTime1'="")&&(endTime1'["次日")) s endTime1=$zth(endTime1,1)
	.s stTime2=obj.ArgStTime2
	.i stTime2'="" s stTime2=$zth(stTime2,1)
	.s endTime2=obj.ArgEndTime2
	.i endTime2["次日" s endTime2=86400+$zth($p(endTime2,"次日",2),1)
	.e  i ((endTime2'="")&&(endTime2'["次日"))  s endTime2=$zth(endTime2,1)
	.s stTime3=obj.ArgStTime3
	.i stTime3'="" s stTime3=$zth(stTime3,1)
	.s endTime3=obj.ArgEndTime3
	.i endTime3["次日" s endTime3=86400+$zth($p(endTime3,"次日",2),1)
	.e  i ((endTime3'="")&&(endTime3'["次日")) s endTime3=$zth(endTime3,1)
	.i ((stTime1'="")&&(endTime1'="")&&(curStTime1'="")&&(((curStTime1>=stTime1)&&(curStTime1<endTime1))||((curStTime1<stTime1)&&(curEndTime1>endTime1)))) s flag=1
	.i ((stTime1'="")&&(endTime1'="")&&(curStTime2'="")&&(((curStTime2>=stTime1)&&(curStTime2<endTime1))||((curStTime2<stTime1)&&(curEndTime2>endTime1)))) s flag=1
	.i ((stTime1'="")&&(endTime1'="")&&(curStTime3'="")&&(((curStTime3>=stTime1)&&(curStTime3<endTime1))||((curStTime3<stTime1)&&(curEndTime3>endTime1)))) s flag=1
	.i ((stTime2'="")&&(endTime2'="")&&(curStTime1'="")&&(((curStTime1>=stTime2)&&(curStTime1<endTime2))||((curStTime1<stTime2)&&(curEndTime2>endTime2)))) s flag=1
	.i ((stTime2'="")&&(endTime2'="")&&(curStTime2'="")&&(((curStTime2>=stTime2)&&(curStTime2<endTime2))||((curStTime2<stTime2)&&(curEndTime2>endTime2)))) s flag=1
	.i ((stTime2'="")&&(endTime2'="")&&(curStTime3'="")&&(((curStTime3>=stTime2)&&(curStTime3<endTime2))||((curStTime3<stTime2)&&(curEndTime3>endTime2)))) s flag=1
	.i ((stTime3'="")&&(endTime3'="")&&(curStTime1'="")&&(((curStTime1>=stTime3)&&(curStTime1<endTime3))||((curStTime1<stTime3)&&(curEndTime3>endTime3)))) s flag=1
	.i ((stTime3'="")&&(endTime3'="")&&(curStTime2'="")&&(((curStTime2>=stTime3)&&(curStTime2<endTime3))||((curStTime2<stTime3)&&(curEndTime2>endTime3)))) s flag=1
	.i ((stTime3'="")&&(endTime3'="")&&(curStTime3'="")&&(((curStTime3>=stTime3)&&(curStTime3<endTime3))||((curStTime3<stTime3)&&(curEndTime3>endTime3)))) s flag=1
	q flag
}

/// creator: xbl
/// createdate: 20170902
/// description: 排班明细
/// table: DHCNMG.Arg.MgArrangeSub
/// input:
/// output:
/// other: w ##class(web.NurMgArgComm).SaveArgSub(^tmpArg("parr1"),^tmpArg("parr2"),^tmpArg("parr3"))
ClassMethod SaveArgSub(parr1 As %String, parr2 As %String, parr3 As %String) As %String
{
	s ^tmpArg("parr1")=parr1,^tmpArg("parr2")=parr2,^tmpArg("parr3")=parr3
	q:(parr1="")||(parr2="")||(parr3="") 0
	s repeatFlag=..CheckRepeat(parr3)
	q:repeatFlag=1 "当天班次时间有交叉"
	q:repeatFlag="没有排班不能添加减班" "没有排班不能添加减班"
	q:repeatFlag="不能在排班时间外添加减班" "不能在排班时间外添加减班"
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s argrowid=..SaveArgRow(parr1,parr2)
	q:+argrowid=0 0
	s argobj=##class(DHCNMG.Arg.MgArrange).%OpenId(argid)
	q:argobj.ArgWardDR="" 0
	s ward=argobj.ArgWardDR.%Id()
	d ##class(web.NurMgVueComm).SplitStr(parr3,"^","|",.tmp)
	s perdr=$g(tmp("ArgPerDR"))
	s date=$g(tmp("ArgDate"))
	s:date["-" date=$zdh(date,3)
	s postdr=$g(tmp("ArgPostDR"))
	s ArgType=$g(tmp("ArgType"))
	q:(perdr="")!(date="")!((postdr="")&&(ArgType'="Y")&&(ArgType'="N")) 0
	s curward=##class(web.NurMgHRComm).GetCurrentWard(perdr,date)
	s argrowObj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(argrowid)
	q:(curward'=ward)&&(argrowObj.ArgPerAddFlag'="Y") 0
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%New()
	s obj.ArrangeDR=##class(DHCNMG.Arg.MgArrange).%OpenId(argid)
	s obj.ArgRowDR=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(argrowid)
	s obj.ArgWardDR=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	s obj.ArgPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	s obj.ArgPostDR=##class(DHCNMG.DB.MgArgWardPost).%OpenId($g(tmp("ArgPostDR")))
	s:$IsObject(obj.ArgPostDR) obj.ArgCategory=obj.ArgPostDR.PostCategory
	s obj.ArgDate=date
	s obj.ArgStTime1=$g(tmp("ArgStTime1"))
	s obj.ArgEndTime1=$g(tmp("ArgEndTime1"))
	s obj.ArgStTime2=$g(tmp("ArgStTime2"))
	s obj.ArgEndTime2=$g(tmp("ArgEndTime2"))
	s obj.ArgStTime3=$g(tmp("ArgStTime3"))
	s obj.ArgEndTime3=$g(tmp("ArgEndTime3"))
	s remark=$g(tmp("ArgWorkRemark"))
	s:remark="" remark=$g(tmp("ArgRemark"))
	s obj.ArgRemark=remark
	i obj.ArgPostDR.PostDR.PostType="H" d
	.s obj.ArgHolidayTime=$g(tmp("ArgHolidayTime"))
	e  s obj.ArgHolidayTime=""
	i $g(tmp("ArgEditUser"))'="" d
	.s obj.ArgEditUser=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("ArgEditUser"))
	e  s obj.ArgEditDate=""
	s obj.ArgEditDate=+$h
	s obj.ArgEditTime=$P($h,",",2)
	s obj.ArgSecStTime=$g(tmp("ArgSecStTime"))
	s obj.ArgSecEndTime=$g(tmp("ArgSecEndTime"))
	s obj.ArgType=ArgType
	i (((argobj.ArgStatus="R")||(argobj.ArgStatus="A")||(argobj.ArgStatus="B"))&&((ArgType="Y")||(ArgType="N"))) d
	.s LogObj=##class(DHCNMG.Arg.MgArrangeLog).%New()
	.s LogObj.ArgLogPerDR=obj.ArgPerDR.%Id()
	.s LogObj.ArrangeDR=obj.ArrangeDR
	.s LogObj.ArgLogArgDate=obj.ArgDate
	.s LogObj.ArgLogAfter=$case(obj.ArgType,"Y":"加班"_obj.ArgStTime1_"-"_obj.ArgEndTime1,"N":"减班"_obj.ArgStTime1_"-"_obj.ArgEndTime1)
	.s LogObj.ArgLogRemark="添加班次"
	.s LogObj.ArgLogCrt=$g(tmp("ArgEditUser"))
	.s LogObj.ArgLogCrtDate=+$h
	.s LogObj.ArgLogCrtTime=$p($h,",",2)
	.s sc1=LogObj.%Save()
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20170902
/// description: 排班明细
/// table: DHCNMG.Arg.MgArrangeSub
/// input:
/// output:
/// other: w ##class(web.NurMgArgComm).GetArgSubById(19)
ClassMethod GetArgSubById(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret="rw|"_id
	i obj.ArgWardDR'="" d
	.s ret=ret_"^ArgWardDR|"_obj.ArgWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.ArgWardDR.WardDesc
	i obj.ArgPerDR'="" d
	.s ret=ret_"^ArgPerDR|"_obj.ArgPerDR.%Id()
	.s ret=ret_"^PerName|"_obj.ArgPerDR.PerName
	i obj.ArgDate'="" s ret=ret_"^ArgDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ArgDate)
	i obj.ArgPostDR'="" d
	.s ret=ret_"^ArgPostDR|"_obj.ArgPostDR.%Id()
	.s ret=ret_"^PostDesc|"_obj.ArgPostDR.PostDesc
	.i obj.ArgPostDR.PostDR'="" d
	..s ret=ret_"^ArgPostType|"_obj.ArgPostDR.PostDR.PostType 
	s ret=ret_"^ArgStTime1|"_obj.ArgStTime1
	s ret=ret_"^ArgEndTime1|"_obj.ArgEndTime1
	s ret=ret_"^ArgStTime2|"_obj.ArgStTime2
	s ret=ret_"^ArgEndTime2|"_obj.ArgEndTime2
	if ((obj.ArgType="Y")||(obj.ArgType="N")){
		s ret=ret_"^ArgRemark|"_obj.ArgRemark
	} else {
		s ret=ret_"^ArgWorkRemark|"_obj.ArgRemark
	}
	s ret=ret_"^ArgStTime3|"_obj.ArgStTime3
	s ret=ret_"^ArgEndTime3|"_obj.ArgEndTime3
	s ret=ret_"^ArgSecStTime|"_obj.ArgSecStTime
	s ret=ret_"^ArgSecEndTime|"_obj.ArgSecEndTime
	s ret=ret_"^ArgHolidayTime|"_obj.ArgHolidayTime
	s ret=ret_"^HolidayTime|"_$case(obj.ArgHolidayTime,"H":"全天","A":"上午","P":"下午",:"")
	i obj.ArgEditUser'="" d
	.s ret=ret_"^ArgEditUser|"_obj.ArgEditUser.%Id()
	.s ret=ret_"EditUserName|"_obj.ArgEditUser.PerName
	i obj.ArgEditDate'="" d
	.s ret=ret_"^ArgEditDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(obj.ArgEditDate)
	i obj.ArgEditTime'="" d
	.s ret=ret_"^ArgEditTime|"_$zt(obj.ArgEditTime,2)
	s ret=ret_"^ArgType|"_obj.ArgType
	q ret
}

/// creator: xbl
/// createdate: 20170902
/// description: 排班明细
/// table: DHCNMG.Arg.MgArrangeSub
/// input:
/// output:
/// other:
ClassMethod GetArgSub(ward As %String, perdr As %String, date As %String) As %String
{
}

/// creator: llin
/// createdate: 2018-07-24
/// description: 根据id删除班次
/// table: DHCNMG.Arg.MgArrangeSub
/// input:
/// output:
/// other:
ClassMethod DeleteArgSubById(parr) As %String
{
	s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(parr)
	q:'$IsObject(obj) 0
	s sc =obj.%DeleteId(parr)
	s ret=1
	s:$$$ISERR(sc) ret=0
	q ret
}

/// creator: xbl
/// createdate: 20170902
/// description: 删除排班明细
/// table: DHCNMG.Arg.MgArrangeSub
/// input:
/// output:
/// other: w ##class(web.NurMgArgComm).DeleteArgSub(^tmpXbl("parr1"),^tmpXbl("parr2"),"2017-09-11")
ClassMethod DeleteArgSub(parr1 As %String, parr2 As %String, date As %String) As %String
{
	;s ^tmpXbl("parr1")=parr1,^tmpXbl("parr2")=parr2
	q:(parr1="")!(parr2="")!(date="") 0
	s:date["-" date=$zdh(date,3)
	Ts
	s argid=..SaveArrange(parr1)
	i +argid=0 {
		Tro
		q "保存排班表失败"
	}
	q:+argid=0 0
	s argrowid=..SaveArgRow(parr1,parr2)
	i +argrowid=0 
	{
		Tro
		q "保存行表失败"
	}
	s flag=1
	s ret=""
	s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,argrowid,date,id)) q:(id="")||(flag=0)  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	.i obj.ArgReplaceDR'="" s flag=0,ret="存在替班,不可删除"
	.i (obj.ArgConfirmDR'="")||(obj.ArgConfirmDate'="") s flag=0,ret="已确认,不可删除"
	.;i ((obj.ArrangeDR.ArgStatus="R")||(obj.ArrangeDR.ArgStatus="A"))&&(date<+$h) s flag=0,ret="已提交且小于当前日期,不可删除"
	.q:flag=0
	.d obj.%DeleteId(id)
	if flag=1 
	{
		Tc
		q 1	
	}else{
		Tro
		q ret	
	}
}

/// creator: xbl
/// createdate: 20170902
/// description: 删除排班明细
/// table: DHCNMG.Arg.MgArrangeSub
/// input:
/// output:
/// other: w ##class(web.NurMgArgComm).DeletePerArgSub(^tmpXbl("parr1"),^tmpXbl("parr2"))
ClassMethod DeletePerArgSub(parr1 As %String, parr2 As %String) As %String
{
	;s ^tmpXbl("parr1")=parr1,^tmpXbl("parr2")=parr2
	q:(parr1="")!(parr2="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s flag=1
	f i=1:1:$L(parr2,",") d
	.s perdr=$P(parr2,",",i)
	.q:(perdr="")||($d(^DHCNMG.HR.MgPersonsD(perdr))=0)
	.s rowid=$O(^DHCNMG.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	.q:rowid=""
	.s date="" f  s date=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowid,date)) q:date=""  d
	..s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowid,date,id)) q:id=""  d
	...s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	...s sc=obj.%DeleteId(id)
	...i $$$ISERR(sc) s flag=0
	q flag
}

/// creator: 
/// createdate: 2017-09-02
/// description: 排班明细
/// table: DHCNMG.Arg.MgArrangeSub
/// input:
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgArgComm","FindArrangeSubList","109^2019-08-12^2019-08-18","",0,0)
Query FindArrangeSubList(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArrangeSubListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s starttime= $p($H,",",2)
	s ward=$P(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	i (ward="")!(stdate="")!(enddate="")!(role="")!(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s tmpHoliday="",tmpWorkDay=""
	s yearSt=$p($zd(stdate,3),"-",1)
	s yearEnd=$p($zd(enddate,3),"-",1)
	s sc=..setHolidayTmp(yearSt,.tmpHoliday,0)
	s sc=..setHolidayTmp(yearSt,.tmpWorkDay,1)
	s sc=..setHolidayTmp(yearEnd,.tmpHoliday,0)
	s sc=..setHolidayTmp(yearEnd,.tmpWorkDay,1)
	s editflagN=0,editflagP=0
	i nurseid=0  s editflagN=1,editflagP=1
	e  d
	.f i=1:1:$l(role,"^") q:((editflagN=1)&&(editflagP=1))  d
	..s roleObj=##class(DHCNMG.Set.MgRoles).%OpenId($p(role,"^",i))
	..q:'$IsObject(roleObj)
	..s:roleObj.RoleDesc["护士长" editflagN=1,editflagP=1
	..s:roleObj.RoleDesc="管理员" editflagN=1,editflagP=1
	..s:roleObj.RoleDesc["护理组长" editflagN=1
	..s:roleObj.RoleDesc["教学组长" editflagP=1
	s listno=$zd(stdate,8)_ward
	s argid=$O(^DHCNMG.Arg.MgArrangeI("ListNo"," "_listno,""))
	k nurlist,tmpgroup
	s nurlist="",tmpgroup=""
	d ..GetWardNurse(argid,ward,stdate,enddate,"",.nurlist,.tmpgroup)
	s row=1
	
	s grptyp="" f  s grptyp=$O(tmpgroup(grptyp)) q:grptyp=""  d
	.s groupsort="" f  s groupsort=$O(tmpgroup(grptyp,groupsort)) q:groupsort=""  d
	..s grp="" f  s grp=$O(tmpgroup(grptyp,groupsort,grp)) q:grp=""  d
	...s GrpDesc=""
	...s grpobj=""
	...i grptyp="G" d //分组行数据
	....i (+grp=0)||($d(^DHCNMG.Arg.MgNurGroupD(grp))=0) d
	.....s ret="PerName|未分组"_"^remarkedit|0^bededit|0"_"^bedCodes|"_"^ArgGroupDR|"_grp
	.....d OutArrangeSub
	....e  d
	.....s grpobj=##class(DHCNMG.Arg.MgNurGroup).%OpenId(grp)
	.....s bedCodes=##class(web.NurMgHISComm).GetBedByGroup(grpobj.GroupBedGroup)
	.....s ret="PerName|"_grpobj.GroupDesc_"^ArgGroupDR|"_grp_"^remarkedit|0^bededit|0"_"^bedCodes|"_bedCodes
	.....s GrpDesc=grpobj.GroupDesc
	.....d OutArrangeSub
	...i (grptyp="A") d
	....i (+grp=0)||($d(^DHCNMG.Arg.MgArrangeGroupD(grp))=0) d
	.....s ret="PerName|未分组"_"^remarkedit|0^bededit|0"_"^bedCodes|"_"^ArgGroupDR|"_grp
	.....d OutArrangeSub
	....e  d
	.....s grpobj=##class(DHCNMG.Arg.MgArrangeGroup).%OpenId(grp)
	.....s bedCodes=""
	.....f i=1:1:grpobj.GroupResBeds.Count() d
	......s bedId=grpobj.GroupResBeds.GetAt(i)
	......q:bedId=""
	......s bedcode=$P($g(^PAWARD(+bedId,"BED",$p(bedId,"||",2))),"^",1)
	......i bedCodes="" s bedCodes=bedcode
	......e  s bedCodes=bedCodes_","_bedcode
	.....s ret="PerName|"_grpobj.GroupDesc_"^ArgGroupDR|"_grp_"^remarkedit|0^bededit|0"_"^bedCodes|"_bedCodes
	.....s GrpDesc=grpobj.GroupDesc
	.....d OutArrangeSub
	...//护士行数据信息
	...s GrpSort=0
	...s sort="" f  s sort=$O(nurlist(ward,grptyp,grp,sort)) q:sort=""  d
	....s perdr="" f  s perdr=$O(nurlist(ward,grptyp,grp,sort,perdr)) q:perdr=""  d
	.....s GrpSort=GrpSort+1
	.....s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.....q:'$IsObject(perobj)
	.....s nurInfo=..GetNurseLevel(stdate,perdr) //珠海改进方法 2019-01-04 gzj新增
	.....s roledesc=""
	.....s roledesc=$p(nurInfo,"^",2)
	.....;s:$zcvt(perobj.PerTypeDR,"U")="P" roledesc="$" //珠海改进方法 2019-01-04 gzj注释
	.....;s:$zcvt(perobj.PerTypeDR,"U")="A" roledesc="§"	//珠海改进方法 2019-01-04 gzj注释
	.....;s:$zcvt(perobj.PerTypeDR,"U")="T" roledesc="¤"	//珠海改进方法 2019-01-04 gzj注释
	.....i perobj.PerTypeDR="S" s roledesc="◇"
	.....s:(($IsObject(grpobj))&&($IsObject(grpobj.GroupMaster))&&(grpobj.GroupMaster.%Id()=perdr)) roledesc="★"
	.....s dutydesc=##class(web.NurMgHRComm).GetDutyDesc(perdr,+$h,+$h)
	.....s:dutydesc["护士长" roledesc="@"
	.....s argrowid=nurlist(ward,grptyp,grp,sort,perdr)
	.....s leveldesc=##class(web.NurMgHRComm).GetLevelDesc(perdr,stdate,enddate)
	.....s isEditPost=0 ;编辑权限
	.....s:((perobj.PerTypeDR="N")&&(editflagN=1)) isEditPost=1
	.....s:((perobj.PerTypeDR="P")&&(editflagP=1)) isEditPost=1
	.....s:((editflagN=1)&&(editflagP=1)) isEditPost=1
	.....s ret="PerName|"_roledesc_perobj.PerName_perobj.PerID_"^PerID|"_perobj.PerID_"^ArgPerDR|"_perdr_"^ArgRowId|"_$case(argrowid,"-":"",:argrowid)_"^ArgPerSort|"_row
	.....s ret=ret_"^LevelDesc|"_leveldesc_"^GrpDesc|"_GrpDesc_"^GrpSort|"_GrpSort_"^isEditPost|"_isEditPost
	.....s PerPost=##class(web.NurMgHRComm).GetTitleDesc(perdr,stdate,enddate)
	.....s ret=ret_"^PerPost|"_PerPost
	.....s ret=ret_"^ArgGroupDR|"_grp
	.....s PerCode=perobj.PerPostName
	.....s totalminute=0,nightminute=0,secminute=0,plusminute=0
	.....i ((argid'="")&&(+argrowid'=0)&&($d(^DHCNMG.Arg.MgArrangeRowD(argrowid)))) d
	......s rowObj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(argrowid)
	......q:'$IsObject(rowObj)
	......s:rowObj.ArrangeDR.ArgStatus'="N" PerCode=rowObj.ArgPerCode
	......s ret=ret_"^ArgWorkRemark|"_rowObj.ArgWorkRemark
	......s ret=ret_"^ArgPerBeds|"_rowObj.ArgPerBeds
	......;s totalminute=0,nightminute=0,secminute=0,plusminute=0
	......f date=stdate:1:enddate d
	.......s ret=ret_"^Date"_$zd(date,3)_"|"
	.......s celldesc=""
	.......s tmpIsAskLeave=..IsPerAskLeavel3(perdr_"^"_date)
	.......s isAskLeave=$p(tmpIsAskLeave,"^")
	.......s askLeaveDesc=$p(tmpIsAskLeave,"^",2)
	.......s replaceDesc="%"
	.......s curward=##class(web.NurMgHRComm).GetCurrentWard(perdr,date)
	.......s secondWard=..GetPostForOther(perdr,date,curward)
	.......s tWard=..GetPostForOther(perdr,date,ward)
	.......;不在本病区且不是护士长添加||本病区护士在其他病区有排班...||护士长添加人员其他病区有排班
	.......;i ((curward'="")&&(curward'=ward)&&(rowObj.ArgPerAddFlag'="Y"))||((tWard'="")&&(tWard'=ward)&&(rowObj.ArgPerAddFlag="Y")) d ;不是当前科室的
	.......i ((curward'="")&&(curward'=ward)&&(rowObj.ArgPerAddFlag'="Y"))||((tWard'="")&&(tWard'=ward)) d
	........s curwardObj=##class(DHCNMG.DB.MgWard).%OpenId(tWard)
	........i tWard="" s curwardObj=##class(DHCNMG.DB.MgWard).%OpenId(curward)
	........s celldesc="」"_curwardObj.WardDesc
	.......e  d
	........s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,argrowid,date,id)) q:id=""  d
	.........q:+id=0
	.........s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	.........q:((obj.ArgPostDR="")&&(obj.ArgType'="Y")&&(obj.ArgType'="N"))
	.........s PostDesc=""
	.........i obj.ArgType="Y" d
	..........s PostDesc=$fn(($zth(obj.ArgEndTime1,1)-$zth(obj.ArgStTime1,1))/3600,"",1)
	.........e  i obj.ArgType="N" d
	..........s PostDesc="-"_$fn(($zth(obj.ArgEndTime1,1)-$zth(obj.ArgStTime1,1))/3600,"",1)
	.........e  s PostDesc=obj.ArgPostDR.PostDesc
	.........;【南通中医备注添加上】
	.........;i celldesc="" s celldesc=id_"」"_obj.ArgPostDR.PostDesc
	.........;e  s celldesc=celldesc_"「"_id_"」"_obj.ArgPostDR.PostDesc
	.........i celldesc="" s celldesc=id_"」"_PostDesc_obj.ArgRemark
	.........e  s celldesc=celldesc_"「"_id_"」"_PostDesc_obj.ArgRemark
	.........//请假处理
	.........s:obj.ArgPostDR.PostDR.PostType="H" isAskLeave=0
	.........q:obj.ArgPostDR.PostDR.PostType="H"
	.........s ArgIsReplace=obj.ArgIsReplace
	.........i (ArgIsReplace'="") d
	..........s:$IsObject(obj.ArgReplaceDR) replaceDesc=$Case(ArgIsReplace,"2":"替",:"")_obj.ArgReplaceDR.PerName_$Case(ArgIsReplace,"1":"替",:"")
	........s totalminute=totalminute+..CountMinutes(perdr,date,ward,0)
	........s nightminute=nightminute+..CountNightMinutes(perdr,date,ward,0)
	........s secminute=secminute+..CountSecondMinutes(perdr,date,ward,0)
	........s plusminute=plusminute+..CountMinutesPlus(perdr,date,ward,0)
	.......s:(replaceDesc="%")&&(isAskLeave=1) replaceDesc="%"_askLeaveDesc
	.......//意愿排班
	.......s wishArg="%"_..getWishArrangeForArgSub(ward,date,perdr)
	.......s ret=ret_celldesc_replaceDesc_wishArg
	......s totalminute=totalminute+plusminute
	......s ret=ret_"^ArgTotalHour|"_(totalminute\60)_"时"_(totalminute#60)_"分"_"^ArgNightHour|"_(nightminute\60)_"时"_(nightminute#60)_"分"
	......s ret=ret_"^ArgSecondHour|"_(secminute\60)_"时"_(secminute#60)_"分"
	.....e  d
	......f date=stdate:1:enddate d
	.......s ret=ret_"^Date"_$zd(date,3)_"|"
	.......s celldesc="",wishArg="%"
	.......s curward=##class(web.NurMgHRComm).GetCurrentWard(perdr,date)
	.......;s secondWard=..GetPostForOther(perdr,date,curward)
	.......s tWard=..GetPostForOther(perdr,date,ward)
	.......;不在本病区且不是护士长添加||非本病区排班且护士长添加
	.......i ((curward'="")&&(curward'=ward))||((tWard'="")&&(tWard'=ward)) d ;不是当前科室的
	........s curwardObj=##class(DHCNMG.DB.MgWard).%OpenId(tWard)
	........i tWard="" s curwardObj=##class(DHCNMG.DB.MgWard).%OpenId(curward)
	........s celldesc="」"_curwardObj.WardDesc_"%"
	.......e  d
	........s tmpIsAskLeave=..IsPerAskLeavel3(perdr_"^"_date)
	........s isAskLeave=$p(tmpIsAskLeave,"^")
	........s askLeaveDesc=$p(tmpIsAskLeave,"^",2)
	........s:isAskLeave=1 celldesc="%"_askLeaveDesc
	.......s:celldesc="" celldesc="%"
	.......//意愿排班数据
	.......s wishArg=wishArg_..getWishArrangeForArgSub(ward,date,perdr)
	.......s ret=ret_celldesc_wishArg
	.....s:PerCode'="" PerCode=##class(web.NurMgPersonComm).GetCommCode(PerCode) ;岗位
	.....s ProductHour=""
	.....s ProductHour=..GetArgProductHour(stdate,enddate,perdr,.tmpHoliday,.tmpWorkDay)
	.....s ret=ret_"^PerCode|"_PerCode_"^ArgProductHour|"_$p(ProductHour,"^")_"^ArgAllProductHour|"_$p(ProductHour,"^",2)_"^remarkedit|0"_"^bededit|0"
	.....d OutArrangeSub
	.....s row=row+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutArrangeSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArrangeSubListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArrangeSubListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArrangeSubListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArrangeSubListExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:
/// Createdate:
/// Description: 
/// Table:DHCNMG.Arg.MgArrangeSub
/// Input: 
/// Output:
/// Return:
/// Other: w ##class(%ResultSet).RunQuery("web.NurMgArgComm","FindNurseArgSub","109","2019-07-22","2019-07-28","120!7346")
Query FindNurseArgSub(ward As %String, stDate As %String, endDate As %String, parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurseArgSubExecute(ByRef qHandle As %Binary, ward As %String, stDate As %String, endDate As %String, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i $l(stDate,"-")=3 s stDate=$zdh(stDate,3)
	e  i (($l(stDate,"/")=3)&&($l($p(stDate,"/",1))=4)) s stDate=$zdh( stDate,5)
	e  i (($l(stDate,"/")=3)&&($l($p(stDate,"/",3))=4)) s stDate=$zdh( stDate,5)
	i $l(endDate,"-")=3 s endDate=$zdh(endDate,3)
	e  i (($l(endDate,"/")=3)&&($l($p(endDate,"/",1))=4)) s endDate=$zdh(endDate,5)
	e  i (($l(endDate,"/")=3)&&($l($p(endDate,"/",3))=4)) s endDate=$zdh(endDate,5)
	s tmpHoliday="",tmpWorkDay=""
	s year=$p($zd(stDate,3),"-",1)
	s year2=$p($zd(endDate,3),"-",1)
	s sc=..setHolidayTmp(year,.tmpHoliday,0)
	s sc=..setHolidayTmp(year,.tmpWorkDay,1)
	s sc=..setHolidayTmp(year2,.tmpHoliday,0)
	s sc=..setHolidayTmp(year2,.tmpWorkDay,1)
	s len=$l(parr,"^")
	s tmp=""
	s argId=$O(^DHCNMG.Arg.MgArrangeI("ListNo"," "_$tr($zd(stDate,3),"-","")_ward,""))
	f i=1:1:len
	{
		//14!7345^14!7345^120!7346^120!7346
		s itm=$p(parr,"^",i)
		i itm="" continue
		s per=$p(itm,"!",1)
		s rowId=$P(itm,"!",2)
		i rowId=""  s rowId=$O(^DHCNMG.Arg.MgArrangeRowI("ArgPerson",argId,per,""))
		s rowObj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(rowId)
		i '$IsObject(rowObj) continue
		i $g(tmp(per))="" s tmp(per)=rowId
	}
	
	s tmpPer="" f  s tmpPer=$o(tmp(tmpPer)) q:tmpPer=""  d
	.s ret="ArgPerDR|"_tmpPer
	.s totalminute=0,plusminute=0
	.s rowObj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(tmp(per))
	.f date=stDate:1:endDate d
	..s ret=ret_"^Date"_$zd(date,3)_"|"
	..s celldesc=""
	..s tmpIsAskLeave=..IsPerAskLeavel3(tmpPer_"^"_date)
	..s isAskLeave=$p(tmpIsAskLeave,"^")
	..s askLeaveDesc="%"_$p(tmpIsAskLeave,"^",2)
	..s curward=##class(web.NurMgHRComm).GetCurrentWard(tmpPer,date)
	..s secondWard=..GetPostForOther(tmpPer,date,curward)
	..s tWard=..GetPostForOther(tmpPer,date,ward)
	..;不在本病区且不是护士长添加||本病区护士在其他病区有排班||护士长添加人员其他病区有排班
	..;i ((curward'="")&&(curward'=ward)&&(rowObj.ArgPerAddFlag'="Y"))||((tWard'="")&&(tWard'=ward)&&(rowObj.ArgPerAddFlag="Y")) d ;不是当前科室的
	..i ((curward'="")&&(curward'=ward)&&(rowObj.ArgPerAddFlag'="Y"))||((tWard'="")&&(tWard'=ward)) d
	...s curwardObj=##class(DHCNMG.DB.MgWard).%OpenId(tWard)
	...i tWard="" s curwardObj=##class(DHCNMG.DB.MgWard).%OpenId(curward)
	...s celldesc="」"_curwardObj.WardDesc
	..e  i isAskLeave=0 d
	...s Row="" f  s Row=$o(^DHCNMG.Arg.MgArrangeSubI("WardPerDate",ward,tmpPer,date,Row)) q:Row=""  d
	....s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(Row)
	....q:'$IsObject(obj)
	....q:((obj.ArgPostDR="")&&(obj.ArgType'="Y")&&(obj.ArgType'="N"))
	....s PostDesc=""
	....i obj.ArgType="Y" d
	.....s PostDesc=$fn(($zth(obj.ArgEndTime1,1)-$zth(obj.ArgStTime1,1))/3600,"",1)
	....e  i obj.ArgType="N" d
	.....s PostDesc="-"_$fn(($zth(obj.ArgEndTime1,1)-$zth(obj.ArgStTime1,1))/3600,"",1)
	....e  s PostDesc=obj.ArgPostDR.PostDesc
	....i celldesc="" s celldesc=Row_"」"_PostDesc_obj.ArgRemark
	....e  s celldesc=celldesc_"「"_Row_"」"_PostDesc_obj.ArgRemark
	..;s:isAskLeave=1 askLeaveDesc="请假"
	..s wishArg="%"_..getWishArrangeForArgSub(ward,date,tmpPer)
	..s ret=ret_celldesc_askLeaveDesc_wishArg
	..s totalminute=totalminute+..CountMinutes(tmpPer,date,ward,0)
	..s plusminute=plusminute+..CountMinutesPlus(tmpPer,date,ward,0)
	.s totalminute=totalminute+plusminute
	.s ProductHour=..GetArgProductHour(stDate,endDate,tmpPer,.tmpHoliday,.tmpWorkDay)
	.s ret=ret_"^ArgTotalHour|"_(totalminute\60)_"时"_(totalminute#60)_"分"_"^ArgProductHour|"_$p(ProductHour,"^")_"^ArgAllProductHour|"_$p(ProductHour,"^",2)
	.d OutNurseArgSub
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurseArgSub
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseArgSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseArgSubExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurseArgSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseArgSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNurseArgSub(ward As %String, stDate As %String, endDate As %String, parr As %String) As %String
{
	
	
	q 0
}

ClassMethod GetNurseStatus(type As %String, param As %String) As %String
{
	
	s ret=""
	s par=$o(^DHCNMG.DB.MgSetCodeI("Code"," "_$tr(param," ",""),""))
	i par'=""
	{
		s rw=$o(^DHCNMG.DB.MgSetCodeSubI("Code",par," "_type,""))
		i rw'=""
		{
			s obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(par_"||"_rw)
			q:'$IsObject(obj) ""
			s ret=obj.SubSymbol
		}
	}
	q ret
}

/// Creator:gzj
/// CreateDate:2019-01-11
/// Desccription:根据日期获取人员的层级以及显示符号和周标准工作时长
/// 
ClassMethod GetNurseLevel(stdate As %String, perdr As %String) As %String
{
	q:((stdate="")!(perdr="")) ""
	s ret=""
	s level="",status="",hours=0,nurType=""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	q:'$IsObject(obj) ""
	
	s PerInternDate=obj.PerInternDate  ///实习生转助护日期	
	s PerInternToStu=obj.PerInternToStu ///实习生转学员日期
	s PerStuToAss=obj.PerStuToAss // 学员 转成助护的日期
	s PerStuToNurse=obj.PerStuToNurse /// 学员转成护士的日期
	s PerAssToNurse=obj.PerAssToNurse /// 助护转成护士的日期
	s PerAssToStu=obj.PerAssToStu /// 助护转 学员 日期
	s PerTypeDR=obj.PerTypeDR //人员类型
	///判断是实习生
	///第一种情况 所有日期都为空 并且类型为P
	///第二种情况 实习生转助护的日期不为空 类型为A（助护） 其他日期都为空 且stdate小于该日期
	///第三种情况 实习生转学员的日期不为空 类型为T（学员） 其他日期都为空 且stdate小于该日期
	///第四种情况 实习生转为学员的日期不为空 学员转为助护的日期不为空 且实习转为学员的日期小于学员转为助护的日期且stdate 小于实习生转为学员的日期
	///第五种情况 实习生转为助护的日期不为空 助护转为学员的日期不为空 且实习生转助护的日期小于助护转学员的日期且stdate小于实习生转助护的日期
	///第六种情况实习生转学员日期不空 学员转助护日期不空 助护转正日期不空 且实习生转学员小于学员转助护  学员转助护小于助护转正 stdate小于实习生转学员
	///第七种情况 实习生转助护日期不空 助护转学员日期不空 学员转正日期不空且实习生转助护小于助护转学员 助护转学员小于学员转正 stdate小于实习生转助护
	i ((PerInternDate="")&&(PerInternToStu="")&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToNurse="")&&(PerAssToStu=""))&&(PerTypeDR="P") d
	.s level="",status="$",hours=35,nurType="P"
	e  i ((PerInternDate'="")&&(PerInternToStu="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToNurse="")&&(PerAssToStu=""))&&(PerTypeDR="A")&&(stdate<PerInternDate) d
	.s level="",status="$",hours=35,nurType="P"
	e  i ((PerInternToStu'="")&&(PerInternDate="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToNurse="")&&(PerAssToStu=""))&&(PerTypeDR="A")&&(stdate<PerInternToStu) d
	.s level="",status="$",hours=35,nurType="P"
	e  i ((PerInternToStu'="")&&(PerStuToAss'="")&&(PerInternToStu<PerStuToAss)&&(stdate<PerInternToStu)) d
	.s level="",status="$",hours=35,nurType="P"
	e  i ((PerInternDate'="")&&(PerAssToStu'="")&&(PerInternDate<PerAssToStu)&&(stdate<PerInternDate)) d
	.s level="",status="$",hours=35,nurType="P"
	e  i ((PerInternToStu'="")&&(PerStuToAss'="")&&(PerAssToNurse'="")&&(PerInternToStu<PerStuToAss)&&(PerStuToAss<PerAssToNurse)&&(stdate<PerInternToStu)) d
	.s level="",status="$",hours=35,nurType="P"
	e  i ((PerInternDate'="")&&(PerAssToStu'="")&&(PerStuToNurse'="")&&(PerInternDate<PerAssToStu)&&(PerAssToStu<PerStuToNurse)&&(stdate<PerInternDate)) d
	.s level="",status="$",hours=35,nurType="P"
	///判断是学员
	///第一种情况日期都为空 且类型为T 则一定是学员
	///第二种情况 实习转学员日期不空，其他日期都空且stdate大于该日期
	///第三种情况 实习转学员日期不空且 学员转助护日期不空且 实习转学员小于学员转助护且stdate大于实习生转学员 且stdate小于学员转助护
	///第四种情况 实习转学员日期不空且学员转助护日期不空且助护转正日期不空且 实转学小于学转助 小于助转正 且stdate小于学转助 且大于实习转学员
	///第五种情况 实习转学员日期不空且 学员转正日期不为空 其他为空且 实转学小于学转正 且stdate小于学转正 stdate大于实转学
	///第六种情况 实习转学员日期空 学员转助护不空 且类型为A 且stdate小于学员转助护
	///第七种情况 实习转学员日期空 学员转助护不空 助护转正不空 且学转助小于 助转正 且stdate小于 学转助
	///第八种情况 实习转学员日期空 学员转正日期不空其他都空且stdte小于学转正
	///第九种情况 实习转学员日期空 助护转学员日期不空 类型为T 且stdate大于助护转学员
	///第十种情况 实习转学员日期空 助护转学员日期不空 学员转正不空 且助护转学员小于学员转正 且stdate小于学转正大于助转学员日期
	///第十一情况 实习转助护日期不空 助护转学员不空 且类型为T 实习生转助护小于助护转学员 且stdate大于助护转学员
	///第十二情况 实习转助护日期不空 助护转学员不空 学员转正不空且 实转助小于助护转学员 且助转学小于学转正 且stdate大于助转学 且stdate小于学转正
	e  i ((PerInternDate="")&&(PerInternToStu="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToNurse="")&&(PerAssToStu="")&&(PerTypeDR="T")) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu'="")&&(PerInternDate="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToNurse="")&&(PerAssToStu="")&&(stdate>PerInternDate)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu'="")&&(PerStuToAss'="")&&(PerInternToStu<PerStuToAss)&&(stdate>=PerInternToStu)&&(stdate<PerStuToAss)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu'="")&&(PerStuToAss'="")&&(PerAssToNurse'="")&&(PerInternToStu<PerStuToAss)&&(PerStuToAss<PerAssToNurse)&&(stdate<PerStuToAss)&&(stdate>PerInternToStu)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu'="")&&(PerStuToNurse'="")&&(PerInternDate="")&&(PerStuToAss="")&&(PerAssToNurse="")&&(PerAssToStu="")&&(PerInternToStu<PerStuToNurse)&&(stdate<PerStuToNurse)&&(stdate>PerInternToStu)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu="")&&(PerStuToAss'="")&&(PerTypeDR="A")&&(stdate<PerStuToAss)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu="")&&(PerStuToAss'="")&&(PerAssToNurse'="")&&(PerStuToAss<PerAssToNurse)&&(stdate<PerStuToAss)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu="")&&(PerStuToNurse'="")&&(PerInternDate="")&&(PerStuToAss="")&&(PerAssToNurse="")&&(PerAssToStu="")&&(stdate<PerStuToNurse)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu="")&&(PerAssToStu'="")&&(PerTypeDR="T")&&(stdate>=PerAssToStu)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternToStu="")&&(PerAssToStu'="")&&(PerStuToNurse'="")&&(PerAssToStu<PerStuToNurse)&&(stdate<PerStuToNurse)&&(stdate>=PerAssToStu)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternDate'="")&&(PerAssToStu'="")&&(PerTypeDR="T")&&(PerInternDate)<(PerAssToStu)&&(stdate>=PerAssToStu)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	e  i ((PerInternDate'="")&&(PerAssToStu'="")&&(PerStuToNurse'="")&&(PerInternDate<PerAssToStu)&&(PerAssToStu<PerStuToNurse)&&(stdate>=PerAssToStu)&&(stdate<PerStuToNurse)) d
	.s level="N0",status="¤",hours=40,nurType="T"
	//判断是助护
	///第一种情况 所有日期都为空 且类型为A 则一定是助护
	///第二种情况 实习转助护日期不空 其他日期都空且stdate大于该日期
	///第三种情况 实习转助护日期不空 且助护转学员日期不空 且实习转助护小于助护转学员且stdate大于实习转助护日期且stdate小于助护转学员日期
	///第四种情况 实习转助护日期不空且 助护转学员日期不空且 学员转正不空且 实写转助护小于助护转学员小于学员转正 且stdate大于实习转助 小于助护转学员
	///第五种情况 实习转助护日期不空 助护转正不空 其他空 且实习转助护小于助护转正且stdate大于实习转助护小于助护转正
	///第六种情况 实习转助护日期空 助护转学员不空 且类型为T 且stdate小于助护转学员
	///第七种情况 实习转助护日期空 助护转学员不空 学员转正不空 且助护转学员小于学员转正 且stdate 小于助护转学员
	///第八种情况 实习转助护日期空 助护转正不空 其他空 且stdate小于助护转正日期
	///第九种情况 实习转助护日期空 学员转助护不空 类型为A 且stdate大于学员转助护日期
	///第十种情况 实习转助护日期空 学员转助护不空 助护转正不空 且学员转助护小于助护转正 且stdate大于学员转助护 小于助护转正
	///第十一种情况 实习转学员不空 学员转助护不空 且类型为A 实习转学员小于学员转助护 且stdate大于实习转学员 小于学员转助护
	//第十二情况 实习转学员不空 学员转助护不空 助护转正不空 且实习转学员小于学员转助护 且学员转助护小于助护转正 且stdate大于学员转助护 小于助护转正
	
	e  i ((PerInternDate="")&&(PerInternToStu="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToNurse="")&&(PerAssToStu="")&&(PerTypeDR="A")) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate'="")&&(PerInternToStu="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToNurse="")&&(PerAssToStu="")&&(stdate>=PerInternDate)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate'="")&&(PerAssToStu'="")&&(PerInternDate<PerAssToStu)&&(stdate>=PerInternDate)&&(stdate<PerAssToStu)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate'="")&&(PerAssToStu'="")&&(PerStuToNurse'="")&&(PerInternDate<PerAssToStu)&&(PerAssToStu<PerStuToNurse)&&(stdate>=PerInternDate)&&(stdate<PerAssToStu)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate'="")&&(PerAssToNurse'="")&&(PerInternToStu="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToStu="")&&(PerInternDate<PerAssToNurse)&&(stdate>=PerInternDate)&&(stdate<PerAssToNurse)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate="")&&(PerAssToStu'="")&&(PerTypeDR="T")&&(stdate<PerAssToStu)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate="")&&(PerAssToStu'="")&&(PerStuToNurse'="")&&(PerAssToStu<PerStuToNurse)&&(stdate<PerAssToStu)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate="")&&(PerAssToNurse'="")&&(PerInternToStu="")&&(PerStuToAss="")&&(PerStuToNurse="")&&(PerAssToStu="")&&(stdate<PerAssToNurse)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate="")&&(PerStuToAss'="")&&(PerTypeDR="A")&&(stdate>=PerStuToAss)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternDate="")&&(PerStuToAss'="")&&(PerAssToNurse'="")&&(PerStuToAss<PerAssToNurse)&&(stdate>=PerStuToAss)&&(stdate<PerAssToNurse)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternToStu'="")&&(PerStuToAss'="")&&(PerTypeDR="A")&&(PerInternToStu<PerStuToAss)&&(stdate>=PerInternToStu)&&(stdate<PerStuToAss)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  i ((PerInternToStu'="")&&(PerStuToAss'="")&&(PerAssToNurse'="")&&(PerInternToStu<PerStuToAss)&&(PerStuToAss<PerAssToNurse)&&(stdate>=PerStuToAss)&&(stdate<PerAssToNurse)) d
	.s level="N0",status="§",hours=35,nurType="A"
	e  d
	.s level=##class(web.NurMgHRComm).GetLevelDesc(perdr,stdate,stdate)
	.s hours=35,nurType="N"
	;s status="" ;.. 
	//进修（S）、实习（P）、护理员（W） 管理员（M） 工人（G）） 助理护士（A） 护理学员（T)
	;i nurType="A" s status=..GetNurseStatus("助理护士","职务")
	;e  i nurType="P" s status=..GetNurseStatus("学员","职务")
	;e  i nurType="S" s status=..GetNurseStatus("进修护士","职务")
	s ret=level_"^"_status_"^"_hours_"^"_nurType
	q ret
}

/// creator: xbl
/// date: 20171120
/// desc:计算当日工作时长【type:1,只取审核。0：取所有】
/// other: w ##class(web.NurMgArgComm).CountMinutes(3,"2017-11-27")
ClassMethod CountMinutes(perdr As %String, date As %String, ward As %String, type As %String) As %Integer
{
	q:((perdr="")||(date="")||(type="")) ""
	s:date["-" date=$zdh(date,3)
	s isAskLeave=..IsPerAskLeavel2(perdr_"^"_date)
	q:isAskLeave=1 ""
	s time=0
	s argid="" f  s argid=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,date-1,argid)) q:argid=""  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argid)
	.q:'$IsObject(obj)
	.q:(type=1)&&(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	.q:'$IsObject(obj.ArgPostDR)
	.q:obj.ArgPostDR.PostDR.PostLevel'="一线班" //排除非一线班
	.q:(ward'="")&&(('$IsObject(obj.ArgWardDR))||(obj.ArgWardDR.%Id()'=ward))
	.q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假
	.s sttime1=obj.ArgStTime1,endtime1=obj.ArgEndTime1
	.s sttime2=obj.ArgStTime2,endtime2=obj.ArgEndTime2
	.s sttime3=obj.ArgStTime3,endtime3=obj.ArgEndTime3
	.i (sttime1'="")&&(endtime1'="")&&(endtime1["次日") d
	..s endtime=$zth($E(endtime1,3,$L(endtime1)),1)
	..i sttime1["次日" s sttime=$zth($E(sttime1,3,$L(sttime1)),1)
	..else  s sttime=0
	..s time=time+(endtime-sttime)
	.i (sttime2'="")&&(endtime2'="")&&(endtime2["次日") d
	..s endtime=$zth($E(endtime2,3,$L(endtime2)),1)
	..i sttime2["次日" s sttime=$zth($E(sttime2,3,$L(sttime2)),1)
	..else  s sttime=0
	..s time=time+(endtime-sttime)
	.i (sttime3'="")&&(endtime3'="")&&(endtime3["次日") d
	..s endtime=$zth($E(endtime3,3,$L(endtime3)),1)
	..i sttime3["次日" s sttime=$zth($E(sttime3,3,$L(sttime3)),1)
	..else  s sttime=0
	..s time=time+(endtime-sttime)
	s argid="" f  s argid=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,date,argid)) q:argid=""  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argid)
	.q:'$IsObject(obj)
	.q:(type=1)&&(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	.q:'$IsObject(obj.ArgPostDR)
	.q:obj.ArgPostDR.PostDR.PostLevel'="一线班" //排除非一线班
	.q:(ward'="")&&(('$IsObject(obj.ArgWardDR))||(obj.ArgWardDR.%Id()'=ward))
	.q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假
	.s sttime1=obj.ArgStTime1,endtime1=obj.ArgEndTime1
	.s sttime2=obj.ArgStTime2,endtime2=obj.ArgEndTime2
	.s sttime3=obj.ArgStTime3,endtime3=obj.ArgEndTime3
	.i (sttime1'="")&&(endtime1'="")&&(sttime1'["次日") d
	..s sttime=$zth(sttime1,1)
	..i endtime1["次日" s endtime=86400
	..e  s endtime=$zth(endtime1,1)
	..s time=time+(endtime-sttime)
	.i (sttime2'="")&&(endtime2'="")&&(sttime2'["次日") d
	..s sttime=$zth(sttime2,1)
	..i endtime2["次日" s endtime=86400
	..e  s endtime=$zth(endtime2,1)
	..s time=time+(endtime-sttime)
	.i (sttime3'="")&&(endtime3'="")&&(sttime3'["次日") d
	..s sttime=$zth(sttime3,1)
	..i endtime3["次日" s endtime=86400
	..e  s endtime=$zth(endtime3,1)
	..s time=time+(endtime-sttime)
	s minute=time\60
	q minute
}

/// creator: lulin
/// date: 20171120
/// desc:计算当日二线班时长
/// other: w ##class(web.NurMgArgComm).CountMinutes(3,"2017-11-27")
ClassMethod CountSecondMinutes(perdr As %String, date As %String, ward As %String = "", type As %String = "") As %Integer
{
	q:((perdr="")||(date="")||(type="")) ""
	s:date["-" date=$zdh(date,3)
	s isAskLeave=..IsPerAskLeavel2(perdr_"^"_date)
	q:isAskLeave=1 ""
	s time=0
	s argid="" f  s argid=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,date-1,argid)) q:argid=""  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argid)
	.q:'$IsObject(obj)
	.q:(type=1)&&((obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A"))
	.q:'$IsObject(obj.ArgPostDR)
	.q:(ward'="")&&('$IsObject(obj.ArgWardDR))||(obj.ArgWardDR.%Id()'=ward)
	.q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假
	.s sttime1=obj.ArgSecStTime,endtime1=obj.ArgSecEndTime
	.i (sttime1'="")&&(endtime1'="")&&(endtime1["次日") d
	..s endtime=$zth($E(endtime1,3,$L(endtime1)),1)
	..i sttime1["次日" s sttime=$zth($E(sttime1,3,$L(sttime1)),1)
	..else  s sttime=0
	..s time=time+(endtime-sttime)
	s argid="" f  s argid=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,date,argid)) q:argid=""  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argid)
	.q:(type=1)&&(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	.q:(ward'="")&&(('$IsObject(obj.ArgWardDR))||(obj.ArgWardDR.%Id()'=ward))
	.q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假
	.s sttime1=obj.ArgSecStTime,endtime1=obj.ArgSecEndTime
	.i (sttime1'="")&&(endtime1'="")&&(sttime1'["次日") d
	..s sttime=$zth(sttime1,1)
	..i endtime1["次日" s endtime=86400
	..e  s endtime=$zth(endtime1,1)
	..s time=time+(endtime-sttime)
	s minute=time\60
	q minute
}

/// 计算当日夜班小时数
/// other: w ##class(web.NurMgArgComm).CountNightMinutes(3,"2017-11-27")
ClassMethod CountNightMinutes(perdr As %String, date As %String, ward As %String = "", type As %String = "") As %String
{
	q:(perdr="")!(date="")!(type="") ""
	s:date["-" date=$zdh(date,3)
	s isAskLeave=..IsPerAskLeavel2(perdr_"^"_date)
	q:isAskLeave=1 ""
	s time=0
	s obj1=##class(DHCNMG.Set.MgArgParamSet).%OpenId(1)
	s monthday=$P($zd(+$h,3),"-",2)_$P($zd(+$h,3),"-",3)
	i (monthday<"1001")&&((monthday>"0501")||(monthday="0501")) d
	.s nsttime=obj1.NightStTime1,nendtime=obj1.NightEndTime1
	e  s nsttime=obj1.NightStTime2,nendtime=obj1.NightEndTime2 
	i nsttime="" s nsttime=$zth("16:00:00",1)
	i nendtime="" s nendtime=$zth("08:00:00",1)
	s argid="" f  s argid=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,date-1,argid)) q:argid=""  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argid)
	.q:'$IsObject(obj)
	.q:'$IsObject(obj.ArgPostDR)
	.q:(type=1)&&(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	.q:obj.ArgPostDR.PostDR.PostLevel'="一线班" //排除非一线班
	.q:(ward'="")&&(('$IsObject(obj.ArgWardDR))||(obj.ArgWardDR.%Id()'=ward))
	.q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假
	.s sttime1=obj.ArgStTime1,endtime1=obj.ArgEndTime1
	.s sttime2=obj.ArgStTime2,endtime2=obj.ArgEndTime2
	.s sttime3=obj.ArgStTime3,endtime3=obj.ArgEndTime3
	.i (sttime1'="")&&(endtime1'="")&&(endtime1["次日") d
	..s endtime=$zth($E(endtime1,3,$L(endtime1)),1)
	..i (sttime1["次日") s sttime=$zth($E(sttime1,3,$L(sttime1)),1)
	..e  s sttime=0
	..i endtime<=nendtime s time=time+(endtime-sttime)
	..e  d
	...i (sttime<=nendtime) s time=time+(nendtime-sttime)
	...i (endtime>=nsttime) s time=time+(endtime-nsttime)
	.i (sttime2'="")&&(endtime2'="")&&(endtime2["次日") d
	..s endtime=$zth($E(endtime2,3,$L(endtime2)),1)
	..i (sttime2["次日") s sttime=$zth($E(sttime2,3,$L(sttime2)),1)
	..e  s sttime=0
	..i endtime<=nendtime s time=time+(endtime-sttime)
	..e  d
	...i (sttime<=nendtime) s time=time+(nendtime-sttime)
	...i (endtime>=nsttime) s time=time+(endtime-nsttime)
	.i (sttime3'="")&&(endtime3'="")&&(endtime3["次日") d
	..s endtime=$zth($E(endtime3,3,$L(endtime3)),1)
	..i (sttime3["次日") s sttime=$zth($E(sttime3,3,$L(sttime3)),1)
	..e  s sttime=0
	..i endtime<=nendtime s time=time+(endtime-sttime)
	..e  d
	...i (sttime<=nendtime) s time=time+(nendtime-sttime)
	...i (endtime>=nsttime) s time=time+(endtime-nsttime)
	
	s argid="" f  s argid=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,date,argid)) q:argid=""  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argid)
	.q:'$IsObject(obj)
	.q:'$IsObject(obj.ArgPostDR)
	.q:(type=1)&&(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	.q:obj.ArgPostDR.PostDR.PostLevel'="一线班" //排除非一线班
	.q:(ward'="")&&(('$IsObject(obj.ArgWardDR))||(obj.ArgWardDR.%Id()'=ward))
	.q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假
	.s sttime1=obj.ArgStTime1,endtime1=obj.ArgEndTime1
	.s sttime2=obj.ArgStTime2,endtime2=obj.ArgEndTime2	
	.s sttime3=obj.ArgStTime3,endtime3=obj.ArgEndTime3
	.i (sttime1'="")&&(endtime1'="") d
	..s sttime=$zth(sttime1,1)
	..i (endtime1'["次日") s endtime=$zth(endtime1,1)
	..e  s endtime=86400
	..i (endtime<=nendtime)||(sttime>=nsttime) s time=time+(endtime-sttime)
	..e  i (endtime<=nsttime)&&(sttime<nendtime) s time=time+(nendtime-sttime)
	..e  i (endtime>nsttime)&&(sttime<nendtime) s time=time+(nendtime-sttime)+(endtime-nsttime)
	..e  i (endtime>nsttime)&&(sttime>nendtime) s time=time+(endtime-nsttime)
	.i (sttime2'="")&&(endtime2'="") d
	..s sttime=$zth(sttime2,1)
	..i (endtime2'["次日") s endtime=$zth(endtime2,1)
	..e  s endtime=86400
	..i (endtime<=nendtime)||(sttime>=nsttime) s time=time+(endtime-sttime)
	..e  i (endtime<=nsttime)&&(sttime<nendtime) s time=time+(nendtime-sttime)
	..e  i (endtime>nsttime)&&(sttime<nendtime) s time=time+(nendtime-sttime)+(endtime-nsttime)
	..e  i (endtime>nsttime)&&(sttime>nendtime) s time=time+(endtime-nsttime)
	.i (sttime3'="")&&(endtime3'="") d
	..s sttime=$zth(sttime3,1)
	..i (endtime3'["次日") s endtime=$zth(endtime3,1)
	..e  s endtime=86400
	..i (endtime<=nendtime)||(sttime>=nsttime) s time=time+(endtime-sttime)
	..e  i (endtime<=nsttime)&&(sttime<nendtime) s time=time+(nendtime-sttime)
	..e  i (endtime>nsttime)&&(sttime<nendtime) s time=time+(nendtime-sttime)+(endtime-nsttime)
	..e  i (endtime>nsttime)&&(sttime>nendtime) s time=time+(endtime-nsttime)
	s minute=time\60
	q minute
}

/// creator: lulin
/// date: 2018-11-21
/// desc:计算当日加减班
/// other: w ##class(web.NurMgArgComm).CountMinutes(3,"2017-11-27")
ClassMethod CountMinutesPlus(perdr As %String, date As %String, ward As %String = "", type As %String = "") As %Integer
{
	q:(perdr="")||(date="")||(type="") ""
	s:date["-" date=$zdh(date,3)
	s isAskLeave=..IsPerAskLeavel2(perdr_"^"_date)
	q:isAskLeave=1 ""
	s time=0
	s argid="" f  s argid=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,date,argid)) q:argid=""  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argid)
	.q:'$IsObject(obj)
	.q:(type=1)&&(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	.q:((obj.ArgType'="Y")&&(obj.ArgType'="N"))
	.;q:obj.ArgApplyFlag="C" ;排除拒绝的申请
	.q:(ward'="")&&(('$IsObject(obj.ArgWardDR))||(obj.ArgWardDR.%Id()'=ward))
	.s sttime1=obj.ArgStTime1,endtime1=obj.ArgEndTime1
	.i (sttime1'="")&&(endtime1'="") d
	..s endtime=$zth(endtime1,1)
	..s sttime=$zth(sttime1,1)
	..i obj.ArgType="Y" s time=time+(endtime-sttime)
	..e  s time=time-(endtime-sttime)
	s minute=time\60
	q minute
}

/// creator: xbl
/// createdate: 20170902
/// description: 获取排班人员当前已存最大序号
/// table: DHCNMG.Arg.MgArrangeRow
/// input:
/// output:
/// other:
ClassMethod GetArgRowSort(argid As %String) As %Integer
{
	q:argid="" 1
	s maxsort=1
	s sort="" f  s sort=$O(^DHCNMG.Arg.MgArrangeRowI("ArgSort",argid,sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeRowI("ArgSort",argid,sort,id)) q:id=""  d
	..s obj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(id)
	..s maxsort=maxsort+1
	q maxsort
}

/// creator: xbl
/// createdate: 20170902
/// description: 删除人员分组
/// table: DHCNMG.Arg.MgArrangeRow
/// input:
/// output:
/// other: w ##class(web.NurMgArgComm).DeleteArgGroup(2)
ClassMethod DeleteArgGroup(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Arg.MgArrangeGroup).%OpenId(id)
	q:obj.ArrangeDR="" 0
	s argid=obj.ArrangeDR.%Id()
	s rowid="" f  s rowid=$O(^DHCNMG.Arg.MgArrangeRowI("ArgGrp",argid,id,rowid)) q:rowid=""  d
	.s rowobj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(rowid)
	.s rowobj.ArgGroupDR=""
	.d rowobj.%Save()
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 20170902
/// description: 复制周排班
/// table: DHCNMG.Arg.MgArrangeRow
/// input: type: "P" 按人复制 "R" 按行复制
/// output:
/// other:
ClassMethod CopyArrange(id As %String, stdate As %String, enddate As %String, type As %String)
{
}

/// creator: xbl
/// createdate: 20170902
/// description: 复制排班
/// table: DHCNMG.Arg.MgArrangeRow
/// input: copy2:复制区域，paste2:粘贴区域
/// output:
/// other: w ##class(web.NurMgArgComm).CopyArgSub(^tmpXbl("copy1"),^tmpXbl("copy2"),^tmpXbl("paste1"),^tmpXbl("paste2"),"copy")
ClassMethod CopyArgSub(copy1 As %String, copy2 As %String, paste1 As %String, paste2 As %String, type As %String) As %String
{
	s ^tmpXbl("copy1")=copy1,^tmpXbl("copy2")=copy2,^tmpXbl("paste1")=paste1,^tmpXbl("paste2")=paste2
	q:(copy1="")!(copy2="")!(paste1="")!(paste2="")!(type="") 0
	s copyargid=..SaveArrange(copy1)
	q:+copyargid=0 0
	s copyrowid=..SaveArgRow(copy1,copy2)
	q:+copyrowid=0 0
	d ##class(web.NurMgVueComm).SplitStr(copy2,"^","|",.tmp1)
	q:$g(tmp1("ArgDate"))="" 0
	s copydate=tmp1("ArgDate")
	s:copydate["-" copydate=$zdh(copydate,3)
	s copysubid=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",copyargid,copyrowid,copydate,""))
	q:+copysubid=0 0
	s pasteargid=..SaveArrange(paste1)
	q:+pasteargid=0 0
	s pasterowid=..SaveArgRow(paste1,paste2)
	q:+pasterowid=0 0
	d ##class(web.NurMgVueComm).SplitStr(paste2,"^","|",.tmp2)
	q:$g(tmp2("ArgDate"))="" 0
	s pastedate=tmp2("ArgDate")
	s:pastedate["-" pastedate=$zdh(pastedate,3)
	s flag=0
	s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",pasteargid,pasterowid,pastedate,id)) q:id=""  d
	.d ##class(DHCNMG.Arg.MgArrangeSub).%DeleteId(id)
	s cid="" f  s cid=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",copyargid,copyrowid,copydate,cid)) q:cid=""  d
	.s cobj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(cid)
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%New()
	.s obj.ArrangeDR=##class(DHCNMG.Arg.MgArrange).%OpenId(pasteargid)
	.s obj.ArgRowDR=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(pasterowid)
	.s obj.ArgWardDR=obj.ArrangeDR.ArgWardDR
	.s obj.ArgPerDR=obj.ArgRowDR.ArgPerDR
	.s obj.ArgDate=pastedate
	.q:'$IsObject(cobj.ArgPostDR)
	.s:((cobj.ArgType'="Y")&&(cobj.ArgType'="N")) obj.ArgPostDR=##class(DHCNMG.DB.MgArgWardPost).%OpenId(cobj.ArgPostDR.%Id())
	.s obj.ArgStTime1=cobj.ArgStTime1
	.s obj.ArgEndTime1=cobj.ArgEndTime1
	.s obj.ArgStTime2=cobj.ArgStTime2
	.s obj.ArgEndTime2=cobj.ArgEndTime2
	.s obj.ArgStTime3=cobj.ArgStTime3
	.s obj.ArgEndTime3=cobj.ArgEndTime3
	.s obj.ArgRemark=cobj.ArgRemark
	.s obj.ArgCategory=cobj.ArgCategory
	.s obj.ArgHolidayTime=cobj.ArgHolidayTime
	.s obj.ArgType=cobj.ArgType
	.s obj.ArgEditUser=obj.ArrangeDR.ArgCrtUser
	.s obj.ArgEditDate=+$h
	.s obj.ArgEditTime=$P($h,",",2)
	.s curward=##class(web.NurMgHRComm).GetCurrentWard(obj.ArgRowDR.ArgPerDR.%Id(),pastedate)
	.s tward=..GetPostForOther(tmp2("ArgPerDR"),pastedate,curward)
	.q:((tward'="")&&(curward'=obj.ArrangeDR.ArgWardDR.%Id()))
	.d obj.%Save()
	.s flag=1
	.i type="cut" d cobj.%DeleteId(cid)
	q flag
}

/// creator: xbl
/// createdate: 20170902
/// description: 快选排班
/// table: DHCNMG.Arg.MgArrangeSub
/// input: 
/// output:
/// other: 
ClassMethod QuickArg(parr1 As %String, parr2 As %String, parr3 As %String) As %String
{
	q:(parr1="")!(parr2="")!(parr3="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s argObj=##class(DHCNMG.Arg.MgArrange).%OpenId(argid)
	s argrowid=..SaveArgRow(parr1,parr2)
	q:+argrowid=0 0
	s rowObj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(argrowid)
	s post=$P(parr3,"^",1)
	s date=$P(parr3,"^",2)
	s:date["-" date=$zdh(date,3)
	q:(post="")!(date="") 0
	s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,argrowid,date,id)) q:id=""  d
	.d ##class(DHCNMG.Arg.MgArrangeSub).%DeleteId(id)
	s obj=##class(DHCNMG.Arg.MgArrangeSub).%New()
	s obj.ArrangeDR=argObj
	s obj.ArgRowDR=rowObj
	s obj.ArgWardDR=argObj.ArgWardDR
	s obj.ArgPerDR=rowObj.ArgPerDR
	s obj.ArgDate=date
	s obj.ArgPostDR=##class(DHCNMG.DB.MgArgWardPost).%OpenId(post)
	i obj.ArgPostDR.PostDR.PostType="H" d
	.s obj.ArgHolidayTime=$case(obj.ArgPostDR.PostDR.HolidayTime,"H":"A","A":"H",:obj.ArgPostDR.PostDR.HolidayTime)
	s obj.ArgStTime1=obj.ArgPostDR.PostStTime1
	s obj.ArgEndTime1=obj.ArgPostDR.PostEndTime1
	s obj.ArgStTime2=obj.ArgPostDR.PostStTime2
	s obj.ArgEndTime2=obj.ArgPostDR.PostEndTime2
	s obj.ArgStTime3=obj.ArgPostDR.PostStTime3
	s obj.ArgEndTime3=obj.ArgPostDR.PostEndTime3
	s obj.ArgRemark=""
	s obj.ArgEditUser=obj.ArrangeDR.ArgCrtUser
	s obj.ArgEditDate=+$h
	s obj.ArgEditTime=$P($h,",",2)
	s obj.ArgCategory=obj.ArgPostDR.PostCategory
	s sc=obj.%Save()
	q:$$$ISOK(sc) obj.%Id()
	q 0
}

/// creator: xbl
/// createdate: 20170902
/// description: 人员移动含班次
/// table: DHCNMG.Arg.MgArrangeRow
/// input: type: D 下移，U 上移
/// output:
/// other: w ##class(web.NurMgArgComm).MoveArgPerson(^tmpXbl("parr1"),^tmpXbl("persons"),"D")
ClassMethod MoveArgPerson(parr1 As %String, persons As %String, type As %String, parr2 As %String = "") As %String
{
	;s ^tmpXbl("parr1")=parr1,^tmpXbl("persons")=persons_"^"_type
	q:(parr1="")!(persons="")!(type="")!(parr2="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s argrowid=..SaveArgRows(parr1,parr2)
	q:+argrowid=0 0
	s ret=0
	i type="U" d
	.f i=1:1:$L(persons,",") d
	..s perdr=$P(persons,",",i)
	..q:perdr=""
	..s id1=$O(^DHCNMG.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	..q:id1=""
	..s obj1=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(id1)
	..s sort1=obj1.ArgPerSort
	..s sort2=sort1-1
	..s id2=$O(^DHCNMG.Arg.MgArrangeRowI("ArgSort",argid,sort2,""))
	..q:id2=""
	..s obj2=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(id2)
	..i obj1.ArgGroupDR'=obj2.ArgGroupDR d
	...i obj2.ArgGroupDR'="" d
	....s obj1.ArgGroupDR=##class(DHCNMG.Arg.MgArrangeGroup).%OpenId(obj2.ArgGroupDR.%Id())
	...e  s obj1.ArgGroupDR=""
	...s ret=1
	..e  d
	...s obj2.ArgPerSort=sort1
	...s sc=obj2.%Save()
	...s ret=$$$ISOK(sc)
	...q:ret=0
	...s obj1.ArgPerSort=sort2
	..q:ret=0
	..s sc=obj1.%Save()
	..s ret=$$$ISOK(sc)
	i type="D" d
	.f i=$L(persons,","):-1:1 d
	..s perdr=$P(persons,",",i)
	..q:perdr=""
	..s id1=$O(^DHCNMG.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	..q:id1=""
	..s obj1=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(id1)
	..s sort1=obj1.ArgPerSort
	..s sort2=sort1+1
	..s id2=$O(^DHCNMG.Arg.MgArrangeRowI("ArgSort",argid,sort2,""))
	..q:id2=""
	..s obj2=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(id2)
	..i obj1.ArgGroupDR'=obj2.ArgGroupDR d
	...i obj2.ArgGroupDR'="" d
	....s obj1.ArgGroupDR=##class(DHCNMG.Arg.MgArrangeGroup).%OpenId(obj2.ArgGroupDR.%Id())
	...e  s obj1.ArgGroupDR=""
	...s ret=1
	..e  d
	...s obj2.ArgPerSort=sort1
	...s sc=obj2.%Save()
	...s ret=$$$ISOK(sc)
	...q:ret=0
	...s obj1.ArgPerSort=sort2
	..q:ret=0
	..s sc=obj1.%Save()
	..s ret=$$$ISOK(sc)
	q ret
}

/// creator: lulin
/// createdate: 2018-09-02
/// description: 移动组
/// table: DHCNMG.Arg.MgArrangeRow
/// input: type: D 下移，U 上移
/// output:
/// other: w ##class(web.NurMgArgComm).MoveArgGroup("10^7","D")
ClassMethod MoveArgGroup(parr As %String, type As %String, parr1 As %String, parr2 As %String) As %String
{
	s argId=$tr($p(parr,"^")," ","")
	s grpId=$tr($p(parr,"^",2)," ","")
	q:(argId="")||(grpId="")||(type="")||(parr1="")||(parr2="") "传参有空值"
	;d ..SaveArgRows(parr1,parr2)
	s:grpId="-" grpId=""
	//要移动组排序，移动组对象，下一个组对象，是否是下一个组，下一组数量
	s tSort="",tgrp="",nextgrp="",isNextGrp=0
	s tmpSort="",tmp=""
	s step=1 ;下移，从大到小，
	i type="U" s step=-1 ;上移，从小到大
	s sort="" f  s sort=$O(^DHCNMG.Arg.MgArrangeRowI("ArgSort",argId,sort),step) q:sort=""  d
	.s id=$O(^DHCNMG.Arg.MgArrangeRowI("ArgSort",argId,sort,""))
	.s obj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(id)
	.q:'$IsObject(obj)
	.i ((($IsObject(obj.ArgGroupDR))&&(obj.ArgGroupDR.%Id()=grpId))||((obj.ArgGroupDR="")&&(grpId=""))) d
	..s:tSort="" tSort=sort,tgrp=obj.ArgGroupDR
	..s tmpSort(sort)=id
	.i ((tSort'="")&&(obj.ArgGroupDR'=tgrp)) d
	..i (isNextGrp=0)||(nextgrp=obj.ArgGroupDR) d
	...s nextgrp=obj.ArgGroupDR,isNextGrp=1
	...s tmp(id)=tSort
	...s tSort=tSort+step
	q:(tSort="")||($d(tmp)'=11) "未获取正确顺序"
	s sort="" f  s sort=$o(tmpSort(sort),step) q:sort=""  d
	.s tmp(tmpSort(sort))=tSort
	.s tSort=tSort+step
	s id="" f  s id=$O(tmp(id)) q:id=""  d
	.s obj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(id)
	.s obj.ArgPerSort=tmp(id)
	.d obj.%Save()
	q 1
}

/// creator: lulin
/// createdate: 2018-05-16
/// description: 人员移动不含班次
/// table: DHCNMG.Arg.MgArrangeRow
/// input: type: D 下移，U 上移
/// output:
/// other: w ##class(web.NurMgArgComm).MoveArgOnlyPerson(^tmpXbl("parr1"),^tmpXbl("persons"),"D")
ClassMethod MoveArgOnlyPerson(parr1 As %String, persons As %String, type As %String, parr2 As %String) As %String
{
	//s ^tmpXbl("parr1")=parr1,^tmpXbl("persons")=persons
	q:(parr1="")!(persons="")!(type="")!(parr2="") 0
	q:(type'="U")&&(type'="D") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s argrowid=..SaveArgRows(parr1,parr2)
	q:+argrowid=0 0
	s ret=1
	s start=1,step=1,end=$L(persons,",")
	i type="D" s start=$L(persons,","),step=-1,end=1
	TS
	f i=start:step:end q:ret=0  d
	.s perdr=$P(persons,",",i)
	.q:perdr=""
	.s id1=$O(^DHCNMG.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	.q:id1=""
	.s obj1=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(id1)
	.q:'$IsObject(obj1)
	.q:'$IsObject(obj1.ArgPerDR)
	.s sort1=obj1.ArgPerSort
	.s sort2=sort1-step
	.s id2=$O(^DHCNMG.Arg.MgArrangeRowI("ArgSort",argid,sort2,""))
	.q:id2=""
	.s obj2=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(id2)
	.q:'$IsObject(obj2)
	.q:'$IsObject(obj2.ArgPerDR)
	.s p="" f  s p=$O(^oddCOM("DHCNMG.Arg.MgArrangeRow","a",p)) q:p=""  d
	..q:p["%"
	..q:p["ChildSub"
	..q:p["Parref"
	..q:p["ArgGroupDR"
	..q:p["ArgPerSort"
	..s value1=$ZOBJPROPERTY(obj1,p)
	..s $ZOBJPROPERTY(obj1,p)=$ZOBJPROPERTY(obj2,p)
	..s $ZOBJPROPERTY(obj2,p)=value1
	.s sc=obj2.%Save()
	.s ret=$$$ISOK(sc)
	.q:ret=0
	.s sc=obj1.%Save()
	.s ret=$$$ISOK(sc)
	.q:ret=0
	.s rowid="" f  s rowid=$o(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowid)) q:(rowid="")||(ret=0)  d
	..q:(rowid'=id1)&&(rowid'=id2)
	..s date="" f  s date=$o(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowid,date)) q:(date="")||(ret=0)  d
	...s subid="" f  s subid=$o(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowid,date,subid)) q:(subid="")||(ret=0)  d
	....s subObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(subid)
	....q:'$IsObject(subObj)
	....q:('$IsObject(subObj.ArgPerDR))
	....q:(subObj.ArgPerDR.%Id()'=obj1.ArgPerDR.%Id())&&(subObj.ArgPerDR.%Id()'=obj2.ArgPerDR.%Id())
	....s replacePerDR=obj1.ArgPerDR
	....i rowid=id2 d
	.....s replacePerDR=obj2.ArgPerDR
	....s ward=##class(web.NurMgHRComm).GetCurrentWard(replacePerDR.%Id(),date)
	....i (ward'="")&&($IsObject(subObj.ArgWardDR))&&(ward'=subObj.ArgWardDR.%Id()) s ret=0
	....q:ret=0
	....s subObj.ArgPerDR=replacePerDR
	....s sc=subObj.%Save()
	....s ret=$$$ISOK(sc)
	....q:ret=0
	if ret=1{
		TC
		q ret	
	}else{
		TRO
		q ret	
	}
}

/// creator: lulin
/// createdate: 2018-11-01
/// description: 获取移动班次下一个次序rowid
/// table: 
/// input: 
/// output:
/// other:
ClassMethod getNextRowId(step, date, argid, wardid, sort, nextsort)
{
	;q:(step="")||(date="")||(argid="")||(sort="")||(nextsort="") ""
	s endSort=$o(^DHCNMG.Arg.MgArrangeRowI("ArgSort",argid,""),-1)
	i nextsort=0 s nextsort=endSort
	e  i nextsort>endSort  s nextsort=1
	s RowId=$O(^DHCNMG.Arg.MgArrangeRowI("ArgSort",argid,nextsort,""))
	s obj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(RowId)
	s tNextSort=nextsort-step
	q:('$IsObject(obj))||('$IsObject(obj.ArgPerDR)) ..getNextRowId(step,date,argid,wardid,sort,tNextSort)
	q:sort=nextsort obj.%Id()
	s currentWard=##class(web.NurMgHRComm).GetCurrentWard(obj.ArgPerDR.%Id(),date)
	s secondWard=..GetPostForOther(obj.ArgPerDR.%Id(),date,wardid)
	q:(currentWard'=wardid)&&(secondWard'="") ..getNextRowId(step,date,argid,wardid,sort,tNextSort)
	q obj.%Id()
}

/// creator: lulin
/// createdate: 2018-11-01
/// description: 全部班次上下移动
/// table: DHCNMG.Arg.MgArrangeSub
/// input: type: U 上移，R 下移
/// output:
/// other:
ClassMethod MovePostAllH(parr1 As %String, type As %String, parr2 As %String)
{
	q:(parr1="")||(type="")||(parr2="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s argrowid=..SaveArgRows(parr1,parr2)
	q:+argrowid=0 0
	s flag=1,step=1
	i type="D" s step=-1
	k tmp
	s tmp=""
	s endSort=$o(^DHCNMG.Arg.MgArrangeRowI("ArgSort",argid,""),-1)
	s rowSort="" f  s rowSort=$o(^DHCNMG.Arg.MgArrangeRowI("ArgSort",argid,rowSort),step) q:rowSort=""  d
	.s rowId="" f  s rowId=$o(^DHCNMG.Arg.MgArrangeRowI("ArgSort",argid,rowSort,rowId)) q:rowId=""  d
	..s date="" f  s date=$o(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowId,date)) q:date=""  d
	...s subid="" f  s subid=$o(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowId,date,subid)) q:(subid="")  d
	....s subObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(subid)
	....q:'$IsObject(subObj)
	....s nextSort=rowSort-step
	....s replaceRowId=..getNextRowId(step,date,argid,subObj.ArgWardDR.%Id(),rowSort,nextSort)
	....q:replaceRowId=""
	....q:replaceRowId=rowId
	....s tmp(subid)=replaceRowId
	TS
	s flag=1
	s subid="" f  s subid=$O(tmp(subid)) q:(subid="")||(flag=0)  d
	.s subObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(subid)
	.q:'$IsObject(subObj)
	.q:'$IsObject(subObj.ArgPerDR)
	.q:'$IsObject(subObj.ArgRowDR)
	.s rowObj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(tmp(subid))
	.q:'$IsObject(rowObj)
	.s subObj.ArgRowDR=rowObj
	.s subObj.ArgPerDR=rowObj.ArgPerDR
	.s flag=flag&&$$$ISOK(subObj.%Save())
	if flag=1{
		TC	
		q 1
	}else{
		TRO
		q 0
	}
}

/// creator: lulin
/// createdate: 2018-10-31
/// description: 班次上下移动
/// table: DHCNMG.Arg.MgArrangeSub
/// input: type: U 上移，R 下移
/// output:
/// other:
ClassMethod MoveHArgSub(parr1 As %String, persons As %String, type As %String, parr2 As %String)
{
	q:(parr1="")||(persons="")||(type="")||(parr2="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s argrowid=..SaveArgRows(parr1,parr2)
	q:+argrowid=0 0
	s flag=1
	s start=1,step=1,end=$L(persons,",")
	i type="D" s start=$L(persons,","),step=-1,end=1
	s endSort=$O(^DHCNMG.Arg.MgArrangeRowI("ArgSort",argid,""),-1)
	TS
	f i=start:step:end q:flag=0  d
	.s perdr=$P(persons,",",i)
	.q:perdr=""
	.s rowId=$O(^DHCNMG.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	.q:rowId=""
	.s rowObj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(rowId)
	.q:'$IsObject(rowObj)
	.q:'$IsObject(rowObj.ArgPerDR)
	.s sort=rowObj.ArgPerSort
	.s nextSort=sort-step
	.s:nextSort>endSort nextSort=1
	.s:nextSort=0 nextSort=endSort
	.q:nextSort=sort
	.s nextRowId=$O(^DHCNMG.Arg.MgArrangeRowI("ArgSort",argid,nextSort,""))
	.q:nextRowId=""
	.s nextRowObj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(nextRowId)
	.q:'$IsObject(nextRowObj)
	.q:'$IsObject(nextRowObj.ArgPerDR)
	.s subRowId="" f  s subRowId=$o(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,subRowId)) q:(subRowId="")||(flag=0)  d
	..q:(subRowId'=rowId)
	..s date="" f  s date=$o(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,subRowId,date)) q:(date="")||(flag=0)  d
	...s nextPerWard=##class(web.NurMgHRComm).GetCurrentWard(nextRowObj.ArgPerDR.%Id(),date)
	...s subid="" f  s subid=$o(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,subRowId,date,subid)) q:(subid="")||(flag=0)  d
	....s subObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(subid)
	....q:'$IsObject(subObj)
	....q:'$IsObject(subObj.ArgPerDR)
	....q:'$IsObject(subObj.ArgWardDR)
	....;s ward=##class(web.NurMgHRComm).GetCurrentWard(subObj.ArgPerDR.%Id(),date)
	....;q:(ward'="")&&($IsObject(subObj.ArgWardDR.%Id()))&&(ward'=subObj.ArgWardDR.%Id())
	....q:subObj.ArgWardDR.%Id()'=nextPerWard
	....s subObj.ArgRowDR=nextRowObj
	....s subObj.ArgPerDR=nextRowObj.ArgPerDR
	....s flag=flag&&$$$ISOK(subObj.%Save())
	if flag=1{
		TC	
		q 1
	}else{
		TRO
		q 0
	}
}

/// creator: xbl
/// createdate: 20170902
/// description: 班次左右移动
/// table: DHCNMG.Arg.MgArrangeRow
/// input: type: L 左移，R 右移
/// output:
/// other:
ClassMethod MoveArgSub(parr1 As %String, persons As %String, type As %String, parr2 As %String)
{
	q:(parr1="")||(persons="")||(type="")||(parr2="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s argrowid=..SaveArgRows(parr1,parr2)
	q:+argrowid=0 0
	s argObj=##class(DHCNMG.Arg.MgArrange).%OpenId(argid)
	f i=1:1:$L(persons,",") d
	.s perdr=$P(persons,",",i)
	.q:perdr=""
	.s rowid=$O(^DHCNMG.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	.q:rowid=""
	.k tmpFirstId
	.s tmpFirstId="",lastDate=argObj.ArgEndDate
	.i type="L" d
	..f date=argObj.ArgStDate:1:argObj.ArgEndDate d
	...s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowid,date,id)) q:id=""  d
	....s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	....i obj.ArgDate=argObj.ArgStDate d
	.....;d obj.%DeleteId(id)
	.....;s obj.ArgDate=argObj.ArgEndDate
	.....s tmpFirstId(id)=id
	....e  d
	.....s obj.ArgDate=obj.ArgDate-1
	....d obj.%Save()
	.i type="R" d
	..s lastDate=argObj.ArgStDate
	..f date=argObj.ArgEndDate:-1:argObj.ArgStDate d
	...s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowid,date,id)) q:id=""  d
	....s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	....i obj.ArgDate=argObj.ArgEndDate d
	.....;d obj.%DeleteId(id)
	.....;s obj.ArgDate=argObj.ArgStDate
	.....s tmpFirstId(id)=id
	....e  d
	.....s obj.ArgDate=obj.ArgDate+1
	....d obj.%Save()
	.s firstId="" f  s firstId=$O(tmpFirstId(firstId)) q:firstId=""  d
	..s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(firstId)
	..q:'$IsObject(obj)
	..s obj.ArgDate=lastDate
	..d obj.%Save()
	q 1
}

/// creator: xbl
/// createdate: 20170902
/// description: 获取已提交排班表人员列表
/// table: DHCNMG.Arg.MgArrangeRow
/// input: 
/// output:
/// other: d ##class(web.NurMgArgComm).GetArgList(1,.tmp)
ClassMethod GetArgList(argid As %String, tmp As %String) As %String
{
	q:argid="" ""
	s argobj=##class(DHCNMG.Arg.MgArrange).%OpenId(argid)
	q:argobj.ArgWardDR=""
	s ward=argobj.ArgWardDR.%Id()
	s perdr="" f  s perdr=$O(^DHCNMG.Arg.MgArrangeRowI("ArgPerson",argid,perdr)) q:perdr=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.Arg.MgArrangeRowI("ArgPerson",argid,perdr,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(rowid)
	..q:obj.ArgPerDR=""
	..i obj.ArgGroupDR'="" s grpid=obj.ArgGroupDR.%Id()
	..e  s grpid="-"
	..i obj.ArgPerSort'="" s sort=obj.ArgPerSort
	..e  s sort="-"
	..s tmp(ward,grpid,sort,perdr)=obj.ArgPerDR.PerName
	q 0
}

/// creator: xbl
/// createdate: 20170902
/// description: 获取排班表人员列表
/// table: DHCNMG.Arg.MgArrangeRow
/// input: 
/// output:
/// other: d ##class(web.NurMgArgComm).GetWardNurse("","1","2017-12-11","2017-12-17","",.tmp)
ClassMethod GetWardNurse(argid As %String = "", ward As %String = "", stdate As %String = "", enddate As %String = "", pertype As %String, tmp As %String, tmpGroup As %String) As %String
{
	q:(ward="")!(stdate="")!(enddate="") ""
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s array="",array1=""
	i argid'="" d
	.s argobj=##class(DHCNMG.Arg.MgArrange).%OpenId(argid)
	.q:(argobj.ArgWardDR'="")&&(argobj.ArgWardDR.%Id()'=ward)
	.q:(argobj.ArgStDate'=stdate)&&(argobj.ArgEndDate'=enddate)
	.s perdr="" f  s perdr=$O(^DHCNMG.Arg.MgArrangeRowI("ArgPerson",argid,perdr)) q:perdr=""  d
	..s rowid="" f  s rowid=$O(^DHCNMG.Arg.MgArrangeRowI("ArgPerson",argid,perdr,rowid)) q:rowid=""  d
	...s obj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(rowid)
	...q:obj.ArgPerDR=""
	...i obj.ArgGroupDR'="" s grpid=obj.ArgGroupDR.%Id()
	...e  s grpid="-"
	...i obj.ArgPerSort'="" s sort=obj.ArgPerSort
	...e  s sort="-"
	...s tmp(ward,"A",grpid,sort,perdr)=rowid
	...s array(perdr)=1
	...i '$d(array1("A",grpid)) s array1("A",grpid)=1,tmpGroup("A",sort,grpid)=grpid
	q:(argid'="")&&(argobj.ArgStatus'="N")&&(argobj.ArgStatus'="S") 1
	;q:argid'="" 1
	;1、设置已分的组，2、根据轮转表查人并根据分组分人
	s grpid="" f  s grpid=$O(^DHCNMG.Arg.MgNurGroupI("Ward",ward,grpid)) q:grpid=""  d
	.s grpobj=##class(DHCNMG.Arg.MgNurGroup).%OpenId(grpid)
	.s:$IsObject(grpobj.GroupMaster) group(grpobj.GroupMaster.%Id())=grpid
	.f i=1:1:grpobj.GroupMember.Count() d
	..s perdr=grpobj.GroupMember.GetAt(i)
	..q:perdr=""
	..s group(perdr)=grpid
	//调科记录表
	s trsid="" f  s trsid=$O(^DHCNMG.HR.MgTransDepI("Dep"," "_ward,trsid)) q:trsid=""  d
	.s obj=##class(DHCNMG.HR.MgTransDep).%OpenId(trsid)
	.q:'$IsObject(obj)
	.s perdr=obj.PerDr
	.q:(perdr="")||($d(^DHCNMG.HR.MgPersonsD(perdr))=0)
	.q:$d(array(perdr))
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.s leavedate=perobj.PerStateDate //离职或退休日期
	.q:(leavedate'="")&&(leavedate<=stdate)
	.q:(pertype'="")&&(pertype'[perobj.PerTypeDR)
	.s trsstdate=obj.PerTranStDate
	.s trsenddate=##class(web.NurMgHRComm).GetTransEndDate(trsid)
	.q:(trsstdate="")||(trsstdate>enddate)||((trsenddate'="")&&(trsenddate<=stdate))
	.s grpid=$g(group(perdr)),grptype="G"
	.i argid'="" s grpid="-",grptype="A"
	.i grpid="" s grpid="-"
	.s grpobj=##class(DHCNMG.Arg.MgNurGroup).%OpenId(grpid)
	.i (($IsObject(grpobj))&&(grpobj.GroupMaster.%Id()=perdr)) d
	..s tmp(ward,grptype,grpid,"+",perdr)="-" ;组长放在第一位
	.e  s tmp(ward,grptype,grpid,"-",perdr)="-"
	.i '$d(array1(grptype,grpid)) s array1(grptype,grpid)=1,tmpGroup(grptype,"-",grpid)=grpid
	
#;	s perid="" f  s perid=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_ward,perid)) q:perid=""  d
#;	.q:$d(array(perid))
#;	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perid)
#;	.s leavedate=perobj.PerStateDate //离职或退休日期
#;	.q:(leavedate'="")&&(leavedate<=stdate)
#;	.q:(pertype'="")&&(pertype'[perobj.PerTypeDR)
#;	.s grpid=$g(group(perdr)),grptype="G"
#;	.i argid'="" s grpid="-",grptype="A"
#;	.i grpid="" s grpid="-"
#;	.s grpobj=##class(DHCNMG.Arg.MgNurGroup).%OpenId(grpid)
#;	.i (($IsObject(grpobj))&&(grpobj.GroupMaster.%Id()=perdr)) d
#;	..s tmp(ward,grptype,grpid,"+",perdr)="-" ;组长放在第一位
#;	.e  s tmp(ward,grptype,grpid,"-",perdr)="-"
#;	.i '$d(array1(grptype,grpid)) s array1(grptype,grpid)=1,tmpGroup(grptype,"-",grpid)=grpid
	/// 实习生
	s plandr="" f  s plandr=$O(^DHCNMG.Intern.MgTransPlanD(plandr)) q:plandr=""  d
	.s planObj=##class(DHCNMG.Intern.MgTransPlan).%OpenId(plandr)
	.q:(planObj.PlanStatus'="S") ;过滤未生效
	.s timedr="" f  s timedr=$O(^DHCNMG.Intern.MgTransPlanTimeI("Plan",plandr,timedr)) q:timedr=""  d
	..s timeObj=##class(DHCNMG.Intern.MgTransPlanTime).%OpenId(timedr)
	..s planstdate=timeObj.PlanStDate,planenddate=timeObj.PlanEndDate
	..q:(planstdate="")||(planstdate>enddate)
	..q:(planenddate="")||(planenddate<stdate)
	..s subdr="" f  s subdr=$O(^DHCNMG.Intern.MgTransPlanSubI("PlanTime",plandr,timedr,subdr)) q:subdr=""  d
	...s subObj=##class(DHCNMG.Intern.MgTransPlanSub).%OpenId(subdr)
	...q:(subObj.PlanWardDR'="")&&(subObj.PlanWardDR.%Id()'=ward)
	...q:('$IsObject(subObj.PlanPerDR))||($d(array(subObj.PlanPerDR.%Id())))
	...s perdr=subObj.PlanPerDR.%Id()
	...s leavedate=subObj.PlanPerDR.PerStateDate //离职或退休日期
	...q:(leavedate'="")&&(leavedate<=stdate)
	...s grpid=$g(group(perdr)),grptype="G"
	...i argid'="" s grpid="-",grptype="A"
	...i grpid="" s grpid="-"
	...s tmp(ward,grptype,grpid,"-",perdr)="-"
	...i '$d(array1(grptype,grpid)) s array1(grptype,grpid)=1,tmpGroup(grptype,"-",grpid)=grpid
	...s array(perdr)=1
	//调科申请表
	if (enddate>+$H) {
		s date="" f  s date=$O(^DHCNMG.HR.MgTransAppI("date"," T",date)) q:date=""  d
		.s appdr="" f  s appdr=$O(^DHCNMG.HR.MgTransAppI("date"," T",date,appdr)) q:appdr=""  d
		..s appObj=##class(DHCNMG.HR.MgTransApp).%OpenId(appdr)
		..q:(appObj.TransStatus'="A") ;过滤未审核的
		..q:appObj.TransEndDate=""
		..q:(appObj.TransEndDate<=+$H) ;过滤掉已经结束的临时转科
		..f i=1:1:appObj.TransNurse.Count() d
		...s perward=appObj.TransNurse.GetAt(i)
		...q:perward=""
		...s warddr=$P(perward,"|",1)
		...s perdr=$P(perward,"|",2)
		...q:((warddr="")||(warddr'=ward)||(perdr="")||($d(array(perdr))))
		...s grpid=$g(group(perdr)),grptype="G"
		...i argid'="" s grpid="-",grptype="A"
		...i grpid="" s grpid="-"
		...s tmp(ward,grptype,grpid,"-",perdr)="-"
		...i '$d(array1(grptype,grpid)) s array1(grptype,grpid)=1,tmpGroup(grptype,"-",grpid)=grpid
		...s array(perdr)=1
	}
	q 1
}

/// 判断护士是否为借调
ClassMethod CheckTmpTransDep(perdr As %String, ward As %String, date As %String) As %String
{
	s flag=0
	q:(perdr="")!(ward="")!(date="")
	s:date["-" date=$zdh(date,3)
	s date="" f  s date=$O(^DHCNMG.HR.MgTransAppI("date"," T",date)) q:date=""  d
	.s appdr="" f  s arrpdr=$O(^DHCNMG.HR.MgTransAppI("date"," T",date,appdr)) q:appdr=""  d
	..s appObj=##class(DHCNMG.HR.MgTransApp).%OpenId(appdr)
	..q:(appObj.TransStatus'="A") ;过滤未审核的
	..q:((appObj.TransDate'="")&&(appObj.TransDate>date))||((appObj.TransEndDate'="")&&(appObj.TransEndDate<stdate))
	..f i=1:1:appObj.TransNurse.Count() d
	...s perward=appObj.TransNurse.GetAt(i)
	...q:perward=""
	...s warddr=$P(perward,"|",1)
	...s trsperdr=$P(perward,"|",2)
	...q:(warddr="")||(warddr'=ward)||(perdr="")||(trsperdr'=perdr)
	...s flag=1
	q flag
}

/// 判断调科日期之后是否存在排班
ClassMethod CheckDateArrange(perdr As %String, date As %String) As %String
{
	q:(perdr="")||(date="") 0
	s flag=0
	s argdate=date-1 f  s argdate=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,argdate)) q:(argdate="")!(flag=1)  d
	.s argid="" f  s argid=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,argdate,argid)) q:(argid="")!(flag=1)  d
	..s flag=1
	q flag
}

/// 批量删除排班记录
ClassMethod DeleteTransArrange(perdr As %String, date As %String) As %String
{
	q:(perdr="")||(date="") 0
	s flag=0
	s argdate=date f  s argid=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,argdate)) q:(argdate="")  d
	.s argid="" f  s argid=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,argdate,argid)) q:(argid="")  d
	..d ##class(DHCNMG.Arg.MgArrangeSub).%DeleteId(argid)
	q 1
}

///  creator: xbl
///  createdate: 20170905
///  description: 获取护士某天排班信息
///  table: DHCNMG.Arg.MgArrangeSub
///  input:
///  output:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgArgComm","FindPerDateArg","1^5^2017-08-29")
Query FindPerDateArg(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPerDateArgExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s perdr=$P(parr,"^",2)
	s date=$p(parr,"^",3)
	i (ward="")||(perdr="")||(date="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s:date["-" date=$zdh(date,3)
	s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("WardPerDate",ward,perdr,date,id)) q:id=""  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	.s ret=..GetArgSubById(id)
	.d OutPerDateArg
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPerDateArg
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPerDateArgClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPerDateArgExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPerDateArgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPerDateArgExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 20170907dx
/// description: 清除排班数据
/// table: DHCNGM.Arg.MgArrange,DHCNMG.Arg.MgArrangeGroup,DHCNMG.Arg.MgArrangeRow,DHCNMG.Arg.MgArrangeSub
/// input:
/// output:
/// other: d ##class(web.NurMgArgComm).ClearArrange()
ClassMethod ClearArrange() As %String
{
	;k ^DHCNMG.DB.MgArgPostI
	;k ^DHCNMG.DB.MgArgPostD
	;k ^DHCNMG.DB.MgArgWardPostI
	;k ^DHCNMG.DB.MgArgWardPostD
	;k ^DHCNMG.DB.MgArgHolidayI
	;k ^DHCNMG.DB.MgArgHolidayD
	k ^DHCNMG.Arg.MgAskLeaveI
	k ^DHCNMG.Arg.MgAskLeaveD
	k ^DHCNMG.Arg.MgArrangeI
	k ^DHCNMG.Arg.MgArrangeD
	k ^DHCNMG.Arg.MgArrangeGroupI
	k ^DHCNMG.Arg.MgArrangeGroupD
	k ^DHCNMG.Arg.MgArrangeRowI
	k ^DHCNMG.Arg.MgArrangeRowD
	k ^DHCNMG.Arg.MgArrangeSubI
	k ^DHCNMG.Arg.MgArrangeSubD
	q 1
}

/// creator: xbl
/// createdate: 20170915
/// description: 添加排班人员
/// table: DHCNMG.Arg.MgArrangeRow
/// input:
/// output:
/// other:
ClassMethod AddArgPersons(parr1 As %String, persons As %String) As %String
{
	q:(parr1="")!(persons="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	f i=1:1:$L(persons,",") d
	.s perdr=$P(persons,",",i)
	.q:perdr=""
	.s id=$O(^DHCNMG.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	.q:id'=""
	.s obj=##class(DHCNMG.Arg.MgArrangeRow).%New()
	.s obj.ArrangeDR=##class(DHCNMG.Arg.MgArrange).%OpenId(argid)
	.s obj.ArgPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.s obj.ArgPerSort=..GetArgRowSort(argid)
	.s obj.ArgPerAddFlag="Y"
	.d obj.%Save()
	q 1
}

/// creator: xbl
/// createdate: 20170915
/// description: 删除排班人员
/// table: DHCNMG.Arg.MgArrangeRow,DHCNMG.Arg.MgArrangeSub
/// input:
/// output:
/// other: w ##class(web.NurMgArgComm).DeleteArgPersons()
ClassMethod DeleteArgPersons(parr1 As %String, persons As %String) As %String
{
	q:(parr1="")!(persons="") 0
	s argid=..SaveArrange(parr1)
	q:+argid=0 0
	s ret=""
	f i=1:1:$L(persons,",") d
	.s perdr=$P(persons,",",i)
	.q:perdr=""
	.s rowid=$O(^DHCNMG.Arg.MgArrangeRowI("ArgPerson",argid,perdr,""))
	.i rowid="" s ret="未查找到人员请刷新重试"
	.q:rowid=""
	.s obj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(rowid)
	.;i obj.ArgPerAddFlag="N" s ret="存在人员为调科到本病区，不可以删除，需要进行调科操作"
	.;q:obj.ArgPerAddFlag="N"
	.s date="" f  s date=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowid,date)) q:date=""  d
	..s subid="" f  s subid=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowid,date,subid)) q:subid=""  d
	...d ##class(DHCNMG.Arg.MgArrangeSub).%DeleteId(subid)
	.d obj.%DeleteId(rowid)
	q:ret'="" ret
	q 1
}

/// creator: xbl
/// createDate: 20170918
/// description: 获取排班表格单元格样式
/// table: DHNMG.Arg.MgArrange,DHCNMG.DB.MgArgPost
/// input:
/// output:
/// other: w ##class(%ResultSet).RunQuery("web.NurMgArgComm","FindArgStyle","109^2019-08-12^2019-08-18","")
Query FindArgStyle(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArgStyleExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s startTime=$P($h,",",2)
	s ward=$P(parr,"^",1)
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	i ((ward="")!(stdate="")!(enddate=""))
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s listno=$zd(stdate,8)_ward
	s argid=$O(^DHCNMG.Arg.MgArrangeI("ListNo"," "_listno,""))
	k nurlist,tmpgroup
	s nurlist="",tmpgroup=""
	d ..GetWardNurse(argid,ward,stdate,enddate,"",.nurlist,.tmpgroup)
	s row=1
	s grptyp="" f  s grptyp=$O(tmpgroup(grptyp)) q:grptyp=""  d
	.s groupsort="" f  s groupsort=$O(tmpgroup(grptyp,groupsort)) q:groupsort=""  d
	..s grp="" f  s grp=$O(tmpgroup(grptyp,groupsort,grp)) q:grp=""  d
	...s GrpDesc=""
	...i grptyp="G" d
	....i (+grp=0)||($d(^DHCNMG.Arg.MgNurGroupD(grp))=0) d
	.....s ret="PerName|未分组^editFlag|0"
	.....d OutArgStyle
	....e  d
	.....s grpobj=##class(DHCNMG.Arg.MgNurGroup).%OpenId(grp)
	.....s ret="PerName|"_grpobj.GroupDesc_"^ArgGroupDR|"_grp_"^editFlag|0"
	.....s GrpDesc=grpobj.GroupDesc
	.....d OutArgStyle
	...i (grptyp="A") d
	....i (+grp=0)||($d(^DHCNMG.Arg.MgArrangeGroupD(grp))=0) d
	.....s ret="PerName|未分组^editFlag|0"
	.....d OutArgStyle
	....e  d
	.....s grpobj=##class(DHCNMG.Arg.MgArrangeGroup).%OpenId(grp)
	.....s ret="PerName|"_grpobj.GroupDesc_"^ArgGroupDR|"_grp_"^editFlag|0"
	.....s GrpDesc=grpobj.GroupDesc
	.....d OutArgStyle
	...s GrpSort=0
	...s sort="" f  s sort=$O(nurlist(ward,grptyp,grp,sort)) q:sort=""  d 
	....s perdr="" f  s perdr=$O(nurlist(ward,grptyp,grp,sort,perdr)) q:perdr=""  d
	.....s GrpSort=GrpSort+1
	.....s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.....s argrowid=nurlist(ward,grptyp,grp,sort,perdr)
	.....s ret="PerName|"_perobj.PerName_"^PerID|^ArgPerDR|^ArgRowId|^ArgPerSort|"
	.....s ret=ret_"^LevelDesc|^GrpDesc|^GrpSort|^ArgGroupDR|^ArgWorkRemark|^ArgPerBeds|"
	.....s PerCode=perobj.PerPostName
	.....i (argid'="")&&(+argrowid'=0)&&$d(^DHCNMG.Arg.MgArrangeRowD(argrowid)) d
	......s rowObj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(argrowid)
	......s totalminute=0,nightminute=0,secondminute=0
	......f date=stdate:1:enddate d
	.......s ret=ret_"^Date"_$zd(date,3)_"|"
	.......s cellstyle=""
	.......s isAskLeave=..IsPerAskLeavel2(perdr_"^"_date)
	.......s curward=##class(web.NurMgHRComm).GetCurrentWard(perdr,date)
	.......s tWard=..GetPostForOther(perdr,date,ward)
	.......;不在本病区且不是护士长添加||本病区护士在其他病区有排班||护士长添加人员其他病区有排班
	.......i ((curward'="")&&(curward'=ward)&&(rowObj.ArgPerAddFlag'="Y"))||((tWard'="")&&(tWard'=ward)&&(rowObj.ArgPerAddFlag="Y")) d ;不是当前科室的
	........s cellstyle=""
	.......e  d
	........s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,argrowid,date,id)) q:id=""  d
	.........q:+id=0
	.........s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	.........q:(obj.ArgPostDR="")&&(obj.ArgType'="Y")&&(obj.ArgType'="N")
	.........;请假处理
	.........s:obj.ArgPostDR.PostDR.PostType="H" isAskLeave=1
	.........s:cellstyle'="" cellstyle=cellstyle_"@"_obj.ArgPostDR.PostDR.PostFontColor_"!"_obj.ArgPostDR.PostDR.PostBgColor
	.........s:cellstyle="" cellstyle=obj.ArgPostDR.PostDR.PostFontColor_"!"_obj.ArgPostDR.PostDR.PostBgColor
	.......s ret=ret_cellstyle_"^editFlag|"
	.....e  d
	......f date=stdate:1:enddate d
	.......s ret=ret_"^Date"_$zd(date,3)_"|"
	.....s ret=ret_"^ArgWorkRemark|^PerCode|"
	.....d OutArgStyle
	.....s row=row+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutArgStyle
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgStyleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgStyleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArgStyleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgStyleExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:
/// CreateDate: 
/// Description: 
/// Table: DHNMG.Arg.MgArrange,DHCNMG.DB.MgArgPost
/// Input:
/// Output:
/// Other: w ##class(%ResultSet).RunQuery("web.NurMgArgComm","FindArgCellStyle","109^2019-08-12^2019-08-18","")
Query FindArgCellStyle(ward As %String, stdate As %String, enddate As %String, parr As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArgCellStyleExecute(ByRef qHandle As %Binary, ward As %String, stdate As %String, enddate As %String, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	i ((ward="")!(stdate="")!(enddate="")!(parr="")) Set qHandle=$lb(0,repid,0) Quit $$$OK
	//109%2019-08-12%2019-08-18%120!7526^120!7526^361!7527^361!7527^781!7528^781!7528
	s tmp=""
	s len=$l(parr,"^")
	f i=1:1:len
	{
		s item=$p(parr,"^",i)
		i item="" continue
		s perDr=$p(item,"!",1)
		s argRow=$p(item,"!",2)
		i $g(tmp(perDr))="" s tmp(perDr)=1
	}
	
	s tmpPer="" f  s tmpPer=$o(tmp(tmpPer)) q:tmpPer=""  d
	.s ret=""
	.s ret="ArgPerDR|"_tmpPer
	.f date=stdate:1:enddate d
	..s cellstyle=""
	..s ret=ret_"^Date"_$zd(date,3)_"|"
	..
	..s rw="" f  s rw=$o(^DHCNMG.Arg.MgArrangeSubI("WardPerDate",ward,tmpPer,date,rw)) q:rw=""  d
	...s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(rw)
	...q:'$IsObject(obj)
	...i ((obj.ArgType'="Y")&&(obj.ArgType'="N")) d
	....i cellstyle="" s cellstyle=obj.ArgPostDR.PostDR.PostFontColor_"!"_obj.ArgPostDR.PostDR.PostBgColor
	....e  s cellstyle=cellstyle_"@"_obj.ArgPostDR.PostDR.PostFontColor_"!"_obj.ArgPostDR.PostDR.PostBgColor
	..s ret=ret_cellstyle
	.d OutArgStyle

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutArgStyle
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgCellStyleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgCellStyleExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindArgCellStyleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgCellStyleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 2017/11/29
/// description: 护士分组
/// table: DHCNMG.Arg.MgNurGroup
/// input:
/// output:
/// return:
/// other: d ##class(web.NurMgArgComm).SaveNurGroup("GroupDesc|第一组^GroupWardDR|1^GroupMaster|3^GroupMember|3,5,6,7,9,10^GroupRemark|测试^rw|^")
ClassMethod SaveNurGroup(parr As %String) As %String
{
	q:parr="" "参数不为空!"
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	;检测：吉林三大一个分组不允许同层级人员存在，办公室护士、护士长不可选择
	;s isnext=..CheckSaveNurGroupIsOk(tmp("GroupMember")_","_tmp("GroupMaster"))
	;q:isnext'=1 isnext
	i $g(tmp("rw"))'="" d
	.s obj=##class(DHCNMG.Arg.MgNurGroup).%OpenId(tmp("rw"))
	e  d
	.s obj=##class(DHCNMG.Arg.MgNurGroup).%New()
	i $g(tmp("GroupWardDR"))'="" d
	.s obj.GroupWardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("GroupWardDR"))
	e  s obj.GroupWardDR=""
	s obj.GroupDesc=$g(tmp("GroupDesc"))
	i $g(tmp("GroupMaster"))'="" d
	.s obj.GroupMaster=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("GroupMaster"))
	e  s obj.GroupMaster=""
	d obj.GroupMember.Clear()
	f i=1:1:$L($g(tmp("GroupMember")),",") d
	.s perdr=$P($g(tmp("GroupMember")),",",i)
	.q:perdr=""
	.d obj.GroupMember.Insert(perdr)
	s obj.GroupRemark=$g(tmp("GroupRemark"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// creator: xbl
/// createdate: 2017/11/29
/// description: 获取护士分组
/// table: DHCNMG.Arg.MgNurGroup
/// input:
/// output:
/// return:
/// other: w ##class(web.NurMgArgComm).GetNurGroup(1)
ClassMethod GetNurGroup(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Arg.MgNurGroup).%OpenId(id)
	s ret="rw|"_id
	i obj.GroupWardDR'="" d
	.s ret=ret_"^GroupWardDR|"_obj.GroupWardDR.%Id()
	.s ret=ret_"^WardDesc|"_obj.GroupWardDR.WardDesc
	s ret=ret_"^GroupDesc|"_obj.GroupDesc
	i obj.GroupMaster'="" d
	.s ret=ret_"^GroupMaster|"_obj.GroupMaster.%Id()
	.s ret=ret_"^MasterName|"_obj.GroupMaster.PerName
	s members1="",members2=""
	f i=1:1:obj.GroupMember.Count() d
	.s perdr=obj.GroupMember.GetAt(i)
	.q:perdr=""
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.i members1="" s members1=perdr,members2=perobj.PerName
	.e  s members1=members1_","_perdr,members2=members2_","_perobj.PerName
	s ret=ret_"^GroupMember|"_members1
	s ret=ret_"^MemberDesc|"_members2
	s BedGroup=obj.GroupBedGroup
	s bedGroupDesc="",beds="",bedcodes=""
	i BedGroup'="" d
	.s bedGroupDesc=$p(^DHCWardProGroup(BedGroup),"^",2)
	.s beds=##class(web.NurMgHISComm).GetBedIdByGroup(BedGroup)
	.s bedcodes=##class(web.NurMgHISComm).GetBedByGroup(BedGroup)
	s ret=ret_"^BedGroup|"_BedGroup
	s ret=ret_"^BedGroupDesc|"_bedGroupDesc
#;	s beds="",bedcodes=""
#;	f i=1:1:obj.GroupResBeds.Count() d
#;	.s bed=obj.GroupResBeds.GetAt(i)
#;	.q:bed=""
#;	.i beds="" s beds=$tr(bed,"||","__"),bedcodes=$P(^PAWARD(+bed,"BED",$P(bed,"||",2)),"^",1)
#;	.e  s beds=beds_","_$tr(bed,"||","__"),bedcodes=bedcodes_","_$P(^PAWARD(+bed,"BED",$P(bed,"||",2)),"^",1)
	s ret=ret_"^GroupResBeds|"_beds
	s ret=ret_"^BedCodes|"_bedcodes
	s ret=ret_"^GroupRemark|"_obj.GroupRemark
	q ret
}

/// creator: xbl
/// createdate: 2017/11/29
/// description: 删除护士分组
/// table: DHCNMG.Arg.MgNurGroup
/// input:
/// output:
/// return:
/// other: 
ClassMethod DeleteNurGroup(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Arg.MgNurGroup).%OpenId(id)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

///  creator: xbl
///  createdate: 2017/11/30
///  description: 获取护士分组列表
///  table: DHCNMG.Arg.MgNurGroup
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgArgComm","FindNurGroup","1")
Query FindNurGroup(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurGroupExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	i (ward="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s id="" f  s id=$O(^DHCNMG.Arg.MgNurGroupI("Ward",ward,id)) q:id=""  d
	.s obj=##class(DHCNMG.Arg.MgNurGroup).%OpenId(id)
	.s ret=..GetNurGroup(id)
	.d OutNurGroup
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurGroup
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurGroupExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 2017/11/30
/// description: 护士分组设置管床
/// table: DHCNMG.Arg.MgNurGroup
/// input:
/// output:
/// return:
/// other:
ClassMethod SaveGroupBed(id As %String, parr As %String) As %String
{
	q:id="" 0
	s obj=##Class(DHCNMG.Arg.MgNurGroup).%OpenId(id)
	s obj.GroupBedGroup=$tr(parr," ","")
#;	d obj.GroupResBeds.Clear()
#;	s beds=##class(web.NurMgHISComm).GetBedIdByGroup($tr(parr," ",""))
#;	f i=1:1:$L(beds,",") d
#;	.s bedid=$P(beds,",",i)
#;	.q:bedid=""
#;	.s bedid=$tr(bedid,"__","||")
#;	.d obj.GroupResBeds.Insert(bedid)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// crearor: xbl
/// createdate: 2018/01/02
/// description: 获取值班护士
/// table: DHCNMG.Arg.MgArrangeGroup,DHCNMG.Arg.MgArrangeRow
/// input: locid CT_Loc, date: 2018-01-02, time: 10:00, bedid: PAC_Bed
/// output: 姓名(工号),姓名(工号)
/// return: 姓名(工号),姓名(工号)
/// other: w ##class(web.NurMgArgComm).GetBedNurse("27","2017-12-26","10:00","10||1")
ClassMethod GetBedNurse(locid As %String, date As %String, time As %String, bedid As %String = "") As %String
{
	q:(locid="")||('$d(^CTLOC(locid))) ""
	s ward=$O(^PAWARD(0,"WARD_LocationDR",locid,""))
	q:(ward="")||(+bedid'=ward) ""
	i date="" s date=+$h
	s:date["-" date=$zdh(date,3)
	i time="" s time=$P($h,",",2)
	s:time[":" time=$zth(time,1)
	s wardid=$O(^DHCNMG.DB.MgWardI("CTLoc",locid,""))
	q:wardid="" ""
	s ret=""
	s subid="" f  s subid=$O(^DHCNMG.Arg.MgArrangeSubI("WardDate",wardid,date,subid)) q:subid=""  d
	.s subobj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(subid)
	.q:subobj.ArgPostDR=""
	.q:(subobj.ArgPostDR.PostDR.PostType'="P") ;||(subobj.ArgPostDR.PostClass'="一线班")
	.s sttime1=subobj.ArgPostDR.PostStTime1,endtime1=subobj.ArgPostDR.PostEndTime1
	.s sttime2=subobj.ArgPostDR.PostStTime2,endtime2=subobj.ArgPostDR.PostEndTime2
	.s sttime3=subobj.ArgPostDR.PostStTime3,endtime3=subobj.ArgPostDR.PostEndTime3
	.q:(((sttime1'="")&&(sttime1>time))||((endtime1'="")&&(endtime1<time)))&&(((sttime2'="")&&(sttime2>time))||((endtime2'="")&&(endtime2<time)))&&(((sttime3'="")&&(sttime3>time))||((endtime3'="")&&(endtime3<time)))
	.q:(subobj.ArgRowDR="")||(subobj.ArgPerDR="")||(subobj.ArgRowDR.ArgGroupDR="")
	.q:subobj.ArgRowDR.ArgGroupDR.GroupResBeds.Find(bedid)=0
	.s ret=ret_subobj.ArgPerDR.PerName_"("_subobj.ArgPerDR.PerID_")"_","
	i ret'="" s ret=$E(ret,1,$L(ret)-1)
	q ret
}

/// crearor: xbl
/// createdate: 2018/01/18
/// description: 获取病区护士分组  
///              GroupType为A取值表DHCNMG.Arg.MgArrangeGroup
///              GroupType为G取值表DHCNMG.Arg.MgNurGroup
/// table: DHCNMG.Arg.MgArrangeGroup,DHCNMG.Arg.MgNurGroup
/// input: loc CT_Loc, date: 2018-01-02
/// output: GroupDesc|^GroupType|^GroupId|^GroupNurse|SSUSR_RowId,工号,姓名;SSUSR_RowId,工号,姓名;"
/// return: 姓名(工号),姓名(工号)
/// other: w ##class(web.NurMgArgComm).GetGroupNurse("27")
ClassMethod GetGroupNurse(loc As %String, date As %String = "") As %String
{
	q:(loc="") ""
	s ward=$O(^DHCNMG.DB.MgWardI("CTLoc",loc,""))
	q:ward="" ""
	i date="" s date=+$h
	s:date["-" date=$zdh(date,3)
	k nurlist,tmpgroup
	s nurlist="",tmpgroup=""
	d ..GetWardNurse("",ward,date,date,"",.nurlist,.tmpgroup)
	s ret=""
	s grptyp="" f  s grptyp=$O(tmpgroup(grptyp)) q:grptyp=""  d
	.s groupsort="" f  s groupsort=$O(tmpgroup(grptyp,groupsort)) q:groupsort=""  d
	..s grp="" f  s grp=$O(tmpgroup(grptyp,groupsort,grp)) q:grp=""  d
	...i grptyp="G" d
	....i (+grp=0)||($d(^DHCNMG.Arg.MgNurGroupD(grp))=0) d
	.....s ret=ret_"@GroupDesc|未分组^GroupType|G^GroupId|0"
	....e  d
	.....s grpobj=##class(DHCNMG.Arg.MgNurGroup).%OpenId(grp)
	.....s ret=ret_"@GroupDesc|"_grpobj.GroupDesc_"^GroupType|G^GroupId|"_grp
	...i (grptyp="A") d
	....i (+grp=0)||($d(^DHCNMG.Arg.MgArrangeGroupD(grp))=0) d
	.....s ret=ret_"@GroupDesc|未分组^GroupType|A^GroupId|0"
	....e  d
	.....s grpobj=##class(DHCNMG.Arg.MgArrangeGroup).%OpenId(grp)
	.....s ret=ret_"@GroupDesc|"_grpobj.GroupDesc_"^GroupType|A^GroupId|"_grp
	...s ret=ret_"^GroupNurse|"
	...s sort="" f  s sort=$O(nurlist(ward,grptyp,grp,sort)) q:sort=""  d 
	....s perdr="" f  s perdr=$O(nurlist(ward,grptyp,grp,sort,perdr)) q:perdr=""  d
	.....s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.....s perid=perobj.PerID
	.....q:perid=""
	.....s userdr=$O(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(perid,"U"),""))
	.....;q:userdr=""
	.....s ret=ret_userdr_","_perid_","_perobj.PerName_";"
	q ret
}

/// crearor: gzj
/// createdate: 2018/02/04
/// description: 获取值班护士 年资 职称 学历
/// table: 
/// input: locid CT_Loc, date: 2018-01-02 10:00, bedid: PAC_Bed,nursename:护士姓名
/// output: 姓名,年资，职称，学历
/// return: 502,2018-02-05 10:11,21||55,王莉慧,王凤红
/// other: w ##class(web.NurMgArgComm).GetNurseInfo()
ClassMethod GetNurseInfo(locid As %String, datetime As %String, bedid As %String, nursename As %String) As %String
{
	q:(locid="")||('$d(^CTLOC(locid))) ""
	s ward=$O(^PAWARD(0,"WARD_LocationDR",locid,""))
	q:(ward="")||(+bedid'=ward) ""
	s date="",time=""
	i datetime="" s date=+$h,time=$P($h,",",2)
	s:$P(datetime," ",1)["-" date=$zdh($P(datetime," ",1),3)
	s:$P(datetime," ",2)[":" time=$zth($P(datetime," ",2),1)
	s wardid=$O(^DHCNMG.DB.MgWardI("CTLoc",locid,""))
	q:wardid="" ""
	s ret=""
	s subid="" f  s subid=$O(^DHCNMG.Arg.MgArrangeSubI("WardDate",wardid,date,subid)) q:subid=""  d
	.s subobj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(subid)
	.q:subobj.ArgPostDR=""
	.q:(subobj.ArgPostDR.PostDR.PostType'="P") ;||(subobj.ArgPostDR.PostClass'="一线班")
	.s sttime1=subobj.ArgPostDR.PostStTime1,endtime1=subobj.ArgPostDR.PostEndTime1
	.s sttime2=subobj.ArgPostDR.PostStTime2,endtime2=subobj.ArgPostDR.PostEndTime2
	.s sttime3=subobj.ArgPostDR.PostStTime3,endtime3=subobj.ArgPostDR.PostEndTime3
	.q:(((sttime1'="")&&(sttime1>time))||((endtime1'="")&&(endtime1<time)))&&(((sttime2'="")&&(sttime2>time))||((endtime2'="")&&(endtime2<time)))&&(((sttime3'="")&&(sttime3>time))||((endtime3'="")&&(endtime3<time)))
	.q:(subobj.ArgRowDR="")||(subobj.ArgPerDR="")||(subobj.ArgRowDR.ArgGroupDR="")
	.q:((bedid="")||(subobj.ArgRowDR.ArgGroupDR.GroupResBeds.Find(bedid)=0))
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(subobj.ArgPerDR.%Id())
	.q:'$IsObject(perobj)
	.q:$tr(nursename," ","")'[perobj.PerName
	.s percomedate=perobj.PerComeDate
	.s yearAge=""
	.i percomedate'="" d
	..s yearAgestr=##class(web.NurMgVueComm).CalAge($zd($g(percomedate),3),$zd(+$H,3))
	..s yearAge=$p($P($g(yearAgestr)," ",1),"Y","1")
	.s postduty=""
	.i perobj.PerPostDuty'="" d
	..s postdutyobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(perobj.PerPostDuty)
	..q:'$IsObject(postdutyobj)
	..s postduty=postdutyobj.SubDesc
	.s adamic="" //学历
	.s edudate=$O(^DHCNMG.HR.MgEducateI("flag",subobj.ArgPerDR.%Id(),""),-1)
	.i edudate'="" d
	..s edurowid=$O(^DHCNMG.HR.MgEducateI("flag",subobj.ArgPerDR.%Id(),edudate,""),-1)
	..i edurowid'="" d
	...s eduObj=##class(DHCNMG.HR.MgEducate).%OpenId(edurowid)
	...q:'$IsObject(eduObj)
	...i eduObj.EduAcademic'="" d
	....s eduCodeObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(eduObj.EduAcademic)
	....q:'$IsObject(eduCodeObj)
	....s adamic=eduCodeObj.SubDesc
	.s ret=ret_subobj.ArgPerDR.PerName_","_yearAge_","_postduty_","_adamic_"|"
	i ret'="" s ret=$E(ret,1,$L(ret)-1)
	q ret
}

/// Crearor: gzj
/// Createdate: 2018/02/05
/// Description: 获取护理部 科护士长 护士长 高级责任护士权限状态
/// Table: 
/// Input:
/// Output:
/// Return: 
/// Other: 
ClassMethod GetLimitNurseState(userid As %String, ctlocid As %String, post As %String) As %String
{
	q:userid="" "UserID不能为空！"
	s flag=0
	s HISNo=$p($g(^SSU("SSUSR",$tr(userid," ",""))),"^",1)
	s nursename=$p($g(^SSU("SSUSR",$tr(userid," ",""))),"^",2)
	s WardRowID=$O(^DHCNMG.DB.MgWardI("CTLoc",$tr(ctlocid," ",""),""))
	q:WardRowID="" "此病区未关联HIS病区！请联系护理部"
	s rowid=$O(^DHCNMG.HR.MgPersonsI("hisno"," "_HISNo,""))
	q:rowid="" "未关联HIS号"
	s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	q:((WardRowID'="")&&(perObj.PerDepDR'=WardRowID)) 0
	s ret=""
	s roleid="" f  s roleid=$O(^DHCNMG.HR.MgNurRoleI("ssid",rowid,roleid)) q:roleid=""  d
	.s roleobj=##class(DHCNMG.HR.MgNurRole).%OpenId(roleid)
	.q:((roleobj.RoleStDate'="")&&(roleobj.RoleStDate>+$H))
	.q:((roleobj.RoleEndDate'="")&&(roleobj.RoleEndDate<+$H))
	.s roledesc=""
	.i roleobj.RoleID'="" d
	..s Obj=##class(DHCNMG.Set.MgRoles).%OpenId(roleobj.RoleID)
	..q:'$IsObject(Obj)
	..i ret="" s ret=Obj.RoleDesc
	..e  s ret=ret_"^"_Obj.RoleDesc
	s len=$L(ret,"^")
	f i=1:1:len
	{
		s itm=$p(ret,"^",i)
		i ((itm'="")&&(itm=$tr(post," ",""))) s flag=1
	}
	q flag
}

/// creator: lulin	
/// createdate: 2018-04-17
/// description: 获取病区护士（吉林三院，排除护士长。岗位名称：办公室护士）
/// table: DHCNMG.HR.MgTransDep
/// input: 
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgArgComm","FindWardNurse","1^2017-09-11^2017-09-17","")
Query FindWardNurse(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardNurseExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	;s ^TMPLL("WardNurse")=parr_"%"_input
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s stdate=$P(parr,"^",2)
	s enddate=$P(parr,"^",3)
	s pertype=$P(parr,"^",4)
	i (ward="")!(stdate="")!(enddate="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)+7
	s trsid="" f  s trsid=$O(^DHCNMG.HR.MgTransDepI("Dep"," "_ward,trsid)) q:trsid=""  d
	.s obj=##class(DHCNMG.HR.MgTransDep).%OpenId(trsid)
	.s perdr=obj.PerDr
	.q:(perdr="")||($d(^DHCNMG.HR.MgPersonsD(perdr))=0)
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.s leavedate=perobj.PerStateDate //离职或退休日期
	.q:(leavedate'="")&&(leavedate<=stdate)
	.q:(pertype'="")&&(pertype'[perobj.PerTypeDR)
	.s trsstdate=obj.PerTranStDate
	.s trsenddate=##class(web.NurMgHRComm).GetTransEndDate(trsid)
	.q:(trsstdate="")||(trsstdate>enddate)||((trsenddate'="")&&(trsenddate<=stdate))
	.s PerName=perobj.PerName
	.s PerNameSpell=##class(web.NurMgVueComm).ToChineseSpell(PerName)
	.q:(input'="")&&(PerNameSpell_PerNameSpell'[$zcvt(input,"U"))
	.q:$d(tmp(perdr))
	.s PerPostName=""
	.s:perobj.PerPostName'="" PerPostName=##class(web.NurMgPersonComm).GetCommCode(perobj.PerPostName) 
	.s disabled=0
	.;s:PerPostName["办公室护士" disabled=1
	.s PerPostDuty=##class(web.NurMgHRComm).GetDutyDesc(perdr,stdate,enddate)
	.;s:PerPostDuty["护士长" disabled=1
	.s leveldesc=##class(web.NurMgHRComm).GetLevelDesc(perdr,stdate,enddate)
	.s tmp(perdr)="PerDR|"_perdr_"^PerName|"_PerName_"^PerID|"_perobj.PerID_"^PerLevel|"_leveldesc_"^disabled|"_disabled
	.s tmp(perdr)=tmp(perdr)_"^PerNameSpell|"_PerNameSpell
	.s ret=tmp(perdr)
	.d OutWardNurse
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardNurse
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardNurseExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: lulin	
/// createdate: 2018-04-17
/// description: 检测是否可以保存分组（吉林三院，排除护士长。岗位名称：办公室护士，同层）
/// table: 
/// input: 
/// output:
/// other:
ClassMethod CheckSaveNurGroupIsOk(parr As %String = "") As %String
{
	s date=+$h
	s isQuit=0
	s qStr=1
	f i=1:1:$L($g(parr),",") q:(isQuit'=0)  d
	.s perdr=$P($g(parr),",",i)
	.q:perdr=""
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.q:'$IsObject(perobj)
	.s PerPostName=""
	.s:perobj.PerPostName'="" PerPostName=##class(web.NurMgPersonComm).GetCommCode(perobj.PerPostName) 
	.s:PerPostName["办公室护士" isQuit=1,qStr="办公室护士不可分组:"_perobj.PerName
	.s PerPostDuty=##class(web.NurMgHRComm).GetDutyDesc(perdr,date,date)
	.s:PerPostDuty["护士长" isQuit=1,qStr="护士长不可分组:"_perobj.PerName
	.s leveldesc=##class(web.NurMgHRComm).GetLevelDesc(perdr,date,date)
	.s:((leveldesc'="")&&($d(nurselevel(leveldesc)))) isQuit=1,qStr="同组(包含护士长)不可存在同层级人员"
	.s:leveldesc'="" nurselevel(leveldesc)=leveldesc
	q qStr
}

/// creator: lulin	
/// createdate: 2018-04-18
/// description: 获取护士班次（用于上班确认）
/// table: DHCNMG.HR.MgTransDep
/// input: 
/// output:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgArgComm","FindNurConArg","","")
Query FindNurConArg(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNurConArgExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	s stdate=$P(parr,"^",2)
	s enddate=$P(parr,"^",3)
	s loginid=$p(parr,"^",4)
	i loginid="" {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s ret=""
	s argid="" f  s argid=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid)) q:argid=""  d
	.s argObj=##class(DHCNMG.Arg.MgArrange).%OpenId(argid)
	.q:'$IsObject(argObj)
	.q:(argObj.ArgStatus'="R")&&(argObj.ArgStatus'="A")
	.s rowid="" f  s rowid=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowid)) q:rowid=""  d
	..s date="" f  s date=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowid,date)) q:date=""  d
	...q:((stdate'="")&&(stdate>date))||((enddate'="")&&(enddate<date))
	...s rowobj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(rowid)
	...q:'$IsObject(rowobj)
	...q:'$IsObject(rowobj.ArgPerDR)
	...q:(loginid'=0)&&(loginid'=rowobj.ArgPerDR.%Id())
	...s perdr=rowobj.ArgPerDR.%Id()
	...s isAskLevel=..IsPerAskLeavel2(perdr_"^"_date)
	...q:isAskLevel=1 ;有请假
	...s PerName=rowobj.ArgPerDR.PerName
	...s LevelDesc=##class(web.NurMgHRComm).GetLevelDesc(rowobj.ArgPerDR.%Id(),date,date)
	...s PerPostName=rowobj.ArgPerCode ;岗位
	...s:PerPostName'="" PerPostName=##class(web.NurMgPersonComm).GetCommCode(PerPostName) 
	...s PerPost="",WardDesc="",rw=""
	...;s Status="未确认"
	...s subid="" f  s subid=$O(^DHCNMG.Arg.MgArrangeSubI("Arrange",argid,rowid,date,subid)) q:subid=""  d
	....s Status="未确认"
	....s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(subid)
	....q:'$IsObject(obj)
	....q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假班
	....q:'$IsObject(obj.ArgWardDR)
	....q:((ward'="")&&(ward'=obj.ArgWardDR.%Id()))
	....q:'$IsObject(obj.ArgRowDR)
	....q:'$IsObject(obj.ArgPerDR)
	....q:'$IsObject(obj.ArgPostDR)
	....s:WardDesc="" WardDesc=obj.ArgWardDR.WardDesc
	....;s:PerPost'="" PerPost=PerPost_"/"_obj.ArgPostDR.PostDesc
	....;s:PerPost="" PerPost=obj.ArgPostDR.PostDesc
	....s:(obj.ArgConfirmDR'="")||(obj.ArgConfirmDate'="") Status="已确认"
	....s endDate=obj.ArgDate,endtime=""
	....s endtime1=obj.ArgEndTime1
	....s:endtime1'="" endtime1=obj.ArgEndTime1
	....s:obj.ArgEndTime1["次日" endDate=endDate+1,endtime1=$e(obj.ArgEndTime1,3,$l(obj.ArgEndTime1))
	....s:endtime1'="" endtime=$zth(endtime1,2)
	....s endtime2=obj.ArgEndTime2
	....s:obj.ArgEndTime2["次日" endDate=endDate+1,endtime2=$e(obj.ArgEndTime2,3,$l(obj.ArgEndTime2))
	....s:endtime2'="" endtime2=$zth(endtime2,2)
	....s:(endtime2'="")&&((endDate>obj.ArgDate)||(endtime2>endtime)) endtime=endtime2
	....s endtime3=obj.ArgEndTime3
	....s:endtime3'="" endtime3=obj.ArgEndTime3
	....s:obj.ArgEndTime3["次日" endDate=endDate+1,endtime3=$e(obj.ArgEndTime3,3,$l(obj.ArgEndTime3))
	....s:endtime3'="" endtime3=$zth(endtime3,2)
	....s:(endtime3'="")&&((endDate>obj.ArgDate)||(endtime3>endtime)) endtime=endtime3
	....s:endDate'="" endDate=##class(web.NurMgHISComm).DateLogicalToHtml(endDate)
	....s:endtime'="" endtime=$zt(endtime,2)
	....s PerPost=obj.ArgPostDR.PostDesc
	....s replaceDesc=""
	....i (obj.ArgIsReplace=2)&&($IsObject(obj.ArgReplaceDR)) d
	.....s replaceDesc="(替"_obj.ArgReplaceDR.PerName_")"
	....s PerPost=PerPost_replaceDesc
	....;s:rw'="" rw=rw_"/"_subid
	....;s:rw="" rw=subid
	....s ret="WardDesc|"_WardDesc_"^PerName|"_PerName_"^Date|"_##class(web.NurMgHISComm).DateLogicalToHtml(date)_"^LevelDesc|"_LevelDesc_"^PerPostName|"_PerPostName_"^PerPost|"_PerPost_"^Status|"_Status_"^perdr|"_perdr_"^subid|"_subid
	....s ret=ret_"^endDate|"_endDate_"^endTime|"_endtime
	....d OutNurConArg
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNurConArg
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurConArgClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurConArgExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNurConArgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurConArgExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: lulin	
/// createdate: 2018-04-20
/// description: 护士确认班次
/// table: 
/// input: 班次明细id^确认人id
/// output:
/// other:
ClassMethod ConfirmNurArg(parr As %String = "") As %String
{
	s subid=$p(parr,"^")
	s perid=$p(parr,"^",2)
	q:subid="" 0
	s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(subid)
	q:'$IsObject(obj) 0
	Ts 
	s obj.ArgConfirmDR=perid
	s obj.ArgConfirmDate=+$h
	s obj.ArgConfirmTime=$p($h,",",2)
	s sc=obj.%Save()
	i $$$ISOK(sc) {
		TC
		q 1	
	}else{
		Tro
		q 0
	}
}

/// creator: lulin	
/// createdate: 2018-05-02
/// description: 是否存在某排班
/// table: 
/// input: 病区id^病区开始日期
/// output:
/// other:w ##class(web.NurMgArgComm).IsExsitArg("62^2018-04-30")
ClassMethod IsExsitArg(parr As %String = "") As %String
{
	s ward=$p(parr,"^")
	s stdate=$p(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	q:((ward="")||(stdate="")) 0
	s argid=$O(^DHCNMG.Arg.MgArrangeI("ListNo"," "_$zd(stdate,8)_ward,""))
	s:argid="" argid=0
	q argid
}

/// creator: lulin	
/// createdate: 2018.05.08
/// description: 获取某人某病区班次名称
/// table: 
/// input: 病区id^护士id^stdate^enddate
/// output:
/// other: w ##class(web.NurMgArgComm).getNurDateArg("62^60^2018-05-07^2018-05-08")
ClassMethod getNurDateArg(parr As %String = "") As %String
{
	q:parr="" ""
	s wardid=$p(parr,"^")
	s perid=$p(parr,"^",2)
	s stdate=$p(parr,"^",3)
	s enddate=$p(parr,"^",4)
	q:(wardid="")||(perid="")||(stdate="")||(enddate="") ""
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s ret=""
	s date="" f  s date=$o(^DHCNMG.Arg.MgArrangeSubI("WardPerDate",wardid,perid,date)) q:date=""  d
	.q:(stdate'="")&&(stdate>date)
	.q:(enddate'="")&&(enddate<date)
	.s subid="" f  s subid=$O(^DHCNMG.Arg.MgArrangeSubI("WardPerDate",wardid,perid,date,subid)) q:subid=""  d
	..s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(subid)
	..q:'$IsObject(obj)
	..q:'$IsObject(obj.ArgPostDR)
	..q:'$IsObject(obj.ArrangeDR)
	..q:((obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A"))
	..i ret'="" s ret=ret_","_obj.ArgPostDR.PostDesc
	..i ret="" s ret=obj.ArgPostDR.PostDesc
	q ret
}

/// creator: lulin	
/// createdate: 2018.05.08
/// description: 获取某人某天是否有假 南方医院版
/// table: 
/// input: 护士id^stdate^enddate
/// output:0:无，1：有
/// other: w ##class(web.NurMgArgComm).getNurDateArg("60^2018-05-07")
ClassMethod IsPerAskLeavel(parr As %String = "") As %String
{
		s perdr=$p(parr,"^")
		s date=$p(parr,"^",2)
		q:(perdr="")||(date="") 0
		s:date["-" date=$zdh(date,3)
		s flag=0
		s leaveId="" f  s leaveId=$o(^DHCNMG.Arg.MgAskLeaveI("PerDR",perdr,leaveId)) q:(leaveId="")||(flag=1)  d
		.s obj=##class(DHCNMG.Arg.MgAskLeave).%OpenId(leaveId)
		.q:'$IsObject(obj)
		.q:((obj.LeaveStDate'="")&&(obj.LeaveStDate>date))||((obj.LeaveEndDate'="")&&(obj.LeaveEndDate<date))
		.s flag=1
		q flag
}

/// creator: lulin	
/// createdate: 2018.05.08
/// description: 获取某人某天假描述
/// table: DHCNMG.Arg.MgNurLeaveApp,DHCNMG.Arg.MgNurNurHeadApp
/// input: 护士id^date
/// output:0:无，1：有
/// other: w ##class(web.NurMgArgComm).IsPerAskLeavel2("60^2018-05-07")
ClassMethod GetPerAskLeavelDesc2(parr As %String = "") As %String
{
		s perdr=$p(parr,"^")
		s date=$p(parr,"^",2)
		q:(perdr="")||(date="") ""
		s:date["-" date=$zdh(date,3)
		s flag=0,ret=""
		s id="" f  s id=$o(^DHCNMG.Arg.MgNurLeaveAppI("Nurse",perdr,id)) q:(id="")||(flag=1)  d
		.s obj=##class(DHCNMG.Arg.MgNurLeaveApp).%OpenId(id)
		.q:'$IsObject(obj)
		.q:obj.LeaveStatus'="NH"
		.q:((obj.LeaveStDate'="")&&(obj.LeaveStDate>date))
		.q:((obj.LeaveEndDate'="")&&(obj.LeaveEndDate<date))
		.s flag=1,ret=obj.LeaveType
		i flag=0 d
		.s id="" f  s id=$o(^DHCNMG.Arg.MgNurNurHeadAppI("Nurse",perdr,id)) q:(id="")||(flag=1)  d
		..s obj2=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(id)
		..q:'$IsObject(obj2)
		..q:obj2.LeaveStatus'="HH"
		..q:((obj2.LeaveStDate'="")&&(obj2.LeaveStDate>date))
		..q:((obj2.LeaveEndDate'="")&&(obj2.LeaveEndDate<date))
		..s flag=1,ret=obj.LeaveType
		q ret
}

/// creator: lulin	
/// createdate: 2018.05.08
/// description: 获取某人某天是否有假【】安贞版
/// table: DHCNMG.Arg.MgNurLeaveApp,DHCNMG.Arg.MgNurNurHeadApp
/// input: 护士id^date
/// output:0:无，1：有
/// other: w ##class(web.NurMgArgComm).IsPerAskLeavel2("60^2018-05-07")
ClassMethod IsPerAskLeavel2(parr As %String = "") As %String
{
		s perdr=$p(parr,"^")
		s date=$p(parr,"^",2)
		q:(perdr="")||(date="") 0
		s:date["-" date=$zdh(date,3)
		s flag=0
		s id="" f  s id=$o(^DHCNMG.Arg.MgNurLeaveAppI("Nurse",perdr,id)) q:((id="")||(flag=1))  d
		.s obj=##class(DHCNMG.Arg.MgNurLeaveApp).%OpenId(id)
		.q:'$IsObject(obj)
		.q:obj.LeaveStatus'="NH"
		.q:((obj.LeaveStDate'="")&&(obj.LeaveStDate>date))
		.q:((obj.LeaveEndDate'="")&&(obj.LeaveEndDate<date))
		.s flag=1
		i flag=0 d
		.s id="" f  s id=$o(^DHCNMG.Arg.MgNurNurHeadAppI("Nurse",perdr,id)) q:((id="")||(flag=1))  d
		..s obj2=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(id)
		..q:'$IsObject(obj2)
		..q:obj2.LeaveStatus'="HH"
		..q:((obj2.LeaveStDate'="")&&(obj2.LeaveStDate>date))
		..q:((obj2.LeaveEndDate'="")&&(obj2.LeaveEndDate<date))
		..s flag=1
		q flag
}

/// creator: wangpf	
/// createdate: 2020.01.13
/// description: 获取某人某天是否有假【安贞版】
/// table: DHCNMG.Arg.MgNurLeaveApp,DHCNMG.Arg.MgNurNurHeadApp
/// input: 护士id^date
/// output:0:无，1：有
/// other: w ##class(web.NurMgArgComm).IsPerAskLeavel3("60^2018-05-07")
ClassMethod IsPerAskLeavel3(parr As %String = "") As %String
{
		s perdr=$p(parr,"^")
		s date=$p(parr,"^",2)
		q:(perdr="")||(date="") 0
		s:date["-" date=$zdh(date,3)
		s decs=""
		s flag=0
		s id="" f  s id=$o(^DHCNMG.Arg.MgNurLeaveAppI("Nurse",perdr,id)) q:((id="")||(flag=1))  d
		.s obj=##class(DHCNMG.Arg.MgNurLeaveApp).%OpenId(id)
		.q:'$IsObject(obj)
		.s leaveObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(obj.LeaveType)
		.q:'$IsObject(leaveObj)
		.q:((obj.LeaveStatus'="NH")&&(obj.LeaveStatus'="HH"))
		.;q:((leaveObj.PostDesc'="婚假")&&(leaveObj.PostDesc'="产假")&&(obj.LeaveStatus'="NH"))
		.;q:(((leaveObj.PostDesc="婚假")||(leaveObj.PostDesc="产假"))&&(obj.LeaveStatus'="HH"))
		.q:((obj.LeaveStDate'="")&&(obj.LeaveStDate>date))
		.q:((obj.LeaveEndDate'="")&&(obj.LeaveEndDate<date))
		.s decs=leaveObj.PostDesc_"["_(date-obj.LeaveStDate+1)_"]"
		.s flag=1
		i flag=0 d
		.s id="" f  s id=$o(^DHCNMG.Arg.MgNurNurHeadAppI("Nurse",perdr,id)) q:((id="")||(flag=1))  d
		..s obj2=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(id)
		..q:'$IsObject(obj2)
		..q:obj2.LeaveStatus'="HH"
		..q:((obj2.LeaveStDate'="")&&(obj2.LeaveStDate>date))
		..q:((obj2.LeaveEndDate'="")&&(obj2.LeaveEndDate<date))
		..s leaveObj2=##class(DHCNMG.DB.MgArgWardPost).%OpenId(obj2.LeaveType)
		..q:'$IsObject(leaveObj2)
		..s decs=leaveObj2.PostDesc_"["_(date-obj2.LeaveStDate+1)_"]"
		..s flag=1
		s:decs'="" flag=flag_"^"_decs
		q flag
}

/// creator: lulin	
/// createdate: 日期
/// description: 设置某人某时间段请假日期临时数组
/// table: DHCNMG.Arg.MgNurLeaveApp,DHCNMG.Arg.MgNurNurHeadApp
/// input: 护士id^date
/// output:
/// other: w ##class(web.NurMgArgComm).SetPerLeaveTmp("60".tmpPerLeave)
ClassMethod SetPerLeaveTmp(perdr, tmpPerLeave) As %String
{
	s id="" f  s id=$o(^DHCNMG.Arg.MgNurLeaveAppI("Nurse",perdr,id)) q:id=""  d
	.s obj=##class(DHCNMG.Arg.MgNurLeaveApp).%OpenId(id)
	.q:'$IsObject(obj)
	.q:obj.LeaveStatus'="NH"
	.s stDate=obj.LeaveStDate,endDate=obj.LeaveEndDate
	.q:stDate=""
	.q:endDate=""
	.f tDate=stDate:1:endDate  d
	..s tmpPerLeave(tDate)=1
	s id="" f  s id=$o(^DHCNMG.Arg.MgNurNurHeadAppI("Nurse",perdr,id)) q:id=""  d
	.s obj2=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(id)
	.q:'$IsObject(obj2)
	.q:obj2.LeaveStatus'="HH"
	.s stDate=obj2.LeaveStDate,endDate=obj2.LeaveEndDate
	.q:stDate=""
	.q:endDate=""
	.f tDate=stDate:1:endDate  d
	..s tmpPerLeave(tDate)=1
	q ""
}

/// creator: lulin	
/// createdate: 2018-07-17
/// description: 复制上个周期排班
/// table: 
/// input: 
/// output:0:失败，id：排班id
/// other:
ClassMethod copyLastArg(parr As %String = "", lastid As %String = "") As %String
{
	q:lastid="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s stdate=tmp("ArgStDate")
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=tmp("ArgEndDate")
	s:enddate["-" enddate=$zdh(enddate,3)
	q:(stdate="")||(enddate="") 0
	s dateStep=enddate-stdate+1
	TS
	s argid=..SaveArrange(parr)
	if +argid=0{
		Tro 
		q 0	
	}
	q:+argid=0 0
	s argObj=##class(DHCNMG.Arg.MgArrange).%OpenId(argid)
	s flag=1
	k tmpgroup
	s tmpgroup=""
	s groupid="" f  s groupid=$O(^DHCNMG.Arg.MgArrangeGroupI("Arrange",lastid,groupid)) q:(groupid="")||(flag=0)  d
	.s oldGroup=##class(DHCNMG.Arg.MgArrangeGroup).%OpenId(groupid)
	.q:'$IsObject(oldGroup)
	.s newGroup=##class(DHCNMG.Arg.MgArrangeGroup).%New()
	.s p="" f  s p=$O(^oddCOM("DHCNMG.Arg.MgArrangeGroup","a",p)) q:p=""  d
	..q:p["%"
	..i p="ArrangeDR" d
	...s newGroup.ArrangeDR=argObj
	..e  s $ZOBJPROPERTY(newGroup,p)=$ZOBJPROPERTY(oldGroup,p)
	.s sc=newGroup.%Save()
	.s:$$$ISERR(sc) flag=0
	.s:flag'=0 tmpgroup(oldGroup.%Id())=newGroup
	if flag=0 {
		Tro
		q 0	
	}
	s tmpRow=""
	s rowid="" f  s rowid=$O(^DHCNMG.Arg.MgArrangeRowI("Arrange",lastid,rowid)) q:(rowid="")||(flag=0)  d
	.s oldRow=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(rowid)
	.q:'$IsObject(oldRow)
	.//过滤掉非本病区人员
	.q:'$IsObject(oldRow.ArgPerDR)
	.;s curward=##class(web.NurMgHRComm).GetCurrentWard(oldRow.ArgPerDR.%Id(),argObj.ArgStDate)
	.;q:curward'=argObj.ArgWardDR.%Id()
	.s isinWard=##class(web.NurMgHRComm).CheckNurWard(oldRow.ArgPerDR.%Id(),argObj.ArgWardDR.%Id(),stdate,enddate)
	.q:isinWard'=1 //这段时间内不在本病区的
	.s newRow=##class(DHCNMG.Arg.MgArrangeRow).%New()
	.s p="" f  s p=$O(^oddCOM("DHCNMG.Arg.MgArrangeRow","a",p)) q:p=""  d
	..q:p["%"
	..i p="ArrangeDR" d
	...s newRow.ArrangeDR=argObj
	..e  i p="ArgGroupDR" d
	...i (oldRow.ArgGroupDR'="")&&($d(tmpgroup(oldRow.ArgGroupDR.%Id())))  s newRow.ArgGroupDR=tmpgroup(oldRow.ArgGroupDR.%Id())
	..e  s $ZOBJPROPERTY(newRow,p)=$ZOBJPROPERTY(oldRow,p)
	.s sc=newRow.%Save()
	.s:$$$ISERR(sc) flag=0
	.s:flag'=0 tmpRow(oldRow.%Id())=newRow
	if flag=0 {
		Tro
		q 0	
	}
	s ward=argObj.ArgWardDR.%Id(),local=$h,flag=1
	s subid="" f  s subid=$O(^DHCNMG.Arg.MgArrangeSubI("Arg",lastid,subid)) q:(subid="")||(flag=0)  d
	.s oSubObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(subid)
	.q:'$IsObject(oSubObj)
	.q:'$IsObject(oSubObj.ArgPerDR)
	.q:'$IsObject(oSubObj.ArgPostDR)
	.q:'$IsObject(oSubObj.ArgRowDR)
	.q:oSubObj.ArgIsReplace=2
	.//g过滤掉非本病区人员
	.s perdr=oSubObj.ArgPerDR.%Id()
	.s date=oSubObj.ArgDate+dateStep
	.s postdr=oSubObj.ArgPostDR.%Id()
	.s curward=##class(web.NurMgHRComm).GetCurrentWard(perdr,date)
	.q:curward'=ward
	.s nSubObj=##class(DHCNMG.Arg.MgArrangeSub).%New()
	.s nSubObj.ArrangeDR=argObj
	.s:$d(tmpRow(oSubObj.ArgRowDR.%Id())) nSubObj.ArgRowDR=tmpRow(oSubObj.ArgRowDR.%Id())
	.s nSubObj.ArgWardDR=oSubObj.ArgWardDR
	.s nSubObj.ArgPerDR=oSubObj.ArgPerDR
	.s nSubObj.ArgPostDR=oSubObj.ArgPostDR
	.s nSubObj.ArgCategory=oSubObj.ArgCategory
	.s nSubObj.ArgDate=oSubObj.ArgDate+dateStep
	.s nSubObj.ArgStTime1=oSubObj.ArgStTime1
	.s nSubObj.ArgEndTime1=oSubObj.ArgEndTime1
	.s nSubObj.ArgStTime2=oSubObj.ArgStTime2
	.s nSubObj.ArgEndTime2=oSubObj.ArgEndTime2
	.s nSubObj.ArgStTime3=oSubObj.ArgStTime3
	.s nSubObj.ArgEndTime3=oSubObj.ArgEndTime3
	.s nSubObj.ArgRemark=oSubObj.ArgRemark
	.s nSubObj.ArgHolidayTime=oSubObj.ArgHolidayTime
	.s nSubObj.ArgSecStTime=oSubObj.ArgSecStTime
	.s nSubObj.ArgSecEndTime=oSubObj.ArgSecEndTime
	.i $g(tmp("ArgCrtUser"))'="" d
	..s nSubObj.ArgEditUser=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("ArgCrtUser"))
	.e  s nSubObj.ArgEditUser=""
	.s nSubObj.ArgEditDate=+local
	.s nSubObj.ArgEditTime=$P(local,",",2)
	.s sc=nSubObj.%Save()
	.s:$$$ISERR(sc) flag=0
	if flag=0 {
		Tro
		q 0	
	}else{
		TC
		q argid	
	}
	q 0
}

/// creator: llin	
/// createdate: 2018-08-02
/// description: 保存审核后班次修改记录
/// table: 
/// input: 
/// output:1：成功;其他：失败原因
/// other:
ClassMethod SaveArgLog(parr) As %String
{
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s argObj=##class(DHCNMG.Arg.MgArrange).%OpenId($g(tmp("ArrangeDR")))
	q:'$IsObject(argObj) "未找到排班记录，请刷新界面"
	s obj=##class(DHCNMG.Arg.MgArrangeLog).%New()
	s obj.ArrangeDR=argObj
	s obj.ArgLogPerDR=$g(tmp("ArgLogPerDR"))
	s argdate=$g(tmp("argDate"))
	s:$l(argdate,"-")'=3 argdate=""
	s:$l(argdate,"-")=3 argdate=$zdh(argdate,3)
	s obj.ArgLogArgDate=argdate
	s ArgLogBefor=$g(tmp("ArgLogBefor"))
	s beforObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(ArgLogBefor)
	s:$IsObject(beforObj) ArgLogBefor=beforObj.PostDesc
	s obj.ArgLogBefor=ArgLogBefor
	s ArgLogAfter=$g(tmp("ArgLogAfter"))
	s afterObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(ArgLogAfter)
	s:$IsObject(afterObj) ArgLogAfter=beforObj.PostDesc
	s obj.ArgLogAfter=$g(tmp("ArgLogAfter"))
	s obj.ArgLogRemark=$g(tmp("ArgLogRemark"))
	s obj.ArgLogCrt=$g(tmp("ArgLogCrt"))
	s obj.ArgLogCrtDate=+$h
	s obj.ArgLogCrtTime=$p($h,",",2)
	i $g(tmp("ArgLogReason"))="null" s tmp("ArgLogReason")=""
	s obj.ArgLogReason=$g(tmp("ArgLogReason"))
	s sc=obj.%Save()
	q:$$$ISOK(sc) 1
	q "保存失败"
}

/// creator: llin	
/// createdate: 2018-08-02
/// description: 获取修改记录表
/// table: DHCNMG.Arg.MgArrangeLog
/// input: 
/// output:
/// other: w ##class(%ResultSet).RunQuery("web.NurMgArgComm","FindArgLogList","12^2018-12-01^2018-12-31^",0,0)
Query FindArgLogList(parr As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindArgLogListExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s sargid=$p(parr,"^",1)
	s stdate=$P(parr,"^",2)
	s enddate=$P(parr,"^",3)
	s ward=$P(parr,"^",4)
	i sargid="" Set qHandle=$lb(0,repid,0) Quit $$$OK	
	s:stdate["-" stdate=$zdh(stdate,3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s ret=""
	k tmpWard
	s tmpWard=""
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s argid="" f  s argid=$O(^DHCNMG.Arg.MgArrangeD(argid)) q:argid=""  d
	.q:(sargid'="")&&(sargid'=argid)
	.s argObj=##class(DHCNMG.Arg.MgArrange).%OpenId(argid)
	.q:'$IsObject(argObj)
	.q:'$IsObject(argObj.ArgWardDR)
	.q:(ward'="")&&(argObj.ArgWardDR.%Id()'=ward)
	.q:(isAll=0)&&('$d(tmpWard(argObj.ArgWardDR.%Id())))
	.q:(sargid="")&&(stdate'="")&&(stdate>argObj.ArgStDate)
	.q:(sargid="")&&(enddate'="")&&(enddate<argObj.ArgStDate)
	.s id=""  f  s id=$O(^DHCNMG.Arg.MgArrangeLogI("Arrange",argid,id)) q:id=""  d
	..s obj=##class(DHCNMG.Arg.MgArrangeLog).%OpenId(id)
	..q:'$IsObject(obj)
	..q:(sargid'="")&&(stdate'="")&&(stdate>obj.ArgLogCrtDate)
	..q:(sargid'="")&&(enddate'="")&&(enddate<obj.ArgLogCrtDate)
	..s perdr=obj.ArgLogPerDR
	..s perObj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	..q:'$IsObject(perObj)
	..s perID=perObj.PerID
	..s ret="logWard|"_argObj.ArgWardDR.WardDesc_"^logArgStDate|"_##class(web.NurMgHISComm).DateLogicalToHtml(argObj.ArgStDate)
	..s ret=ret_"^perID|"_perID
	..s perName=perObj.PerName
	..s ret=ret_"^perName|"_perName
	..s logBefor=obj.ArgLogBefor
	..s ret=ret_"^logBefor|"_logBefor
	..s logAfter=obj.ArgLogAfter
	..s ret=ret_"^logAfter|"_logAfter
	..s logPost=logAfter
	..s:logAfter="" logPost=logBefor
	..s ret=ret_"^logPost|"_logPost
	..s argDate=obj.ArgLogArgDate
	..s:argDate'="" argDate=##class(web.NurMgHISComm).DateLogicalToHtml(argDate)
	..s ret=ret_"^argDate|"_argDate
	..s logMark=obj.ArgLogRemark
	..s:(((logBefor'="")||(logAfter'=""))&&(logMark'["删除")) logMark=logMark_logBefor_"->"_logAfter
	..s ret=ret_"^logMark|"_logMark
	..s logcrtid=obj.ArgLogCrt
	..s logCrtName=""
	..i logcrtid=0 d
	...s logCrtName="管理员"
	..e  d
	...s logCrtObj=##class(DHCNMG.HR.MgPersons).%OpenId(logcrtid)
	...s logCrtName=logCrtObj.PerName
	..s:logCrtName="" logCrtName=logcrtid
	..s ret=ret_"^logCrtName|"_logCrtName
	..s logCrtDate=obj.ArgLogCrtDate
	..s:logCrtDate'="" logCrtDate=##class(web.NurMgHISComm).DateLogicalToHtml(logCrtDate)
	..s ret=ret_"^logCrtDate|"_logCrtDate
	..s logCrtTime=obj.ArgLogCrtTime
	..s:logCrtTime'="" logCrtTime=$zt(logCrtTime,1)
	..s ret=ret_"^logCrtTime|"_logCrtTime
	..s ret=ret_"^rw|"_obj.%Id()
	..s reason=obj.ArgLogReason
	..i reason="null" s reason=""
	..s ret=ret_"^logReason|"_reason
	..d OutArgLogData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutArgLogData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindArgLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArgLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArgLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArgLogListExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

///  creator: lulin
///  createdate: 2018-08-23
///  description: 未按时提交排班记录列表【提交晚于开始日期，未提交但开始日期大于当前日期】
///  table: DHCNMG.Arg.MgArrange
///  input:
///  output:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgArgComm","FindNotCurrentArgList","^2017-10-01^2017-11-30","")
Query FindNotCurrentArgList(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindNotCurrentArgListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s stdate=$p(parr,"^",1)
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",2)
	s:enddate["-" enddate=$zdh(enddate,3)
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s listno="" f  s listno=$O(^DHCNMG.Arg.MgArrangeI("ListNo",listno),-1) q:listno=""  d
	.s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeI("ListNo",listno,id),-1) q:id=""  d
	..s obj=##class(DHCNMG.Arg.MgArrange).%OpenId(id)
	..q:'$IsObject(obj)
	..q:(isAll=0)&&(('$IsObject(obj.ArgWardDR))||('$d(tmpWard(obj.ArgWardDR.%Id()))))
	..q:obj.ArgStDate=""
	..q:((stdate'="")&&(obj.ArgEndDate'="")&&(stdate>obj.ArgEndDate))||((enddate'="")&&(obj.ArgStDate'="")&&(enddate<obj.ArgStDate))
	..s submitDate=obj.ArgSubmitDate
	..s isExist=1
	..i submitDate="" d
	...i obj.ArgStDate<($h-7) s isExist=0
	..e  d
	...i obj.ArgSubmitDate>=obj.ArgStDate  s isExist=0
	..q:isExist=1
	..s ret=..GetArrange(id)
	..d OutNotCurrentArg
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutNotCurrentArg
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNotCurrentArgListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNotCurrentArgListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindNotCurrentArgListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNotCurrentArgListExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

///  creator: lulin
///  createdate: 2018-11-06
///  description: 判断某人某天是否存在不在本病区的排班
///  table: DHCNMG.Arg.MgArrange
///  input:
///  output:
///  other:
ClassMethod GetPostForOther(perdr As %String, date As %String, ward As %String) As %String
{
	q:((perdr="")!(date="")!(ward="")) ""
	s retWard=""
	s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,date,id)) q:((id="")||(retWard'=""))  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	.q:'$IsObject(obj)
	.q:'$IsObject(obj.ArgRowDR)
	.;q:obj.ArgRowDR.ArgPerAddFlag'="Y"
	.i (($IsObject(obj.ArgWardDR))&&(obj.ArgWardDR.%Id()'=ward))  s retWard=obj.ArgWardDR.%Id()
	q retWard
}

/// 本周积假^全部积假
ClassMethod GetArgProductHour(stdate As %String, enddate As %String, perdr As %String, tmpHoliday, tmpWork) As %String
{
	q:((stdate="")!(enddate="")!(perdr="")!(stdate>=enddate)) ""
	//开始时间~结束时间有多少周
	s week=(enddate-stdate)\7+1
	s step=""
	//标准时长7小时候
	s argParamObj=##class(DHCNMG.Set.MgArgParamSet).%OpenId(1)
	q:'$IsObject(argParamObj) 0
	s:$IsObject(argParamObj) step=+argParamObj.ArgStandardTime
	s:step="" step=7
	//年开始时间，1、第一年产品上线开始排班，从第一次排班算起。
	//2、第一年之后从本年完整第一周周一开始。
	s yearStart=$zdh(+$zd(stdate,3)_"-01"_"-01",3)
	s firstDate=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,"")) //开始日期从第一次排班算起
	q:firstDate="" "0^0"
	i firstDate'="" 
	{
		;s firstYear=+$zd(firstDate,3)
		;i firstYear=+$zd(stdate,3) s yearStart=firstDate
		i firstDate>yearStart s yearStart=firstDate
	}
	i ((yearStart<stdate)&&($zd(yearStart,3)["01-01"))
	{
		s yearStartWeek=$zd(yearStart,10)
		i yearStartWeek'=1 d
		.i yearStartWeek=0  s yearStart=yearStart+1
		.e  s yearStart=yearStart+8-yearStartWeek
	}
	;结束日期
	s yearEnd=enddate
	s weekTime=0,yearTime=0,flag=0
	//法定假日天数,应休假
	s numWeekHoliday=0,numYearHoliday=0,plusWeekTime=0,plusYearTime=0
	s date=yearStart-1 f  s date=$O(tmpHoliday(date)) q:(date="")||(date>yearEnd)  d
	.s holidayFlag=tmpHoliday(date)
	.i (holidayFlag)&&(($zd(date,11)'="Sat")&&($zd(date,11)'="Sun")) d
	..s:(date>=stdate)&&(date<=enddate) numWeekHoliday=numWeekHoliday+1
	..s numYearHoliday=numYearHoliday+1
	//计算已工作时长
	d ..SetPerLeaveTmp(perdr,.tmpPerLeave)
	s filterLeval=$LB("事假","病假","产假","婚假","丧假","公休") //这些假会算入应休假，不同医院修改
	s date=yearStart-1 f  s date=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,date)) q:(date="")||(date>yearEnd)  d
	.q:$g(tmpPerLeave(date))=1 
	.//请假的没有算入应休假中
	.s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,date,id)) q:id=""  d
	..s time=0,plusTime=0
	..s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	..q:'$IsObject(obj)
	..q:((obj.ArgPostDR="")&&(obj.ArgType'="Y")&&(obj.ArgType'="N"))
	..;q:(obj.ArrangeDR.ArgStatus'="R") //R 提交 A 审核
	..i (obj.ArgType="Y")||(obj.ArgType="N") d
	...s plusTime=($zth(obj.ArgEndTime1,1)-$zth(obj.ArgStTime1,1))
	...s:obj.ArgType="N" plusTime=0-plusTime
	..e  d
	...s ArgDesc=obj.ArgPostDR.PostDR.PostDesc
	...i (($g(tmpHoliday(date))="")&&($LF(filterLeval,ArgDesc)'=0))  d
	....i (($zd(date,11)'="Sat")&&($zd(date,11)'="Sun"))||($g(tmpWork(date))'="") d
	.....s tDateHolidayNum=$case(obj.ArgHolidayTime,"A":0.5,"P":0.5,"H":1,:1)
	.....s:(date>=stdate)&&(date<=enddate) numWeekHoliday=numWeekHoliday+tDateHolidayNum
	.....s numYearHoliday=numYearHoliday+tDateHolidayNum
	...q:obj.ArgPostDR.PostDR.PostLevel'="一线班" //排除非一线班
	...q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假
	...s sttime=obj.ArgStTime1,endtime=obj.ArgEndTime1
	...i ((sttime'="")&&(endtime'="")) d
	....i (endtime["次日") d
	.....s endtime=$zth($E(endtime,3,$L(endtime)),1)+86400
	.....s:date=yearEnd endtime=86400
	....e  s endtime=$zth(endtime,1)
	....i (sttime["次日") d
	.....s sttime=$zth($E(sttime,3,$L(sttime)),1)+86400
	.....s:date=yearEnd sttime=86400
	....e  s sttime=$zth(sttime,1)
	....s time=time+(endtime-sttime)
	...;二阶段
	...s sttime=obj.ArgStTime2,endtime=obj.ArgEndTime2
	...i ((sttime'="")&&(endtime'="")) d
	....i (endtime["次日") d
	.....s endtime=$zth($E(endtime,3,$L(endtime)),1)+86400
	.....s:date=yearEnd endtime=86400
	....e  s endtime=$zth(endtime,1)
	....i (sttime["次日") d
	.....s sttime=$zth($E(sttime,3,$L(sttime)),1)+86400
	.....s:date=yearEnd sttime=86400
	....e  s sttime=$zth(sttime,1)
	....s time=time+(endtime-sttime)
	...;三阶段
	...s sttime=obj.ArgStTime3,endtime=obj.ArgEndTime3
	...i ((sttime'="")&&(endtime'="")) d
	....i (endtime["次日") d
	.....s endtime=$zth($E(endtime,3,$L(endtime)),1)+86400
	.....s:date=yearEnd endtime=86400
	....e  s endtime=$zth(endtime,1)
	....i (sttime["次日") d
	.....s sttime=$zth($E(sttime,3,$L(sttime)),1)+86400
	.....s:date=yearEnd sttime=86400
	....e  s sttime=$zth(sttime,1)
	....s time=time+(endtime-sttime)
	..s yearTime=yearTime+time+plusTime
	..i ((date>=stdate)&&(date<=enddate)) s weekTime=weekTime+time+plusTime
	//周末补班
	s numWeekFillWork=0,numYearFillWork=0
	s date=yearStart-1 f  s date=$O(tmpWork(date)) q:(date="")||(date>yearEnd)  d
	.s workFlag=tmpWork(date)
	.i workFlag d
	..s:(date>=stdate)&&(date<=enddate) numWeekFillWork=numWeekFillWork+1
	..s numYearFillWork=numYearFillWork+1
	//应工作小时数-（期初前一天夜班）-休假*step
	//时间段工作时长。周数*每天工作小时数*每周工作天数(5）+周末为补假的天数*每天工作小时数
	//本周应工作小时数
	
	s weekStandard=week*step*5+(numWeekFillWork*step)
	s weekBeforWorkHour=0
	s weekBeforWorkHour=..getBeforStWorkTime(stdate-1,perdr)/3600
	s weekStandard=weekStandard-weekBeforWorkHour-(numWeekHoliday*step)  
	//本年应工作小时数
	s yearStandard=((yearEnd-yearStart)\7+1)*step*5+(numYearFillWork*step)
	s yearBeforWorkHour=0
	s yearBeforWorkHour=..getBeforStWorkTime(yearStart-1,perdr)/3600
	s yearStandard=yearStandard-yearBeforWorkHour-(numYearHoliday*step)
	//i weekTime'=0 d 
	//.s yearStandard1=yearStandard-numWeekHoliday*7-(weekTime/3600-weekStandard)
	//已工作小时数-应工作小时数
	i weekTime'=0 d
	.s weekTime=$fn((weekTime/3600-weekStandard),"",1)
	i yearTime'=0 d
	.s yearTime=$fn((yearTime/3600-yearStandard),"",1)
	q weekTime_"^"_yearTime
}

ClassMethod getBeforStWorkTime(date, perdr) As %String
{
	s time=0
	s rw=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,date,""))
	i rw'="" d
	.s ProObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(rw)
	.q:'$IsObject(ProObj)
	.q:ProObj.ArgPostDR.PostDR.PostLevel'="一线班"
	.s endtime=0
	.s endtime1=ProObj.ArgEndTime1
	.s endtime2=ProObj.ArgEndTime2
	.s endtime3=ProObj.ArgEndTime3
	.i ((endtime1'="")&&(endtime1["次日")) d
	..s endtime=$zth($E(endtime1,3,$L(endtime1)),1)
	..s time=time+endtime
	.i ((endtime2'="")&&(endtime2["次日")) d
	..s endtime=$zth($E(endtime2,3,$L(endtime2)),1)
	..s time=time+endtime
	.i ((endtime3'="")&&(endtime3["次日")) d
	..s endtime=$zth($E(endtime3,3,$L(endtime3)),1)
	..s time=time+endtime
	q time
}

ClassMethod ComputerHoliday(stDate As %String, endDate As %String, perdr As %String) As %String
{
	s tmp=""
	s step=""
	s argParamObj=##class(DHCNMG.Set.MgArgParamSet).%OpenId(1)
	q:'$IsObject(argParamObj) 0
	s:$IsObject(argParamObj) step=+argParamObj.ArgStandardTime
	s:step="" step=7
	s time=0
	s rw=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,stDate-1,""))
	i rw'="" d
	.s ProObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(rw)
	.q:'$IsObject(ProObj)
	.q:ProObj.ArgPostDR.PostDR.PostLevel'="一线班"
	.s endtime=0
	.s endtime1=ProObj.ArgEndTime1
	.s endtime2=ProObj.ArgEndTime2
	.s endtime3=ProObj.ArgEndTime3
	.i ((endtime1'="")&&(endtime1["次日")) d
	..s endtime=$zth($E(endtime1,3,$L(endtime1)),1)
	..s time=time+endtime
	.i ((endtime2'="")&&(endtime2["次日")) d
	..s endtime=$zth($E(endtime2,3,$L(endtime2)),1)
	..s time=time+endtime
	.i ((endtime3'="")&&(endtime3["次日")) d
	..s endtime=$zth($E(endtime3,3,$L(endtime3)),1)
	..s time=time+endtime
	f date=stDate:1:endDate d
	.s flag=..IsHoliday(date)
	.i flag=1 s tmp(date)=1
	.s id=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,date,""))
	.q:id=""
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	.q:'$IsObject(obj)
	.s ArgDesc=obj.ArgPostDR.PostDR.PostDesc
	.i ((flag=0)&&((ArgDesc["病假")!(ArgDesc["事假")!(ArgDesc["产假")!(ArgDesc["婚假")!(ArgDesc["丧假")!(ArgDesc["公休"))) s tmp(date)=1
	s num=0
	s numWeek=0,numYear=0
	s tmpDate="" f  s tmpDate=$o(tmp(tmpDate)) q:tmpDate=""  d
	.i tmp(tmpDate)=1&&(($zd(tmpDate,11)'="Sat")&&($zd(tmpDate,11)'="Sun")) d
	..s numWeek=numWeek+1
	..;i (($zd(tmpDate,11)'="Sat")&&($zd(tmpDate,11)'="Sun")) s numYear=numYear+1
	..s numYear=numYear+1
	s num=num*step+(time/3600)
	s numWeek=numWeek*step+(time/3600)
	s numYear=numYear*step+(time/3600)
	q numWeek_"^"_numYear
}

ClassMethod IsWorkDay(stDate As %String, endDate As %String) As %String
{
	q:((stDate="")!(endDate="")) 0
	s num=0
	s year=$p($zd(stDate,3),"-",1)
	s code="" f  s code=$o(^DHCNMG.DB.MgHolidaySetI("code",year,code)) q:code=""  d
	.s rw="" f  s rw=$o(^DHCNMG.DB.MgHolidaySetI("code",year,code,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgHolidaySet).%OpenId(rw)
	..q:'$IsObject(obj)
	..q:obj.HolidayDate=""
	..s start=$zdh($p(obj.HolidayDate,",",1),3)
	..s end=$zdh($p(obj.HolidayDate,",",2),3)
	..q:(endDate<start)||(stDate>end)||(obj.HolidayID.SubDesc'="班")
	..s realStart=start
	..s:stDate>start realStart=stDate
	..s realEnd=end
	..s:endDate<end realEnd=endDate
	..s num=num+realEnd-realStart+1
	q num
}

ClassMethod IsHoliday(date As %String) As %String
{
	q:date="" 0
	s flag=0
	s year=$p($zd(date,3),"-",1)
	s code="" f  s code=$o(^DHCNMG.DB.MgHolidaySetI("code",year,code)) q:code=""  d
	.s rw="" f  s rw=$o(^DHCNMG.DB.MgHolidaySetI("code",year,code,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgHolidaySet).%OpenId(rw)
	..q:'$IsObject(obj)
	..q:obj.HolidayDate=""
	..s start=$zdh($p(obj.HolidayDate,",",1),3)
	..s end=$zdh($p(obj.HolidayDate,",",2),3)
	..i ((date>=start)&&(date<=end))&&(obj.HolidayID.SubDesc'="班") d
	...s flag=1
	q flag
}

// 设置假日的临时数组

ClassMethod setHolidayTmp(year, tmpHoliday, flag) As %String
{
	q:year="" ""
	s code="" f  s code=$o(^DHCNMG.DB.MgHolidaySetI("code",year,code)) q:code=""  d
	.s rw="" f  s rw=$o(^DHCNMG.DB.MgHolidaySetI("code",year,code,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.DB.MgHolidaySet).%OpenId(rw)
	..q:'$IsObject(obj)
	..q:obj.HolidayDate=""
	..s start=$zdh($p(obj.HolidayDate,",",1),3)
	..s end=$zdh($p(obj.HolidayDate,",",2),3)
	..q:(flag'=1)&&(obj.HolidayID.SubDesc="班")
	..q:(flag=1)&&(obj.HolidayID.SubDesc'="班")
	..s date="" 
	..f date=start:1:end  d
	...q:$d(tmpHoliday(date))
	...s tmpHoliday(date)=1
	q 1
}

///  creator: lulin
///  createdate: 2018-11-06
///  description: 获取积假
///  table: DHCNMG.Arg.MgArrange
///  input:
///  output:
///  other:
ClassMethod GetArgProductHour1(stdate As %String, enddate As %String, perdr As %String) As %String
{
	q:((stdate="")!(enddate="")!(perdr="")!(stdate>=enddate)) ""
	
	s week=(enddate-stdate)\7+1
	s step=""
	s argParamObj=##class(DHCNMG.Set.MgArgParamSet).%OpenId(1)
	q:'$IsObject(argParamObj) 0
	s:$IsObject(argParamObj) step=+argParamObj.ArgStandardTime
	s:step="" step=7
	s weekStandard=week*step*5
	s yearStart=$zdh(+$zd(stdate,3)_"-01"_"-01",3)
	s yearStartWeek=$zd(yearStart,10)
	i yearStartWeek'=1 d
	.i yearStartWeek=0  s yearStart=yearStart+1
	.e  s yearStart=yearStart+8-yearStartWeek
	//全年
#;	s yearEnd=$zdh(+$zd(stdate,3)_"-12"_"-31",3)
#;	s yearEndWeek=$zd(yearEnd,10)
#;	i yearEndWeek'=0 d
#;	.s yearEnd=yearEnd+7-yearEndWeek
	;结束日期
	s yearEnd=enddate
	s weekTime=0,yearTime=0,flag=0
	s realYearStart=yearStart ;真正年开始日期
	s date=yearStart f  s date=$o(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,date)) q:((date="")||(date>yearEnd))  d
	.s isAskLeave=..IsPerAskLeavel2(perdr_"^"_date)
	.q:isAskLeave=1
	.s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,date,id)) q:id=""  d
	..s time=0
	..s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	..q:'$IsObject(obj)
	..q:'$IsObject(obj.ArgPostDR)
	..q:obj.ArgPostDR.PostDR.PostLevel'="一线班" //排除非一线班
	..q:obj.ArgPostDR.PostDR.PostType="H" ;排除休假
	..s sttime1=obj.ArgStTime1,endtime1=obj.ArgEndTime1
	..s sttime2=obj.ArgStTime2,endtime2=obj.ArgEndTime2
	..s sttime3=obj.ArgStTime3,endtime3=obj.ArgEndTime3
	..i ((sttime1'="")&&(endtime1'="")) d
	...i (endtime1["次日") s endtime=$zth($E(endtime1,3,$L(endtime1)),1)+86400
	...e  s endtime=$zth(endtime1,1)
	...i (sttime1["次日") s sttime=$zth($E(sttime1,3,$L(sttime1)),1)+86400
	...e  s sttime=$zth(sttime1,1)
	...s time=time+(endtime-sttime)
	..i ((sttime2'="")&&(endtime2'="")) d
	...i (endtime2["次日") s endtime=$zth($E(endtime2,3,$L(endtime2)),1)+86400
	...e  s endtime=$zth(endtime2,1)
	...i (sttime2["次日") s sttime=$zth($E(sttime2,3,$L(sttime2)),1)+86400
	...e  s sttime=$zth(sttime2,1)
	...s time=time+(endtime-sttime)
	..i ((sttime3'="")&&(endtime3'="")) d
	...i (endtime3["次日") s endtime=$zth($E(endtime3,3,$L(endtime3)),1)+86400
	...e  s endtime=$zth(endtime3,1)
	...i (sttime3["次日") s sttime=$zth($E(sttime3,3,$L(sttime3)),1)+86400
	...e  s sttime=$zth(sttime3,1)
	...s time=time+(endtime-sttime)
	..i flag=0 s flag=1,realYearStart=date
	..s yearTime=yearTime+time
	..i ((date>=stdate)&&(date<=enddate)) s weekTime=weekTime+time
	s yearStandard=((yearEnd-realYearStart)\7+1)*step*5 ;
	i weekTime'=0 d
	.s weekTime=$fn((weekTime/3600-weekStandard),"",1)
	i yearTime'=0 d
	.s yearTime=$fn((yearTime/3600-yearStandard),"",1)
	q weekTime_"^"_yearTime
}

/// Creator:gzj
/// CreateDate:2019-01-10
/// Description:获取排班主表记录状态
/// Table:DHCNMG.Arg.MgArrange
/// Input：主表记录ID
/// Output:输出状态
/// Return:返回状态码 1：提交 2：审核 0：其他
/// Other:
ClassMethod GetArgRowState(id As %String) As %String
{
	q:id="" 0
	s flag=0
	s obj=##class(DHCNMG.Arg.MgArrange).%OpenId(id)
	q:'$IsObject(obj) 0
	i obj.ArgStatus="R" s flag=1
	e  i obj.ArgStatus="A" s flag=2
	q flag
}

/// Creator:gzj
/// Date:2019-05-15
/// Description:删除加班班次
/// Table:DHCNMG.Arg.MgArrangeSub
/// Input:id 记录ID
/// Output:
/// Return:
/// Other:
ClassMethod DeleteArgPlus(id As %String, nurseId As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	q:'$IsObject(obj) 0
	s flag=1
	Ts
	i ((obj.ArrangeDR.ArgStatus="R")!(obj.ArrangeDR.ArgStatus="A"))
	{
		s LogObj=##class(DHCNMG.Arg.MgArrangeLog).%New()
		s LogObj.ArgLogPerDR=obj.ArgPerDR.%Id()
		s LogObj.ArrangeDR=obj.ArrangeDR
		s LogObj.ArgLogArgDate=obj.ArgDate
		s LogObj.ArgLogBefor=$case(obj.ArgType,"Y":"加班"_obj.ArgStTime1_"-"_obj.ArgEndTime1,"N":"减班"_obj.ArgStTime1_"-"_obj.ArgEndTime1)
		s LogObj.ArgLogRemark="删除班次"
		s LogObj.ArgLogCrt=nurseId
		s LogObj.ArgLogCrtDate=+$h
		s LogObj.ArgLogCrtTime=$p($h,",",2)
		s sc=LogObj.%Save()
		s flag=($$$ISOK(sc)&&flag)
	}
	s argSc=obj.%DeleteId(id)
	s flag=($$$ISOK(argSc)&&flag)
	i flag=1
	{
		tc
	}
	else
	{
		tro
	}
	q flag
}

/// Creator:lulin
/// CreateDate:2019年9月18日
/// Description:保存意愿排班
/// Table:DHCNMG.Arg.MgWishArrange
/// Input：表字段
/// Output:保存是否成功
/// Return:返回状态码 1:成功，0：失败
/// Other:
ClassMethod SaveWishArrange(parr As %String) As %String
{
	s tmp=""
	s $ZT="ERROR"
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	q:tmp("PerDR")=0 "超级管理员无法申请"
	s error=""
	//检测是否排班周期是否已提交，则不能申请
	s wishDate=tmp("WishDate")
	s wardId=$g(tmp("WardDR"))
	q:(wishDate="")||(wardId="") "参数为空，无法保存"
	s wishDate=$zdh(wishDate,3)
	s stDate="" f  s stDate=$O(^DHCNMG.Arg.MgArrangeI("WardDate",wardId,stDate)) q:(stDate="")||(error'="")  d
	.q:(stDate>wishDate)
	.s endDate="" f  s endDate=$O(^DHCNMG.Arg.MgArrangeI("WardDate",wardId,stDate,endDate)) q:(endDate="")||(error'="")  d
	..q:endDate<wishDate
	..s argId="" f  s argId=$O(^DHCNMG.Arg.MgArrangeI("WardDate",wardId,stDate,endDate,argId)) q:(argId="")||(error'="")  d
	...s argObj=##class(DHCNMG.Arg.MgArrange).%OpenId(argId)
	...q:'$IsObject(argObj)
	...s:(argObj.ArgStatus'="N")&&(argObj.ArgStatus'="S") error="排班非草稿或保存状态，不可申请排班"
	q:error'="" error
	if $g(tmp("rw"))=""{
		s obj=##class(DHCNMG.Arg.MgWishArrange).%New()
	}else{
		s obj=##class(DHCNMG.Arg.MgWishArrange).%OpenId(tmp("rw"))
		s:'$IsObject(obj) error="无对应数据请刷新重试"
		s:($IsObject(obj))&&(obj.Status'="N") error="非未提交状态，不可修改"
	}
	q:error'="" error
	s obj.PerDR=##class(DHCNMG.HR.MgPersons).%OpenId(tmp("PerDR"))
	s obj.WardDR=##class(DHCNMG.DB.MgWard).%OpenId(tmp("WardDR"))
	s obj.WishDate=$zdh(tmp("WishDate"),3)
	s obj.PostDR=##class(DHCNMG.DB.MgArgWardPost).%OpenId(tmp("PostDR"))
	s obj.Remark=$g(tmp("Remark"))
	s obj.Status=$g(tmp("Status"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
ERROR
	s $ZT=""
    s ErrorMsg=$ZE
    Quit "Error"_$SYSTEM.Status.DisplayError(ErrorMsg)
}

///   lulin
///  createdate: 2019-9-19
///  description: 排班界面显示已提交的意愿排班【专属于排班界面显示】
///  table: DHCNMG.Arg.MgWishArrange
///  input:Id
///  output:
///  other:
ClassMethod getWishArrangeForArgSub(ward, date, perId) As %String
{
	q:(ward="")||(perId="")||(date="")
	s ret=""
	s id="" f  s id=$O(^DHCNMG.Arg.MgWishArrangeI("WardPerDate",ward,perId,date,id)) q:id=""  d
	.s obj=##class(DHCNMG.Arg.MgWishArrange).%OpenId(id)
	.q:'$IsObject(obj)
	.q:'$IsObject(obj.PostDR)
	.q:obj.Status'="S"
	.i ret="" s ret=obj.%Id()_"」"_obj.PostDR.PostDesc
	.e  s ret=ret_"「"_obj.%Id()_"」"_obj.PostDR.PostDesc
	q ret
}

///  creator: lulin
///  createdate: 2019-9-18
///  description: 根据ID获取意愿排班列表
///  table: DHCNMG.Arg.MgWishArrange
///  input:Id
///  output:
///  other:w ##Class(web.NurMgArgComm).getWishArrange(id)
ClassMethod getWishArrange(id As %String = "") As %String
{
	q:id="" "传参失败请刷新重试"
	s obj=##class(DHCNMG.Arg.MgWishArrange).%OpenId(id)
	s rw=obj.%Id()
	s WardDR="",WardDesc=""
	s:$IsObject(obj.WardDR) WardDR=obj.WardDR.%Id(),WardDesc=obj.WardDR.WardDesc
	s PerDR="",PerName=""
	s:$IsObject(obj.PerDR) PerDR=obj.PerDR.%Id(),PerName=obj.PerDR.PerName
	s WishDate=obj.WishDate
	s:WishDate'="" WishDate=##class(web.NurMgHISComm).DateLogicalToHtml(WishDate)
	s Remark=obj.Remark
	s Status=obj.Status
	s StatusDesc=$case(Status,"N":"未提交","S":"已提交","A":"已审核","B":"驳回",:"未提交")
	s Auditor="",AuditorName=""
	s:$IsObject(obj.Auditor) Auditor=obj.Auditor.%Id(),AuditorName=obj.Auditor.PerName
	s AuditDate=obj.AuditDate
	s:(Auditor="")&&(AuditDate'="") AuditorName="管理员"
	s:AuditDate'="" AuditDate=##class(web.NurMgHISComm).DateLogicalToHtml(AuditDate)
	///班次日期返回到审核界面显示
	s PostDR="",PostDesc="",ArgTime=""
	i $IsObject(obj.PostDR) d
	.s PostDR=obj.PostDR.%Id(),PostDesc=obj.PostDR.PostDesc
	.s st1=obj.PostDR.PostStTime1
	.s end1=obj.PostDR.PostEndTime1
	.s ArgTime=st1_"-"_end1
	.s st2=obj.PostDR.PostStTime2
	.s end2=obj.PostDR.PostEndTime2
	.i st2'="" d
	..i ArgTime="" s ArgTime=st2_""_end2
	..e  s ArgTime=ArgTime_";"_st2_""_end2
	.s st3=obj.PostDR.PostStTime3
	.s end3=obj.PostDR.PostEndTime3
	.i st3'="" d
	..i ArgTime="" s ArgTime=st3_"-"_end3
	..e  s ArgTime=ArgTime_";"_st3_"-"_end3
	s ret="WardDR|"_WardDR_"^WardDesc|"_WardDesc_"^PerDR|"_PerDR_"^PerName|"_PerName_"^WishDate|"_WishDate
	_"^PostDR|"_PostDR_"^PostDesc|"_PostDesc_"^Remark|"_Remark_"^Status|"_Status_"^StatusDesc|"_StatusDesc
	_"^Auditor|"_Auditor_"^AuditorName|"_AuditorName_"^AuditDate|"_AuditDate
	_"^rw|"_rw_"^ArgTime|"_ArgTime
	q ret
}

///  creator: lulin
///  createdate: 2019-9-18
///  description: 获取意愿排班列表
///  table: DHCNMG.Arg.MgWishArrange
///  input:
///  output:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgArgComm","FindWishArrangeList","")
Query FindWishArrangeList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWishArrangeListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s perId=$P(parr,"^",1)
	s stDate=$P(parr,"^",2)
	s endDate=$p(parr,"^",3)
	i stDate["-" s stDate=$zdh(stDate,3)
	e  s stDate=""
	i endDate["-" s endDate=$zdh(endDate,3)
	e  s endDate=""
	if $g(perId)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s date="" f  s date=$O(^DHCNMG.Arg.MgWishArrangeI("PerDate",perId,date)) q:date=""  d
	.q:(stDate'="")&&(date<stDate)
	.q:(endDate'="")&&(date>endDate)
	.s id="" f  s id=$O(^DHCNMG.Arg.MgWishArrangeI("PerDate",perId,date,id)) q:id=""  d
	..s ret=..getWishArrange(id)
	..q:ret=""
	..d OutWishArg
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWishArg
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWishArrangeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWishArrangeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWishArrangeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWishArrangeListExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:lulin
/// CreateDate:2019-9-20
/// Description:审核或者驳回意愿排班
/// Table:DHCNMG.Arg.MgWishArrange
/// Input：表字段
/// Output:保存是否成功
/// Return:返回状态码 1:成功；失败信息
/// Other:w ##class(web.NurMgArgComm).AuditWishArrange(^TMP("SaveWishArrange"))
ClassMethod AuditWishArrange(parr As %String) As %String
{
	s id=$p(parr,"^",1)
	s auditor=$p(parr,"^",2)
	s status=$P(parr,"^",3)
	s type=$P(parr,"^",4)
	s argId=$P(parr,"^",5)
	s rowId=$P(parr,"^",6)
	q:(id="")||(auditor="")||(status="")||(type="") "传参失败，请刷新重试"
	s ret=1
	s obj=##class(DHCNMG.Arg.MgWishArrange).%OpenId(id)
	q:'$IsObject(obj) "未获取到意愿排班数据，请刷新重试"
	q:'$IsObject(obj.PerDR) "未获取到意愿排班人员信息，请刷新重试"
	q:'$IsObject(obj.PostDR) "未获取到意愿排班班次数据，请联系工程师"
	q:'$IsObject(obj.WardDR) "未获取意愿排班病区数据，请联系工程师"
	s argObj=##class(DHCNMG.Arg.MgArrange).%OpenId(argId)
	q:'$IsObject(argObj) "未获取到排班数据，请刷新界面"
	q:(argObj.ArgStatus'="N")&&(argObj.ArgStatus'="S") "排班非草稿或保存状态，不可审核意愿排班"
	s rowObj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(rowId)
	q:'$IsObject(rowObj) "未获取到行数据，请刷新"
	//检测重岗
	i status="A" d
	.i type=1 d
	..s checkStr="ArgStTime1|"_obj.PostDR.PostStTime1_"^ArgEndTime1|"_obj.PostDR.PostEndTime1
	..s checkStr=checkStr_"^ArgStTime2|"_obj.PostDR.PostStTime2_"^ArgEndTime2|"_obj.PostDR.PostEndTime2
	..s checkStr=checkStr_"^ArgStTime3|"_obj.PostDR.PostStTime3_"^ArgEndTime3|"_obj.PostDR.PostEndTime3
	..s checkStr=checkStr_"^ArgPerDR|"_obj.PerDR.%Id()_"^ArgDate|"_$zd(obj.WishDate,3)
	..s repeatFlag=..CheckRepeat(checkStr)
	..s:repeatFlag=1 ret="当天班次时间有交叉"
	q:ret'=1 ret
	s obj.Status=status
	s auditorObj=""
	i auditor'=0 d
	.s auditorObj=##class(DHCNMG.HR.MgPersons).%OpenId(auditor)
	.s:'$IsObject(auditorObj) auditorObj=""
	s obj.Auditor=auditorObj
	s obj.AuditDate=+$h
	TS
	s sc=obj.%Save()
	s:$$$ISERR(sc) ret="修改意愿排班状态失败"	
	//驳回状态
	if status'="A"{
		TC
		q ret	
	}
	//type=0；删除当天排班
	i ((type'=1)&&('$IsObject(obj.WardDR))) d
	.//当天某人排班
	.s argId="" f  s argId=$O(^DHCNMG.Arg.MgArrangeSubI("WardPerDate",obj.WardDR.%Id(),obj.PerDR.%Id(),obj.WishDate,id)) q:(id="")||(ret'=1)  d
	..s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	..q:'$IsObject(obj)
	..s sc=##class(DHCNMG.Arg.MgArrangeSub).%DeleteId(id)
	..s:$$$ISERR(sc) ret="替换当天排班失败"
	if ret'=1{
		TRO
		q ret	
	}
	//添加本次排班
	s objArg=##class(DHCNMG.Arg.MgArrangeSub).%New()
	s objArg.ArrangeDR=argObj
	s objArg.ArgRowDR=rowObj
	s objArg.ArgWardDR=obj.WardDR
	s objArg.ArgPerDR=obj.PerDR
	s objArg.ArgPostDR=obj.PostDR
	s objArg.ArgCategory=obj.PostDR.PostCategory
	s objArg.ArgDate=obj.WishDate
	s objArg.ArgStTime1=obj.PostDR.PostStTime1
	s objArg.ArgEndTime1=obj.PostDR.PostEndTime1
	s objArg.ArgStTime2=obj.PostDR.PostStTime2
	s objArg.ArgEndTime2=obj.PostDR.PostEndTime2
	s objArg.ArgStTime3=obj.PostDR.PostStTime3
	s objArg.ArgEndTime3=obj.PostDR.PostEndTime3
	s objArg.ArgRemark=obj.Remark
	s objArg.ArgEditUser=obj.Auditor
	s objArg.ArgEditDate=+$h
	s objArg.ArgEditTime=$P($h,",",2)
	s objArg.ArgType="P"
	s objArg.ArgWishDR=obj.%Id()
	s sc=objArg.%Save()
	if $$$ISOK(sc){
		TC
		q 1	
	}else{
		TRO
		q "保存失败"	
	}
}

/// Creator:gzj
/// Date:2020-03-25
/// Description：获取意愿排班的记录状态
/// 
ClassMethod getWishArgStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCNMG.Arg.MgWishArrange).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.Status
	q status
}

/// Creator:gzj
/// Date:2020-03-25
/// Description:删除意愿排班记录
/// 
ClassMethod DeleteWishRec(id As %String) As %String
{
	q:id="" 0
	s obj=##class(DHCNMG.Arg.MgWishArrange).%OpenId(id)
	q:'$IsObject(obj) 0
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

}
