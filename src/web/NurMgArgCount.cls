/// creator:xbl
/// createdate:2017-10-23
/// description:排班统计类
Class web.NurMgArgCount Extends %RegisteredObject
{

ClassMethod GetCountPost(perdr, stdate, enddate, tmp) As %String
{
	f admdate=stdate:1:enddate d
	.s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,admdate,id)) q:id=""  d
	..s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	..q:'$IsObject(obj)
	..q:(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	..q:'$IsObject(obj.ArgPostDR)
	..q:'$IsObject(obj.ArgPostDR.PostDR)
	..q:(obj.ArgPostDR.PostDR.PostType'="H")
	..s num=1
	..s num=$case(obj.ArgHolidayTime,"H":1,"A":0.5,"P":0.5,:0)
	..s tmp(perdr,obj.ArgPostDR.PostDR.%Id())=+$g(tmp(perdr,obj.ArgPostDR.PostDR.%Id()))+num
	s id="" f  s id=$o(^DHCNMG.Arg.MgNurLeaveAppI("Nurse",perdr,id)) q:id=""  d
	.s leaveObj=##class(DHCNMG.Arg.MgNurLeaveApp).%OpenId(id)
	.q:'$IsObject(leaveObj)
	.q:leaveObj.LeaveStatus'="NH"
	.s leaveSt=leaveObj.LeaveStDate,leaveEnd=leaveObj.LeaveEndDate
	.q:(leaveSt="")||(leaveEnd="")
	.q:(leaveSt>enddate)||(leaveEnd<stdate)
	.q:leaveObj.LeaveType=""
	.s wardArgObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(leaveObj.LeaveType)
	.q:'$IsObject(wardArgObj)
	.q:'$IsObject(wardArgObj.PostDR)
	.i stdate>leaveSt s leaveSt=stdate
	.i leaveEnd>enddate s leaveEnd=enddate
	.s tmp(perdr,wardArgObj.PostDR.%Id())=+$g(tmp(perdr,wardArgObj.PostDR))+(leaveEnd-leaveSt+1)
	s id="" f  s id=$o(^DHCNMG.Arg.MgNurNurHeadAppI("Nurse",perdr,id)) q:id=""  d
	.s headLeaveObj=##class(DHCNMG.Arg.MgNurNurHeadApp).%OpenId(id)
	.q:'$IsObject(headLeaveObj)
	.q:headLeaveObj.LeaveStatus'="HH"
	.s leaveSt=headLeaveObj.LeaveStDate,leaveEnd=headLeaveObj.LeaveEndDate
	.q:(leaveSt="")||(leaveEnd="")
	.q:(leaveSt>enddate)||(leaveEnd<stdate)
	.q:headLeaveObj.LeaveType=""
	.s wardArgObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(headLeaveObj.LeaveType)
	.q:'$IsObject(wardArgObj)
	.q:'$IsObject(wardArgObj.PostDR)
	.i stdate>leaveSt s leaveSt=stdate
	.i leaveEnd>enddate s leaveEnd=enddate
	.s tmp(perdr,wardArgObj.PostDR.%Id())=+$g(tmp(perdr,wardArgObj.PostDR))+(leaveEnd-leaveSt+1)
}

/// creator:xbl
/// createdate:20180828
/// description: 护士月报考勤表
/// table:DHCNMG.Arg.MgArrangeSub
/// input: 开始日期^结束日期^病区, 工号或姓名或简拼
/// output:
/// return:
/// other: w ##class(%ResultSet).RunQuery("web.NurMgArgCount","CountPost","^^1^N","zhq")
Query CountPost(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod CountPostExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s date=$zd(+$h,3)
	s stdate=$P(parr,"^",1)
	i stdate'["-" s stdate=+date_"-01-01"
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",2)
	i enddate'["-" s enddate=+date_"-12-31"
	s:enddate["-" enddate=$zdh(enddate,3)
	s ward=$P(parr,"^",3)
	s type=$P(parr,"^",4)
	s posttype=$P(parr,"^",5)
	s input=$zcvt($tr(input," ",""),"U")
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s tmpPerson=""
	s perdr="" f  s perdr=$O(^DHCNMG.HR.MgPersonsI("type"," "_$zcvt(type,"U"),perdr)) q:perdr=""  d
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.q:'$IsObject(perobj)
	.q:perobj.PerTypeDR'="N" ;只取正式护士
	.s PerStatus=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(perobj.PerStatus)
	.q:(($IsObject(PerStatus))&&(PerStatus.SubDesc'["在职")&&(perobj.PerStateDate<stdate)) ;只统计在职
	.s pername=$zcvt(perobj.PerName,"U"),perid=$zcvt(perobj.PerID,"U")
	.s pershort=##class(web.NurMgVueComm).ToChineseSpell(pername)
	.q:(input'="")&&(pername'[input)&&(perid'[input)&&(pershort'[input)
	.s curward=##class(web.NurMgHRComm).GetCurrentWard(perdr,+$h)
	.q:(ward'="")&&(curward'=ward)
	.q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))
	.s ret="PerName|"_perobj.PerName_"^PerDR|"_perdr
	.k tmp
	.s tmp=""
	.d ..GetCountPost(perdr,stdate,enddate,.tmp)
	.s postdr="" f  s postdr=$O(^DHCNMG.DB.MgArgPostI("Type"," "_posttype,postdr)) q:postdr=""  d
	..s postobj=##class(DHCNMG.DB.MgArgPost).%OpenId(postdr)
	..s count=$g(tmp(perdr,postdr))
	..s:(count'="")&&($P(count,".")="") count="0"_count
	..s ret=ret_"^Post"_postdr_"|"_count
	.d OutPostCount
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPostCount
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CountPostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CountPostExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CountPostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CountPostExecute ]
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

ClassMethod GetPostHour(perdr, stdate, enddate, tmp) As %String
{
	f admdate=stdate:1:enddate d
	.s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,admdate,id)) q:id=""  d
	..s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	..q:'$IsObject(obj.ArgPostDR)
	..q:(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	..;q:(obj.ArgPostDR.PostDR.PostType="H")
	..q:'$IsObject(obj.ArgPostDR.PostDR)
	..s tmp(perdr,"Post",obj.ArgPostDR.PostDR.PostDesc)=+$g(tmp(perdr,"Post",obj.ArgPostDR.PostDR.PostDesc))+1
	.s minutes=##class(web.NurMgArgComm).CountMinutes(perdr,admdate,"",1)
	.s plusMinutes=##class(web.NurMgArgComm).CountMinutesPlus(perdr,admdate,"",1)
	.s nightMinutes=##class(web.NurMgArgComm).CountNightMinutes(perdr,admdate,"",1)
	.s tmp(perdr,"TotalHour")=+$g(tmp(perdr,"TotalHour"))+minutes
	.s tmp(perdr,"plusMinutes")=+$g(tmp(perdr,"plusMinutes"))+plusMinutes
	.s tmp(perdr,"NightHour")=+$g(tmp(perdr,"NightHour"))+nightMinutes
}

///  creator:xbl
///  createdate:20180828
///  description: 护士工时数统计
///  table:DHCNMG.Arg.MgArrangeSub
///  input: 开始日期^结束日期^病区, 工号或姓名或简拼
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgArgCount","CountPostHour","2017-01-01^2017-12-31^1^N","")
Query CountPostHour(parr As %String = "", role As %String = "", nurseid As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod CountPostHourExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String = "", nurseid As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s date=$zd(+$h,3)
	s stdate=$P(parr,"^",1)
	i stdate="" s stdate=+date_"-01-01"
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",2)
	i enddate="" s enddate=+date_"-12-31"
	s:enddate["-" enddate=$zdh(enddate,3)
	s ward=$P(parr,"^",3)
	s type=$P(parr,"^",4)
	s roleid=$P(parr,"^",6)
	s input=$ZCVT($tr(input," ",""),"U")
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s totalCount=0,dayCount=0,nightCount=0,plusCount=0
	s perdr="" f  s perdr=$O(^DHCNMG.HR.MgPersonsI("type"," "_$zcvt(type,"U"),perdr)) q:perdr=""  d
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.q:'$IsObject(perobj)
	.q:perobj.PerTypeDR'="N" ;只取正式护士
	.s PerStatus=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(perobj.PerStatus)
	.q:(($IsObject(PerStatus))&&(PerStatus.SubDesc'["在职")&&(perobj.PerStateDate<stdate)) ;只统计在职
	.s pername=$zcvt(perobj.PerName,"U"),perid=$zcvt(perobj.PerID,"U")
	.s pershort=##class(web.NurMgVueComm).ToChineseSpell(pername)
	.s isExsit=0
	.s curward=##class(web.NurMgHRComm).GetCurrentWard(perdr,+$h)
	.q:(ward'="")&&(curward'=ward)
	.q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))
	.q:(input'="")&&(pername'[input)&&(perid'[input)&&(pershort'[input)
	.k tmp
	.s tmp=""
	.d ..GetPostHour(perdr,stdate,enddate,.tmp)
	.s ret="PerName|"_perobj.PerName
	.i perobj.PerDepDR'="" d
	..s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(curward) //perobj.PerDepDR
	..q:'$IsObject(wardobj)
	..s ret=ret_"^WardDesc|"_wardobj.WardDesc
	.s leveldesc=##class(web.NurMgHRComm).GetLevelDesc(perdr,stdate,enddate)
	.s ret=ret_"^LevelDesc|"_leveldesc
	.s dutydesc=##class(web.NurMgHRComm).GetDutyDesc(perdr,stdate,enddate)
	.s ret=ret_"^DutyDesc|"_dutydesc
	.s titledesc=##class(web.NurMgHRComm).GetTitleDesc(perdr,stdate,enddate)
	.s ret=ret_"^TitleDesc|"_titledesc
	.i +$g(tmp(perdr,"TotalHour"))'=0 d
	..s totalCount=totalCount+($g(tmp(perdr,"TotalHour"))+$g(tmp(perdr,"plusMinutes"))) //计算工作量总小时数
	..s ret=ret_"^TotalHour|"_(($g(tmp(perdr,"TotalHour"))+$g(tmp(perdr,"plusMinutes")))\60)_"时"_(($g(tmp(perdr,"TotalHour"))+$g(tmp(perdr,"plusMinutes")))#60)_"分"
	..i +$g(tmp(perdr,"NightHour"))'=0 d
	...s nightCount=nightCount++$g(tmp(perdr,"NightHour")) //计算夜班总小时数
	...s ret=ret_"^NightHour|"_($g(tmp(perdr,"NightHour"))\60)_"时"_($g(tmp(perdr,"NightHour"))#60)_"分"
	..e  s ret=ret_"^NightHour|0"
	..s dayHour=$g(tmp(perdr,"TotalHour"))-$g(tmp(perdr,"NightHour"))
	..i +$g(dayHour)'=0 d
	...s dayCount=dayCount++$g(dayHour) //计算白班总时长
	...s ret=ret_"^DayHour|"_(dayHour\60)_"时"_(dayHour#60)_"分"
	..e  s ret=ret_"^DayHour|0"
	..i +$g(tmp(perdr,"plusMinutes"))'=0 d
	...s plusCount=plusCount++$g(tmp(perdr,"plusMinutes")) //计算加班总小时数
	...s ret=ret_"^PlusHour|"_($g(tmp(perdr,"plusMinutes"))\60)_"时"_($g(tmp(perdr,"plusMinutes"))#60)_"分"
	..e  s ret=ret_"^PlusHour|0"
	.e  s ret=ret_"^TotalHour|0^DayHour|0^NightHour|0^PlusHour|0"
	.s retPostDesc=""
	.s postdesc="" f  s postdesc=$O(tmp(perdr,"Post",postdesc)) q:postdesc=""  d
	..i retPostDesc="" s retPostDesc=postdesc_"」"_+$g(tmp(perdr,"Post",postdesc))
	..e  s retPostDesc=retPostDesc_"「"_postdesc_"」"_+$g(tmp(perdr,"Post",postdesc))
	.s ret=ret_"^PostDetail|"_retPostDesc
	.d OutPostHour
	s ret="PerName|汇总^WardDesc|^LevelDesc|^DutyDesc|^TitleDesc^TotalHour|"_($g(totalCount)\60)_"时"_($g(totalCount)#60)_"分"_"^DayHour|"_(dayCount\60)_"时"_(dayCount#60)_"分"_"^NightHour|"_(nightCount\60)_"时"_(nightCount#60)_"分"_"^PlusHour|"_(plusCount\60)_"时"_(plusCount#60)_"分"
	d OutPostHour
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPostHour
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CountPostHourClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CountPostHourExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CountPostHourFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CountPostHourExecute ]
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

///  creator:lulin
///  createdate:2018-08-11
///  description: 保存日报信息
///  table:DHCNMG.Arg.MgArgDayWork
///  input:
///  output:
///  return:
///  other:
ClassMethod SaveArgDayWork(parr) As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw")),date=$g(tmp("date")),ward=$g(tmp("ward")),sort=$g(tmp("sort"))
	q:(date="")||(ward="")||(sort="") 0
	s:date["-" date=$zdh(date,3)
	i rw="" d
	.s rw=$O(^DHCNMG.Arg.MgArgDayWorkI("Date",date,ward,sort,""))
	i rw'="" d
	.s obj=##class(DHCNMG.Arg.MgArgDayWork).%OpenId(rw)
	e  d
	.s obj=##class(DHCNMG.Arg.MgArgDayWork).%New()
	s itemId=$O(^DHCNMG.DB.MgClinicItemsI("sort",sort,""))
	s itemObj=##class(DHCNMG.DB.MgClinicItems).%OpenId(itemId)
	i $IsObject(itemObj) d
	.s obj.WorkCode=itemObj.ClinicCode
	.s obj.WorkDesc=itemObj.ClinicDesc
	s num=$g(tmp("num"))
	i num'="" d
	.s num=+num
	.s:$P(num,".")="" num="0"_num
	s obj.WorkNum=$g(tmp("num"))
	s obj.WorkSort=sort
	s obj.WorkWard=ward
	s obj.WorkDate=date
	s obj.WorkRemark=$g(tmp("remark"))
	s sc=obj.%Save()
	if $$$ISOK(sc) {
		q 1
	}else{
		q 0
	}
}

/// creator: lulin
/// createDate: 2018-08-12
/// description: 保存护患比
/// table: 
/// input:
/// output:
/// other:
ClassMethod saveNurPR(parr As %String = "") As %String
{
	q:parr="" 0
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw")),date=$g(tmp("date")),ward=$g(tmp("ward"))
	s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	q:(date="")||('$IsObject(wardObj)) 0
	s:date["-" date=$zdh(date,3)
	i rw="" d
	.s rw=$O(^DHCNMG.Sens.MgNurPRI("dateward",date,ward,""))
	i rw'="" d
	.s obj=##class(DHCNMG.Sens.MgNurPR).%OpenId(rw)
	e  d
	.s obj=##class(DHCNMG.Sens.MgNurPR).%New()
	s obj.NurPRDate=date
	s obj.NurPRWard=wardObj
	s num=$g(tmp("NurPRNurNum"))
	i num'="" d
	.s num=+num
	.s:$P(num,".")="" num="0"_num
	s obj.NurPRNurNum=num
	s num=$g(tmp("NurPRPatNum"))
	i num'="" d
	.s num=+num
	.s:$P(num,".")="" num="0"_num
	s obj.NurPRPatNum=num
	s NurPRNurPR="无效值"
	s:((obj.NurPRNurNum'="")&&(obj.NurPRPatNum'="")&&(obj.NurPRNurNum'=0)&&(obj.NurPRPatNum'=0)) NurPRNurPR="1:"_$fn(obj.NurPRPatNum/obj.NurPRNurNum,"",1)
	s obj.NurPRNurPR=NurPRNurPR
	s num=$g(tmp("NurPRNurNumN"))
	i num'="" d
	.s num=+num
	.s:$P(num,".")="" num="0"_num
	s obj.NurPRNurNumN=num
	s num=$g(tmp("NurPRPatNumN"))
	i num'="" d
	.s num=+num
	.s:$P(num,".")="" num="0"_num
	s obj.NurPRPatNumN=num
	s NurPRNurPRN="无效值"
	s:((obj.NurPRNurNumN'="")&&(obj.NurPRPatNumN'="")&&(obj.NurPRNurNumN'=0)&&(obj.NurPRPatNumN'=0)) NurPRNurPRN="1:"_$fn(obj.NurPRPatNumN/obj.NurPRNurNumN,"",1)
	s obj.NurPRNurPRN=NurPRNurPRN
	s sc=obj.%Save()
	if $$$ISOK(sc) {
		q 1
	}else{
		q 0
	}
}

///  creator:lulin
///  createdate:2018-08-11
///  description: 保存日报信息【系统任务，每天02:00执行】
///  table:DHCNMG.Arg.MgArgDayWork
///  input:
///  output:
///  return:
///  other:w ##class(web.NurMgArgCount).SaveAllArgDayWork()
ClassMethod SaveAllArgDayWork() As %String
{
	k tmpWardAdm,tmpNurse,tmpOrd
	s tmpWardAdm="",tmpNurse="",tmpOrd=""
	s date=+$h-1
	d ..SaveTMPPatAndDuty(date,.tmpWardAdm,.tmpNurse,.tmpOrd)
	s flag=1
	TS
	s hisWardID="" f  s hisWardID=$O(tmpWardAdm(hisWardID)) q:(hisWardID="")||(flag=0)  d
	.q:+hisWardID=0
	.q:$g(^PAWARD(hisWardID))=""
	.s CTLOC=$P(^PAWARD(hisWardID),"^",5)
	.q:+CTLOC=0 
	.s wardId=$O(^DHCNMG.DB.MgWardI("CTLoc",CTLOC,""))
	.q:wardId=""
	.s IsExistPostP=..IsExistPostP(wardId,date)
	.s dayPatNum="",nightPatNum=""
	.s type="" f  s type=$O(tmpWardAdm(hisWardID,type)) q:(type="")||(flag=0)  d
	..s obj=##class(DHCNMG.Arg.MgArgDayWork).%New()
	..s desc="接班患者人数",sort=30
	..s post=$e(type,1),tType=$e(type,2)
	..i $l(type)=2 d
	...i $e(type,2)="T" s desc="转入患者人数",sort=27
	...e  s desc="新入患者人数",sort=24
	..i post="A" s sort=sort+1
	..i post="P" s sort=sort+2
	..s code=desc_post
	..s desc=desc_"("_post_"班)"
	..s num=tmpWardAdm(hisWardID,type)
	..i IsExistPostP=0 d
	...i post="N" s num=+$g(tmpWardAdm(hisWardID,type))+$g(tmpWardAdm(hisWardID,"P"_tType))
	...i post="P" s num=0
	..;s parr="code|"_code_"^desc|"_desc_"^num|"_num_"^date|"_date_"^ward|"_wardId_"^sort|"_sort
	..s parr="num|"_num_"^date|"_date_"^ward|"_wardId_"^sort|"_sort
	..s flag=..SaveArgDayWork(parr)
	..q:flag=0
	..i (post="A")&&(tType'="T") d
	...s dayPatNum=+$g(dayPatNum)+num
	..i (post'="A")&&(type'="T") d
	...s nightPatNum=+$g(nightPatNum)+num
	.q:flag=0
	.;s desc="白班护理患者总数"
	.;s parr="code|"_desc_"^desc|"_desc_"^num|"_dayPatNum_"^date|"_date_"^ward|"_wardId_"^sort|33"
	.s parr="num|"_dayPatNum_"^date|"_date_"^ward|"_wardId_"^sort|33"
	.s flag=..SaveArgDayWork(parr)
	.q:flag=0
	.;s desc="夜班护理患者总数"
	.s:nightPatNum'="" nightPatNum=$fn(nightPatNum/2,"",1)
	.;s parr="code|"_desc_"^desc|"_desc_"^num|"_nightPatNum_"^date|"_date_"^ward|"_wardId_"^sort|34"
	.s parr="num|"_nightPatNum_"^date|"_date_"^ward|"_wardId_"^sort|34"
	.s flag=..SaveArgDayWork(parr)
	.q:flag=0
	.s dayMinutes="",nightMinutes=""
	.s perID="" f  s perID=$O(tmpNurse(hisWardID,perID)) q:perID=""  d
	..s tMinutes=##class(web.NurMgArgComm).CountMinutes(perID,date,wardId,1)
	..s tNightMinutes=##class(web.NurMgArgComm).CountNightMinutes(perID,date,wardId,1)
	..s nightMinutes=+$g(nightMinutes)+tNightMinutes
	..s dayMinutes=+$g(dayMinutes)+tMinutes-tNightMinutes
	.;s desc="白班责任护士数"
	.s:dayMinutes'="" dayMinutes=$fn(dayMinutes/60/8,"",1)
	.;s parr="code|"_desc_"^desc|"_desc_"^num|"_dayMinutes_"^date|"_date_"^ward|"_wardId_"^sort|35"
	.s parr="num|"_dayMinutes_"^date|"_date_"^ward|"_wardId_"^sort|35"
	.s flag=..SaveArgDayWork(parr)
	.q:flag=0
	.;s desc="夜班责任护士数"
	.s:nightMinutes'="" nightMinutes=$fn(nightMinutes/60/8,"",1)
	.;s parr="code|"_desc_"^desc|"_desc_"^num|"_nightMinutes_"^date|"_date_"^ward|"_wardId_"^sort|36"
	.s parr="num|"_nightMinutes_"^date|"_date_"^ward|"_wardId_"^sort|36"
	.s flag=..SaveArgDayWork(parr)
	.q:flag=0
	.;s NurPR="无效值"
	.;s:((+dayMinutes'=0)&&(+dayMinutes'=0)) NurPR="1:"_$fn(dayPatNum/dayMinutes,"",1)
	.;s NurPRN="无效值"
	.;s:((+nightPatNum'=0)&&(+nightMinutes'=0)) NurPRN="1:"_$fn(nightPatNum/nightMinutes,"",1)
	.s parr="ward|"_wardId_"^date|"_date_"^NurPRNurNum|"_dayMinutes_"^NurPRPatNum|"_dayPatNum
	.s parr=parr_"^NurPRNurNumN|"_nightMinutes_"^NurPRPatNumN|"_nightPatNum
	.s flag=..saveNurPR(parr)
	.q:flag=0
	if flag=0 {
		TRO
		q 0
	}
	//保存循环护管病区，临床护理质量控制与控制指标数据统计表项
	s wardId="" f  s wardId=$O(^DHCNMG.DB.MgWardD(wardId)) q:(wardId="")||(flag=0)  d
	.s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardId)
	.q:'$IsObject(wardObj)
	.;s desc="当天病区内执业护士实际上班小时数"
	.s num=..GetWardDateHours(date,wardId)
	.;s parr="code|"_desc_"^desc|"_desc_"^num|"_num_"^date|"_date_"^ward|"_wardId_"^sort|37"
	.s parr="num|"_num_"^date|"_date_"^ward|"_wardId_"^sort|37"
	.s flag=..SaveArgDayWork(parr)
	.q:flag=0
	.;s desc="当天手术患者的人数"
	.s num=##class(web.NurArgWorkLoadComm).GetOprationsCounts($zd(date,3),$zd(date,3),wardId)
	.;s parr="code|"_desc_"^desc|"_desc_"^num|"_num_"^date|"_date_"^ward|"_wardId_"^sort|23"
	.s parr="num|"_num_"^date|"_date_"^ward|"_wardId_"^sort|23"
	.s flag=..SaveArgDayWork(parr)
	.q:flag=0
	.;q
	.;不良事件相关项保存
	.q:'$IsObject(wardObj.CTLocDR)
	.s CTLOC=wardObj.CTLocDR.%Id()
	.q:+CTLOC=0 
	.s ADVINStr=##class(web.DHCADVINTERFACE).GetNurTypeData(CTLOC,$zd(date,3))
	.f i=1:1:$l(ADVINStr,"^") q:flag=0  d
	..s tADVIN=$P(ADVINStr,"^",i)
	..q:tADVIN=""
	..s sort=$p(tADVIN,"|")
	..s num=$p(tADVIN,"|",2)
	..q:(sort="")
	..s clinicItesDR=$O(^DHCNMG.DB.MgClinicItemsI("sort",sort,""))
	..s clinicItesObj=##class(DHCNMG.DB.MgClinicItems).%OpenId(clinicItesDR)
	..q:'$IsObject(clinicItesObj)
	..;s desc=clinicItesObj.ClinicDesc
	..;s parr="code|"_desc_"^desc|"_desc_"^num|"_num_"^date|"_date_"^ward|"_wardId_"^sort|"_sort
	..s parr="num|"_num_"^date|"_date_"^ward|"_wardId_"^sort|"_sort
	..s flag=..SaveArgDayWork(parr)
	if flag=0 {
		TRO
		q 0
	}
	//保存医嘱相关项
	s HISWard="" f  s HISWard=$O(tmpOrd(HISWard)) q:(HISWard="")||(flag=0)  d
	.s CTLOC=$P($g(^PAWARD(HISWard)),"^",5)
	.q:+CTLOC=0 
	.s wardId=$O(^DHCNMG.DB.MgWardI("CTLoc",CTLOC,""))
	.q:wardId=""
	.s saveDate=""  f  s saveDate=$O(tmpOrd(HISWard,saveDate)) q:(saveDate="")||(flag=0)  d
	..s sort=""  f  s sort=$O(tmpOrd(HISWard,saveDate,sort)) q:(sort="")||(flag=0)  d
	...s clinicItesDR=$O(^DHCNMG.DB.MgClinicItemsI("sort",sort,""))
	...s clinicItesObj=##class(DHCNMG.DB.MgClinicItems).%OpenId(clinicItesDR)
	...q:'$IsObject(clinicItesObj)
	...;s desc=clinicItesObj.ClinicDesc
	...s num=tmpOrd(HISWard,saveDate,sort)
	...;s parr="code|"_desc_"^desc|"_desc_"^num|"_num_"^date|"_saveDate_"^ward|"_wardId_"^sort|"_sort
	...s parr="num|"_num_"^date|"_saveDate_"^ward|"_wardId_"^sort|"_sort
	...s flag=..SaveArgDayWork(parr)
	if flag=1{
		TC
		q 1	
	}else{
		TRO
		q 0
	}
}

///  creator:lulin
///  createdate:2018-08-13
///  description: 获取病区某天执业护士实际上班小时数
///  table:DHCNMG.Arg.MgArrangeSub
///  input:
///  output:
///  return:
///  other:
ClassMethod GetWardDateHours(date As %String = "", ward As %String = "") As %String
{
	q:(date="")||(ward="") ""
	s:date["-" date=$zdh(date,3)
	s ret="",tmp=""
	s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("WardDate",ward,date,id)) q:id=""  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	.q:('$IsObject(obj))||('$IsObject(obj.ArgPerDR))
	.q:$d(tmp(obj.ArgPerDR.%Id()))
	.q:obj.ArgPerDR.PerTypeDR="S"
	.q:obj.ArgPerDR.PerStatus=""
	.;s status=##class(web.NurMgPersonComm).GetCommCode(obj.ArgPerDR.PerStatus)
	.;q:status'["在职"
	.s minitus=##class(web.NurMgArgComm).CountMinutes(obj.ArgPerDR.%Id(),date,ward,1)
	.s ret=$g(ret)+minitus
	.s tmp(obj.ArgPerDR.%Id())=obj.ArgPerDR.%Id()
	s ret=+$fn(ret/60/8,"",1)
	i ret=0 s ret=""
	e  s:$p(ret,".")="" ret="0"_ret
	q ret
}

///  creator:lulin
///  createdate:2018-08-11
///  description: 某病区某日是否存在p班
///  table:DHCNMG.Arg.MgArgDayWork
///  input:
///  output:
///  return:
///  other:w ##class(web.NurMgArgCount).IsExistPostP(109)
ClassMethod IsExistPostP(wardid, date) As %String
{
	q:(wardid="")||(date="") 0
	s:date["-" date=$zdh(date,3)
	s flag=0
	s id=""  f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("WardDate",wardid,date,id)) q:(id="")||(flag=1)  d
	.s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	.q:('$IsObject(obj))||('$IsObject(obj.ArgPostDR))
	.i obj.ArgPostDR.PostDesc["P" s flag=1
	q flag
}

///  creator:lulin
///  createdate:2018-08-12
///  description: 保存某天A/P/N班的接班、转科、入院患者及责任护士、医嘱临时数组
///  table:DHCNMG.Arg.MgArgDayWork
///  input:
///  output:
///  return:
///  other:
ClassMethod SaveTMPPatAndDuty(date, tmpWardAdm, tmpNurse, tmpOrd) As %String
{
	k tmpOrdARCIMCode
	s tmpOrdARCIMCode=""
	d ..SetOrderArcimTMP(.tmpOrdARCIMCode)
	s adm="" f  s adm=$O(^PAADM(adm)) q:adm=""  d
	.q:+adm=0
	.q:$g(^PAADM(adm))=""
 	.s iadmtype=$p($g(^PAADM(adm)),"^",2)  ;就诊类型
 	.s disdate=$p($g(^PAADM(adm)),"^",17)  ;出院日期
 	.s distime=$p($g(^PAADM(adm)),"^",18)  ;出院时间
 	.s visstu=$p($g(^PAADM(adm)),"^",20)   ;出院状态
 	.q:iadmtype'="I"
 	.q:visstu="C"
 	.q:(disdate'="")&&(disdate<date) ;已出院
	.s oldTranid="",index=1,ward="",stDate="",stTime="",endDate="",endTime=""
	.s tranid=""  f  s tranid=$O(^PAADM(adm,"TRANS",tranid)) q:tranid=""  d
	..q:+tranid=0
	..s bed=$P(^PAADM(adm,"TRANS",tranid),"^",8)
	..q:+bed=0 ;不是入床的轮转记录
	..s tstDate=$P(^PAADM(adm,"TRANS",tranid),"^",1)
	..q:tstDate>date ;开始时间>date
	..s tstTime=$P($g(^PAADM(adm,"TRANS",tranid)),"^",2)
	..s newWard=$P($g(^PAADM(adm,"TRANS",tranid)),"^",9)
	..i (ward'="")&&(tstDate<date) s index=index+1,ward=newWard,stDate=tstDate,stTime=tstTime
	..q:(ward'="")&&(tstDate<date) ;上个病区结束日期（本次的开始日期）<date 
	..i newWard'=ward d
	...i ward="" d
	....s stDate=$P($g(^PAADM(adm,"TRANS",tranid)),"^",1)
	....s stTime=$P($g(^PAADM(adm,"TRANS",tranid)),"^",2)
	....s ward=newWard
	...e  d
	....s endDate=$P($g(^PAADM(adm,"TRANS",tranid)),"^",1)
	....s endTime=$P($g(^PAADM(adm,"TRANS",tranid)),"^",2)
	....;保存病区护士临时数组
	....s duty=##class(web.NurMgHISComm).GetDutyNurseID(adm,ward,date,.tmpNurse)
	....i (stDate<date) d
	.....;s tmpWardAdm(ward,adm,"N")=adm ;n班接班患者
	.....s tmpWardAdm(ward,"N")=+$g(tmpWardAdm(ward,"N"))+1 ;n班接班患者
	....i ((stDate<date)||(stTime<28800))&&((endDate>date)||(endTime>=28800)) d
	.....;s tmpWardAdm(ward,adm,"A")=adm //a班接班患者
	.....s tmpWardAdm(ward,"A")=+$g(tmpWardAdm(ward,"A"))+1 ;a班接班患者
	....i ((stDate<date)||(stTime<57600))&&((endDate>date)||(endTime>=57600)) d
	.....;s tmpWardAdm(ward,adm,"P")=adm //p班接班患者
	.....s tmpWardAdm(ward,"P")=+$g(tmpWardAdm(ward,"P"))+1 ;p班接班患者
	....i stDate=date d
	....i index=1 d
	.....i stTime<28800  d
	......;s tmpWardAdm(ward,adm,"NN")=adm ;n班入院患者
	......s tmpWardAdm(ward,"NN")=+$g(tmpWardAdm(ward,"NN"))+1 ;n班入院患者
	.....e  i stTime<57600 d
	......;s tmpWardAdm(ward,adm,"AN")=adm ;A班入院患者
	......s tmpWardAdm(ward,"AN")=+$g(tmpWardAdm(ward,"AN"))+1 ;A班入院患者
	.....e  d
	......;s tmpWardAdm(ward,adm,"PN")=adm ;P班入院患者
	......s tmpWardAdm(ward,"PN")=+$g(tmpWardAdm(ward,"PN"))+1 ;P班入院患者
	....e  d
	.....i stTime<28800 d
	......;s tmpWardAdm(ward,adm,"NT")=adm ;n班转科转入患者
	......s tmpWardAdm(ward,"NT")=+$g(tmpWardAdm(ward,"NT"))+1 ;n班转科转入患者
	.....e  i stTime<57600 d
	......;s tmpWardAdm(ward,adm,"AT")=adm //A班转科转入患者
	......s tmpWardAdm(ward,"AT")=+$g(tmpWardAdm(ward,"AT"))+1 ;A班转科转入患者
	.....e  d
	......;s tmpWardAdm(ward,adm,"PT")=adm //P班转科转入患者
	......s tmpWardAdm(ward,"PT")=+$g(tmpWardAdm(ward,"PT"))+1 ;P班转科转入患者
	....s stDate=$P(^PAADM(adm,"TRANS",tranid),"^",1)
	....s stTime=$P(^PAADM(adm,"TRANS",tranid),"^",2)
	....s index=index+1
	....s endDate="",endTime=""
	....s ward=newWard
	.q:ward=""
	.i endDate="" d
	..s endDate=disdate,endTime=distime
	.i (stDate<date) d
	..;s tmpWardAdm(ward,adm,"N")=adm //n班接班患者
	..s tmpWardAdm(ward,"N")=+$g(tmpWardAdm(ward,"N"))+1 //n班接班患者
	.i ((stDate<date)||(stTime<28800))&&((endDate="")||(endDate>date)||(endTime>=28800)) d
	..;s tmpWardAdm(ward,adm,"A")=adm //a班接班患者
	..s tmpWardAdm(ward,"A")=+$g(tmpWardAdm(ward,"A"))+1 //a班接班患者
	.i ((stDate<date)||(stTime<57600))&&((endDate="")||(endDate>date)||(endTime>=57600)) d
	..;s tmpWardAdm(ward,adm,"P")=adm //p班接班患者
	..s tmpWardAdm(ward,"P")=+$g(tmpWardAdm(ward,"P"))+1 //p班接班患者
	.i stDate=date d
	..i index=1 d
	...i stTime<28800 d
	....;s tmpWardAdm(ward,adm,"NN")=adm //n班入院患者
	....s tmpWardAdm(ward,"NN")=+$g(tmpWardAdm(ward,"NN"))+1 //n班入院患者
	...e  i stTime<57600 d
	....;s tmpWardAdm(ward,adm,"AN")=adm //A班入院患者
	....s tmpWardAdm(ward,"AN")=+$g(tmpWardAdm(ward,"AN"))+1 //A班入院患者
	...e  d
	....;s tmpWardAdm(ward,adm,"PN")=adm //P班入院患者
	....s tmpWardAdm(ward,"PN")=+$g(tmpWardAdm(ward,"PN"))+1 //P班入院患者
	..e  d
	...i stTime<28800 d
	....;s tmpWardAdm(ward,adm,"NT")=adm //n班转科转入患者
	....s tmpWardAdm(ward,"NT")=+$g(tmpWardAdm(ward,"NT"))+1 //n班转科转入患者
	...e  i stTime<57600 d
	....;s tmpWardAdm(ward,adm,"AT")=adm //A班转科转入患者
	....s tmpWardAdm(ward,"AT")=+$g(tmpWardAdm(ward,"AT"))+1 //A班转科转入患者
	...e  d
	....;s tmpWardAdm(ward,adm,"PT")=adm //P班转科转入患者
	....s tmpWardAdm(ward,"PT")=+$g(tmpWardAdm(ward,"PT"))+1 //P班转科转入患者
	.;保存病区护士临时数组
	.s duty=##class(web.NurMgHISComm).GetDutyNurseID(adm,ward,date,.tmpNurse) ;护士ID
	.;根据医嘱约束带数据
	.s isStrap=..IfOrddailyExist(adm,"ZT0023",date,"284^287^355^362^93^285^625") ;约束带
 	.i isStrap=1 d
 	..s tmpOrd(ward,date,38)=$g(tmpOrd(ward,date,38))+1
 	.;患者静脉使用高危药物人次
 	.s is2=..GetCareType1(adm,date,"高危注射")
 	.i is2=1 d
 	..s tmpOrd(ward,date,2)=$g(tmpOrd(ward,date,2))+1
 	.;当天0点医嘱数据
 	.d ..SetPatOrderDayBreakTMP(adm, date+1, ward,.tmpOrd, .tmpOrdARCIMCode)
#; 	.q
#; 	.s ordDate=date+1
#; 	.;当天0点体内留置尿管患者人数,11
#;	.s ARCIMCode="H20058^JC076^ZT0014^zy1216000012^ESU121^E1216000012^EHC50093^Ezy1216000012^1216000012^HC50093^SU121^ESU122"
#;	.s isBefor=..IfOrddailyExist(adm,ARCIMCode,date,"")
#;	.s isNow=..IfOrddailyExist(adm,ARCIMCode,ordDate,"")
#;	.i (isBefor=1)&&(isNow=1) d
#; 	..s tmpOrd(ward,ordDate,11)=$g(tmpOrd(ward,ordDate,11))+1
#; 	
#; 	.;当天0点体内留置胃肠管患者人数（所有经口鼻插入的胃管+肠管）(十二肠管暂无医嘱),12
#;	.s ARCIMCode="ESU122^SU122^310903001^E111111^111111"
#;	.s isBefor=..IfOrddailyExist(adm,ARCIMCode,date,"")
#;	.s isNow=..IfOrddailyExist(adm,ARCIMCode,ordDate,"")
#;	.i (isBefor=1)&&(isNow=1) d
#; 	..s tmpOrd(ward,ordDate,12)=$g(tmpOrd(ward,ordDate,12))+1
#;	.;当天0点体内留置CVC置管患者人数,13
#;	.s ARCIMCode="510001297^zy1204000111^E1204000111^Ezy1204000111"
#;	.s isBefor=..IfOrddailyExist(adm,ARCIMCode,date,"")
#;	.s isNow=..IfOrddailyExist(adm,ARCIMCode,ordDate,"")
#;	.i (isBefor=1)&&(isNow=1) d
#; 	..s tmpOrd(ward,ordDate,13)=$g(tmpOrd(ward,ordDate,13))+1
#; 	.;当天0点体内留置PICC患者人数,14
#;	.s ARCIMCode="1204000111"
#;	.s isBefor=..IfOrddailyExist(adm,ARCIMCode,date,"")
#;	.s isNow=..IfOrddailyExist(adm,ARCIMCode,ordDate,"")
#;	.i (isBefor=1)&&(isNow=1) d
#; 	..s tmpOrd(ward,ordDate,14)=$g(tmpOrd(ward,ordDate,14))+1
#;	.;当天0点体内留置气管插管患者人数,15
#;	.s ARCIMCode="H20150^3301000143^H20075^E330100013^3301000141^3301000145^330100014^3301000144^3301000122^3301000142^3301000146^311202004^330100013^3301000131^E1201000101"
#;	.s isBefor=..IfOrddailyExist(adm,ARCIMCode,date,"")
#;	.s isNow=..IfOrddailyExist(adm,ARCIMCode,ordDate,"")
#;	.i (isBefor=1)&&(isNow=1) d
#; 	..s tmpOrd(ward,ordDate,15)=$g(tmpOrd(ward,ordDate,15))+1
#; 	.;当天0点体内留置气管切开患者人数,16
#;	.s ARCIMCode="1201000101^H20077^3106050071^E3106050071^E120100010^E330701005^330701005"
#;	.s isBefor=..IfOrddailyExist(adm,ARCIMCode,date,"")
#;	.s isNow=..IfOrddailyExist(adm,ARCIMCode,ordDate,"")
#;	.i (isBefor=1)&&(isNow=1) d
#; 	..s tmpOrd(ward,ordDate,16)=$g(tmpOrd(ward,ordDate,16))+1
#;	.;当天0点体内留置其他管道患者人数,17
#;	.s ARCIMCode="120100010^3301000112^3107020221^330701003^220302022^3307030171^320200004"
#;	.s ARCIMCode=ARCIMCode_"^33010020S1^zy1208000011^3106040051^E111141^E3307030171^E1208000011"
#;	.s ARCIMCode=ARCIMCode_"^E120400012^E111139^E3307030172^E111132^E111133^E111137^E330502001"
#;	.s ARCIMCode=ARCIMCode_"^Ezy1208000011^3307030172^3301000113^240400004^320200001^3301000145"
#;	.s ARCIMCode=ARCIMCode_"^331005009^330803023^111131^111132^111133^111137^111139^111141^120400012"
#;	.s ARCIMCode=ARCIMCode_"^1208000011^1208000013^3201000101^311000001^330100011^330502001"
#;	.s isBefor=..IfOrddailyExist(adm,ARCIMCode,date,"")
#;	.s isNow=..IfOrddailyExist(adm,ARCIMCode,ordDate,"")
#;	.i (isBefor=1)&&(isNow=1) d
#; 	..s tmpOrd(ward,ordDate,17)=$g(tmpOrd(ward,ordDate,17))+1
#; 	.;当日0点使用有创机械通气患者人数,18
#; 	.s ARCIMCode="E120700001B^120700001B"
#;	.s isBefor=..IfOrddailyExist(adm,ARCIMCode,date,"")
#;	.s isNow=..IfOrddailyExist(adm,ARCIMCode,ordDate,"")
#;	.i (isBefor=1)&&(isNow=1) d
#; 	..s tmpOrd(ward,ordDate,18)=$g(tmpOrd(ward,ordDate,18))+1
}

///  creator:lulin
///  createdate:2018-08-15
///  description:设置医嘱code对应临床护理质量控制报表的临时数组
///  table:
///  input:医嘱code数组
///  output:
///  return:
///  other:
ClassMethod SetOrderArcimTMP(tmpOrdARCIMCode) As %String
{
 	s tmpSelectARCIMCode(11)="H20058^JC076^ZT0014^zy1216000012^ESU121^E1216000012^EHC50093^Ezy1216000012^1216000012^HC50093^SU121^ESU122"
 	s tmpSelectARCIMCode(12)="ESU122^SU122^310903001^E111111^111111"
 	s tmpSelectARCIMCode(13)="510001297^zy1204000111^E1204000111^Ezy1204000111"
 	s tmpSelectARCIMCode(14)="1204000111"
 	s tmpSelectARCIMCode(15)="H20150^3301000143^H20075^E330100013^3301000141^3301000145^330100014^3301000144^3301000122^3301000142^3301000146^311202004^330100013^3301000131^E1201000101"
 	s tmpSelectARCIMCode(16)="1201000101^H20077^3106050071^E3106050071^E120100010^E330701005^330701005"
 	s ARCIMCode="120100010^3301000112^3107020221^330701003^220302022^3307030171^320200004"
	s ARCIMCode=ARCIMCode_"^33010020S1^zy1208000011^3106040051^E111141^E3307030171^E1208000011"
	s ARCIMCode=ARCIMCode_"^E120400012^E111139^E3307030172^E111132^E111133^E111137^E330502001"
	s ARCIMCode=ARCIMCode_"^Ezy1208000011^3307030172^3301000113^240400004^320200001^3301000145"
	s ARCIMCode=ARCIMCode_"^331005009^330803023^111131^111132^111133^111137^111139^111141^120400012"
	s ARCIMCode=ARCIMCode_"^1208000011^1208000013^3201000101^311000001^330100011^330502001"
 	s tmpSelectARCIMCode(17)=ARCIMCode
 	s tmpSelectARCIMCode(18)="E120700001B^120700001B"
 	s clinicItemsSort="" f  s clinicItemsSort=$O(tmpSelectARCIMCode(clinicItemsSort)) q:clinicItemsSort=""  d
 	.s num=$l(tmpSelectARCIMCode(clinicItemsSort),"^")
 	.for i=1:1:num d
 	..s code=$p(tmpSelectARCIMCode(clinicItemsSort),"^",i)
 	..q:code=""
 	..s rowidm=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
 	..q:rowidm=""
 	..s rowid=rowidm_"||"_"1"
 	..s tmpOrdARCIMCode(rowid,clinicItemsSort)=rowid
}

///  creator:lulin
///  createdate:2018-08-15
///  description:这只某病区当天0点仍有的医嘱临时数组
///  table:
///  input:登记号，日期，病区，tmp临时数组，医嘱code数组
///  output:
///  return:
///  other:
ClassMethod SetPatOrderDayBreakTMP(adm, date, ward, tmpOrd, tmpOrdARCIMCode) As %String
{
	s adm=$g(adm) 
	set ord=$o(^OEORD(0,"Adm",adm,""))
 	q:ord="" 0
 	s ret=0
 	s flag=0
 	k tmpBeforIsExist
 	s stDate=date-1,tmpBeforIsExist=""
 	s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",ord,stDate,ordSttTime)) q:(ordSttTime="")  d
 	.s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"Date",ord,stDate,ordSttTime,OrdSub)) q:(OrdSub="")  d
 	..s OreSub=0 f  s OreSub=$o(^OEORDi(0,"Date",ord,stDate,ordSttTime,OrdSub,OreSub)) q:(OreSub="")  d
 	...s ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
 	...s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 	...q:(ordStat'="V")&(ordStat'="E")
 	...s StrArcRowIds=$p($g(^OEORD(ord,"I",OrdSub,1)),"^",2)
 	...q:StrArcRowIds=""
 	...i $d(tmpOrdARCIMCode(StrArcRowIds)) d
 	....s codeSort=""  f  s codeSort=$O(tmpOrdARCIMCode(StrArcRowIds,codeSort)) q:codeSort=""  d
 	.....q:codeSort=""
 	.....s tmpBeforIsExist(codeSort)=1
 	s stDate=date
 	s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",ord,stDate,ordSttTime)) q:(ordSttTime="")  d
 	.s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"Date",ord,stDate,ordSttTime,OrdSub)) q:(OrdSub="")  d
 	..s OreSub=0 f  s OreSub=$o(^OEORDi(0,"Date",ord,stDate,ordSttTime,OrdSub,OreSub)) q:(OreSub="")  d
 	...s ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
 	...s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 	...q:(ordStat'="V")&(ordStat'="E")
 	...s StrArcRowIds=$p($g(^OEORD(ord,"I",OrdSub,1)),"^",2)
 	...q:StrArcRowIds=""
 	...i $d(tmpOrdARCIMCode(StrArcRowIds)) d
 	....s codeSort=""  f  s codeSort=$O(tmpOrdARCIMCode(StrArcRowIds,codeSort)) q:codeSort=""  d
 	.....q:codeSort=""
 	.....i $d(tmpBeforIsExist(codeSort)) d
 	......s tmpOrd(ward,date,codeSort)=$g(tmpOrd(ward,date,codeSort))+1
}

///  creator:lulin
///  createdate:2018-08-14
///  description: 判断某天某患者是否存在某些医嘱【过滤开医嘱科室】
///  table:
///  input:患者登记号，医嘱编号【ARC_ItmMast.ARCIM_Code】,日期,过滤开医嘱科室
///  output:
///  return:
///  other:
ClassMethod IfOrddailyExist(EpisodeID, ArcimCodes, stDate, noCTLocDRs) As %String
{
 
 s num=$l(ArcimCodes,"^")
 s ret=0
 for i=1:1:num d
 .q:ret=1
 .s code=$p(ArcimCodes,"^",i)
 .q:code=""
 .s rowidm=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
 .q:rowidm=""
 .s rowid=rowidm_"||"_"1"
 .s ret=..GetCareType(EpisodeID, rowid,stDate,noCTLocDRs)
 q ret
}

///  creator:lulin
///  createdate:2018-08-14
///  description: 判断某天某患者是否存在某些子医嘱的医嘱
///  table:
///  input:患者登记号,日期,子医嘱描述
///  output:
///  return:
///  other:w ##class(web.NurMgArgCount).GetCareType1(2852222,+$h,"高危")
ClassMethod GetCareType1(AdmNo, date, ARCICCode) As %String
{
 	s AdmNo=$g(AdmNo)
 	s:date["-" date=$zdh(date,3) 
	set retno=0
	q:AdmNo="" 0
	set ord=$o(^OEORD(0,"Adm",AdmNo,""))
	q:ord="" 0
	s flag=0
	s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",ord,date,ordSttTime)) q:(ordSttTime="")!(retno=1)  d
	.s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"Date",ord,date,ordSttTime,OrdSub)) q:(OrdSub="")!(retno=1)  d
	..s OreSub=0 f  s OreSub=$o(^OEORDi(0,"Date",ord,date,ordSttTime,OrdSub,OreSub)) q:(OreSub="")!(retno=1)  d
	...s ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
 	...s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 	...q:(ordStat'="V")&(ordStat'="E")
 	...s itmmastdr=$P($g(^OEORD(ord,"I",OrdSub,1)),"^",2) ;医嘱描述
 	...q:itmmastdr=""
 	...s ARCICId=$p($g(^ARCIM(+itmmastdr,$P(itmmastdr,"||",2),1)),"^",10)
 	...q:ARCICId=""
 	...s tARCICCode=$P($g(^ARC("IC",ARCICId)),"^",1)
 	...i tARCICCode[ARCICCode d
 	....s retno=1
 	q retno
}

// w ##class(web.NurMgArgCount).Test()

ClassMethod Test() As %String
{
	s sttime=$p($h,",",2)
 	s date=$h-1,tmpWardAdm="",tmpNurse="",tmpOrd=""
	d ..SaveTMPPatAndDuty(date,.tmpWardAdm,.tmpNurse,.tmpOrd)
 	s endtime=$p($h,",",2)
	w endtime-sttime,!
 	q 1
}

///  creator:lulin
///  createdate:2018-08-14
///  description: 判断某天某患者是否存在某些医嘱【过滤开医嘱科室】
///  table:
///  input:患者登记号，医嘱编号【ARC_ItmMast.ROWID】,日期,过滤开医嘱科室
///  output:
///  return:
///  other:
ClassMethod GetCareType(AdmNo, StrArcRowIds, stDate, noCTLocDRs) As %String
{
 s AdmNo=$g(AdmNo)
 s StrArcRowIds=$g(StrArcRowIds) 
 set retno=0
 q:AdmNo="" 0
 q:StrArcRowIds="" 0
 set ord=$o(^OEORD(0,"Adm",AdmNo,""))
 q:ord="" 0
 k tmpCareTypeCTLocDR
 s tmpCareTypeCTLocDR=""
 f i=1:1:$l(noCTLocDRs,"^") d
 .q:$P(noCTLocDRs,"^",i)=""
 .s tmpCareTypeCTLocDR($P(noCTLocDRs,"^",i))=$P(noCTLocDRs,"^",i)
 s num=$l(StrArcRowIds,"^")
 s flag=0
 s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",ord,stDate,ordSttTime)) q:(ordSttTime="")!(retno=1)  d
 .s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"Date",ord,stDate,ordSttTime,OrdSub)) q:(OrdSub="")!(retno=1)  d
 ..s ordLoc=$p($g(^OEORD(ord,"I",OrdSub,1)),"^",3)
 ..q:ordLoc=""
 ..q:($g(noCTLocDRs)'="")&&($d(tmpCareTypeCTLocDR(ordLoc)))
 ..s OreSub=0 f  s OreSub=$o(^OEORDi(0,"Date",ord,stDate,ordSttTime,OrdSub,OreSub)) q:(OreSub="")!(retno=1)  d
 ...s ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
 ...s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 ...q:(ordStat'="V")&(ordStat'="E")
 ...q:StrArcRowIds'=$p($g(^OEORD(ord,"I",OrdSub,1)),"^",2)
 ...s retno=1
 q retno
}

///  creator:lulin
///  createdate:2018-08-15
///  description: 获取护理日报工作量分数【南方医院】
///  table:DHCNMG.Arg.MgArgDayWork
///  input: 病区^日报项目sort^日期^
///  output:
///  return:
///  other:
ClassMethod GetDayNurseWork(parr As %String = "") As %String
{
	s ward=$P(parr,"^")
	s sort=$P(parr,"^",2)
	s date=$P(parr,"^",3)
	q:(ward="")||(sort="")||(date="") ""
	s:date["-" date=$zdh(date,3)
	s id=$O(^DHCNMG.Arg.MgArgDayWorkI("Ward",ward,date,sort,""))
	s obj=##class(DHCNMG.Arg.MgArgDayWork).%OpenId(id)
	q:'$IsObject(obj) ""
	s num=+obj.WorkNum
	i num=0 s num=""
	e  s:$p(num,".")="" num="0"_num
	q num
}

///  creator:lulin
///  createdate:2018-08-15
///  description: 查询护理全院日报工作量【南方医院】
///  table:DHCNMG.DB.MgWard,DHCNMG.Arg.MgArgDayWork，DHCNMG.DB.MgClinicItems
///  input: 开始日期^结束日期
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgArgCount","FindHospitalDayNurseWork","2018-08-01^2018-08-15")
Query FindHospitalDayNurseWork(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindHospitalDayNurseWorkExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s stDate=$p(parr,"^")
	s endDate=$P(parr,"^",2)
	i ((stDate="")||(endDate="")) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s:stDate["-" stDate=$zdh(stDate,3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s ret=""
	s sort="" f  s sort=$O(^DHCNMG.DB.MgClinicItemsI("sort",sort)) q:sort=""  d
	.s itemDR=$O(^DHCNMG.DB.MgClinicItemsI("sort",sort,""))
	.s itemObj=##class(DHCNMG.DB.MgClinicItems).%OpenId(itemDR)
	.q:'$IsObject(itemObj)
	.s ret="workDesc|"_itemObj.ClinicDesc_"^workSort|"_sort
	.s total=0
	.f date=stDate:1:endDate  d
	..s num=0
	..s WardDR="" f  s WardDR=$O(^DHCNMG.Arg.MgArgDayWorkI("SortDate",sort,date,WardDR)) q:WardDR=""  d
	...s workDR=$O(^DHCNMG.Arg.MgArgDayWorkI("SortDate",sort,date,WardDR,""))
	...s workObj=##class(DHCNMG.Arg.MgArgDayWork).%OpenId(workDR)
	...i $IsObject(workObj) d
	....s num=num+workObj.WorkNum
	..i num=0 s num=""
	..e  s:$p(num,".")="" num="0"_num
	..s prop="Date"_$zd(date,3)
	..s ret=ret_"^"_prop_"|"_num
	..s total=total+num
	.i total=0 s total=""
	.e  s:$p(total,".")="" total="0"_total
	.s ret=ret_"^total|"_total
	.d OutHospitalDayNurseWork
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutHospitalDayNurseWork
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHospitalDayNurseWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHospitalDayNurseWorkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHospitalDayNurseWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHospitalDayNurseWorkExecute ]
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

///  creator:lulin
///  createdate:2018-08-15
///  description: 查询护理日报工作量【南方医院】
///  table:DHCNMG.DB.MgWard,DHCNMG.Arg.MgArgDayWork，DHCNMG.DB.MgClinicItems
///  input: 病区^开始日期^结束日期
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgArgCount","FindDayNurseWork","2018-08-01^2018-08-15^1",0,0)
Query FindDayNurseWork(parr As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindDayNurseWorkExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s stDate=$p(parr,"^")
	s endDate=$P(parr,"^",2)
	i ((stDate="")||(endDate="")) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s:stDate["-" stDate=$zdh(stDate,3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s ward=$P(parr,"^",3)
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s ret="",index=1
	s wardid="" f  s wardid=$O(^DHCNMG.DB.MgWardD(wardid)) q:wardid=""  d
	.q:(ward'="")&&(wardid'=ward)
	.q:(isAll'=1)&&('$d(tmpWard(wardid)))
	.s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardid)
	.q:'$IsObject(wardObj)
	.s sort="" f  s sort=$O(^DHCNMG.DB.MgClinicItemsI("sort",sort)) q:sort=""  d
	..s itemDR=$O(^DHCNMG.DB.MgClinicItemsI("sort",sort,""))
	..s itemObj=##class(DHCNMG.DB.MgClinicItems).%OpenId(itemDR)
	..q:'$IsObject(itemObj)
	..s ret="workDesc|"_itemObj.ClinicDesc_"^workCode|"_itemObj.ClinicCode_"^workWard|"_wardObj.WardDesc_"^workSort|"_sort_"^wardDR|"_wardid
	..s total=0
	..f date=stDate:1:endDate  d
	...s workDR=$O(^DHCNMG.Arg.MgArgDayWorkI("Ward",wardid,date,sort,""))
	...s workObj=##class(DHCNMG.Arg.MgArgDayWork).%OpenId(workDR)
	...s num=""
	...i $IsObject(workObj) d
	....s num=+workObj.WorkNum
	....i num=0 s num=""
	....e  s:$p(num,".")="" num="0"_num
	...s prop="Date"_$zd(date,3)
	...s ret=ret_"^"_prop_"|"_num_"^"_prop_"Flag|0"
	...s total=total+num
	..i total=0 s total=""
	....e  s:$p(total,".")="" total="0"_total
	..s ret=ret_"^total|"_total_"^index|"_index
	..s index=index+1
	..d OutDayNurseWorkData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutDayNurseWorkData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDayNurseWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDayNurseWorkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDayNurseWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDayNurseWorkExecute ]
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

///  creator:lulin
///  createdate:2018-08-15
///  description: 查询护理日报工作量项目
///  table:DHCNMG.DB.MgClinicItems
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgArgCount","FindClinicItems")
Query FindClinicItems(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindClinicItemsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s sort="" f  s sort=$O(^DHCNMG.DB.MgClinicItemsI("sort",sort)) q:sort=""  d
	.q:sort<=0
	.s id=$O(^DHCNMG.DB.MgClinicItemsI("sort",sort,""))
	.s obj=##class(DHCNMG.DB.MgClinicItems).%OpenId(id)
	.q:'$IsObject(obj)
	.s ret="Desc|"_obj.ClinicDesc_"^Code|"_obj.ClinicCode_"^Sort|"_sort_"^rw|"_id
	.d OutClinicItemsData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutClinicItemsData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindClinicItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindClinicItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindClinicItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindClinicItemsExecute ]
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

/// Creator:gzj
/// Date:2019-04-29
/// Description:按照月份生成病区出勤情况
/// Table: DHCNMG.Arg.MgArrangeSub 、DHCNMG.HR.MgTransDep、DHCNMG.DB.MgWard
/// Input: 月份(2019-04)  病区ID
/// Output:
/// Return:
/// Other: 默认是按照病区顺序全部生成（系统任务），可以实现单病区按照月份生成数据（手动生成）
ClassMethod GenerateAttendance(month As %String, ward As %String, userId As %String) As %String
{
	q:month="" 0
	s startDate=$zdh(month_"-01",3)
	s year=$p(month,"-",1)
	s Month=$p(month,"-",2)
	i (Month+1)>12 s Month="01",year=(year+1)
	s endDate=$zdh(year_"-"_(Month+1)_"-01",3)-1
	s flag=1
	s tmp="",nurse="",work="",holiday=""
	s WardID="" f  s WardID=$o(^DHCNMG.Arg.MgArrangeI("Ward",WardID)) q:WardID=""  d
	.q:((ward'="")&&(WardID'=ward))
	.s ArgID="" f  s ArgID=$o(^DHCNMG.Arg.MgArrangeI("Ward",WardID,ArgID)) q:ArgID=""  d
	..s ArgObj=##class(DHCNMG.Arg.MgArrange).%OpenId(ArgID)
	..q:'$IsObject(ArgObj)
	..q:((ArgObj.ArgEndDate<startDate)!(ArgObj.ArgStDate>endDate))
	..q:((ArgObj.ArgStatus'="A")&&(ArgObj.ArgStatus'="R"))
	..s RowSort="" f  s RowSort=$o(^DHCNMG.Arg.MgArrangeRowI("ArgSort",ArgID,RowSort)) q:RowSort=""  d
	...s RowID="" f  s RowID=$o(^DHCNMG.Arg.MgArrangeRowI("ArgSort",ArgID,RowSort,RowID)) q:RowID=""  d
	....s RowObj=##class(DHCNMG.Arg.MgArrangeRow).%OpenId(RowID)
	....q:'$IsObject(RowObj)
	....q:'$IsObject(RowObj.ArgPerDR)
	....s nurse(WardID,RowObj.ArgPerDR.%Id())=0 
	f date=startDate:1:endDate 
	{
		s WardDR="" f  s WardDR=$o(^DHCNMG.Arg.MgArrangeSubI("WardPerDate",WardDR)) q:WardDR=""  d
		.q:((ward'="")&&(WardDR'=ward))
		.s PerDR="" f  s PerDR=$o(^DHCNMG.Arg.MgArrangeSubI("WardPerDate",WardDR,PerDR)) q:PerDR=""  d
		..s Rw="" f  s Rw=$o(^DHCNMG.Arg.MgArrangeSubI("WardPerDate",WardDR,PerDR,date,Rw)) q:Rw=""  d
		...s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(Rw)
		...q:((obj.ArrangeDR.ArgStatus'="A")&&(obj.ArrangeDR.ArgStatus'="R"))
		...q:'$IsObject(obj)
		...i ($g(tmp(WardDR,PerDR,date))'="") s tmp(WardDR,PerDR,date)=$g(tmp(WardDR,PerDR,date))_"^"_$case($IsObject(obj.ArgPostDR),1:obj.ArgPostDR.%Id(),0:obj.ArgType)
		...e  i ($g(tmp(WardDR,PerDR,date))="") s tmp(WardDR,PerDR,date)=$case($IsObject(obj.ArgPostDR),1:obj.ArgPostDR.%Id(),0:obj.ArgType)
		
	}
	s flag=1
	Ts
	s oldRw=$o(^DHCNMG.Arg.MgAttendanceI("ward",ward,$p(month,"-",1)_$p(month,"-",2),""))
	i oldRw'="" d
	.s OldObj=##class(DHCNMG.Arg.MgAttendance).%OpenId(oldRw)
	.q:'$IsObject(OldObj)
	.s oldSc=OldObj.%DeleteId(oldRw)
	.s flag=(flag&&$$$ISOK(oldSc))
	f date1=startDate:1:endDate
	{
		s tmpWard="" f  s tmpWard=$o(nurse(tmpWard)) q:tmpWard=""  d
		.;s tmpWard="" f  s tmpWard=$o(tmp(tmpWard)) q:tmpWard=""  d
		.;s flag=1
		.;Ts
		.s pro=..ConvertDay(date1)
		.s raw=$o(^DHCNMG.Arg.MgAttendanceI("ward",tmpWard,$p(month,"-",1)_$p(month,"-",2),""))
		.i raw="" s ParObj=##class(DHCNMG.Arg.MgAttendance).%New()
		.e  s ParObj=##class(DHCNMG.Arg.MgAttendance).%OpenId(raw)
		.s ParObj.AttendMonth=$p(month,"-",1)_$p(month,"-",2)
		.s ParObj.AttendWard=tmpWard
		.s ParObj.CreateDate=+$h
		.s ParObj.CreateTime=$p($h,",",2)
		.s ParObj.CreateUser=userId
		.s scPar=ParObj.%Save()
		.s flag=($$$ISOK(scPar)&&flag)
		.s tmpPer=""  f  s tmpPer=$o(nurse(tmpWard,tmpPer)) q:tmpPer=""  d
		..s SubRw=$o(^DHCNMG.Arg.MgAttendanceSubI("per",ParObj.%Id()," "_tmpPer,""))
		..i SubRw=""  d
		...s SubObj=##class(DHCNMG.Arg.MgAttendanceSub).%New()
		...s SubObj.Parref=##class(DHCNMG.Arg.MgAttendance).%OpenId(ParObj.%Id())
		..e  d
		...s SubObj=##class(DHCNMG.Arg.MgAttendanceSub).%OpenId(ParObj.%Id()_"||"_SubRw)
		..i $g(tmp(tmpWard,tmpPer,date1))'="" d
		...s len=$l($g(tmp(tmpWard,tmpPer,date1)),"^")
		...s short=""
		...f i=1:1:len d
		....s itm=$p($g(tmp(tmpWard,tmpPer,date1)),"^",i)
		....i itm="" continue
		....i (+itm) d
		.....s PostObj=##class(DHCNMG.DB.MgArgWardPost).%OpenId(itm)
		.....q:'$IsObject(PostObj)
		.....s holidayFlag=..CheckHoliday(date1)
		.....i ((holidayFlag=1)&&(PostObj.PostDR.PostCategory'="H")) d
		......s holiday(tmpWard,tmpPer,date1)=1
		.....i ((PostObj.PostDR.PostCategory'="H")&&(PostObj.PostDR.PostCategory'="N")) d
		......s short="√"
		.....e  i (PostObj.PostDR.PostCategory="N") d
		......s short="√△"
		.....e  i PostObj.PostDR.PostCategory="H" d
		......i PostObj.PostDR.PostDesc="病假" s short="+"
		......e  i PostObj.PostDR.PostDesc="事假" s short="-"
		......e  i PostObj.PostDR.PostDesc="探亲假" s short="A"
		......e  i ((PostObj.PostDR.PostDesc="婚假")!(PostObj.PostDR.PostDesc="丧假")) s short="B"
		......e  i PostObj.PostDR.PostDesc="产假" s short="C"
		......e  i ((PostObj.PostDR.PostDesc="年假")!(PostObj.PostDR.PostDesc="年休假")) s short="D"
		......e  i ((PostObj.PostDR.PostDesc="休息")!(PostObj.PostDR.PostDesc="休")) s short="="
		......e  i PostObj.PostDR.PostDesc="" s $ZOBJPROPERTY(SubObj,pro)=""
		....e  d
		.....s work(tmpWard,tmpPer,date1)=itm
		...s $ZOBJPROPERTY(SubObj,pro)=short
		..e  i ($g(tmp(tmpWard,tmpPer,date1))=""&&$IsObject(SubObj)) s $ZOBJPROPERTY(SubObj,pro)="×"
		..i date1=endDate d
		...s AddWork=0,SubWork=0
		...;s date2="" f  s date2=$o(work(tmpWard,tmpPer,date2)) q:date2=""  d
		....;i work(tmpWard,tmpPer,date2)="Y" s AddWork=AddWork+1
		....;e  i work(tmpWard,tmpPer,date2)="N" s SubWork=SubWork+1
		...;s SubObj.OverTime=AddWork
		...s date2="" f  s date2=$o(holiday(tmpWard,tmpPer,date2)) q:date2=""  d
		....i holiday(tmpWard,tmpPer,date2)=1 s AddWork=AddWork+1
		...s SubObj.OverTime=AddWork
		..i $IsObject(SubObj) s SubObj.NurseID=tmpPer
		..i $IsObject(SubObj) s subSc=SubObj.%Save()
		..i $IsObject(SubObj) s flag=(flag&&($$$ISOK(subSc)))
		.;i flag=1 tc
		.;e  tro
	}
	i flag=1 tc
	e  tro
	q flag
}

/// Creator:gzj
/// Date:2019-05-16
/// Description:判断当天是否为假期【假期维护】
ClassMethod CheckHoliday(date As %String) As %String
{
	q:date="" 0
	s flag=0
	s year=$p($zd(date,3),"-",1)
	s code="" f  s code=$o(^DHCNMG.DB.MgHolidaySetI("code",year,code)) q:((code="")!(flag=1))  d
	.s Rw="" f  s Rw=$o(^DHCNMG.DB.MgHolidaySetI("code",year,code,Rw)) q:((Rw="")!(flag=1))  d
	..s obj=##class(DHCNMG.DB.MgHolidaySet).%OpenId(Rw)
	..q:'$IsObject(obj)
	..
	..q:obj.HolidayID.SubDesc="班"
	..s stDate=$zdh($p(obj.HolidayDate,",",1),3)
	..s endDate=$zdh($p(obj.HolidayDate,",",2),3)
	..i ((date>=stDate)&&(date<=endDate)) s flag=1
	q flag
}

ClassMethod ConvertDay(date As %String) As %String
{
	q:date="" 0
	s flag=""
	s day=$p($zd(date,3),"-",3)
	i day="01" s flag="One"
	e  i day="02" s flag="Two"
	e  i day="03" s flag="Three"
	e  i day="04" s flag="Four"
	e  i day="05" s flag="Five"
	e  i day="06" s flag="Six"
	e  i day="07" s flag="Seven"
	e  i day="08" s flag="Eight"
	e  i day="09" s flag="Nine"
	e  i day="10" s flag="Ten"
	e  i day="11" s flag="Eleven"
	e  i day="12" s flag="Twelve"
	e  i day="13" s flag="Thirteen"
	e  i day="14" s flag="Fourteen"
	e  i day="15" s flag="Fifteen"
	e  i day="16" s flag="Sixteen"
	e  i day="17" s flag="Seventeen"
	e  i day="18" s flag="Eighteen"
	e  i day="19" s flag="Nineteen"
	e  i day="20" s flag="Twenty"
	e  i day="21" s flag="TwentyOne"
	e  i day="22" s flag="TwentyTwo"
	e  i day="23" s flag="TwentyThree"
	e  i day="24" s flag="TwentyFour"
	e  i day="25" s flag="TwentyFive"
	e  i day="26" s flag="TwentySix"
	e  i day="27" s flag="TwentySeven"
	e  i day="28" s flag="TwentyEight"
	e  i day="29" s flag="TwentyNine"
	e  i day="30" s flag="Thirty"
	e  i day="31" s flag="ThirtyOne"
	q flag
}

///  Creator:gzj
///  Createdate:2019-05-06
///  Description: 按照月份查询病区考勤数据
///  Table:
///  Input:
///  Output:
///  Return:
///  Other: d ##class(%ResultSet).RunQuery("web.NurMgArgCount","FindAttendaceList")
Query FindAttendaceList(ward As %String, month As %String) As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindAttendaceListExecute(ByRef qHandle As %Binary, ward As %String, month As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp="",ret=""
	s Ward="" f  s Ward=$o(^DHCNMG.Arg.MgAttendanceI("ward",Ward)) q:Ward=""  d
	.q:((ward'="")&&(Ward'=ward))
	.
	.s Month="" f  s Month=$o(^DHCNMG.Arg.MgAttendanceI("ward",Ward,Month)) q:Month=""  d
	..q:((month'="")&&(Month'=($p(month,"-",1)_$p(month,"-",2))))
	..s RowID="" f  s RowID=$o(^DHCNMG.Arg.MgAttendanceI("ward",ward,Month,RowID)) q:RowID=""  d
	...s SubRw="" f  s SubRw=$o(^DHCNMG.Arg.MgAttendanceSubD(RowID,SubRw)) q:SubRw=""  d
	....s SickDays=0,LeaveDays=0,VisitDays=0,MarryFuneral=0,Maternity=0,AnnualDays=0,NightNum=0,OverTime=0
	....//病假数 事假数 探亲假天数 婚丧假天数 产假天数 年休假天数 夜班数 加班数
	....s obj=##class(DHCNMG.Arg.MgAttendanceSub).%OpenId(RowID_"||"_SubRw)
	....q:'$IsObject(obj)
	....s NurseID=obj.NurseID
	....s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(NurseID)
	....q:'$IsObject(PerObj)
	....s NurseName=PerObj.PerName
	....s NurseNo=PerObj.PerID
	....s One=obj.One
	....i One="+" s SickDays=SickDays+1 //病假
	....e  i One="-" s LeaveDays=LeaveDays+1 //事假
	....e  i One="A" s VisitDays=VisitDays+1 //探亲假
	....e  i One="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i One="C" s Maternity=Maternity+1 //产假
	....e  i One="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i One["△" s NightNum=NightNum+1 //夜班数
	....s Two=obj.Two
	....i Two="+" s SickDays=SickDays+1 //病假
	....e  i Two="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Two="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Two="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Two="C" s Maternity=Maternity+1 //产假
	....e  i Two="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Two["△" s NightNum=NightNum+1 //夜班数
	....s Three=obj.Three
	....i Three="+" s SickDays=SickDays+1 //病假
	....e  i Three="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Three="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Three="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Three="C" s Maternity=Maternity+1 //产假
	....e  i Three="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Three["△" s NightNum=NightNum+1 //夜班数
	....s Four=obj.Four
	....i Four="+" s SickDays=SickDays+1 //病假
	....e  i Four="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Four="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Four="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Four="C" s Maternity=Maternity+1 //产假
	....e  i Four="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Four["△" s NightNum=NightNum+1 //夜班数
	....s Five=obj.Five
	....i Five="+" s SickDays=SickDays+1 //病假
	....e  i Five="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Five="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Five="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Five="C" s Maternity=Maternity+1 //产假
	....e  i Five="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Five["△" s NightNum=NightNum+1 //夜班数
	....s Six=obj.Six
	....i Six="+" s SickDays=SickDays+1 //病假
	....e  i Six="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Six="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Six="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Six="C" s Maternity=Maternity+1 //产假
	....e  i Six="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Six["△" s NightNum=NightNum+1 //夜班数
	....s Seven=obj.Seven
	....i Seven="+" s SickDays=SickDays+1 //病假
	....e  i Seven="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Seven="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Seven="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Seven="C" s Maternity=Maternity+1 //产假
	....e  i Seven="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Seven["△" s NightNum=NightNum+1 //夜班数
	....s Eight=obj.Eight
	....i Eight="+" s SickDays=SickDays+1 //病假
	....e  i Eight="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Eight="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Eight="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Eight="C" s Maternity=Maternity+1 //产假
	....e  i Eight="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Eight["△" s NightNum=NightNum+1 //夜班数
	....s Nine=obj.Nine
	....i Nine="+" s SickDays=SickDays+1 //病假
	....e  i Nine="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Nine="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Nine="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Nine="C" s Maternity=Maternity+1 //产假
	....e  i Nine="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Nine["△" s NightNum=NightNum+1 //夜班数
	....s Ten=obj.Ten
	....i Ten="+" s SickDays=SickDays+1 //病假
	....e  i Ten="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Ten="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Ten="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Ten="C" s Maternity=Maternity+1 //产假
	....e  i Ten="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Ten["△" s NightNum=NightNum+1 //夜班数
	....s Eleven=obj.Eleven
	....i Eleven="+" s SickDays=SickDays+1 //病假
	....e  i Eleven="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Eleven="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Eleven="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Eleven="C" s Maternity=Maternity+1 //产假
	....e  i Eleven="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Eleven["△" s NightNum=NightNum+1 //夜班数
	....s Twelve=obj.Twelve
	....i Twelve="+" s SickDays=SickDays+1 //病假
	....e  i Twelve="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Twelve="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Twelve="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Twelve="C" s Maternity=Maternity+1 //产假
	....e  i Twelve="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Twelve["△" s NightNum=NightNum+1 //夜班数
	....s Thirteen=obj.Thirteen
	....i Thirteen="+" s SickDays=SickDays+1 //病假
	....e  i Thirteen="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Thirteen="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Thirteen="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Thirteen="C" s Maternity=Maternity+1 //产假
	....e  i Thirteen="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Thirteen["△" s NightNum=NightNum+1 //夜班数
	....s Fourteen=obj.Fourteen
	....i Fourteen="+" s SickDays=SickDays+1 //病假
	....e  i Fourteen="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Fourteen="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Fourteen="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Fourteen="C" s Maternity=Maternity+1 //产假
	....e  i Fourteen="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Fourteen["△" s NightNum=NightNum+1 //夜班数
	....s Fifteen=obj.Fifteen
	....i Fifteen="+" s SickDays=SickDays+1 //病假
	....e  i Fifteen="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Fifteen="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Fifteen="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Fifteen="C" s Maternity=Maternity+1 //产假
	....e  i Fifteen="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Fifteen["△" s NightNum=NightNum+1 //夜班数
	....s Sixteen=obj.Sixteen 
	....i Sixteen="+" s SickDays=SickDays+1 //病假
	....e  i Sixteen="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Sixteen="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Sixteen="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Sixteen="C" s Maternity=Maternity+1 //产假
	....e  i Sixteen="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Sixteen["△" s NightNum=NightNum+1 //夜班数
	....s Seventeen=obj.Seventeen
	....i Seventeen="+" s SickDays=SickDays+1 //病假
	....e  i Seventeen="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Seventeen="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Seventeen="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Seventeen="C" s Maternity=Maternity+1 //产假
	....e  i Seventeen="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Seventeen["△" s NightNum=NightNum+1 //夜班数
	....s Eighteen=obj.Eighteen
	....i Eighteen="+" s SickDays=SickDays+1 //病假
	....e  i Eighteen="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Eighteen="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Eighteen="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Eighteen="C" s Maternity=Maternity+1 //产假
	....e  i Eighteen="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Eighteen["△" s NightNum=NightNum+1 //夜班数
	....s Nineteen=obj.Nineteen
	....i Nineteen="+" s SickDays=SickDays+1 //病假
	....e  i Nineteen="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Nineteen="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Nineteen="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Nineteen="C" s Maternity=Maternity+1 //产假
	....e  i Nineteen="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Nineteen["△" s NightNum=NightNum+1 //夜班数
	....s Twenty=obj.Twenty
	....i Twenty="+" s SickDays=SickDays+1 //病假
	....e  i Twenty="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Twenty="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Twenty="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Twenty="C" s Maternity=Maternity+1 //产假
	....e  i Twenty="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Twenty["△" s NightNum=NightNum+1 //夜班数
	....s TwentyOne=obj.TwentyOne
	....i TwentyOne="+" s SickDays=SickDays+1 //病假
	....e  i TwentyOne="-" s LeaveDays=LeaveDays+1 //事假
	....e  i TwentyOne="A" s VisitDays=VisitDays+1 //探亲假
	....e  i TwentyOne="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i TwentyOne="C" s Maternity=Maternity+1 //产假
	....e  i TwentyOne="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i TwentyOne["△" s NightNum=NightNum+1 //夜班数
	....s TwentyTwo=obj.TwentyTwo
	....i TwentyTwo="+" s SickDays=SickDays+1 //病假
	....e  i TwentyTwo="-" s LeaveDays=LeaveDays+1 //事假
	....e  i TwentyTwo="A" s VisitDays=VisitDays+1 //探亲假
	....e  i TwentyTwo="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i TwentyTwo="C" s Maternity=Maternity+1 //产假
	....e  i TwentyTwo="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i TwentyTwo["△" s NightNum=NightNum+1 //夜班数
	....s TwentyThree=obj.TwentyThree
	....i TwentyThree="+" s SickDays=SickDays+1 //病假
	....e  i TwentyThree="-" s LeaveDays=LeaveDays+1 //事假
	....e  i TwentyThree="A" s VisitDays=VisitDays+1 //探亲假
	....e  i TwentyThree="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i TwentyThree="C" s Maternity=Maternity+1 //产假
	....e  i TwentyThree="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i TwentyThree["△" s NightNum=NightNum+1 //夜班数
	....s TwentyFour=obj.TwentyFour
	....i TwentyFour="+" s SickDays=SickDays+1 //病假
	....e  i TwentyFour="-" s LeaveDays=LeaveDays+1 //事假
	....e  i TwentyFour="A" s VisitDays=VisitDays+1 //探亲假
	....e  i TwentyFour="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i TwentyFour="C" s Maternity=Maternity+1 //产假
	....e  i TwentyFour="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i TwentyFour["△" s NightNum=NightNum+1 //夜班数
	....s TwentyFive=obj.TwentyFive 
	....i TwentyFive="+" s SickDays=SickDays+1 //病假
	....e  i TwentyFive="-" s LeaveDays=LeaveDays+1 //事假
	....e  i TwentyFive="A" s VisitDays=VisitDays+1 //探亲假
	....e  i TwentyFive="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i TwentyFive="C" s Maternity=Maternity+1 //产假
	....e  i TwentyFive="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i TwentyFive["△" s NightNum=NightNum+1 //夜班数
	....s TwentySix=obj.TwentySix
	....i TwentySix="+" s SickDays=SickDays+1 //病假
	....e  i TwentySix="-" s LeaveDays=LeaveDays+1 //事假
	....e  i TwentySix="A" s VisitDays=VisitDays+1 //探亲假
	....e  i TwentySix="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i TwentySix="C" s Maternity=Maternity+1 //产假
	....e  i TwentySix="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i TwentySix["△" s NightNum=NightNum+1 //夜班数
	....s TwentySeven=obj.TwentySeven
	....i TwentySeven="+" s SickDays=SickDays+1 //病假
	....e  i TwentySeven="-" s LeaveDays=LeaveDays+1 //事假
	....e  i TwentySeven="A" s VisitDays=VisitDays+1 //探亲假
	....e  i TwentySeven="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i TwentySeven="C" s Maternity=Maternity+1 //产假
	....e  i TwentySeven="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i TwentySeven["△" s NightNum=NightNum+1 //夜班数
	....s TwentyEight=obj.TwentyEight
	....i TwentyEight="+" s SickDays=SickDays+1 //病假
	....e  i TwentyEight="-" s LeaveDays=LeaveDays+1 //事假
	....e  i TwentyEight="A" s VisitDays=VisitDays+1 //探亲假
	....e  i TwentyEight="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i TwentyEight="C" s Maternity=Maternity+1 //产假
	....e  i TwentyEight="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i TwentyEight["△" s NightNum=NightNum+1 //夜班数
	....s TwentyNine=obj.TwentyNine
	....i TwentyNine="+" s SickDays=SickDays+1 //病假
	....e  i TwentyNine="-" s LeaveDays=LeaveDays+1 //事假
	....e  i TwentyNine="A" s VisitDays=VisitDays+1 //探亲假
	....e  i TwentyNine="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i TwentyNine="C" s Maternity=Maternity+1 //产假
	....e  i TwentyNine="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i TwentyNine["△" s NightNum=NightNum+1 //夜班数
	....s Thirty=obj.Thirty
	....i Thirty="+" s SickDays=SickDays+1 //病假
	....e  i Thirty="-" s LeaveDays=LeaveDays+1 //事假
	....e  i Thirty="A" s VisitDays=VisitDays+1 //探亲假
	....e  i Thirty="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i Thirty="C" s Maternity=Maternity+1 //产假
	....e  i Thirty="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i Thirty["△" s NightNum=NightNum+1 //夜班数
	....s ThirtyOne=obj.ThirtyOne
	....i ThirtyOne="+" s SickDays=SickDays+1 //病假
	....e  i ThirtyOne="-" s LeaveDays=LeaveDays+1 //事假
	....e  i ThirtyOne="A" s VisitDays=VisitDays+1 //探亲假
	....e  i ThirtyOne="B" s MarryFuneral=MarryFuneral+1 //婚丧假
	....e  i ThirtyOne="C" s Maternity=Maternity+1 //产假
	....e  i ThirtyOne="D" s AnnualDays=AnnualDays+1 //年休假
	....e  i ThirtyOne["△" s NightNum=NightNum+1 //夜班数
	....s OverTime=obj.OverTime
	....s TrainNum=obj.TrainNum  //外地进修
	....s FromTrainNum=obj.FromTrainNum //进修回科
	....s TransIn=obj.TransIn //调入
	....s TransOut=obj.TransOut //调出
	....s ret="NurseName|"_NurseName_"^NurseID|"_NurseNo_"^One|"_One_"^Two|"_Two_"^Three|"_Three_"^Four|"_Four_"^Five|"_Five_"^Six|"_Six_"^Seven|"_Seven
	....s ret=ret_"^Eight|"_Eight_"^Nine|"_Nine_"^Ten|"_Ten_"^Eleven|"_Eleven_"^Twelve|"_Twelve_"^Thirteen|"_Thirteen_"^Fourteen|"_Fourteen_"^Fifteen|"_Fifteen_"^Sixteen|"_Sixteen
	....s ret=ret_"^Seventeen|"_Seventeen_"^Eighteen|"_Eighteen_"^Nineteen|"_Nineteen_"^Twenty|"_Twenty_"^TwentyOne|"_TwentyOne_"^TwentyTwo|"_TwentyTwo_"^TwentyThree|"_TwentyThree
	....s ret=ret_"^TwentyFour|"_TwentyFour_"^TwentyFive|"_TwentyFive_"^TwentySix|"_TwentySix_"^TwentySeven|"_TwentySeven_"^TwentyEight|"_TwentyEight_"^TwentyNine|"_TwentyNine_"^Thirty|"_Thirty
	....s ret=ret_"^ThirtyOne|"_ThirtyOne_"^SickDays|"_SickDays_"^LeaveDays|"_LeaveDays_"^VisitDays|"_VisitDays_"^MarryFuneral|"_MarryFuneral_"^Maternity|"_Maternity_"^AnnualDays|"_AnnualDays_"^NightNum|"_NightNum
	....s ret=ret_"^isShow|"_"0"_"^fromIsShow|"_"0"_"^FromTrainNum|"_FromTrainNum_"^TrainNum|"_TrainNum_"^OverTime|"_OverTime_"^RowID|"_RowID_"^SubRw|"_SubRw_"^inShow|0^outShow|0"_"^TransIn|"_TransIn_"^TransOut|"_TransOut
	....d OutAttendace
	/*
		出勤(√)病假(+)事假(-)探亲假(A)婚丧假(B)产假(C) 年休假(D)旷工(×)休息(=)夜班(△)
	*/
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutAttendace
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAttendaceListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAttendaceListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAttendaceListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAttendaceListExecute ]
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

ClassMethod SaveAttendance(RowID As %String, SubRw As %String, args As %String) As %String
{
	q:((RowID="")!(SubRw="")!(args=""))
	s obj=##class(DHCNMG.Arg.MgAttendanceSub).%OpenId(RowID_"||"_SubRw)
	q:'$IsObject(obj)
	i $p(args,"^",1)="FromTrainNum" s obj.FromTrainNum=$p(args,"^",2)
	e  i $p(args,"^",1)="TrainNum" s obj.TrainNum=$p(args,"^",2)
	e  i $p(args,"^",1)="TransIn" s obj.TransIn=$p(args,"^",2)
	e  i $p(args,"^",1)="TransOut" s obj.TransOut=$p(args,"^",2)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

///  creator:zhangjz
///  createdate:20190418
///  description: 病区排班类型统计-粤北人民医院
///  table:DHCNMG.Arg.MgArrangeSub
///  input: 开始日期^结束日期^病区
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgArgCount","WardPostStat","2019-03-01^2019-05-31^N","0","0")
Query WardPostStat(parr As %String = "", role As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod WardPostStatExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s date=$zd(+$h,3)
	s stdate=$P(parr,"^",1)
	i stdate="" s stdate=+date_"-01-01"
	s:stdate["-" stdate=$zdh(stdate,3)
	s enddate=$P(parr,"^",2)
	i enddate="" s enddate=+date_"-12-31"
	s:enddate["-" enddate=$zdh(enddate,3)
	s type=$P(parr,"^",3)
	s tmpWard=""
	s isAll=0
	k tmp
	s tmp=""
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)	
	s perdr="" f  s perdr=$O(^DHCNMG.HR.MgPersonsI("type"," "_$zcvt(type,"U"),perdr)) q:perdr=""  d
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(perdr)
	.q:'$IsObject(perobj)
	.q:perobj.PerTypeDR'="N" ;只取正式护士
	.s PerStatus=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(perobj.PerStatus)
	.q:(($IsObject(PerStatus))&&(PerStatus.SubDesc'["在职")&&(perobj.PerStateDate<stdate)) ;只统计在职
	.s curward=##class(web.NurMgHRComm).GetCurrentWard(perdr,+$h)
	.q:curward=""
	.s tmp("Person",curward)=+$g(tmp("Person",curward))+1
	.q:(isAll=0)&&((curward="")||('$d(tmpWard(curward))))	
	.d ..GetWardPostCount(perdr,stdate,enddate,curward,.tmp)	
	
	s ret=""
	s Sort="" f  s Sort=$O(^DHCNMG.DB.MgWardI("Sort",Sort)) q:Sort=""  d
	.s RowID="" f  s RowID=$O(^DHCNMG.DB.MgWardI("Sort",Sort,RowID)) q:RowID=""  d
	..s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(RowID)
	..q:'$IsObject(WardObj.CTLocDR)
	..s CtLocId=WardObj.CTLocDR.%Id()
	..q:CtLocId=""
	..s wardID=$o(^PAWARD(0,"WARD_LocationDR",CtLocId,""))
	..q:wardID=""
	..s inHospitalPatNum=0 //在院人数
	..s roomID=0 f  s roomID=$o(^PAADMi("CurrWard",wardID,roomID)) q:roomID=""  d
	...s episodeID=0 f  s episodeID=$o(^PAADMi("CurrWard",wardID,roomID,episodeID)) q:episodeID=""  d
    ....s padmType=$p($g(^PAADM(episodeID)),"^",2) //就诊类型
    ....q:padmType'="I"
    ....s patVisit=$p($g(^PAADM(episodeID)),"^",20) //获取在院状态
    ....q:patVisit'="A" //过滤掉不是在院状态的记录   
    ....s inHospitalPatNum=inHospitalPatNum+1
	..s num=##class(web.NurMgSensComm).getBedsAndNurses(RowID) ;实际床数、在编床数、护士数
	..s NurseNum=$p(num,"^",3)
	..s bedNum=$p(num,"^",2) 
	..s waitNum=##class(web.NurMgSensComm).GetWardWaitNum(wardID) //获取等待区的人数
    ..s inHospitalPatNum=inHospitalPatNum+waitNum
    ..s tmp("BedSum",RowID)=+$g(tmp("BedSum",RowID))+bedNum //床位总数
    ..s tmp("PatSum",RowID)=+$g(tmp("PatSum",RowID))+inHospitalPatNum //患者数
    ..//s tmp("NurseNum",RowID)=+$g(tmp("NurseNum",RowID))+NurseNum //上班护士数
	
	s ret="PostDesc|床位总数"
	s wardDR="" f  s wardDR=$O(tmp("BedSum",wardDR)) q:wardDR=""  d
	.s tmp("BedSum")=+$g(tmp("BedSum"))+$g(tmp("BedSum",wardDR))
	.s ret=ret_"^"_wardDR_"|"_+$g(tmp("BedSum",wardDR))
    s ret=ret_"^AllWard|"_+$g(tmp("BedSum"))
	d OutPostHour
	
	s ret="PostDesc|患者数"
	s wardDR="" f  s wardDR=$O(tmp("PatSum",wardDR)) q:wardDR=""  d
	.s tmp("PatSum")=+$g(tmp("PatSum"))+$g(tmp("PatSum",wardDR))
	.s ret=ret_"^"_wardDR_"|"_+$g(tmp("PatSum",wardDR))
    s ret=ret_"^AllWard|"_+$g(tmp("PatSum"))
	d OutPostHour
	
	s ret="PostDesc|护士总数"
	s wardDR="" f  s wardDR=$O(tmp("Person",wardDR)) q:wardDR=""  d
	.s tmp("Person")=+$g(tmp("Person"))+$g(tmp("Person",wardDR))
	.s ret=ret_"^"_wardDR_"|"_+$g(tmp("Person",wardDR))
    s ret=ret_"^AllWard|"_+$g(tmp("Person"))
	d OutPostHour
	
	s ret="PostDesc|上班护士数"
	s wardDR="" f  s wardDR=$O(tmp("NurseNum",wardDR)) q:wardDR=""  d
	.s tmp("NurseNum")=+$g(tmp("NurseNum"))+$g(tmp("NurseNum",wardDR))
	.s ret=ret_"^"_wardDR_"|"_+$g(tmp("NurseNum",wardDR))
    s ret=ret_"^AllWard|"_+$g(tmp("NurseNum"))
	d OutPostHour
	
	
	s sort="" f  s sort=$O(^DHCNMG.DB.MgArgPostI("Sort",sort)) q:sort=""  d
	.s id="" f  s id=$O(^DHCNMG.DB.MgArgPostI("Sort",sort,id)) q:id=""  d
	..s obj=##class(DHCNMG.DB.MgArgPost).%OpenId(id)
	..s desc=obj.PostDesc	
	..s ret="PostDesc|"_desc
	..s wardDR="" f  s wardDR=$O(tmp("Post",id,wardDR)) q:wardDR=""  d
	...s tmp("Post",id)=+$g(tmp("Post",id))+$g(tmp("Post",id,wardDR))
	...s ret=ret_"^"_wardDR_"|"_+$g(tmp("Post",id,wardDR))
    ..s ret=ret_"^AllWard|"_+$g(tmp("Post",id))
	..d OutPostHour	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPostHour
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod WardPostStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WardPostStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod WardPostStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WardPostStatExecute ]
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

ClassMethod GetWardPostCount(perdr, stdate, enddate, curward, tmp) As %String
{
	s flag=0
	f admdate=stdate:1:enddate d
	.s id="" f  s id=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perdr,admdate,id)) q:id=""  d
	..s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	..q:'$IsObject(obj.ArgPostDR)
	..q:(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	..q:'$IsObject(obj.ArgPostDR.PostDR)
	..s flag=1
	..s tmp("Post",obj.ArgPostDR.PostDR.%Id(),curward)=+$g(tmp("Post",obj.ArgPostDR.PostDR.%Id(),curward))+1
	i flag s tmp("NurseNum",curward)=+$g(tmp("NurseNum",curward))+1 //上班护士数
}

}
