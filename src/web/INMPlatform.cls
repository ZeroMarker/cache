/// Creator:lulin
/// Desctiptions:工作台
/// Date:2021-03-15
Class web.INMPlatform Extends %RegisteredObject
{

/// Description：根据argWardId获取班次的名称、背景色、字体颜色
/// Date:2021-03-15
/// Creator:lulin
/// Table:CF.DHCINM.DB.MgArgWardPost、CF.DHCINM.DB.MgArgPost
/// Input: 用户id
/// Output:
/// Other:w ##class(web.INMPlatform).GetArgDescAndColor(1)
ClassMethod GetArgDescAndColor(wardPostId)
{
	q:wardPostId="" ""
	s wardPostObj=$g(^CF.DHCINM.DB.MgArgWardPostD(wardPostId))
	q:wardPostObj="" ""
	s postId=$LG(wardPostObj,4)
	s postObj=$G(^CF.DHCINM.DB.MgArgPostD(postId))
	q:postObj="" ""
	s argDesc=$LG(postObj,3)
	s bgColor=$Lg(postObj,16)
	s fontColor=$Lg(postObj,15)
	q argDesc_"」"_bgColor_"」"_fontColor
}

/// -----公共方法分界线-----
/// Description：获取节假日json数据
/// Date:2021-03-15
/// Creator:lulin
/// Table:
/// Input:
/// Output:
/// Other:
ClassMethod FindHolidayJSON(year As %String) As %String
{
	q:year="" "{}"
	w "{"
	s firstFlag=1
	s code="" f  s code=$o(^CF.DHCINM.DB.MgHolidaySetI("code",year,code)) q:code=""  d
	.s rw="" f  s rw=$o(^CF.DHCINM.DB.MgHolidaySetI("code",year,code,rw)) q:rw=""  d
	..s obj=##class(CF.DHCINM.DB.MgHolidaySet).%OpenId(rw)
	..s obj=$G(^CF.DHCINM.DB.MgHolidaySetD(rw))
	..q:obj=""
	..s HolidayDate=$LG(obj,4)
	..q:HolidayDate=""
	..s start=$zdh($p(HolidayDate,",",1),3)
	..s end=$zdh($p(HolidayDate,",",2),3)
	..s desc=$LG(obj,3)
	..s date=""
	..s desc=##class(web.INMDBComm).GetCommCode(desc)
	..q:desc=""
	..f date=start:1:end  d
	...w:firstFlag'=1 ","
	...w """"_$zd(date,3)_""":"""_desc_""""
	...s firstFlag=0
	w "}"
	q ""
}

/// Description：查询个人排班
/// Date:2021-03-15
/// Creator:lulin
/// Table:DHCINM.Arg.MgArrangeSub
/// Input: 用户id
/// Output:
/// Other:w ##class(web.INMPlatform).FindUserArgList("2021-03-01",1597)
ClassMethod FindUserArgList(parr As %String = "", loginID As %String = "", appFlag As %String = "0", appRet As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ArrayOfDataTypes).%New()
	s ret=""
	s startDate=$P(parr,"^",1)
	i startDate["-" d
	.s startDate=$zdh(startDate,3)
	e  d
	.s startDate=""
	s perDR=$LG($g(^CF.DHCINM.DB.MgUserD(loginID)),5)
	if ((startDate="")||(loginID="")||(perDR="")){
		q:appFlag=1 appRet
		q "{}"
	}
	w:appFlag'=1 "{"
	s endDate=startDate+41
	f date=startDate:1:endDate d
	.s tmpIsAskLeave=##class(web.INMArgComm).IsPerAskLeavel3(perDR_"^"_date)
	.s isAskLeave=$p(tmpIsAskLeave,"^")
	.w:(date'=startDate)&&(appFlag'=1) ","
	.w:appFlag'=1 """"_$zd(date,3)_""":"
	.s tmpRet=##class(%ListOfDataTypes).%New()
	.s dateData=""
	.i isAskLeave'=0 d
	..s wardPostId=$P(tmpIsAskLeave,"^",3)
	..s dateData=..GetArgDescAndColor(wardPostId)
	..q:dateData=""
	..s tmpRetObj=##class(%ArrayOfDataTypes).%New()
	..d tmpRetObj.SetAt($p(dateData,"」"),"Desc")
	..d tmpRetObj.SetAt($p(dateData,"」",2),"BgColor")
	..d tmpRetObj.SetAt($p(dateData,"」",3),"FontColor")
	..d tmpRet.Insert(tmpRetObj)
	.e  d
	..s dateDataFlag=0
	..s argSubId="" f  s argSubId=$O(^DHCINM.Arg.MgArrangeSubI("PerDate",perDR,date,argSubId)) q:argSubId=""  d
	...s argSubObj=$G(^DHCINM.Arg.MgArrangeSubD(argSubId))
	...q:argSubObj=""
	...s argId=$LG(argSubObj,2)
	...s argObj=$G(^DHCINM.Arg.MgArrangeD(argId))
	...q:argObj=""
	...s argStatus=$LG(argObj,7)
	...q:((argStatus'="R")&&(argStatus'="A"))
	...s wardPostId=$LG(argSubObj,7)
	...i $LG(argSubObj,27)="" d
	....s postData=..GetArgDescAndColor(wardPostId)
	...e  i ($LG(argSubObj,27)="Y") d               ////加减班处理
	....s postData=$fn(($zth($LG(argSubObj,9),1)-$zth($LG(argSubObj,8),1))/3600,"",1)
	...e  i ($LG(argSubObj,27)="N") d
	....s postData="-"_$fn(($zth($LG(argSubObj,9),1)-$zth($LG(argSubObj,8),1))/3600,"",1)
	...q:postData=""
	...i dateDataFlag=0  d
	....s dateData=postData
	...e  d
	....s dateData=dateData_"「"_postData
	...s dateDataFlag=1
	...s tmpRetObj=##class(%ArrayOfDataTypes).%New()
	...d tmpRetObj.SetAt($p(postData,"」"),"Desc")
	...d tmpRetObj.SetAt($p(postData,"」",2),"BgColor")
	...d tmpRetObj.SetAt($p(postData,"」",3),"FontColor")
	...d tmpRet.Insert(tmpRetObj)
	.w:appFlag'=1 """"_dateData_""""
	.d appRet.SetAt(tmpRet,$zd(date,3))
	w:appFlag'=1 "}"
	q:appFlag=1 appRet
	q ""
}

/// Description：查询此时各级护理人数
/// Date:2021-04-20
/// Creator:lulin
/// Table:
/// Input: 用户id
/// Output:
/// Other:w ##class(web.INMPlatform).GetCareLevelData(0,2)
ClassMethod GetCareLevelData(nurseid, ward As %String = "") As %String
{
	s firstCare=0,secondCare=0,threeCase=0,sepcial=0 //一级 二级 特级护理
	k tmpWard
	s tmpWard=""
	s isAll=##class(INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s RowID="" f  s RowID=$O(^CF.DHCINM.DB.MgWardD(RowID)) q:RowID=""  d
	.s wardLB=$g(^CF.DHCINM.DB.MgWardD(RowID))
	.q:wardLB=""
	.q:((ward'="")&&(RowID'=ward))
	.q:((isAll=0)&&('$d(tmpWard(RowID))))
	.s stDate=$lg(wardLB,11)
	.s endDate=$lg(wardLB,12)
	.q:((stDate'="")&&(stDate>+$H))
	.q:((endDate'="")&&(endDate<+$H))
	.s CtLocId=$lg(wardLB,2)
	.q:CtLocId=""
	.s wardID=$o(^PAWARD(0,"WARD_LocationDR",CtLocId,""))
	.q:wardID=""
	.s roomID=0 f  s roomID=$o(^PAADMi("CurrWard",wardID,roomID)) q:roomID=""  d
	..s episodeID=0 f  s episodeID=$o(^PAADMi("CurrWard",wardID,roomID,episodeID)) q:episodeID=""  d
    ...s padmType=$p($g(^PAADM(episodeID)),"^",2) //就诊类型
    ...q:padmType'="I"
    ...s patVisit=$p($g(^PAADM(episodeID)),"^",20) //获取在院状态
    ...q:patVisit'="A" //过滤掉不是在院状态的记录
    ...s flag=##class(web.INMHISComm).getPatCareLevel(episodeID,+$H)
    ...i flag["一级" s firstCare=firstCare+1
    ...e  i flag["二级" s secondCare=secondCare+1
    ...e  i flag["三级" s threeCase=threeCase+1
    ...e  i flag["特级" s sepcial=sepcial+1
	q sepcial_"^"_firstCare_"^"_secondCare_"^"_threeCase
}

/// creator: lulin
/// createDate: 2021-04-26
/// description: 获取实时床护比
/// table: 
/// input:
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.INMPlatform","FindRealBedPR",0,"1")
Query FindRealBedPR(nurseid As %String = "", type As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRealBedPRExecute(ByRef qHandle As %Binary, nurseid As %String = "", type As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	k tmpWard
	s tmpWard=""
	s isAll=##class(INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s aRealBedNum=0,aPatNum=0,aNurseNum=0
	s spell="" f  s spell=$O(^CF.DHCINM.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s rowid="" f  s rowid=$O(^CF.DHCINM.DB.MgWardI("Spell",spell,rowid)) q:rowid=""  d
	..s objLB=$g(^CF.DHCINM.DB.MgWardD(rowid))
	..q:objLB=""
	..q:((isAll=0)&&('$d(tmpWard(rowid))))
	..s wardClass=$LG(objLB,5),wardClassDesc=""
	..s:wardClass'="" wardClassDesc=$LG($g(^CT.DHCINM.Set.MgSysParamSubD($P(wardClass,"||",1),$P(wardClass,"||",2))),3)
	..q:wardClassDesc'["病区"
	..s WardDesc=$lg(objLB,4)
	..s realBedNum=##class(web.INMHISComm).GetWardBedData(+$H,rowid)
	..q:(realBedNum<1)
	..s PatNum=##class(web.INMHISComm).GetWardBedUsedNum(rowid) ;##class(web.INMHISComm).GetWardPatNum(rowid,1)
	..s NurseNum=..GetNurseNum(rowid)
	..s RealBedPR="无效值"
	..i ((NurseNum'=0)&&(realBedNum'=0)) d
	...s pr=$fn(NurseNum/realBedNum,"",3)
	...s RealBedPR="1:"_pr
	..s OccupiyBedRate="无效值"
	..i ((realBedNum'=0)&&(PatNum'=0)) d
	...s OccupiyBedRate=($fn(PatNum/realBedNum,"",3)*100)_"%"
	..s ret="WardDesc|"_WardDesc_"^NurseNum|"_NurseNum_"^RealBedNum|"_realBedNum_"^RealBedPR|"_RealBedPR
	..s ret=ret_"^OccupiyBedRate|"_OccupiyBedRate
	..s aRealBedNum=realBedNum+aRealBedNum
	..s aPatNum=aPatNum+PatNum
	..s aNurseNum=aNurseNum+NurseNum
	..d OutRealBedPR
	s RealBedPR="无效值"
	i ((aNurseNum'=0)&&(aRealBedNum'=0)) d
	.s pr=$fn(aNurseNum/aRealBedNum,"",3)
	.s RealBedPR="1:"_pr
	s OccupiyBedRate="无效值"
	i ((aRealBedNum'=0)&&(aPatNum'=0)) d
	.s OccupiyBedRate=($fn(aPatNum/aRealBedNum,"",3)*100)_"%"
	s ret="WardDesc|总计^NurseNum|"_aNurseNum_"^RealBedNum|"_aRealBedNum_"^RealBedPR|"_RealBedPR
	_"^OccupiyBedRate|"_OccupiyBedRate
	d OutRealBedPR
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRealBedPR
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRealBedPRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRealBedPRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRealBedPRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRealBedPRExecute ]
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

/// creator: lulin
/// createDate: 2021-04-26
/// description: 获取实时在职护士数
/// table: 
/// input:
/// output:
/// other:
ClassMethod GetNurseNum(ward) As %String
{
	s nurNum=0
	s prw="" f  s prw=$o(^CF.DHCINM.HR.PersonsI("DepID"," "_ward,prw)) q:prw=""  d
	.s objLB=$g(^CF.DHCINM.HR.PersonsD(prw))
	.q:objLB=""
	.s perType=$lg(objLB,25)
	.q:perType'="N"
	.s PerCareType=$lg(objLB,8)
	.q:PerCareType'="N"
	.s PerStatus=$lg(objLB,42)
	.s perStateDate=$lg(objLB,43)
	.s perStatusDesc=""
	.i PerStatus'="" d
	..s perStatusDesc=$lg($g(^CT.DHCINM.DB.MgSetCodeSubD($P(PerStatus,"||",1),$P(PerStatus,"||",2))),3)
	.q:((perStatusDesc'["在职")&&(perStateDate<=+$H)) 
	.s PerRegRegiDate="",IsRegister="N" ;是否是注册护士
	.s RegisterID="" f  s RegisterID=$O(^DHCINM.HR.MgQualRegistedI("Assid"," "_prw," A",RegisterID)) q:((RegisterID="")||(IsRegister="Y"))  d
	..s RegisterLB=$G(^DHCINM.HR.MgQualRegistedD(RegisterID))
	..q:RegisterLB=""
	..s RegistedStatus=$Lg(RegisterLB,2)
	..q:RegistedStatus'="A"
	..s tPerRegRegiDate=$LG(RegisterLB,3)
	..q:tPerRegRegiDate>+$H
	..s IsRegister="Y"
	.s PerRegNo=$Lg(objLB,15)
	.s:PerRegNo'="" IsRegister="Y"
	.q:IsRegister'="Y"
	.s nurNum=nurNum+1	
	q nurNum
}

/// creator: lulin
/// createDate: 2021-04-27
/// description: 保存我的日程
/// table: 
/// input:
/// output:
/// other:
ClassMethod SaveSchedule(parr) As %String
{
	s ^TEMP("SaveSchedule")=parr
	k tmp
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	b ;011
	s DataUser=$g(tmp("DataUser"))
	s DataDate=$g(tmp("DataDate"))
	s DataTitle=$g(tmp("DataTitle"))
	s DataContext=$replace($g(tmp("DataContext")),$c(10),"★") //使用★替换$c(10)
	s DataColor=$g(tmp("DataColor"))
	if DataDate["-" d
	.s DataDate=$zdh(DataDate,3)
	e  s DataDate=""
	q:(DataUser="") "获取登录人信息失败,请刷新重试"
	q:(DataDate="") "日程日期获取失败,请刷新重试"
	s oldRw=$O(^DHCINM.PF.MgScheduleI("PerDate",DataUser,DataDate,""))
	i oldRw'="" d
	.s obj=##class(DHCINM.PF.MgSchedule).%OpenId(oldRw)
	e  d
	.s obj=##class(DHCINM.PF.MgSchedule).%New()
	.s obj.DataUser=DataUser
	.s obj.DataDate=DataDate
	s obj.DataTitle=DataTitle
	s obj.DataContext=DataContext
	s obj.DataColor=DataColor
	TS
	s sc=$$$ISOK(obj.%Save())
	if sc{
		TC
		q 1	
	}else{
		TRO
		q "保存失败"	
	}
}

/// creator: lulin
/// createDate: 2021-04-27
/// description: 获取我的日程
/// table: 
/// input:
/// output:
/// other: 使用$c(10) 替换 字符串中的★ 保证页面支持换行
ClassMethod GetSchedule(date As %String = "", loginID As %String = "") As %String
{
	s date=$zdh(date,3)
	q:((date="")||(loginID="")) ""
	s id=$O(^DHCINM.PF.MgScheduleI("PerDate",loginID,date,""))
	s obj=##class(DHCINM.PF.MgSchedule).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret="DataUser|"_obj.DataUser_"^DataDate|"_$zd(obj.DataDate,3)_"^DataTitle|"_obj.DataTitle
	_"^DataContext|"_$replace(obj.DataContext,"★",$c(10))_"^DataColor|"_obj.DataColor
	q ret
}

/// creator: lulin
/// createDate: 2021-04-27
/// description: 删除我的日程
/// table: 
/// input:
/// output:
/// other:
ClassMethod DeleteSchedule(date As %String = "", loginID As %String = "") As %String
{
	s date=$zdh(date,3)
	s id=$O(^DHCINM.PF.MgScheduleI("PerDate",loginID,date,""))
	q:id="" "0"
	d ##class(DHCINM.PF.MgSchedule).%DeleteId(id)
	q 1
}

/// Description：查询个人日程
/// Date:2021-04-27
/// Creator:lulin
/// Table:DHCINM.PF.MgSchedule
/// Input: 
/// Output:
/// Other:w ##class(web.INMPlatform).FindUserScheduleList("2021-04-01",0)
ClassMethod FindUserScheduleList(parr As %String = "", loginID As %String = "") As %String
{
	s ret=""
	s startDate=$P(parr,"^",1)
	i startDate["-" d
	.s startDate=$zdh(startDate,3)
	e  d
	.s startDate=""
	if ((startDate="")||(loginID="")){
		q "{}"
	}
	w "{"
	s endDate=startDate+41
	f date=startDate:1:endDate d
	.w:date'=startDate ","
	.w """"_$zd(date,3)_""":"
	.s dateData=""
	.s id=$O(^DHCINM.PF.MgScheduleI("PerDate",loginID,date,""))
	.i id'="" d
	..s objLB=$g(^DHCINM.PF.MgScheduleD(id))
	..s dateData=""
	..i objLB'="" d
	...s title=$Lg(objLB,4)
	...s context=$replace($lg(objLB,5),"★","\n") //
	...s bgColor=$lg(objLB,6)
	...s fontColor=""
	...s:bgColor'="" fontColor="#FFFFFF"
	...s dateData=title_"」"_bgColor_"」"_fontColor_"」"_context
	.w """"_dateData_""""
	w "}"
	q ""
}

/// creator: lulin
/// createDate: 2021-04-30
/// description: 保存通知公告
/// table: 
/// input:
/// output:
/// other:
ClassMethod SaveWorkNotice(parr As %String = "", context As %String = "", loginID As %String = "") As %String
{
	k tmp
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s rw=$g(tmp("rw"))
	s nowDate=+$H
	s nowTime=$P($H,",",2)
	s error=""
	i rw="" d
	.s obj=##class(DHCINM.PF.WorkNotice).%New()
	.s obj.NoticeCreatDate=nowDate
	.s obj.NoticeCreatTime=nowTime
	.s obj.NoticeCreator=loginID
	e  d
	.s obj=##class(DHCINM.PF.WorkNotice).%OpenId(rw)
	.s:obj.NoticeCreator'=loginID error="非本人不可修改"
	q:error'="" error
	s error="已提交,不可重复提交"
	s NoticeStatus=$g(tmp("NoticeStatus"))
	s:NoticeStatus="N" error="已提交,不可修改"
	q:obj.NoticeStatus="Y" error
	s obj.NoticeStatus=NoticeStatus
	s obj.NoticeTitle=$g(tmp("NoticeTitle"))
	s obj.NoticeLevel=$g(tmp("NoticeLevel"))
	i $g(tmp("NoticeDate"))["-" d
	.s obj.NoticeDate=$zdh($g(tmp("NoticeDate")),3)
	e  d
	.s obj.NoticeDate=""
	i $g(tmp("NoticeTime"))[":" d
	.s obj.NoticeTime=$zth($g(tmp("NoticeTime")))
	e  d
	.s obj.NoticeTime=""
	s obj.NoticeWard=$g(tmp("NoticeWard"))
	i $CLASSNAME(context)["CSP.CharacterStream" {
		d obj.NoticeContext.CopyFromAndSave(context)
	}else {
		d obj.NoticeContext.Write(context)
	}
	i NoticeStatus="Y" d
	.s obj.NoticePubLishDate=nowDate
	.s obj.NoticePubLishTime=nowTime
	
	TS
	s sc=$$$ISOK(obj.%Save())
	if 'sc{
		TRO
		q "保存失败"
	}
	k tmpWard
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	i NoticeStatus="Y" d
	.;保存子表接收人员数据
	.s depID="" f  s depID=$O(^CF.DHCINM.HR.PersonsI("DepID",depID)) q:((depID="")||('sc))  d
	..s wardID=$tr(depID," ","")
	..q:wardID=""
	..q:((isAll'=1)&&('$d(tmpWard(wardID))))
	..q:((obj.NoticeWard'="")&&($LF($LFS(obj.NoticeWard,","),wardID)<=0))
	..s perDR="" f  s perDR=$O(^CF.DHCINM.HR.PersonsI("DepID",depID,perDR)) q:((perDR="")||('sc))  d
	...s userDR=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perDR,""))
	...q:userDR=""
	...s userObj=##class(CF.DHCINM.DB.MgUser).%OpenId(userDR)
	...q:'$IsObject(userObj)
	...q:($d(^DHCINM.PF.WorkNoticeSubI("User",obj.%Id(),userDR)))
	...s subObj=##class(DHCINM.PF.WorkNoticeSub).%New()
	...s subObj.Parref=obj
	...s subObj.NoticeUser=userObj
	...s sc=$$$ISOK(subObj.%Save())
	if sc{
		TC
		q obj.%Id()	
	}else{
		TRO
		q "保存通知人员子表失败"	
	}
}

/// creator: lulin
/// createDate: 2021-04-30
/// description: 删除通知公告
/// table: 
/// input:
/// output:
/// other:
ClassMethod DelWorkNotice(rw As %String = "", loginID As %String = "") As %String
{
	q:rw="" "获取数据失败，请刷新重试"
	q:loginID="" "获取数据失败，请刷新重试"
	s obj=##class(DHCINM.PF.WorkNotice).%OpenId(rw)
	q:'$IsObject(obj) "获取数据失败，请刷新重试"
	q:obj.NoticeCreator'=loginID "非本人不可删除"
	q:obj.NoticeStatus="Y" "已发布不可删除"
	d obj.%DeleteId(rw)
	q 1
}

/// creator: lulin
/// createDate: 2021-04-30
/// description: 保存通知公告文件路径
/// table: 
/// input:
/// output:
/// other:
ClassMethod SaveWorkNoticeFileUrl(parr As %String = "") As %String
{
	s rw=$P(parr,"^",1)
	s url=$p(parr,"^",2)
	s obj=##class(DHCINM.PF.WorkNotice).%OpenId(rw)
	q:'$IsObject(obj) "0"
	d obj.NoticeFileUrl.Insert(url)
	s sc=obj.%Save()
	i $$$ISOK(sc){
		q 1	
	}else{
		q 0
	}
}

/// creator: lulin
/// createDate: 2021-04-30
/// description: 获取通知公告
/// table: 
/// input:
/// output:
/// other:
ClassMethod GetWorkNotice(rw As %String = "", flag As %String = "") As %String
{
	s obj=##class(DHCINM.PF.WorkNotice).%OpenId(rw)
	q:'$IsObject(obj) ""
	s NoticeLevel=obj.NoticeLevel
	s NoticeLevelDesc="",NoticeLevelColor=""
	i NoticeLevel'="" d
	.s codeObj=$G(^CT.DHCINM.DB.MgSetCodeSubD($P(NoticeLevel,"||",1),$P(NoticeLevel,"||",2)))
	.s NoticeLevelDesc=$LG(codeObj,3)
	.s NoticeLevelColor=$LG(codeObj,4)
	s NoticeDate=obj.NoticeDate
	s NoticeTime=obj.NoticeTime
	s:NoticeDate'="" NoticeDate=$zd(NoticeDate,3)
	s:NoticeTime'="" NoticeTime=$zt(NoticeTime)
	s NoticeWard=obj.NoticeWard
	s NoticeFileUrl=""
	f i=1:1:obj.NoticeFileUrl.Count()  d
	.s tUrl=obj.NoticeFileUrl.GetAt(i)
	.q:tUrl=""
	.i NoticeFileUrl="" s NoticeFileUrl=tUrl
	.e  s NoticeFileUrl=NoticeFileUrl_","_tUrl
	s NoticeStatus=obj.NoticeStatus
	s NoticeStatusDesc=$case(NoticeStatus,"Y":"发布","N":"保存",:"保存")
	s NoticeCreator=obj.NoticeCreator,NoticeCreatorDesc=""
	i NoticeCreator=0 d
	.s NoticeCreatorDesc="超级管理员"
	e  d
	.s NoticeCreatorDesc=##class(web.INMPersonComm).GetUserInfo(NoticeCreator)
	s NoticePubLishDate=obj.NoticePubLishDate
	s NoticePubLishTime=obj.NoticePubLishTime
	s:NoticePubLishDate'="" NoticePubLishDate=$zd(NoticePubLishDate,3)
	s:NoticePubLishTime'="" NoticePubLishTime=$zt(NoticePubLishTime)
	if flag=1{
		w "{""rw"":"""_rw_""",""NoticeTitle"":"""_obj.NoticeTitle_""",""NoticeLevel"":"""_NoticeLevel_""""
		w ",""NoticeDate"":"""_NoticeDate_""",""NoticeTime"":"""_NoticeTime_""",""NoticeWard"":"""_NoticeWard_""""
		w ",""NoticeFileUrl"":"""_NoticeFileUrl_""",""NoticeStatus"":"""_NoticeStatus_""""
		w ",""NoticeCreator"":"""_NoticeCreator_""",""NoticeContext"":"""
		while ('obj.NoticeContext.AtEnd){
			w $replace($zcvt($tr(obj.NoticeContext.Read(),$c(10,13)),"O","JS"),"\'","'")
		}
		w """}"
		q ""
	}else{
		s ret="rw|"_rw_"^NoticeTitle|"_obj.NoticeTitle_"^NoticeLevel|"_NoticeLevel_"^NoticeLevelDesc|"_NoticeLevelDesc
		s ret=ret_"^NoticeDate|"_NoticeDate_"^NoticeTime|"_NoticeTime_"^NoticeWard|"_NoticeWard
		s ret=ret_"^NoticeFileUrl|"_NoticeFileUrl_"^NoticeStatus|"_NoticeStatus_"^NoticeStatusDesc|"_NoticeStatusDesc
		s ret=ret_"^NoticeCreatorDesc|"_NoticeCreatorDesc_"^NoticePubLishDate|"_NoticePubLishDate_"^NoticePubLishTime|"_NoticePubLishTime
		s ret=ret_"^NoticeLevelColor|"_NoticeLevelColor
		q ret
	}
}

/// creator: lulin
/// createDate: 2021-04-30
/// description: 删除通知公告文件路径
/// table: 
/// input:
/// output:
/// other:
ClassMethod DelWorkNoticeFileUrl(rw As %String = "", fileUrl As %String = "", loginID As %String = "") As %String
{
	q:rw="" "数据获取失败,请刷新重试"
	s obj=##class(DHCINM.PF.WorkNotice).%OpenId(rw)
	q:'$IsObject(obj) "数据获取失败,请刷新重试"
	s removeIndex=obj.NoticeFileUrl.Find(fileUrl)
	q:removeIndex<1 1
	d obj.NoticeFileUrl.RemoveAt(removeIndex)
	d obj.%Save()
	q 1
}

/// creator: lulin
/// createDate: 2021-04-30
/// description: 获取通知公告列表
/// table: 
/// input:
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.INMPlatform","FindWorkNotice","N","",0)
Query FindWorkNotice(parr As %String = "", input As %String = "", loginID As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWorkNoticeExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if loginID=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s status=$P(parr,"^",1)
	s ret=""
	s NoticeDate="" f  s NoticeDate=$O(^DHCINM.PF.WorkNoticeI("Creator"," "_loginID,NoticeDate),-1) q:NoticeDate=""  d
	.s rw="" f  s rw=$O(^DHCINM.PF.WorkNoticeI("Creator"," "_loginID,NoticeDate,rw),-1) q:rw=""  d
	..s objLB=$G(^DHCINM.PF.WorkNoticeD(rw))
	..q:objLB=""
	..s title=$lg(objLB,2)
	..s tStatus=$lg(objLB,9)
	..q:((status'="")&&(status'=tStatus))
	..q:((input'="")&&(($zcvt(title,"U"))'[($zcvt($tr(input," ",""),"U"))))
	..s ret=..GetWorkNotice(rw,0)
	..d OutRowData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWorkNoticeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkNoticeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWorkNoticeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkNoticeExecute ]
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

/// creator: lulin
/// createDate: 2021-04-30
/// description: 获取个人通知信息
/// table: 
/// input:
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.INMPlatform","FindWorkNoticeByUser","2",0)
Query FindWorkNoticeByUser(parr As %String = "", loginID As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWorkNoticeByUserExecute(ByRef qHandle As %Binary, parr As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if loginID=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s noReadFlag=$P(parr,"^",1) ;只取设置时限内的且未读
	s ret=""
	s NoticeDay=$Lg($g(^CT.DHCINM.Set.MgArgParamSetD(1)),27)
	s NoticeShowDay=$Lg($g(^CT.DHCINM.Set.MgArgParamSetD(1)),28)
	s:NoticeShowDay="" NoticeShowDay=700
	s NoticeDate="" f  s NoticeDate=$O(^DHCINM.PF.WorkNoticeI("DateTime",NoticeDate),-1) q:NoticeDate=""  d
	.s NoticeTime="" f  s NoticeTime=$O(^DHCINM.PF.WorkNoticeI("DateTime",NoticeDate,NoticeTime),-1) q:NoticeTime=""  d
	..s rw="" f  s rw=$O(^DHCINM.PF.WorkNoticeI("DateTime",NoticeDate,NoticeTime,rw)) q:rw=""  d
	...s objLB=$g(^DHCINM.PF.WorkNoticeD(rw))
	...q:objLB=""
	...s tStatus=$lg(objLB,9)
	...q:tStatus'="Y"
	...s subRw=$O(^DHCINM.PF.WorkNoticeSubI("User",rw,loginID,""))
	...s subObjLB=""
	...s:subRw'="" subObjLB=$G(^DHCINM.PF.WorkNoticeSubD(rw,subRw))
	...q:((loginID'=0)&&(subObjLB="")) ;无查看权限
	...s LookDate="",LookTime=""
	...i subObjLB'="" d
	....s LookDate=$lg(subObjLB,3)
	....s LookTime=$lg(subObjLB,4)
	...s overDueFlag=0 ;是否超期
	...s:((NoticeDate+NoticeDay)<(+$H)) overDueFlag=1
	...q:((NoticeDate+NoticeShowDay)<(+$H)) ;超过显示天数不做显示
	...s:LookDate'="" LookDate=$zd(LookDate,3)
	...s:LookTime'="" LookTime=$zt(LookTime)
	...s readStatus="未读",readStatusColor="#FF0000",tReadFlag=1
	...i LookDate'="" d
	....s readStatus="已读",readStatusColor="#4CAE4C",tReadFlag=2
	...e  d
	....s:overDueFlag readStatus="过期",readStatusColor="#747474",tReadFlag=2
	...q:(noReadFlag'=tReadFlag)
	...s ret=..GetWorkNotice(rw,0)
	...s ret=ret_"^readStatus|"_readStatus_"^readStatusColor|"_readStatusColor
	...d OutRowData
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWorkNoticeByUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkNoticeByUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWorkNoticeByUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkNoticeByUserExecute ]
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

/// creator: lulin
/// createDate: 2021-04-30
/// description: 获取个人通知信息
/// table: 
/// input:
/// output:
/// other:
ClassMethod SetLookNotice(rw As %String = "", loginID As %String)
{
	q:((rw="")||(loginID="")) "入参为空"
	s subRw=$O(^DHCINM.PF.WorkNoticeSubI("User",rw,loginID,""))
	q:subRw="" "未查询到有效信息"
	s subObj=##class(DHCINM.PF.WorkNoticeSub).%OpenId(rw_"||"_subRw)
	q:'$IsObject(subObj) "未查询到有效信息"
	s subObj.LookDate=+$H
	s subObj.LookTime=$P($H,",",2)
	d subObj.%Save()
	q 1
}

/// creator: lulin
/// createDate:2021-05-25
/// description:保存消息追踪
/// table: 
/// input:userID:接收人用户表id,date：追踪接收日期,可默认当前,title:追踪显示标签，context:详细内容
/// output:
/// other:d ##class(web.INMPlatform).SaveTrackMessage(0,+$H,"ces4","ceshi4","","")
ClassMethod SaveTrackMessage(userID As %String = "", date As %Date, title As %String = "", context As %String = "", tableName As %String = "", tableID As %String = "") As %String
{
	s $ZT="ERROR"
	s:date["-" date=$zdh(date,3)
	q:((userID="")||('(date?1n.n))) 0
	s obj=##class(DHCINM.PF.TrackMessage).%New()
	s obj.MessagePer=userID
	s obj.MessageDate=date
	s obj.MessageStatus="N"
	s obj.MessageTitle=title
	s obj.MessageContext=context
	s obj.MessageTableName=tableName
	s obj.MessageTableID=tableID
	d obj.%Save()
	q 1
ERROR
	q 0
}

/// creator: lulin
/// createDate: 2021-05-25
/// description: 设置追踪已读
/// table: 
/// input:rw^rw
/// output:
/// other:
ClassMethod MarkReadMessage(rws) As %String
{
	q:rws="" "入参不能为空"
	f i=1:1:$L(rws,",") d
	.s rw=$P(rws,",",i)
	.q:rw=""
	.s obj=##class(DHCINM.PF.TrackMessage).%OpenId(rw)
	.q:'$IsObject(obj)
	.s obj.MessageStatus="Y"
	.s obj.ReadDate=+$H
	.s obj.ReadTime=$P($H,",",2)
	.d obj.%Save()
	.d obj.%Save()
	q 1
}

/// creator: lulin
/// createDate: 2021-04-30
/// description: 获取个人追踪信息
/// table: 
/// input:
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.INMPlatform","FindTrackMessageByUser","N","",0)
Query FindTrackMessageByUser(parr As %String = "", input As %String = "", loginID As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindTrackMessageByUserExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	if loginID=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s selStatus=parr
	s date="" f  s date=$O(^DHCINM.PF.TrackMessageI("perDate",loginID,date),-1) q:date=""  d
	.s rw="" f  s rw=$O(^DHCINM.PF.TrackMessageI("perDate",loginID,date,rw)) q:rw=""  d
	..s objLB=$g(^DHCINM.PF.TrackMessageD(rw))
	..q:objLB=""
	..s status=$lg(objLB,4)
	..q:((selStatus'="")&&(status'=selStatus))
	..s title=$lg(objLB,7)
	..s titleShell=##class(web.INMVueComm).ToChineseSpell(title)
	..q:((input'="")&&($zcvt(title_titleShell,"U")'[$zcvt(input,"U")))
	..s context=$lg(objLB,8)
	..s retDate=$zd(date,3)
	..s readDate=$lg(objLB,5)
	..s:readDate'="" readDate=$zd(readDate,3)
	..s readTime=$lg(objLB,6)
	..s:readTime'="" readTime=$zt(readTime)
	..s statusDesc=$case(status,"N":"未读","Y":"已读",:"")
	..s ret="rw|"_rw_"^date|"_retDate_"^title|"_title_"^context|"_context_"^readDate|"_readDate_"^readTime|"_readTime
	..s ret=ret_"^status|"_status
	..d OutRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTrackMessageByUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTrackMessageByUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTrackMessageByUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTrackMessageByUserExecute ]
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

/// creator: lulin
/// createDate: 2021-06-08
/// description: 获取个人审批事项数量
/// table: 
/// input:
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.INMPlatform","FindApprovalByUser","","",0)
Query FindApprovalByUser(parr As %String = "", input As %String = "", loginID As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindApprovalByUserExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	if loginID=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	k tmpWard
	s tmpWard=""
	s isAll=..SetLoginWard(loginID,.tmpWard)
	s levelParID=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," 消息等级",""))
	if levelParID=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s levelSort="" f  s levelSort=$O(^CT.DHCINM.DB.MgSetCodeSubI("Sort",levelParID,levelSort)) q:levelSort=""  d
	.s levelID="" f  s levelID=$O(^CT.DHCINM.DB.MgSetCodeSubI("Sort",levelParID,levelSort,levelID)) q:levelID=""  d
	..s ApprovalLevel=" "_levelParID_"||"_levelID
	..s ApprovalLevelDesc="",ApprovalLevelColor=""
	..s codeObj=$G(^CT.DHCINM.DB.MgSetCodeSubD(levelParID,levelID))
	..s ApprovalLevelDesc=$LG(codeObj,3)
	..s ApprovalLevelColor=$LG(codeObj,4)
	..d LevelRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
LevelRowData
	s ApprovalType="" f  s ApprovalType=$O(^CT.DHCINM.Set.ApprovalSetI("LevelType",ApprovalLevel," Y",ApprovalType)) q:ApprovalType=""  d
	.s realApprovalType=$tr(ApprovalType," ","")
	.q:realApprovalType="B"
	.s rw="" f  s rw=$O(^CT.DHCINM.Set.ApprovalSetI("LevelType",ApprovalLevel," Y",ApprovalType,rw)) q:rw=""  d
	..s objLB=$g(^CT.DHCINM.Set.ApprovalSetD(rw))
	..q:objLB=""
	..s objStatus=$lg(objLB,5)
	..q:objStatus'="Y"
	..s ApprovalName=$lg(objLB,2)
	..s ApprovalCls=$lg(objLB,9)
	..q:ApprovalCls=""
	..s dataGlobal="^"_ApprovalCls_"D"
	..s LimitType=$lg(objLB,10) ;W：病区，U:用户，P：档案
	..s LimitNum=$lg(objLB,11)
	..s LimitDateType=$lg(objLB,12) ;N:当前，W:表数据
	..s LimitDateNum=$lg(objLB,13)
	..s keyId="" f  s keyId=$O(^CT.DHCINM.Set.ApprovalSetKeyD(rw,keyId)) q:keyId=""  d
	...s keyObjLB=$g(^CT.DHCINM.Set.ApprovalSetKeyD(rw,keyId))
	...q:keyObjLB=""
	...s keyStatus=$lg(keyObjLB,14)
	...q:keyStatus'="Y"
	...s desc=$lg(keyObjLB,2)
	...s statusNum=$lg(keyObjLB,3)
	...q:statusNum=""
	...s status=$lg(keyObjLB,4)
	...s statusLB=$LFS(status,",")
	...s otherNum=$lg(keyObjLB,15)
	...s otherStatus=$lg(keyObjLB,16)
	...s ApprovalIcon=$lg(objLB,19)
	...s FtColor=$lg(objLB,20)
	...s BgColor=$lg(objLB,21)
	...s roles=$LG(keyObjLB,6)
	...s num=0
	...s dataId="" f  s dataId=$O(@dataGlobal@(dataId)) q:dataId=""  d
	....s dataObjLB=@dataGlobal@(dataId)
	....q:dataObjLB=""
	....s tStatus=$lg(dataObjLB,statusNum)
	....q:$LF(statusLB,tStatus)<1
	....s tOtherStatus=""
	....s:otherNum'="" tOtherStatus=$lg(dataObjLB,otherNum)
	....q:((otherNum'="")&&(tOtherStatus'=otherStatus))
	....s dataWardID="" ;数据归属病区
	....s LimitNumData=""
	....s:LimitNum'="" LimitNumData=$LG(dataObjLB,LimitNum)
	....i LimitType="W" d
	.....s dataWardID=LimitNumData
	....e  i ((LimitType="U")||(LimitType="P")) d
	.....s perID=""
	.....i LimitType="P" d
	......s perID=LimitNumData
	.....e  d
	......s:LimitNumData'="" perID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_LimitNumData,""))
	.....i perID'=""  d
	......s roleDate=$LG(dataObjLB,LimitDateNum)
	......s dataWardID=$LG($g(^CF.DHCINM.HR.PersonsD(perID)),10)
	......i ((LimitDateType'="N")&&(roleDate'="")) d
	.......s dataWardID=##class(web.INMHRComm).GetCurrentWard(perID,roleDate)
	....s noRoleFlag=0
	....s:loginID=0 noRoleFlag=1
	....f roleIndex=1:1:$l(roles,",") q:noRoleFlag=1  d
	.....s tRole=$P(roles,",",roleIndex)
	.....q:tRole=""
	.....q:((LimitNum'="")&&(dataWardID=""))
	.....q:((dataWardID'="")&&('$d(tmpWard(tRole,dataWardID))))
	.....s noRoleFlag=1
	....q:noRoleFlag=0
	....s num=num+1
	...q:num=0
	...s ApprovalRouter=$lg(objLB,8)
	...s MenuID="",MenuRouter="",params="",MenuName="",MenuCode=""
	...i ApprovalRouter'="" d
	....s menuObj=$g(^CT.DHCINM.Set.MgMenuD(ApprovalRouter))
	....s modelID=$lg(menuObj,4)
	....s MenuID=modelID_"-"_ApprovalRouter
	....s MenuRouter=$lg(menuObj,6)
	....s params=$lg(menuObj,8)
	....s MenuName=$lg(menuObj,3)
	....s MenuCode=$lg(menuObj,2)
	...s ret="desc|"_desc_"^keyID|"_rw_"||"_keyId_"^num|"_num_"^Color|"_ApprovalLevelColor_"^Type|"_realApprovalType_"^rw|"_rw_"^ApprovalIcon|"_ApprovalIcon_"^FtColor|"_FtColor_"^BgColor|"_BgColor
	...s ret=ret_"^MenuID|"_MenuID_"^Router|"_MenuRouter_"^params|"_params_"^MenuName|"_MenuName_"^MenuCode|"_MenuCode
	...d OutRowData
	
	s rw="" f  s rw=$O(^CT.DHCINM.Set.ApprovalSetI("LevelType",ApprovalLevel," Y"," B",rw)) q:rw=""  d
	.s objLB=$g(^CT.DHCINM.Set.ApprovalSetD(rw))
	.q:objLB=""
	.s objStatus=$lg(objLB,5)
	.q:objStatus'="Y"
	.s desc=$lg(objLB,2)
	.s ApprovalClass=$lg(objLB,6)
	.s ApprovalMethod=$lg(objLB,7)
	.s ApprovalRouter=$lg(objLB,8)
	.s ApprovalMethodType=$lg(objLB,17,"M")
	.s ApprovalParameter=$lg(objLB,18)
	.s ApprovalIcon=$lg(objLB,19)
	.s FtColor=$lg(objLB,20)
	.s BgColor=$lg(objLB,21)
	.k tmpParam
	.s tmpParam=$ll(ApprovalParameter)
	.s paramIndex=0 
	.s ptr=0 f  s status=$listnext(ApprovalParameter,ptr,param) q:status'=1  d
	..s paramIndex=paramIndex+1
	..s:param="#loginID" param=loginID //转换变量
	..s:param="#Date" param=+$h 
	..s tmpParam(paramIndex)=param
	.q:((ApprovalClass="")||(ApprovalMethod=""))
	.s num=0
	.i ApprovalMethodType="M" d
	..s num=$classmethod(ApprovalClass,ApprovalMethod,tmpParam...)
	..;x ("(num) s num = ##class("_ApprovalClass_")."_ApprovalMethod_"("""_ApprovalParameter_""")",.num) 
	.i ApprovalMethodType="Q" d
	..s result=##class(%ResultSet).%New(ApprovalClass_":"_ApprovalMethod)
	..d result.Execute(tmpParam...)
	..while result.%Next(){}
	..s num=result.%ROWCOUNT
	.q:num<1
	.s MenuID="",MenuRouter="",params="",MenuName="",MenuCode=""
	.i ApprovalRouter'="" d
	..s menuObj=$g(^CT.DHCINM.Set.MgMenuD(ApprovalRouter))
	..s modelID=$lg(menuObj,4)
	..s MenuID=modelID_"-"_ApprovalRouter
	..s MenuRouter=$lg(menuObj,6)
	..s params=$lg(menuObj,8)
	..s MenuName=$lg(menuObj,3)
	..s MenuCode=$lg(menuObj,2)
	.s ret="desc|"_desc_"^keyID|"_rw_"^num|"_num_"^Color|"_ApprovalLevelColor_"^Type|B^rw|"_rw_"^ApprovalIcon|"_ApprovalIcon_"^FtColor|"_FtColor_"^BgColor|"_BgColor
	.s ret=ret_"^MenuID|"_MenuID_"^Router|"_MenuRouter_"^params|"_params_"^MenuName|"_MenuName_"^MenuCode|"_MenuCode
	.d OutRowData
	q
}

ClassMethod FindApprovalByUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindApprovalByUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindApprovalByUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindApprovalByUserExecute ]
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

/// creator: lulin
/// createDate: 2021-06-08
/// description: 获取个人审批事项明细
/// table: 
/// input:
/// output:
/// other:d ##class(%ResultSet).RunQuery("web.INMPlatform","FindApprovalDetailByUser","40||1",0)
Query FindApprovalDetailByUser(keyID As %String = "", loginID As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindApprovalDetailByUserExecute(ByRef qHandle As %Binary, keyID As %String = "", loginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	if ((loginID="")||(keyID="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	k tmpWard
	s tmpWard=""
	s isAll=..SetLoginWard(loginID,.tmpWard)
	s rw=$P(keyID,"||",1)
	s keyId=$P(keyID,"||",2)
	s objLB=$g(^CT.DHCINM.Set.ApprovalSetD(rw))
	s keyObjLB=$g(^CT.DHCINM.Set.ApprovalSetKeyD(rw,keyId))
	if ((keyObjLB="")||(objLB="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	if $g(^DHCINM.YS)="Y" {
		i keyID="1||2" {
			s tmp(1)="rw|48^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|N^keyID|1||2^1__8|李娇^1__9|3364^1__10|内分泌科护理单元^1__11|主管护师^1__12|2022-11-30^1__13|^1__14|主管护师^1__15|2022-10-25"
		}elseif keyID="20||1" {
			s tmp(1)="rw|8^ToValue|NA^BackFlag|Y^BackToValue|B^OptionFlag|Y^keyID|20||1^20__1|武平平^20__2|1877^20__3|心内科护理单元^20__4|休假^20__5|2022-10-25^20__6|2022-10-30"
		}elseif keyID="33||1" {
			s tmp(1)="rw|2^ToValue|S^BackFlag|Y^BackToValue|B^OptionFlag|Y^keyID|33||1^33__1|实用新型专利证书^33__2|一种测试专利^33__3|专利局^33__4|123456^33__5|2022-10-25^33__6|内分泌科护理单元^33__7|李娇^33__8|2022-10-25"
		}elseif keyID="2||1" {
			s tmp(1)="rw|19^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|N^keyID|2||1^2__6|丁蓬琳^2__7|丁蓬琳^2__8|副主任^2__9|2022-08-04^2__10|2022-08-31^2__11|内分泌科护理单元"
		}elseif keyID="27||1" {
			s tmp(1)="rw|14^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|N^keyID|27||1^27__1|护理部^27__2|月度^27__3|202201^27__4|2022-07-11"
		}elseif keyID="37||1" {
			s tmp(1)="rw|1^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|Y^keyID|37||1^37__1|医技组^37__2|半年度^37__3|02^37__4|2022^37__5|高淑红^37__6|2022-07-21"
		}elseif keyID="3||1" {
			s tmp(1)="rw|33^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|N^keyID|3||1^3__1|李娇^3__2|3364^3__3|内分泌科护理单元^3__4|2022-10-25"
		}elseif keyID="4||1" {
			s tmp(1)="rw|11^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|N^keyID|4||1^4__1|丁蓬琳^4__2|1480^4__3|内分泌科护理单元^4__4|学会^4__5|32^4__6|3^4__7|2022-08-02^4__8|2022-08-06"
		}elseif keyID="5||1" {
			s tmp(1)="rw|17^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|N^keyID|5||1^5__1|丁蓬琳^5__2|1480^5__3|内分泌科护理单元^5__4|2022-07-01^5__5|业余^5__6|安徽蚌埠医学院^5__7|硕士研究生"
		}elseif keyID="6||1" {
			s tmp(1)="rw|9^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|Y^keyID|6||1^6__1|测试0715^6__2|0715^6__3|内分泌科护理单元^6__4|宁夏护理学会^6__5|伤口造口专科护士资质证^6__6|PICC专科护士^6__7|2022-07-15"
			s tmp(2)="rw|16^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|Y^keyID|6||1^6__1|测试0715^6__2|0715^6__3|内分泌科护理单元^6__4|天坛医院^6__5|PICC专科护士资质证^6__6|糖尿病专科护士^6__7|2022-07-22"
			s tmp(3)="rw|18^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|Y^keyID|6||1^6__1|闵凤英^6__2|1009^6__3|内分泌科护理单元^6__4|宁夏护理学会^6__5|PICC专科护士资质证^6__6|糖尿病专科护士^6__7|2022-07-08"
			s tmp(4)="rw|19^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|Y^keyID|6||1^6__1|zfm0711^6__2|HS0711^6__3|内分泌科护理单元^6__4|宁夏护理学会^6__5|PICC专科护士资质证^6__6|ICU专科护士^6__7|2022-07-21"
			s tmp(5)="rw|21^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|Y^keyID|6||1^6__1|王倩倩^6__2|5786^6__3|内分泌科护理单元^6__4|宁夏护理学会^6__5|PICC专科护士资质证^6__6|PICC专科护士^6__7|2022-08-01"
			s tmp(6)="rw|24^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|Y^keyID|6||1^6__1|王凯^6__2|5995^6__3|内分泌科护理单元^6__4|西安交通大学第一附属医院^6__5|伤口造口专科护士资质证^6__6|PICC专科护士^6__7|2022-08-03"
			s tmp(7)="rw|26^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|Y^keyID|6||1^6__1|徐静^6__2|2407^6__3|内分泌科护理单元^6__4|协和医院^6__5|伤口造口专科护士资质证^6__6|PICC专科护士^6__7|2022-08-01"
			s tmp(8)="rw|27^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|Y^keyID|6||1^6__1|李娇^6__2|3364^6__3|内分泌科护理单元^6__4|协和医院^6__5|PICC专科护士资质证^6__6|手术室专科护士^6__7|2022-08-02"
			s tmp(9)="rw|28^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|Y^keyID|6||1^6__1|0720zz^6__2|0720ZZ^6__3|内分泌科护理单元^6__4|宁夏护理学会^6__5|PICC专科护士资质证^6__6|PICC专科护士^6__7|2022-08-04"
			s tmp(10)="rw|29^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|Y^keyID|6||1^6__1|闵凤英^6__2|1009^6__3|内分泌科护理单元^6__4|宁夏护理学会^6__5|PICC专科护士资质证^6__6|PICC专科护士^6__7|2022-08-04"
			s tmp(11)="rw|30^ToValue|A^BackFlag|Y^BackToValue|B^OptionFlag|Y^keyID|6||1^6__1|丁蓬琳^6__2|1480^6__3|内分泌科护理单元^6__4|宁夏护理学会^6__5|PICC专科护士资质证^6__6|糖尿病专科护士^6__7|2022-08-30"
		}
		
		s tt="" f  s tt=$o(tmp(tt)) q:tt=""  d
		.s ret=tmp(tt)
		.d OutRowData
		
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ApprovalCls=$lg(objLB,9)
	s LimitType=$lg(objLB,10) ;W：病区，U:用户，P：档案
	s LimitDateType=$lg(objLB,12) ;N:当前，W:表数据
	s LimitDateNum=$lg(objLB,13)
	s dataGlobal="^"_ApprovalCls_"D"
	s statusNum=$lg(keyObjLB,3)
	s status=$lg(keyObjLB,4)
	s roles=$LG(keyObjLB,6)
	s LimitNum=$lg(objLB,11)
	s ToValue=$lg(keyObjLB,5)
	s BackFlag=$lg(keyObjLB,7)
	s BackToValue=$lg(keyObjLB,8)
	s OpinionFlag=$lg(keyObjLB,12)
	s otherNum=$lg(keyObjLB,15)
	s otherStatus=$lg(keyObjLB,16)
	s dataId="" f  s dataId=$O(@dataGlobal@(dataId)) q:dataId=""  d
	.s dataObjLB=@dataGlobal@(dataId)
	.q:dataObjLB=""
	.s tStatus=$Lg(dataObjLB,statusNum)
	.q:tStatus'=status
	.s tOtherStatus=""
	.s:otherNum'="" tOtherStatus=$lg(dataObjLB,otherNum)
	.q:((otherNum'="")&&(tOtherStatus'=otherStatus))
	.s dataWardID="" ;数据归属病区
	.s LimitNumData=""
	.s:LimitNum'="" LimitNumData=$LG(dataObjLB,LimitNum)
	.i LimitType="W" d
	..s dataWardID=LimitNumData
	.e  i ((LimitType="U")||(LimitType="P"))  d
	..s perID=""
	..i LimitType="P" d
	...s perID=LimitNumData
	..e  d
	...s:LimitNumData'="" perID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_LimitNumData,""))
	..i perID'=""  d
	...s roleDate=$LG(dataObjLB,LimitDateNum)
	...s dataWardID=$LG($g(^CF.DHCINM.HR.PersonsD(perID)),10)
	...i ((LimitDateType'="N")&&(roleDate'="")) d
	....s dataWardID=##class(web.INMHRComm).GetCurrentWard(perID,roleDate)
	.s noRoleFlag=0
	.s:loginID=0 noRoleFlag=1
	.f roleIndex=1:1:$l(roles,",") q:noRoleFlag=1  d
	..s tRole=$P(roles,",",roleIndex)
	..q:tRole=""
	..q:((LimitNum'="")&&(dataWardID=""))
	..q:((isAll'=1)&&(dataWardID'="")&&('$d(tmpWard(tRole,dataWardID))))
	..s noRoleFlag=1
	.q:noRoleFlag=0
	.s ret="rw|"_dataId_"^ToValue|"_ToValue_"^BackFlag|"_BackFlag_"^BackToValue|"_BackToValue_"^OptionFlag|"_OpinionFlag_"^keyID|"_keyID
	.s showID="" f  s showID=$O(^CT.DHCINM.Set.ApprovalSetShowD(rw,showID)) q:showID=""  d
	..s showObj=$g(^CT.DHCINM.Set.ApprovalSetShowD(rw,showID))
	..q:showObj=""
	..s globalNum=$lg(showObj,3)
	..s globalName=$lg(showObj,2)
	..s showType=$lg(showObj,6)
	..q:((globalNum="")||(showType=""))
	..s showDesc=$lg(dataObjLB,globalNum)
	..s:((showType'="S")&&(showDesc'="")) showDesc=..GetClsDescByType($lg(showObj,7), showDesc,showType,$lg(showObj,10))
	..s ret=ret_"^"_rw_"__"_showID_"|"_showDesc
	.d OutRowData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindApprovalDetailByUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindApprovalDetailByUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindApprovalDetailByUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindApprovalDetailByUserExecute ]
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

/// creator: lulin
/// createDate: 2021-06-08
/// description: 批量审批
/// table: 
/// input:
/// output:
/// other:w ##class(web.INMPlatform).SaveApprovalData(10,"22||1","A","ces","通过",0)
ClassMethod SaveApprovalData(rws As %String = "", keyID As %String = "", toValue As %String = "", option As %String = "", loginID As %String = "", toValueDesc As %String = "") As %String
{
	q:((rws="")||(keyID="")) "入参错误,请刷新重试"
	s rw=$P(keyID,"||",1)
	s keyId=$P(keyID,"||",2)
	s objLB=$g(^CT.DHCINM.Set.ApprovalSetD(rw))
	s keyObjLB=$g(^CT.DHCINM.Set.ApprovalSetKeyD(rw,keyId))
	q:((keyObjLB="")||(objLB="")) "入参错误,请刷新重试"
	s ApprovalCls=$lg(objLB,9)
	q:ApprovalCls="" "入参错误,请刷新重试"
	s dataGlobal="^"_ApprovalCls_"D"
	s KeyProperNum=$lg(keyObjLB,3)
	q:KeyProperNum="" "入参错误,请刷新重试"
	s AuditorNum=$lg(keyObjLB,9)
	s AuditDateNum=$lg(keyObjLB,10)
	s AuditTimeNum=$lg(keyObjLB,11)
	s OpinionNum=$lg(keyObjLB,13)
	s NoticeNum=$lg(objLB,14)
	s NoticeType=$lg(objLB,15)
	k messageTmp
	s messageTmp=""
	TS
	s $ZT="ERROR"
	f i=1:1:$L(rws,",") d
	.s dataRW=$P(rws,",",i)
	.q:dataRW=""
	.s dataObjLB=@dataGlobal@(dataRW)
	.q:dataObjLB=""
	.s $li(@dataGlobal@(dataRW),KeyProperNum)=toValue
	.s:AuditorNum'="" $li(@dataGlobal@(dataRW),AuditorNum)=loginID
	.s:AuditDateNum'="" $li(@dataGlobal@(dataRW),AuditDateNum)=+$H
	.s:AuditTimeNum'="" $li(@dataGlobal@(dataRW),AuditTimeNum)=$P($H,",",2)
	.s:OpinionNum'="" $li(@dataGlobal@(dataRW),OpinionNum)=option
	.d SaveTrackTmp
	d $classmethod(ApprovalCls,"%BuildIndices")
	TC
	i ((NoticeNum'="")&&($o(messageTmp(""))'="")) d
	.d SaveTrack
	q 1
ERROR
	TRO
	q "保存失败"
SaveTrackTmp
	;审批/驳回临时数据
	i NoticeNum'="" d
	.s userIDFlag=0
	.f NoticeNumIndex=1:1:$L(NoticeNum,",") d
	..s tNoticeNum=$P(NoticeNum,",",NoticeNumIndex)
	..q:tNoticeNum=""
	..s userID=$lg(dataObjLB,tNoticeNum)
	..q:userID=""
	..s:((NoticeType="P")&&(userID'="")) userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_userID,""))
	..q:userID=""
	..s messageTmp(dataRW,"User",userID)=userID
	..s userIDFlag=1
	.i userIDFlag'=0 d
	..s showID="" f  s showID=$O(^CT.DHCINM.Set.ApprovalSetShowD(rw,showID)) q:showID=""  d
	...s showObj=$g(^CT.DHCINM.Set.ApprovalSetShowD(rw,showID))
	...q:showObj=""
	...s showStatus=$lg(showObj,9)
	...q:showStatus'="Y"
	...s globalNum=$lg(showObj,3)
	...s showType=$lg(showObj,6)
	...q:((globalNum="")||(showType=""))
	...s NoticeSort=$lg(showObj,8)
	...q:NoticeSort=""
	...s showDesc=$lg(dataObjLB,globalNum)
	...i ((showType'="S")&&(showDesc'="")) d
	....s showDesc=..GetClsDescByType($lg(showObj,7), showDesc,showType,$lg(showObj,10))
	...s messageTmp(dataRW,"title",NoticeSort)=showDesc
	q 
SaveTrack
	s NoticeTitle=$lg(objLB,16)
	s dataRW="" f  s dataRW=$O(messageTmp(dataRW)) q:dataRW=""  d
	.s userID="" f  s userID=$O(messageTmp(dataRW,"User",userID)) q:userID=""  d
	..s message=""
	..s NoticeSort="" f  s NoticeSort=$O(messageTmp(dataRW,"title",NoticeSort)) q:NoticeSort=""  d
	...s tMessage=$g(messageTmp(dataRW,"title",NoticeSort))
	...q:tMessage=""
	...i message="" d
	....s message=tMessage
	...e  d
	....s message=message_" "_tMessage
	..s:message'="" message="【"_NoticeTitle_"】"_toValueDesc_" "_message
	..d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,message,message,ApprovalCls,dataRW)
	q
}

/// Creator:lulin
/// Createdate:2021-06-10
/// Description:根据type
/// Input:
/// Output:
/// Other:
ClassMethod GetClsDescByType(Foreignkey, showDesc, type, ShowKeyOption)
{
	q:((showDesc="")||(type="")) ""
	i type="D" d
	.s:showDesc'="" showDesc=$zd(showDesc,3)
	i type="Y" d
	.s:showDesc'="" showDesc=+$zd(showDesc,3)
	e  i type="T" d
	.s:showDesc'="" showDesc=$zt(showDesc)
	e  i type="P"  d
	.s showDesc=..GetClsDescByLB(Foreignkey,showDesc)
	e  i type="K" d
	.i ShowKeyOption'="" d
	..k optionTmp
	..s optionTmp=""
	..f i=1:1:$L(ShowKeyOption,";")  d
	...s option=$P(ShowKeyOption,";",i)
	...q:option=""
	...s key=$P(option,":",1)
	...q:key=""
	...s value=$P(option,":",2)
	...s optionTmp(key)=value
	..s showDesc=$g(optionTmp(showDesc))
	q showDesc
}

/// Creator:lulin
/// Createdate:2021-06-10
/// Description:根据list,id获取描述
/// Input:
/// Output:
/// Other:
ClassMethod GetClsDescByLB(Foreignkey, showDesc)
{
	q:((Foreignkey="")||(showDesc="")||($LL(Foreignkey)<1)) ""
	s data=$LG(Foreignkey,1)
	q:data="" ""
	s cls=$P(data,"」",1)
	q:((cls="CF.DHCINM.DB.MgUser")&&(showDesc=0)) "超级管理员"
	s level=$P(data,"」",2)
	s num=$P(data,"」",3)
	s type=$P(data,"」",4)
	s rw=""
	f showGlobalIndex=1:1:level  d
	.s tID=$P(showDesc,"||",showGlobalIndex)
	.q:tID=""
	.i rw="" d
	..s rw=tID
	.e  d
	..s rw=rw_","_tID
	try{
		s foreignDesc=$LG($g(@("^"_cls_"D("_rw_")")),num)
		s:foreignDesc'="" showDesc=foreignDesc
	}catch{
	}
	i type="D" d
	.s:showDesc'="" showDesc=$zd(showDesc,3)
	i type="Y" d
	.s:showDesc'="" showDesc=+$zd(showDesc,3)
	e  i type="T" d
	.s:showDesc'="" showDesc=$zt(showDesc)
	e  i type="P"  d
	.s newForeignkey=$li(Foreignkey,2,$LL(Foreignkey))
	.s showDesc=..GetClsDescByLB(newForeignkey,showDesc)
	q showDesc
}

/// Creator:lulin
/// Createdate:2021-06-10
/// Description:获取用户每个角色下的所辖病区
/// Input:
/// Output:
/// Other:
ClassMethod SetLoginWard(nurseid, tmpWard) As %String
{
	q:nurseid="" 0
	q:nurseid=0 1
	s perId=$LG($G(^CF.DHCINM.DB.MgUserD(nurseid)),5)
	i perId'="" d
	.s curward=$LG($g(^CF.DHCINM.HR.PersonsD(perId)),10)
	s roleflag=0
	s roles=##class(web.INMLoginComm).GetRolesByLoginId(nurseid)
	f i=1:1:$l(roles,"^") q:roleflag=1  d
	.s trole=$p(roles,"^",i)
	.q:trole=""
	.s rolerw="" f  s rolerw=$O(^CF.DHCINM.Set.MgDataLimitI("Role"," "_trole," "_nurseid,rolerw)) q:rolerw=""  d
	..s roledeprw="" f  s roledeprw=$O(^CF.DHCINM.Set.MgDataLimitSubD(rolerw,roledeprw)) q:roledeprw=""  d
	...s SubWard=$LG(^CF.DHCINM.Set.MgDataLimitSubD(rolerw,roledeprw),2)
	...q:SubWard=""
	...s tmpWard(trole,SubWard)=SubWard
	.s:(curward'="")&&('$d(tmpWard(trole,curward))) tmpWard(trole,curward)=curward
	q roleflag
}

/// Creator:lulin
/// Description:查询通讯人员信息
/// Date:2019-10-08
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPlatform","FindPersons","x")
Query FindPersons(parr As %String = "", APPLoginID As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonsExecute(ByRef qHandle As %Binary, parr As %String = "", APPLoginID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s input=parr
	s index=0,masLength=5
	s loginPerDepDR=""
	if APPLoginID'=0{
		s loginPerDepDR=$lg($g(^CF.DHCINM.DB.MgUserD(APPLoginID)),9)
	}
	k tmpWard
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(APPLoginID,.tmpWard)
	s mailFlag=$lg($g(^CT.DHCINM.Set.MgArgParamSetD(1)),34)
	s rw="" f  s rw=$O(^CF.DHCINM.HR.PersonsD(rw)) q:((rw="")||(index>=masLength))  d
	.s objLB=$g(^CF.DHCINM.HR.PersonsD(rw))
	.q:objLB=""
	.s PerName=$lg(objLB,2)
	.s shellPerName=##class(INMVueComm).ToChineseSpell(PerName)
	.q:((input'="")&&((PerName_shellPerName)'[($zcvt(input,"U"))))
	.s wardID=$lg(objLB,10)
	.q:((input="")&&(loginPerDepDR'="")&&(loginPerDepDR'=wardID)) ;默认本病区人员
	.q:((mailFlag="N")&&(isAll'=1)&&((wardID="")||('$d(tmpWard(wardID))))) ;根据配置检索全院或所辖病区
	.q:##class(web.INMHRComm).IsFormalWorkNur(rw,+$h,"")'=1
	.s PerDepDR=""
	.i wardID'="" d
	..s wardLB=$g(^CF.DHCINM.DB.MgWardD(wardID))
	..s:wardLB'="" PerDepDR=$lg(wardLB,4)
	.s PerPhone=$lg(objLB,30)
	.s PostDuty=##class(web.INMHRComm).GetNurseDuty(rw,+$h) //职务
	.s PerPostDuty=$p(PostDuty,"^",2)
	.s ret="PerName|"_PerName_"^PerDepDR|"_PerDepDR_"^PerPhone|"_PerPhone_"^PerPostDuty|"_PerPostDuty
	.d OutputPerData
	.s index=index+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPerData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPersonsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonsExecute ]
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

ClassMethod FindPersonsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description：查询此时不良事件数据
/// Date:2021-04-20
/// Creator:lulin
/// Table:
/// Input: 用户id
/// Output:
/// Other:w ##class(web.INMPlatform).GetAdvInfoData(0,2)
ClassMethod GetAdvInfoData(nurseid, ward As %String = "") As %String
{
	k tmpWard
	s tmpWard=""
	s column="新发压疮^院外带入压疮^管路滑脱^跌倒坠床^用药错误^意外事件例数"
	s isAll=##class(INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s yData=$LB(0,0,0,0,0,0)
	s nowDate=$zd(+$H,3)
	s RowID="" f  s RowID=$O(^CF.DHCINM.DB.MgWardD(RowID)) q:RowID=""  d
	.s wardLB=$g(^CF.DHCINM.DB.MgWardD(RowID))
	.q:wardLB=""
	.q:((ward'="")&&(RowID'=ward))
	.q:((isAll=0)&&('$d(tmpWard(RowID))))
	.s stDate=$lg(wardLB,11)
	.s endDate=$lg(wardLB,12)
	.q:((stDate'="")&&(stDate>+$H))
	.q:((endDate'="")&&(endDate<+$H))
	.s CtLocId=$lg(wardLB,2)
	.q:CtLocId=""
	.s x="s result=##class(web.DHCADVINTERFACE).QueryNurRepByWard("""_nowDate_""","""_nowDate_""","""_CtLocId_""",""^"_CtLocId_"^^"")"
	.s result=##class(web.INMVueComm).CalXMethod(x)
	.s result=$P(result,"$$",1)
	.f i=1:1:$LL(yData) d
	..s $list(yData,i)=$list(yData,i)+$P(result,"^",i+2)
	q column_"「"_$LTS(yData,"^")
}

/// Description：登录时需要续注册的提示
/// Date:2022-06-20
/// Creator:张竞争
/// Table:
/// Input: 用户id
/// Output:
/// Other:w ##class(web.INMPlatform).IsNeedRegistedTips(0)
ClassMethod IsNeedRegistedTips(loginID As %String = "")
{
	q:loginID="" 0
	s str=0
	s date=+$h
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	s wardid="" f  s wardid=$o(^CF.DHCINM.HR.PersonsI("DepID",wardid)) q:wardid=""  d
	.;s warddesc=$lg(^CF.DHCINM.DB.MgWardD($tr(wardid," ","")),4)
	.;q:((isAll'=1)&&('$d(tmpWard($tr(wardid," ","")))))
	.s per="" f  s per=$o(^CF.DHCINM.HR.PersonsI("DepID",wardid,per)) q:per=""  d
	..q:'$d(^CF.DHCINM.HR.PersonsD(per))
	..s UserID=$o(^CF.DHCINM.DB.MgUserI("PerDR"," "_per,""))
	..q:UserID'=loginID
	..s perGlo=^CF.DHCINM.HR.PersonsD(per)
	..s PerStatus=$lg(perGlo,42)
	..s PerStatusDesc=##class(web.INMPersonComm).GetCommCode(PerStatus)
	..q:((PerStatusDesc'["在职")&&(PerStatusDesc'["转岗"))
	..s perName=$lg(perGlo,2)
	..s registedId=$o(^DHCINM.HR.MgQualRegistedI("Assid"," "_per," A",""),-1)
	..q:registedId=""
	..s registedObj=##class(DHCINM.HR.MgQualRegisted).%OpenId(registedId)
	..q:'$isObject(registedObj)
	..s outdate=registedObj.RegistedDate+(5*30*12)-30
	..;s outdate=registedObj.RegistedDate-30
	..i outdate<=date d
	...s str=str+1
	q str
}

/// Creator: LCY
/// CreatDate: 2022-03-09
/// Description: 获取问题处理处理提醒
/// Table: DHCINM.CHK.MgCheckResult,DHCINM.CHK.MgCheckQues
/// Input: 人员id，角色
/// Output:
/// Return:
/// Other: w ##class(web.INMPlatform).GetQuesRemind(0)
ClassMethod GetQuesRemind(loginID As %String = "") As %String
{
	q:loginID="" 0
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(loginID,.tmpWard)
	s NurHeadFlag=##class(web.INMLoginComm).IsNurInRoleForCode(loginID,"nurhead",+$H)
	q:NurHeadFlag'=1 0
	s ret=0
	s checkDate="" f  s checkDate=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate)) q:checkDate=""  d
	.s checkWard="" f  s checkWard=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard)) q:checkWard=""  d
	..q:((isAll'=1)&&('$d(tmpWard(checkWard))))
	..s checkItem="" f  s checkItem=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem)) q:checkItem=""  d
	...s checkItemGlo=$g(^CT.DHCINM.DB.MgQualItemD(checkItem))
	...s resultId="" f  s resultId=$o(^DHCINM.CHK.MgCheckResultI("Date",checkDate," S",checkWard,checkItem,resultId)) q:resultId=""  d
	....q:'$d(^DHCINM.CHK.MgCheckResultD(resultId))
	....s quesId=$o(^DHCINM.CHK.MgCheckQuesI("Result",resultId,""))
	....q:(quesId'="")
	....s resultGlo=^DHCINM.CHK.MgCheckResultD(resultId)
	....s scoreType=$lg(resultGlo,13)
	....s scoreTypeSub=$lg(resultGlo,14)
	....s scoreTypeMode=$lg(resultGlo,15)
	....s scoreStandardList=$lg(resultGlo,16)
	....s quesDesc="",mistakeFlag=0,counter=0
	....s resultSubId="" f  s resultSubId=$o(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)) q:resultSubId=""  d
	.....q:'$d(^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId))
	.....s resultSubGlo=^DHCINM.CHK.MgCheckResultSubD(resultId,resultSubId)
	.....s resultSubScore=$lg(resultSubGlo,3)
	.....q:((resultSubScore="")||((resultSubScore=0)&&($lg(checkItemGlo,8)=4)))
	.....s subStandardScore=$lg(resultSubGlo,5)
	.....q:(scoreType=2)&&(subStandardScore="")
	.....s deductFlag=##class(web.INMQualControlComm).IsQualSubDeduct(scoreType,scoreTypeSub,resultSubScore,subStandardScore)
	.....q:deductFlag'=1
	.....s mistakeFlag=1
	....q:mistakeFlag'=1
	....s ret=ret+1
	q ret
}

/// creator: liwenzhen
/// createDate:2022-05-14
/// description:删除某一次操作产生的消息追踪
/// table: 
/// input:tableName:类名,tableID：类id
/// output:
/// other:d ##class(web.INMPlatform).DeleteTrackMessage("DHCINM.Intern.MgTrainPlan","8")
ClassMethod DeleteTrackMessage(tableName As %String = "", tableID As %String = "") As %String
{
       q:(tableName)||(tableID="") 0
       s $ZT="ERROR"
       s tableName=$zcvt(tableName,"U")
       s messageId="" f  s messageId=$o(^DHCINM.PF.TrackMessageI("tableID"," "_tableName," "_tableID,messageId)) q:messageId=""  d
       .d ##class(DHCINM.PF.TrackMessage).%DeleteId(messageId)
       q 1
ERROR
       q 0
}

ClassMethod GetMsgByUsers(type As %String = "", userCode As %String = "", postCode As %String = "", orgCode As %String = "") As %String
{
	s ^TMP("GetMsgByUsers")=$zt($p($h,",",2))_" "_type_" "_userCode
	s type=$tr(type,"_","|")
	s nurseid=""
	s:userCode'="" nurseid=$o(^CF.DHCINM.DB.MgUserI("UserID"," "_$zcvt(userCode,"U"),""))
	
	if $g(^DHCINM.YS)="Y" {
		s num=-1
		s:type="1||2" num=1
		s:type="20||1" num=1
		s:type="22||1" num=1
		s:type="33||1" num=1
		s:type="43" num=4
		s:type="2||1" num=1
		s:type="27||1" num=1
		s:type="37||1" num=1
		s:type="3||1" num=1
		s:type="4||1" num=1
		s:type="5||1" num=1
		s:type="6||1" num=11
		s:type="26||1" num=2
		s:type="21||1" num=2
		s:type="23||1" num=-1
		s:type="25||1" num=2
		
		s:num=0 num=-1
		Set obj = {"code":200,"data":(num),"msg":"success","success":true,"userCode":(userCode),"postCode":(postCode),"orgCode":(orgCode)}
	    w obj.%ToJSON()
	    q ""
	}
	k tmpWard
	s isAll=..SetLoginWard(nurseid,.tmpWard)
	
	s num=0
	s objLB=$g(^CT.DHCINM.Set.ApprovalSetD($p(type,"||",1)))
	q:objLB=""
	s ApprovalType=$lg(objLB,3)
	i ApprovalType'="B"
	{
		s objStatus=$lg(objLB,5)
		q:objStatus'="Y"
		s ApprovalName=$lg(objLB,2)
		s ApprovalCls=$lg(objLB,9)
		q:ApprovalCls=""
		s dataGlobal="^"_ApprovalCls_"D"
		s LimitType=$lg(objLB,10) ;W：病区，U:用户，P：档案
		s LimitNum=$lg(objLB,11)
		s LimitDateType=$lg(objLB,12) ;N:当前，W:表数据
		s LimitDateNum=$lg(objLB,13)
		q:$l(type,"||")'=2
		s keyObjLB=$g(^CT.DHCINM.Set.ApprovalSetKeyD($p(type,"||",1),$p(type,"||",2)))
		q:keyObjLB=""
		s keyStatus=$lg(keyObjLB,14)
		q:keyStatus'="Y"
		s desc=$lg(keyObjLB,2)
		s statusNum=$lg(keyObjLB,3)
		q:statusNum=""
		s status=$lg(keyObjLB,4)
		s statusLB=$LFS(status,",")
		s otherNum=$lg(keyObjLB,15)
		s otherStatus=$lg(keyObjLB,16)
		s roles=$LG(keyObjLB,6)
		s dataId="" f  s dataId=$O(@dataGlobal@(dataId)) q:dataId=""  d
		.s dataObjLB=@dataGlobal@(dataId)
		.q:dataObjLB=""
		.s tStatus=$lg(dataObjLB,statusNum)
		.q:$LF(statusLB,tStatus)<1
		.s tOtherStatus=""
		.s:otherNum'="" tOtherStatus=$lg(dataObjLB,otherNum)
		.q:((otherNum'="")&&(tOtherStatus'=otherStatus))
		.s dataWardID="" ;数据归属病区
		.s LimitNumData=""
		.s:LimitNum'="" LimitNumData=$LG(dataObjLB,LimitNum)
		.i LimitType="W" d
		..s dataWardID=LimitNumData
		.e  i ((LimitType="U")||(LimitType="P")) d
		..s perID=""
		..i LimitType="P" d
		...s perID=LimitNumData
		..e  d
		...s:LimitNumData'="" perID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_LimitNumData,""))
		..i perID'=""  d
		...s roleDate=$LG(dataObjLB,LimitDateNum)
		...s dataWardID=$LG($g(^CF.DHCINM.HR.PersonsD(perID)),10)
		...i ((LimitDateType'="N")&&(roleDate'="")) d
		....s dataWardID=##class(web.INMHRComm).GetCurrentWard(perID,roleDate)
		.s noRoleFlag=0
		.s:nurseid=0 noRoleFlag=1
		.f roleIndex=1:1:$l(roles,",") q:noRoleFlag=1  d
		..s tRole=$P(roles,",",roleIndex)
		..q:tRole=""
		..q:((LimitNum'="")&&(dataWardID=""))
		..q:((dataWardID'="")&&('$d(tmpWard(tRole,dataWardID))))
		..s noRoleFlag=1
		.q:noRoleFlag=0
		.s num=num+1
	}
	else  
	{
		
		s objStatus=$lg(objLB,5)
		q:objStatus'="Y"
		s desc=$lg(objLB,2)
		s ApprovalClass=$lg(objLB,6)
		s ApprovalMethod=$lg(objLB,7)
		s ApprovalRouter=$lg(objLB,8)
		s ApprovalMethodType=$lg(objLB,17,"M")
		s ApprovalParameter=$lg(objLB,18)
		k tmpParam
		s tmpParam=$ll(ApprovalParameter)
		s paramIndex=0
		s ptr=0 f  s status=$listnext(ApprovalParameter,ptr,param) q:status'=1  d
		.s paramIndex=paramIndex+1
		. s:param="#loginID" param=nurseid //转换变量
		.s:param="#Date" param=+$h
		.s tmpParam(paramIndex)=param
		q:((ApprovalClass="")||(ApprovalMethod=""))
		i ApprovalMethodType="M" d
		.s num=$classmethod(ApprovalClass,ApprovalMethod,tmpParam...)
		.;x ("(num) s num = ##class("_ApprovalClass_")."_ApprovalMethod_"("""_ApprovalParameter_""")",.num)
		i ApprovalMethodType="Q" d
		.s result=##class(%ResultSet).%New(ApprovalClass_":"_ApprovalMethod)
		.d result.Execute(tmpParam...)
		.while result.%Next(){}
		.s num=result.%ROWCOUNT
	}
	s:num=0 num=-1
	Set obj = {"code":200,"data":(num),"msg":"success","success":true,"userCode":(userCode),"postCode":(postCode),"orgCode":(orgCode)}
    w obj.%ToJSON()
	q ""
	//w "{""code"":""200"",""msg"":""success"",""data"":"_num_",""success"":true}"
	//q ""
}

/// Other: w ##class(web.INMPlatform).GetMsgByUser("进修信息",0)
ClassMethod GetMsgByUser(type As %String = "", nurseid As %String = "") As %String
{
	k tmpWard
	s isAll=..SetLoginWard(nurseid,.tmpWard)
	
	s num=0
	s ApprovalType="" f  s ApprovalType=$O(^CT.DHCINM.Set.ApprovalSetI("StatusType"," Y",ApprovalType)) q:ApprovalType=""  d
	.s realApprovalType=$tr(ApprovalType," ","")
	.q:realApprovalType="B"
	.s rw="" f  s rw=$O(^CT.DHCINM.Set.ApprovalSetI("StatusType"," Y",ApprovalType,rw)) q:rw=""  d
	..s objLB=$g(^CT.DHCINM.Set.ApprovalSetD(rw))
	..q:objLB=""
	..s objStatus=$lg(objLB,5)
	..q:objStatus'="Y"
	..s ApprovalName=$lg(objLB,2)
	..q:type'=ApprovalName
	..s ApprovalCls=$lg(objLB,9)
	..q:ApprovalCls=""
	..s dataGlobal="^"_ApprovalCls_"D"
	..s LimitType=$lg(objLB,10) ;W：病区，U:用户，P：档案
	..s LimitNum=$lg(objLB,11)
	..s LimitDateType=$lg(objLB,12) ;N:当前，W:表数据
	..s LimitDateNum=$lg(objLB,13)
	..s keyId="" f  s keyId=$O(^CT.DHCINM.Set.ApprovalSetKeyD(rw,keyId)) q:keyId=""  d
	...s keyObjLB=$g(^CT.DHCINM.Set.ApprovalSetKeyD(rw,keyId))
	...q:keyObjLB=""
	...s keyStatus=$lg(keyObjLB,14)
	...q:keyStatus'="Y"
	...s desc=$lg(keyObjLB,2)
	...s statusNum=$lg(keyObjLB,3)
	...q:statusNum=""
	...s status=$lg(keyObjLB,4)
	...s statusLB=$LFS(status,",")
	...s otherNum=$lg(keyObjLB,15)
	...s otherStatus=$lg(keyObjLB,16)
	...s roles=$LG(keyObjLB,6)
	...s dataId="" f  s dataId=$O(@dataGlobal@(dataId)) q:dataId=""  d
	....s dataObjLB=@dataGlobal@(dataId)
	....q:dataObjLB=""
	....s tStatus=$lg(dataObjLB,statusNum)
	....q:$LF(statusLB,tStatus)<1
	....s tOtherStatus=""
	....s:otherNum'="" tOtherStatus=$lg(dataObjLB,otherNum)
	....q:((otherNum'="")&&(tOtherStatus'=otherStatus))
	....s dataWardID="" ;数据归属病区
	....s LimitNumData=""
	....s:LimitNum'="" LimitNumData=$LG(dataObjLB,LimitNum)
	....i LimitType="W" d
	.....s dataWardID=LimitNumData
	....e  i ((LimitType="U")||(LimitType="P")) d
	.....s perID=""
	.....i LimitType="P" d
	......s perID=LimitNumData
	.....e  d
	......s:LimitNumData'="" perID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_LimitNumData,""))
	.....i perID'=""  d
	......s roleDate=$LG(dataObjLB,LimitDateNum)
	......s dataWardID=$LG($g(^CF.DHCINM.HR.PersonsD(perID)),10)
	......i ((LimitDateType'="N")&&(roleDate'="")) d
	.......s dataWardID=##class(web.INMHRComm).GetCurrentWard(perID,roleDate)
	....s noRoleFlag=0
	....s:nurseid=0 noRoleFlag=1
	....f roleIndex=1:1:$l(roles,",") q:noRoleFlag=1  d
	.....s tRole=$P(roles,",",roleIndex)
	.....q:tRole=""
	.....q:((LimitNum'="")&&(dataWardID=""))
	.....q:((dataWardID'="")&&('$d(tmpWard(tRole,dataWardID))))
	.....s noRoleFlag=1
	....q:noRoleFlag=0
	....s num=num+1
		
	s rw="" f  s rw=$O(^CT.DHCINM.Set.ApprovalSetI("StatusType"," Y"," B",rw)) q:rw=""  d
	.s objLB=$g(^CT.DHCINM.Set.ApprovalSetD(rw))
	.q:objLB=""
	.s objStatus=$lg(objLB,5)
	.q:objStatus'="Y"
	.s desc=$lg(objLB,2)
	.q:type'=desc
	.s ApprovalClass=$lg(objLB,6)
	.s ApprovalMethod=$lg(objLB,7)
	.s ApprovalRouter=$lg(objLB,8)
	.s ApprovalMethodType=$lg(objLB,17,"M")
	.s ApprovalParameter=$lg(objLB,18)
	.k tmpParam
	.s tmpParam=$ll(ApprovalParameter)
	.s paramIndex=0 
	.s ptr=0 f  s status=$listnext(ApprovalParameter,ptr,param) q:status'=1  d
	..s paramIndex=paramIndex+1
	..s:param="#loginID" param=nurseid //转换变量
	..s:param="#Date" param=+$h 
	..s tmpParam(paramIndex)=param
	.q:((ApprovalClass="")||(ApprovalMethod=""))
	.i ApprovalMethodType="M" d
	..s num=$classmethod(ApprovalClass,ApprovalMethod,tmpParam...)
	..;x ("(num) s num = ##class("_ApprovalClass_")."_ApprovalMethod_"("""_ApprovalParameter_""")",.num) 
	.i ApprovalMethodType="Q" d
	..s result=##class(%ResultSet).%New(ApprovalClass_":"_ApprovalMethod)
	..d result.Execute(tmpParam...)
	..while result.%Next(){}
	..s num=result.%ROWCOUNT
	
	w "{""code"":""200"",""msg"":""success"",""data"":"_num_",""success"":true}"
	q ""
}

}
