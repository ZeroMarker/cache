/// creator:lulin
/// createdate:2019-11-21
/// description:东华护管接口
Class web.NurSensDHCNurMgComm Extends %RegisteredObject
{

/// ext版本方法
/// Creator:
/// Date:2019-12-24
/// Description:获取职称、职务、学历的key+value
/// Table:DHCMGNUR.CommDictionary、DHCMGNUR.CommDictionarySub
/// Input:type:类别(聘任专业技术职称\学历\职务)
/// Output:
/// Return:
/// Other:d $$class(web.NurSensNurMgComm).GetCategroy("",.tmp)
ClassMethod GetCategroy(type As %String, tmp As %String) As %String
{
	k tmp
	q:type="" ""	
	s mType=$case(type,"E":"学历","P":"职务","D":"聘任专业技术职称",:"")	
	q:mType="" ""
	s par=$o(^DHCMGNUR.CommDictionaryI("Code"," "_$zcvt($tr(mType," ",""),"U"),""))
	q:par="" ""
	s rw="" f  s rw=$o(^DHCMGNUR.CommDictionarySubD(par,rw)) q:rw=""  d
	.s obj=##class(DHCMGNUR.CommDictionarySub).%OpenId(par_"||"_rw)
	.q:'$IsObject(obj)
	.s code=obj.Code
	.s tmp(par_"||"_rw)=code
}

/// Creator:
/// Date:2019-12-24
/// Description:根据日期获取当期日期护士所在病区等信息
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:ext版本方法
ClassMethod GetPersonInfo(date As %String, stTime As %String, endTime As %String, tmp As %String) As %String
{
	q:date="" ""
	s date=$zdh(date,3)
	s argPostStore=$LB("A班","P班","N班","早晚班","责护班")
	//s  ^DHCMGNUR.MgNurTransDepI("stdate",64494," 193",6,3) 
	s stDate="" f  s stDate=$o(^DHCMGNUR.MgNurTransDepI("stdate",stDate)) q:stDate=""  d
	.q:(stDate>date)
	.s ward="" f  s ward=$o(^DHCMGNUR.MgNurTransDepI("stdate",stDate,ward)) q:ward=""  d
	..s tWardId=$tr(ward," ","")
	..q:(((tWardId="9997")!(tWardId="9998")!(tWardId="9999"))&&(stDate'=date))
	..s per="" f  s per=$o(^DHCMGNUR.MgNurTransDepI("stdate",stDate,ward,per)) q:per=""  d
	...s perObj=##class(DHCMGNUR.MgPersons).%OpenId(per)
	...q:'$IsObject(perObj)
	...q:perObj.PersonType2'="N"
	...q:((perObj.PersonAdmHosDate'="")&&(perObj.PersonAdmHosDate>date))
	...s NurWard=perObj.PersonDepDR,NurseID="",HISNo="",Sex="",AdcaDR="",AppDutyDR="",HeadShipDR="",DayCount=0
	...s NightCount=0,comeDate="",workDate="",NurBeforWard=""
	...s:$IsObject(perObj.PersonSchoolAgeDr) AdcaDR=perObj.PersonSchoolAgeDr.%Id()
	...s:$IsObject(perObj.PersonAppDutyDR) AppDutyDR=perObj.PersonAppDutyDR.%Id()
	...s:$IsObject(perObj.PersonheadshipDR) HeadShipDR=perObj.PersonheadshipDR.%Id()
	...s rw="" f  s rw=$o(^DHCMGNUR.MgNurTransDepI("stdate",stDate,ward,per,rw)) q:rw=""  d
	....s obj=##class(DHCMGNUR.MgNurTransDep).%OpenId(rw)
	....q:'$IsObject(obj)
	....q:((obj.PerTranEndDate'="")&&(date>obj.PerTranEndDate))
	....s NurBeforWard=""
	....s beforrw="" f  s beforrw=$O(^DHCMGNUR.MgNurTransDepI("PerDr",per,beforrw),-1) q:((beforrw="")||(NurBeforWard=""))  d
	.....s beforObj=##class(DHCMGNUR.MgNurTransDep).%OpenId(beforrw)
	.....q:'$IsObject(beforObj)
	.....s NurBeforWard=beforObj.PerDepart
	....s NurWard=obj.PerDepart
	...q:NurWard=""
	...s NurseID=perObj.PersonID
	...s PersonName=perObj.PersonName
	...s HISNo=NurseID
	...s Sex=perObj.PersonSexDR //性别ID
	...i perObj.PersonAdmHosDate'="" s comeDate=$zd(perObj.PersonAdmHosDate,3)
	...e  s comeDate=""
	...i perObj.PersonWorkDateTime'="" s workDate=$zd(perObj.PersonWorkDateTime,3)
	...e  s workDate=""
	...//学历
	...s AdcaRealDate=""
	...s adcaDate="" f  s adcaDate=$o(^DHCMGNUR.MgNurLeaExpI("date",per,adcaDate)) q:adcaDate=""  d
	....q:(adcaDate>date)
	....q:(adcaDate<AdcaRealDate)
	....s adcaRw="" f  s adcaRw=$o(^DHCMGNUR.MgNurLeaExpI("date",per,adcaDate,adcaRw)) q:adcaRw=""  d
	.....s adcaObj=##class(DHCMGNUR.MgNurLeaExp).%OpenId(per_"||"_adcaRw)
	.....;q:(adcaObj.PerFlag'="Y")
	.....q:((adcaObj.EndDate'="")&&(adcaObj.EndDate>date))
	.....i $IsObject(adcaObj.PerSchoolAgeDr) d
	......s AdcaDR=adcaObj.PerSchoolAgeDr.%Id()
	...//聘任职称(取的聘任专业技术职务)
	...s AppDutyRealDate=""
	...s proRw="" f  s proRw=$O(^DHCMGNUR.MgNurProTechPositionI("PerID"," "_NurseID,per,proRw)) q:proRw=""  d
	....s proObj=##class(DHCMGNUR.MgNurProTechPosition).%OpenId(per_"||"_proRw)
	....q:'$IsObject(proObj)
	....q:(proObj.PerAppStartDate>date)
	....q:proObj.PerAppStartDate<AppDutyRealDate
	....q:((proObj.PerAppEndDate'="")&&(proObj.PerAppEndDate<date))
	....q:(proObj.PerFlag'="1")&&(proObj.PerFlag'="2")
	....i $IsObject(proObj.PerAppProfQualPosName) d
	.....s AppDutyDR=proObj.PerAppProfQualPosName.%Id(),AppDutyRealDate=proObj.PerAppStartDate
	...;s AppDutyRealDate=""
	...;s proDate="" f  s proDate=$o(^DHCMGNUR.MgNurProTechPositionI("date",per,proDate)) q:proDate=""  d
	...;.q:(proDate>date)
	...;.q:(proDate<AppDutyRealDate)
	...;.s proRw="" f  s proRw=$O(^DHCMGNUR.MgNurProTechPositionI("date",per,proDate,proRw)) q:proRw=""  d
	...;..s proObj=##class(DHCMGNUR.MgNurProTechPosition).%OpenId(per_"||"_proRw)
	...;..q:'$IsObject(proObj)
	...;..q:((proObj.PerAppEndDate'="")&&(proObj.PerAppEndDate<date))
	...;..q:(proObj.PerFlag'="1")&&(proObj.PerFlag'="2")
	...;..i $IsObject(proObj.PerAppProfQualPosName) d
	...;...s AppDutyDR=proObj.PerAppProfQualPosName.%Id(),AppDutyRealDate=proObj.PerAppStartDate
	...s headFlag=0 //职务
	...s headShipDate="" f  s headShipDate=$o(^DHCMGNUR.MgNurChiefPositionI("date",per,headShipDate),-1) q:((headShipDate="")!(headFlag=1))  d
	....q:(headShipDate>date)
	....s headShipRw="" f  s headShipRw=$o(^DHCMGNUR.MgNurChiefPositionI("date",per,headShipDate,headShipRw)) q:((headShipRw="")!(headFlag=1))  d
	.....s headShipObj=##class(DHCMGNUR.MgNurChiefPosition).%OpenId(per_"||"_headShipRw)
	.....q:'$IsObject(headShipObj)
	.....;q:headShipObj.PerFlag'="Y"
	.....i $IsObject(headShipObj.PerDutyName) d
	......s HeadShipDR=headShipObj.PerDutyName.%Id()
	......s headFlag=1
	...//获取白、夜班时长 并把前一天的夜班过了零点的算在第二天夜班中
	...//白、夜班时长
	...//首先获取前一天的白夜班中的夜班时长
	...s argProRw="" f  s argProRw=$o(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_NurWard," N"," "_$zcvt($tr(NurseID," ",""),"U")," "_(date-1),argProRw)) q:argProRw=""  d
	....s ArgProObj=##class(DHCMGNUR.MgNurArrangeJob).%OpenId(argProRw)
	....q:'$IsObject(ArgProObj)
	....s PostObj=##class(DHCMGNUR.MgNurPost).%OpenId(ArgProObj.AJCodeDR)
	....q:'$IsObject(PostObj)
	....s PostDesc=PostObj.PostDesc
	....q:$LF(argPostStore,PostDesc)<1
	....s NightCount=$fn(PostObj.PostNightHours,"")
	....s DayCount=$fn($fn(PostObj.PostHours,"")-NightCount,"")
	...s tmp(per)="PersonName|"_PersonName_"^NurBeforWard|"_NurBeforWard_"^CTLocDR|"_NurWard_"^NurseID|"_NurseID
	...s tmp(per)=tmp(per)_"^HISNo|"_HISNo_"^Sex|"_Sex_"^AdcaDR|"_AdcaDR_"^AppDutyDR|"_AppDutyDR_"^HeadShipDR|"_HeadShipDR
	...s tmp(per)=tmp(per)_"^DayCount|"_DayCount_"^NightCount|"_NightCount_"^ComeDate|"_comeDate_"^WorkDate|"_workDate
	...s tmp(per)=tmp(per)_"^IsRegister|Y"_"^DayCountDuty|"_DayCount_"^NightCountDuty|"_NightCount_"^AllDayCount|"_(DayCount+NightCount)
	...s tmp(per)=tmp(per)_"^AllDayCountDuty|"_(DayCount+NightCount)
}

/// Vue版本
/// Creator:
/// Date:2019-12-24
/// Description:获取职称、职务、学历的key+value
/// Table:DHCMGNUR.CommDictionary、DHCMGNUR.CommDictionarySub
/// Input:type:类别(聘任专业技术职称\学历\职务)
/// Output:
/// Return:
/// Other:Vue版本方法
ClassMethod GetCategroyVue(type As %String, tmp As %String) As %String
{
	k tmp
	q:type="" ""
	s mType=$case(type,"E":"学历","P":"职务","D":"聘任职称",:"")	
	q:mType="" ""
	s par=$o(^DHCNMG.DB.MgSetCodeI("Code"," "_$zcvt($tr(mType," ",""),"U"),""))
	q:par="" ""
	s rw="" f  s rw=$o(^DHCNMG.DB.MgSetCodeSubD(par,rw)) q:rw=""  d
	.s obj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(par_"||"_rw)
	.q:'$IsObject(obj)
	.s code=obj.SubCode
	.s tmp(par_"||"_rw)=code
}

/// Vue4.1版本
/// Creator:
/// Date:2019-12-24
/// Description:获取职称、职务、学历的key+value
/// Table:DHCMGNUR.CommDictionary、DHCMGNUR.CommDictionarySub
/// Input:type:类别(聘任专业技术职称\学历\职务)
/// Output:
/// Return:
/// Other:Vue版本方法
ClassMethod GetCategroyVue4(type As %String, tmp As %String) As %String
{
	k tmp
	q:type="" ""
	s mType=$case(type,"E":"学历","P":"职务","D":"聘任职称",:"")	
	q:mType="" ""
	s par=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," "_$zcvt($tr(mType," ",""),"U"),""))
	q:par="" ""
	s rw="" f  s rw=$o(^CT.DHCINM.DB.MgSetCodeSubD(par,rw)) q:rw=""  d
	.s obj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(par_"||"_rw)
	.q:'$IsObject(obj)
	.s code=obj.SubDesc
	.s tmp(par_"||"_rw)=code
}

/// Creator:
/// Date:2020-03-24
/// Description:根据日期获取当期日期护士所在病区等信息
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:Vue版本方法
ClassMethod GetPersonInfoVue(date As %String, stTime As %String, endTime As %String, tmp As %String) As %String
{
	//循环每个人，获取当前病区及上一个病区。
	q:date="" ""
	s date=$zdh(date,3)
	s perid="" f  s perid=$O(^DHCNMG.HR.MgPersonsD(perid)) q:perid=""  d
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(perid)
	.q:'$IsObject(obj)
	.q:obj.PerCareType'="N" ;只保留护士
	.q:obj.PerTypeDR'="N" ;只保留正式
	.s PerRegRegiDate=obj.PerRegRegiDate
	.s PerRegValidDate=obj.PerRegValidDate
	.;只考虑注册日期在统计日期范围内
	.;q:(PerRegRegiDate="")||(PerRegValidDate="")||(PerRegRegiDate>date)||(PerRegValidDate<date)
	.s statusobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.PerStatus)
	.s status=""
	.i statusobj'="" s status=statusobj.SubDesc
	.s:obj.PerStateDate>date status="在职"
	.q:(status'["离职")&&(status'["在职") ;离职退休通过修改人员状态
	.q:(status["离职")&&(obj.PerStateDate'=date)
	.q:((obj.PerComeDate'="")&&(obj.PerComeDate>date))
	.s isResignFlag=1
	.i status["离职" d
	..s resignId=$O(^DHCNMG.HR.MgNurseResignI("ssid",perid,""))
	..i resignId'="" d
	...s resignObj=##class(DHCNMG.HR.MgNurseResign).%OpenId(resignId)
	...i (($IsObject(resignObj))&&($D(^oddCOM("DHCNMG.HR.MgNurseResign","a","ResignReStatus"))=0)) d
	....s:resignObj.ResignReStatus'="E" isResignFlag=0
	.q:isResignFlag'=1
	.;如果是离职获取是否是资源离职。
	.s PersonName=obj.PerName
	.s NurseID=obj.PerID,HISNo=obj.HISNO,Sex=obj.PerSexDR,comeDate=obj.PerComeDate,workDate=obj.PerWorkDate
	.s AdcaDR="",AppDutyDR="",HeadShipDR="",DayCount=0,NightCount=0
	.s IsRegister=obj.PerIsRegiste ;判断是否是注册护士
	.s:obj.PerRegNo'="" IsRegister="Y"
	.s PerRegRegiDate=obj.PerRegRegiDate
	.s:IsRegister="" IsRegister="N"
	.;责任班通过班次类型判断，
	.s DayCountDuty=0,NightCountDuty=0,AllDayCount=0,AllDayCountDuty=0
	.k tmpWardWorkDay,tmpWardWorkDayDate
	.s NurBeforWard="",NurWard="",tmpWardWorkDay="",tmpWardWorkDayDate=""
	.i obj.PerDepDR'="" d
	..s perWardObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.PerDepDR)
	..i $IsObject(perWardObj) d
	...s NurWard=perWardObj.WardCode
	.s stDate="" f  s stDate=$O(^DHCNMG.HR.MgTransDepI("stDate"," "_perid,stDate)) q:(stDate="")  d
	..q:((date'="")&&(stDate>date))
	..s rw="" f  s rw=$O(^DHCNMG.HR.MgTransDepI("stDate"," "_perid,stDate,rw)) q:(rw="")  d
	...s depObj=##class(DHCNMG.HR.MgTransDep).%OpenId(rw)
	...q:'$IsObject(depObj)
	...s wardObj=##class(DHCNMG.DB.MgWard).%OpenId(depObj.PerDepart)
	...q:'$IsObject(wardObj)
	...s NurWard=wardObj.WardCode
	...s realStDate=stDate
	...s:realStDate<PerRegRegiDate realStDate=PerRegRegiDate
	...s realEndDate=date
	...i ((depObj.PerTranEndDate'="")&&(date>depObj.PerTranEndDate)) d
	....s realEndDate=depObj.PerTranEndDate
	...s:realEndDate>=realStDate tmpWardWorkDay(NurWard)=$g(tmpWardWorkDay(NurWard))+realEndDate-realStDate
	...s beforEndDate=$g(tmpWardWorkDayDate(NurWard))
	...i ((beforEndDate'="")&&(realStDate-beforEndDate<365)) d
	....s:realStDate>=beforEndDate tmpWardWorkDay(NurWard)=$g(tmpWardWorkDay(NurWard))+realStDate-beforEndDate
	...s tmpWardWorkDayDate(NurWard)=realEndDate
	...q:(depObj.PerTranEndDate'="")&&(date>depObj.PerTranEndDate)
	...q:depObj.PerDepart=""
	...s beforFlag=0
	...s beforStDate=stDate f  s beforStDate=$O(^DHCNMG.HR.MgTransDepI("stDate"," "_perid,beforStDate),-1) q:(beforStDate="")||(beforFlag=1)  d
	....s beforId=rw f  s beforId=$O(^DHCNMG.HR.MgTransDepI("stDate"," "_perid,beforStDate,beforId),-1)  q:(beforId="")||(beforFlag=1)  d
	.....s beforObj=##class(DHCNMG.HR.MgTransDep).%OpenId(beforId)
	.....q:'$IsObject(beforObj)
	.....q:beforObj.PerDepart=depObj.PerDepart
	.....q:beforObj.PerDepart=""
	.....s beforWardObj=##class(DHCNMG.DB.MgWard).%OpenId(beforObj.PerDepart)
	.....q:'$IsObject(beforWardObj)
	.....q:'$IsObject(beforWardObj.CTLocDR)
	.....s NurBeforWard=beforWardObj.CTLocDR.%Id()
	.....s beforFlag=1
	.;职称
	.s dataInfoDate=""
	.s hireStDate="" f  s hireStDate=$O(^DHCNMG.HR.MgHireDutyI("HireDate",perid,hireStDate)) q:hireStDate=""  d
	..q:(hireStDate<0)||(hireStDate>date)
	..s typeid="" f  s typeid=$o(^DHCNMG.HR.MgHireDutyI("ssid",perid,typeid)) q:typeid=""  d
	...s hireobj=##class(DHCNMG.HR.MgHireDuty).%OpenId(typeid)
	...q:hireobj.HireStatus'="A"
	...q:(hireobj.HireEndDate'="")&&(hireobj.HireEndDate<date)
	...q:hireobj.HireDuty=""
	...q:(hireobj.HireStDate<dataInfoDate)
	...s AppDutyDR=hireobj.HireDuty,dataInfoDate=hireobj.HireStDate
	.;职务
	.s dataInfoDate=""
	.s postStDate="" f  s postStDate=$O(^DHCNMG.HR.MgPostDutyI("PostDate",perid,postStDate)) q:postStDate=""  d
	..q:(postStDate<0)||(postStDate>date)
	..s hireid="" f  s hireid=$o(^DHCNMG.HR.MgPostDutyI("PostDate",perid,postStDate,hireid)) q:hireid=""  d
	...s postObj=##class(DHCNMG.HR.MgPostDuty).%OpenId(hireid)
	...q:postObj.PostStatus'="A"
	...q:(postObj.PostEndDate'="")&&(postObj.PostEndDate<date)
	...q:postObj.PostDuty=""
	...q:postObj.PostStDate<dataInfoDate
	...s HeadShipDR=postObj.PostDuty,dataInfoDate=postObj.PostStDate
	.;学历
	.s dataInfoDate=""
	.s degreeStDate="" f  s degreeStDate=$O(^DHCNMG.HR.MgEducateI("flag",perid,degreeStDate)) q:degreeStDate=""  d
	..q:(degreeStDate<0)||(degreeStDate>date)
	..s degreeId="" f  s degreeId=$o(^DHCNMG.HR.MgEducateI("flag",perid,degreeStDate,degreeId)) q:degreeId=""  d
	...s degreeobj=##class(DHCNMG.HR.MgEducate).%OpenId(degreeId)
	...q:degreeobj.EduStatus'="A"
	...q:(degreeobj.EduEndDate'="")&&(degreeobj.EduEndDate>date)
	...q:degreeobj.EduAcademic=""
	...q:degreeobj.EduStDate<dataInfoDate
	...s AdcaDR=degreeobj.EduAcademic,dataInfoDate=degreeobj.EduStDate
	.i (status["在职")  d
	..s time=..GetWorkCount(date,perid,stTime,endTime)
	..s DayCount=$P(time,"^",1),NightCount=$P(time,"^",2)
	..s DayCountDuty=$P(time,"^",3),NightCountDuty=$P(time,"^",4)
	..s AllDayCount=$P(time,"^",5),AllDayCountDuty=$P(time,"^",6)
	.e  i status["离职"  d
	..s NurBeforWard=NurWard
	..s NurWard=9997
	.q:NurWard="" ;过滤掉没有关联his病区
	.s tmp(perid)="PersonName|"_PersonName_"^NurBeforWard|"_NurBeforWard_"^CTLocDR|"_NurWard_"^NurseID|"_NurseID
	.s tmp(perid)=tmp(perid)_"^HISNo|"_HISNo_"^Sex|"_Sex_"^AdcaDR|"_AdcaDR_"^AppDutyDR|"_AppDutyDR
	.s tmp(perid)=tmp(perid)_"^HeadShipDR|"_HeadShipDR_"^DayCount|"_DayCount_"^NightCount|"_NightCount_"^ComeDate|"_comeDate_"^WorkDate|"_workDate
	.s tmp(perid)=tmp(perid)_"^DayCountDuty|"_DayCountDuty_"^NightCountDuty|"_NightCountDuty_"^WardWorkDay|"_$g(tmpWardWorkDay(NurWard))
	.s tmp(perid)=tmp(perid)_"^AllDayCount|"_AllDayCount_"^AllDayCountDuty|"_AllDayCountDuty_"^IsRegister|"_IsRegister
}

/// Creator:
/// Date:2020-03-27
/// Description:根据日期获取某人当天白班小时数、夜班小时数
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:Vue版本方法
ClassMethod GetWorkCount(date, perid, stTime, endTime) As %String
{
	s DayCount=0,NightCount=0,DayCountDuty=0,NightCountDuty=0 ;今明天统计8-8
	s AllDayCount=0,AllDayCountDuty=0 ;昨今数据.0-0
	s:date["-" date=$zdh(date,3)
	s isAskLeavePrev=..IsPerAskLeavel(perid_"^"_(date-1))
	s isAskLeave=..IsPerAskLeavel(perid_"^"_date)
	s isAskLeaveNext=..IsPerAskLeavel(perid_"^"_(date+1))
	s isAskLeavekTmp=$LB(isAskLeavePrev,isAskLeavePrev,isAskLeavePrev)
	f i=-1:1:1  d
	.q:$LG(isAskLeavekTmp,i+2)=1
	.s argid="" f  s argid=$O(^DHCNMG.Arg.MgArrangeSubI("PerDate",perid,date+i,argid)) q:argid=""  d
	..s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(argid)
	..q:'$IsObject(obj)
	..q:(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	..q:($IsObject(obj.ArgPostDR)&&(obj.ArgPostDR.PostDR.PostLevel'="一线班")) //排除非一线班
	..q:($IsObject(obj.ArgPostDR)&&(obj.ArgPostDR.PostDR.PostType="H")) ;排除休假
	..s PostPlusMinutes=""
	..i $D(^oddCOM("DHCNMG.DB.MgArgPost","a","PostPlusMinutes"))'=0 d
	...s:i=1 PostPlusMinutes=obj.ArgPostDR.PostDR.PostPlusMinutes
	..s time=..GetTime(obj.ArgStTime1,obj.ArgEndTime1,stTime,endTime,i)
	..s tDayCount=0,tNightCount=0,tAllDayCount=0
	..s tDayCount=tDayCount+$P(time,"^",1)
	..s tNightCount=tNightCount+$P(time,"^",2)
	..s tAllDayCount=tAllDayCount+$P(time,"^",3)
	..s time=..GetTime(obj.ArgStTime2,obj.ArgEndTime2,stTime,endTime,i)
	..s tDayCount=tDayCount+$P(time,"^",1)
	..s tNightCount=tNightCount+$P(time,"^",2)
	..s tAllDayCount=tAllDayCount+$P(time,"^",3)
	..s time=..GetTime(obj.ArgStTime3,obj.ArgEndTime3,stTime,endTime,i)
	..s tDayCount=tDayCount+$P(time,"^",1)
	..s:tDayCount>0 tDayCount=tDayCount+PostPlusMinutes
	..s tNightCount=tNightCount+$P(time,"^",2)
	..s tAllDayCount=tAllDayCount+$P(time,"^",3)
	..s:tAllDayCount>=0 tAllDayCount=tAllDayCount+PostPlusMinutes
	..s:i'=-1 DayCount=DayCount+tDayCount,NightCount=NightCount+tNightCount
	..s:i'=1 AllDayCount=AllDayCount+tAllDayCount
	..i (($IsObject(obj.ArgPostDR))&&($IsObject(obj.ArgPostDR.PostDR))) d
	...i $D(^oddCOM("DHCNMG.DB.MgArgPost","a","IsDuty"))=0  d
	....s:i'=-1 DayCountDuty=DayCountDuty+tDayCount,NightCountDuty=NightCountDuty+tNightCount
	....s:i'=1 AllDayCountDuty=AllDayCountDuty++tAllDayCount
	...e  d
	....i obj.ArgPostDR.PostDR.IsDuty'="N"  d
	.....s:i'=-1 DayCountDuty=DayCountDuty+tDayCount,NightCountDuty=NightCountDuty+tNightCount
	.....s:i'=1 AllDayCountDuty=AllDayCountDuty++tAllDayCount
	s:DayCount'=0 DayCount=$fn(DayCount/60,"",10)
	s:NightCount'=0 NightCount=$fn(NightCount/60,"",10)
	s:DayCountDuty'=0 DayCountDuty=$fn(DayCountDuty/60,"",10)
	s:NightCountDuty'=0 NightCountDuty=$fn(NightCountDuty/60,"",10)
	s:AllDayCount'=0 AllDayCount=$fn(AllDayCount/60,"",10)
	s:AllDayCountDuty'=0 AllDayCountDuty=$fn(AllDayCountDuty/60,"",10)
	q DayCount_"^"_NightCount_"^"_DayCountDuty_"^"_NightCountDuty_"^"_AllDayCount_"^"_AllDayCountDuty
}

/// creator: lulin	
/// createdate: 2018.05.08
/// description: 
/// table: 
/// input: 护士id^date
/// output:0:无，1：有
/// other: w ##class(web.NurMgArgComm).IsPerAskLeavel("60^2018-05-07")
ClassMethod IsPerAskLeavel(parr As %String = "") As %String
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

/// creator: lulin	
/// createdate: 2020-03-27
/// description: 
/// table: flag:0:当日，1：次日.stTime:白班开始日期，endTime:白班结束日期
/// input: 
/// output:
/// other:
ClassMethod GetTime(st, end, stTime, endTime, flag) As %String
{
	s day=0,night=0,allDayCount=0
	q:(st="")||(end="") "0^0^0"
	s tSt=0,tEnd=0,allTSt=0,allTEnd=0
	if flag=0  {
		i st["次日" d
		.s st=$zth($E(st,3,$L(st)),1)
		.s end=$zth($E(end,3,$L(end)),1)
		.i st<stTime d
		..i end>stTime s night=stTime-st
		..e  s night=end-st
		e  d
		.s st=$zth(st,1)
		.i end["次日" d
		..s end=$zth($E(end,3,$L(end)),1)+86400
		..s allDayCount=86400-st
		.e  d
		..s end=$zth(end,1)
		..s allDayCount=end-st
		.i ((st<endTime)&&(end>stTime)) d
		..i st<stTime d
		...i end>endTime s day=endTime-stTime
		...e  s day=end-stTime
		..e  d
		...i end>endTime s day=endTime-st
		...e  s day=end-st
		.s nightSt=endTime
		.s nightEnd=stTime+86400
		.i end>nightSt d
		..i st>nightSt d
		...i end>nightEnd s night=nightEnd-st
		...e  s night=end-st
		..e  d
		...i end>nightEnd s night=nightEnd-nightSt
		...e  s night=end-nightSt
	}elseif flag=1 { ;第二天仅算0-stTime归入到今天夜班中
		i (st'["次日")  d
		.s st=$zth(st,1)
		.i st<stTime d
		..i end["次日" s night=stTime-st
		..e  d
		...s end=$zth(end,1)
		...i end<stTime s night=end-st
		...e  s night=stTime-st
	}else{ ;前一天的工作时长
		i end["次日" d
		.s allTEnd=86400+$zth($E(end,3,$L(end)),1)
		.i st["次日" d
		..s allTSt=86400+$zth($E(st,3,$L(st)),1)
		.e  s allTSt=86400
		s stTime=stTime+86400
		s endTime=endTime+86400
		s day=0
		i allTEnd>stTime d
		.i allTSt>stTime d
		..i allTEnd>endTime s day=endTime-allTSt
		..e  s day=allTEnd-allTSt
		.e  d
		..i allTEnd>endTime s day=endTime-stTime
		..e  s day=allTEnd-stTime
		s night=0
		i allTEnd>endTime d
		.i allTSt>endTime s night=allTEnd-allTSt
		.e  s night=allTEnd-endTime
		s allDayCount=allTEnd-allTSt
	}
	s day=day/60,night=night/60,allDayCount=allDayCount/60
	q day_"^"_night_"^"_allDayCount
}

/// Creator:
/// Date:2020-03-24
/// Description:根据日期获取当期日期护士所在病区等信息
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:Vue4.1版本方法
ClassMethod GetPersonInfoVue4(date As %String, stTime As %String, endTime As %String, tmp As %String) As %String
{
	//循环每个人，获取当前病区及上一个病区。
	q:date="" ""
	s date=$zdh(date,3)
	s perid="" f  s perid=$O(^CF.DHCINM.HR.PersonsD(perid)) q:perid=""  d
	.s obj=##class(CF.DHCINM.HR.Persons).%OpenId(perid)
	.q:'$IsObject(obj)
	.q:obj.PerCareType'="N" ;只保留护士
	.q:obj.PerTypeDR'="N" ;只保留正式
	.q:((obj.PerComeDate'="")&&(obj.PerComeDate>date))
	.s statusobj=##class(CT.DHCINM.DB.MgSetCodeSub).%OpenId(obj.PerStatus)
	.s status=""
	.i statusobj'="" s status=statusobj.SubDesc
	.s:obj.PerStateDate>date status="在职"
	.q:(status'["离职")&&(status'["在职") ;离职退休通过修改人员状态
	.q:(status["离职")&&(obj.PerStateDate'=date)
	.s PersonName=obj.PerName
	.s NurseID=obj.PerID,HISNo=obj.HISNO,Sex=obj.PerSexDR,comeDate=obj.PerComeDate,workDate=obj.PerWorkDate
	.s AdcaDR="",AppDutyDR="",HeadShipDR="",DayCount=0,NightCount=0
	.s PerRegRegiDate="",IsRegister="N" ;是否是注册护士
	.s RegisterID="" f  s RegisterID=$O(^DHCINM.HR.MgQualRegistedI("Assid"," "_perid," Y",RegisterID)) q:RegisterID=""  d
	..s RegisterLB=$G(^DHCINM.HR.MgQualRegistedD(RegisterID))
	..q:RegisterLB=""
	..s tPerRegRegiDate=$LG(RegisterLB,3)
	..i PerRegRegiDate'="" s PerRegRegiDate=tPerRegRegiDate
	..e  d
	...s:tPerRegRegiDate<PerRegRegiDate PerRegRegiDate=tPerRegRegiDate
	..s IsRegister="Y"
	.s:obj.PerRegNo'="" IsRegister="Y"
	.;责任班通过班次类型判断，
	.s DayCountDuty=0,NightCountDuty=0,AllDayCount=0,AllDayCountDuty=0
	.k tmpWardWorkDay,tmpWardWorkDayDate
	.s NurBeforWard="",tmpWardWorkDay="",tmpWardWorkDayDate=""
	.s NurWard=obj.PerDepDR
	.;i obj.PerDepDR'="" d
	.;.s perWardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(obj.PerDepDR)
	.;.i (($IsObject(perWardObj))&&($IsObject(perWardObj.CTLocDR))) d
	.;..s NurWard=perWardObj.CTLocDR.%Id()
	.s rw="" f  s rw=$O(^CF.DHCINM.Trans.TransDepI("ssdr"," "_perid,rw)) q:(rw="")  d
	..s depObj=##class(CF.DHCINM.Trans.TransDep).%OpenId(rw)
	..q:'$IsObject(depObj)
	..q:((date'="")&&(depObj.PerTranStDate>date))
	..q:depObj.PerDepart=""
	..s NurWard=depObj.PerDepart
	..;s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(depObj.PerDepart)
	..;q:'$IsObject(wardObj)
	..;q:'$IsObject(wardObj.CTLocDR)
	..;s NurWard=wardObj.CTLocDR.%Id()
	..s realStDate=depObj.PerTranStDate
	..s realEndDate=date
	..i ((depObj.PerTranEndDate'="")&&(date>=depObj.PerTranEndDate)) d
	...s realEndDate=depObj.PerTranEndDate
	..s tmpWardWorkDay(NurWard)=$g(tmpWardWorkDay(NurWard))+realEndDate-realStDate
	..s beforEndDate=$g(tmpWardWorkDayDate(NurWard))
	..i ((beforEndDate'="")&&(realStDate-beforEndDate<365)) d
	...s tmpWardWorkDay(NurWard)=$g(tmpWardWorkDay(NurWard))+realStDate-beforEndDate
	..s tmpWardWorkDayDate(NurWard)=realEndDate
	..q:(depObj.PerTranEndDate'="")&&(date>=depObj.PerTranEndDate)
	..s beforFlag=0
	..s beforId=rw f  s beforId=$O(^CF.DHCINM.Trans.TransDepI("ssdr"," "_perid,beforId),-1)  q:(beforId="")||(beforFlag=1)  d
	...s beforObj=##class(CF.DHCINM.Trans.TransDep).%OpenId(beforId)
	...q:'$IsObject(beforObj)
	...q:beforObj.PerDepart=depObj.PerDepart
	...s NurBeforWard=beforObj.PerDepart
	...;q:beforObj.PerDepart=""
	...;s beforWardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(beforObj.PerDepart)
	...;q:'$IsObject(beforWardObj)
	...;q:'$IsObject(beforWardObj.CTLocDR)
	...;s NurBeforWard=beforWardObj.CTLocDR.%Id()
	...s beforFlag=1
	.;职称
	.s dataInfoDate=""
	.s hireStDate="" f  s hireStDate=$O(^CF.DHCINM.HR.HireDutyI("HireDate",perid,hireStDate)) q:hireStDate=""  d
	..q:(hireStDate<0)||(hireStDate>date)
	..s typeid="" f  s typeid=$o(^CF.DHCINM.HR.HireDutyI("ssid",perid,typeid)) q:typeid=""  d
	...s hireobj=##class(CF.DHCINM.HR.HireDuty).%OpenId(typeid)
	...q:hireobj.HireStatus'="A"
	...q:(hireobj.HireEndDate'="")&&(hireobj.HireEndDate<date)
	...q:hireobj.HireDuty=""
	...q:hireobj.HireStDate<dataInfoDate
	...s AppDutyDR=hireobj.HireDuty,dataInfoDate=hireobj.HireStDate
	.;职务
	.s dataInfoDate=""
	.s postStDate="" f  s postStDate=$O(^CF.DHCINM.HR.PostDutyI("PostDate",perid,postStDate)) q:postStDate=""  d
	..q:(postStDate<0)||(postStDate>date)
	..s hireid="" f  s hireid=$o(^CF.DHCINM.HR.PostDutyI("PostDate",perid,postStDate,hireid)) q:hireid=""  d
	...s postObj=##class(CF.DHCINM.HR.PostDuty).%OpenId(hireid)
	...q:postObj.PostStatus'="A"
	...q:(postObj.PostEndDate'="")&&(postObj.PostEndDate<date)
	...q:postObj.PostDuty=""
	...q:postObj.PostStDate<dataInfoDate
	...s HeadShipDR=postObj.PostDuty,dataInfoDate=postObj.PostStDate
	.;学历
	.s dataInfoDate=""
	.s degreeStDate="" f  s degreeStDate=$O(^CF.DHCINM.HR.EducateI("flag",perid,degreeStDate)) q:degreeStDate=""  d
	..q:(degreeStDate<0)||(degreeStDate>date)
	..s degreeId="" f  s degreeId=$o(^CF.DHCINM.HR.EducateI("flag",perid,degreeStDate,degreeId)) q:degreeId=""  d
	...s degreeobj=##class(CF.DHCINM.HR.Educate).%OpenId(degreeId)
	...q:degreeobj.EduStatus'="A"
	...q:(degreeobj.EduEndDate="")||(degreeobj.EduEndDate>date)
	...q:degreeobj.EduAcademic=""
	...q:degreeobj.EduStDate<dataInfoDate
	...s AdcaDR=degreeobj.EduAcademic,dataInfoDate=degreeobj.EduStDate
	.i (status["在职")  d
	..s time=..GetWorkCount4(date,perid,stTime,endTime)
	..s DayCount=$P(time,"^",1),NightCount=$P(time,"^",2)
	..s DayCountDuty=$P(time,"^",3),NightCountDuty=$P(time,"^",4)
	..s AllDayCount=$P(time,"^",5),AllDayCountDuty=$P(time,"^",6)
	.e  i status["离职"  d
	..s NurBeforWard=NurWard
	..s NurWard=9997
	.q:NurWard="" ;过滤掉病区得错误数据
	.s tmp(perid)="PersonName|"_PersonName_"^NurBeforWard|"_NurBeforWard_"^CTLocDR|"_NurWard_"^NurseID|"_NurseID
	.s tmp(perid)=tmp(perid)_"^HISNo|"_HISNo_"^Sex|"_Sex_"^AdcaDR|"_AdcaDR_"^AppDutyDR|"_AppDutyDR
	.s tmp(perid)=tmp(perid)_"^HeadShipDR|"_HeadShipDR_"^DayCount|"_DayCount_"^NightCount|"_NightCount_"^ComeDate|"_comeDate_"^WorkDate|"_workDate
	.s tmp(perid)=tmp(perid)_"^DayCountDuty|"_DayCountDuty_"^NightCountDuty|"_NightCountDuty_"^WardWorkDay|"_$g(tmpWardWorkDay(NurWard))
	.s tmp(perid)=tmp(perid)_"^AllDayCount|"_AllDayCount_"^AllDayCountDuty|"_AllDayCountDuty_"^IsRegister|"_IsRegister
}

/// Creator:
/// Date:2020-03-27
/// Description:根据日期获取某人当天白班小时数、夜班小时数
/// Table:
/// Input:
/// Output:
/// Return:
/// Other:Vue版本方法
ClassMethod GetWorkCount4(date, perid, stTime, endTime) As %String
{
	s DayCount=0,NightCount=0,DayCountDuty=0,NightCountDuty=0,AllDayCount=0,AllDayCountDuty=0
	s:date["-" date=$zdh(date,3)
	s isAskLeavePrev=..IsPerAskLeavel4(perid_"^"_(date-1))
	s isAskLeave=..IsPerAskLeavel4(perid_"^"_date)
	s isAskLeaveNext=..IsPerAskLeavel4(perid_"^"_(date+1))
	s isAskLeavekTmp=$LB(isAskLeavePrev,isAskLeavePrev,isAskLeavePrev)
	f i=-1:1:1  d
	.q:$LG(isAskLeavekTmp,i+2)=1
	.s argid="" f  s argid=$O(^DHCINM.Arg.MgArrangeSubI("PerDate",perid,date+i,argid)) q:argid=""  d
	..s obj=##class(DHCINM.Arg.MgArrangeSub).%OpenId(argid)
	..q:'$IsObject(obj)
	..q:(obj.ArrangeDR.ArgStatus'="R")&&(obj.ArrangeDR.ArgStatus'="A")
	..q:($IsObject(obj.ArgPostDR)&&(obj.ArgPostDR.PostDR.PostLevel'="一线班")) //排除非一线班
	..q:($IsObject(obj.ArgPostDR)&&(obj.ArgPostDR.PostDR.PostType="H")) ;排除休假
	..s time=..GetTime(obj.ArgStTime1,obj.ArgEndTime1,stTime,endTime,i)
	..s tDayCount=0,tNightCount=0,tAllDayCount=0
	..s tDayCount=tDayCount+$P(time,"^",1)
	..s tNightCount=tNightCount+$P(time,"^",2)
	..s tAllDayCount=tAllDayCount+$P(time,"^",3)
	..s time=..GetTime(obj.ArgStTime2,obj.ArgEndTime2,stTime,endTime,i)
	..s tDayCount=tDayCount+$P(time,"^",1)
	..s tNightCount=tNightCount+$P(time,"^",2)
	..s tAllDayCount=tAllDayCount+$P(time,"^",3)
	..s time=..GetTime(obj.ArgStTime3,obj.ArgEndTime3,stTime,endTime,i)
	..s tDayCount=tDayCount+$P(time,"^",1)
	..s tNightCount=tNightCount+$P(time,"^",2)
	..s tAllDayCount=tAllDayCount+$P(time,"^",3)
	..s:i'=-1 DayCount=DayCount+tDayCount,NightCount=NightCount+tNightCount
	..s:i'=1 AllDayCount=AllDayCount+tAllDayCount
	..i (($IsObject(obj.ArgPostDR))&&($IsObject(obj.ArgPostDR.PostDR))) d
	...i $D(^oddCOM("CF.DHCINM.DB.MgArgPost","a","IsDuty"))=0  d
	....s:i'=-1 DayCountDuty=DayCountDuty+tDayCount,NightCountDuty=NightCountDuty+tNightCount
	....s:i'=1 AllDayCountDuty=AllDayCountDuty++tAllDayCount
	...e  d
	....i obj.ArgPostDR.PostDR.IsDuty'="N"  d
	.....s:i'=-1 DayCountDuty=DayCountDuty+tDayCount,NightCountDuty=NightCountDuty+tNightCount
	.....s:i'=1 AllDayCountDuty=AllDayCountDuty++tAllDayCount
	s:DayCount'=0 DayCount=$fn(DayCount/60,"",10)
	s:NightCount'=0 NightCount=$fn(NightCount/60,"",10)
	s:DayCountDuty'=0 DayCountDuty=$fn(DayCountDuty/60,"",10)
	s:NightCountDuty'=0 NightCountDuty=$fn(NightCountDuty/60,"",10)
	s:AllDayCount'=0 AllDayCount=$fn(AllDayCount/60,"",10)
	s:AllDayCountDuty'=0 AllDayCountDuty=$fn(AllDayCountDuty/60,"",10)
	q DayCount_"^"_NightCount_"^"_DayCountDuty_"^"_NightCountDuty_"^"_AllDayCount_"^"_AllDayCountDuty
}

/// creator: lulin	
/// createdate: 2018.05.08
/// description: 
/// table: 
/// input: 护士id^date
/// output:0:无，1：有
/// other: w ##class(web.NurMgArgComm).IsPerAskLeavel2("60^2018-05-07")
ClassMethod IsPerAskLeavel4(parr As %String = "") As %String
{
		s perdr=$p(parr,"^")
		s date=$p(parr,"^",2)
		q:(perdr="")||(date="") 0
		s:date["-" date=$zdh(date,3)
		s flag=0
		s ^DHCINM.Arg.MgLeaveAppI("Nurse")=""
		s id="" f  s id=$o(^DHCINM.Arg.MgLeaveAppI("Nurse",perdr,id)) q:(id="")||(flag=1)  d
		.q:'$d(^DHCINM.Arg.MgLeaveAppD(id))
		.s leaveGlo=^DHCINM.Arg.MgLeaveAppD(id)
		.s source=$lg(leaveGlo,2)
		.s status=$lg(leaveGlo,13)
		.q:((source="N")&&(status'["A"))||((source="H")&&(status'="HA"))
		.s stDate=$lg(leaveGlo,5)
		.s endDate=$lg(leaveGlo,7)
		.s workDate=$lg(leaveGlo,29)
		.q:$lf(workDate,date)
		.q:(date<stDate)||(date>endDate)
		.s flag=1
		q flag
}

}
