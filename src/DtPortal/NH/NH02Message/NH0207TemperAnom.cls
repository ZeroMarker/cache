/// 名称:DtPortal.NH.NH02Message.NH0207TemperAnom
/// 描述:查询护士长提示信息的体温异常信息
/// 编写者：bmz
/// 编写日期: 2014-12-03
Class DtPortal.NH.NH02Message.NH0207TemperAnom Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： bmz
/// CreatDate： 2014-12-03
/// Description: 查询护士长提示信息的体温异常信息
/// Input：  userCode         
/// Return： 
/// 服务代码 NH02.07.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0207TemperAnom","NH020701","2156","1")
Query NH020701(userCode As %String, wardId As %String) As DtPortal.Query(ROWSPEC = "bedNum:%String,name:%String,sex:%String,tempPreYest:%String,tempYest:%String,tempToday:%String,patId:%String,age:%String,regNo:%String,EpisodeId:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,medicareNo:%String,admReason:%String,inDay:%String")
{
}

ClassMethod NH020701Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String) As %Status
{
	New (qHandle,userCode,wardId)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:wardId="" $$$OK

	Set admIdStr=""
	Set admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",userCode,wardId)
	Quit:admIdStr="" $$$OK
	Set inNum=$l(admIdStr,"^")
	
	f i=1:1:inNum d
	.s EpisodeId=""
	.s EpisodeId=$p(admIdStr,"^",i)
	.q:EpisodeId=""
	.s TempData=..GetTemperatureTableData(EpisodeId)
    .s TempAnomaliesFlag=$p(TempData,"#",6)
	.q:TempAnomaliesFlag=0
	.s bedNum=$p(TempData,"#",2) 
	.s name=$p(TempData,"#",1)
	.s sex=$p(TempData,"#",7)
	.s tempPreYest=$p(TempData,"#",3)
	.s tempYest=$p(TempData,"#",4)
	.s tempToday=$p(TempData,"#",5)
	.s patId=$p(TempData,"#",8)
	.s age=$p(TempData,"#",9)
	.s medicareNo=$p(TempData,"#",10)
	.s admReason=$p(TempData,"#",11)
	.s regNo=$p(TempData,"#",12)
	.s docDesc=$p(TempData,"#",13)
	.s nurseDesc=$p(TempData,"#",14)
	.s diagnoseDesc=$p(TempData,"#",15)
	.s inDay=$p(TempData,"#",16)
	.s inDateTime=$p(TempData,"#",17)
    .d temperAnomInfo 
	
  	q $$$OK
temperAnomInfo
    s Data=$lb(bedNum,name,sex,tempPreYest,tempYest,tempToday,patId,age,regNo,EpisodeId,docDesc,nurseDesc,diagnoseDesc,medicareNo,admReason,inDay)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Creator： 白明哲
/// CreatDate： 2014-12-3
/// Description: 获取体温异常的数据
/// Input：  AdmId         
/// Return： 个人体温异常信息Name、bedNum、OBSValueList(+$h-2)、OBSValueList(+$h-1)、OBSValueList(+$h)、flag
/// w ##class(DtPortal.NH.NH02Message.NH0207TemperAnom).GetTemperatureTableData()
ClassMethod GetTemperatureTableData(AdmId) As %String
{
	n (AdmId)
	
	
	//体温异常的值，从Portal配置取
	s tempValueLow=##Class(DtPortal.Common.PublicService).getValueByCode("TEMPERATURELOWER")
	s tempValueHigh=##Class(DtPortal.Common.PublicService).getValueByCode("TEMPERATUREHIGHER")
	i (tempValueLow="")||(tempValueHigh="") d
	.s tempValueLow=36
	.s tempValueHigh=37.5
	
	
	s MrAdmId=$p(^PAADM(AdmId),"^",61)
	q:MrAdmId="" ""
	
	s tempCode=##Class(DtPortal.Common.PublicService).getValueByCode("TEMPERATURECODE")
	q:tempCode="" ""
	s OBSItemDR=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4(tempCode),0))  //bmz20180223--取Portal配置
	q:OBSItemDR="" ""
	s flag=0  //判断是否有体温异常标记
	f date=$h-2:1:$h d
	.s OBSValueList(date)=""
	.s childSub=""
	.f  s childSub=$O(^MR(MrAdmId,"OBS",0,"Date",date,OBSItemDR,childSub)) q:childSub=""  d
	..s OBSValue=$p($g(^MR(MrAdmId,"OBS",childSub)),"^",2)
	
	..s OBSTime=$p($g(^MR(MrAdmId,"OBS",childSub)),"^",4)
	..q:+OBSValue=0	//要过滤掉，因为""<36是成立的
	..i ((OBSValue>tempValueHigh)||(OBSValue<tempValueLow))  d
	...s flag=1
	...;i OBSValueList(date)'="" s OBSValueList(date)=OBSValueList(date)_","_OBSValue
	...;e  s OBSValueList(date)=OBSValue
	...s OBSValueList(date,OBSTime)=OBSValue
	.//用数组排序---按体温时间
	.s OBSTime1=""  f  s OBSTime1=$O(OBSValueList(date,OBSTime1)) q:OBSTime1=""  d
	..i OBSValueList(date)'="" s OBSValueList(date)=OBSValueList(date)_","_OBSValueList(date,OBSTime1)
	..e  s OBSValueList(date)=OBSValueList(date,OBSTime1)
	i flag=1 d
	.s Papmidr=$P(^PAADM(AdmId),"^",1)
	.s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(AdmId)
	.s bedNum=$p(patInfoStr,"^",1)
	.s Name=$p(patInfoStr,"^",2)
	.s sex=$p(patInfoStr,"^",3)
	.s age=$p(patInfoStr,"^",4)
	.s MedicareNo=$p(patInfoStr,"^",5)   //病案号
	.s AdmReason=$p(patInfoStr,"^",6)    //费用类型
	.s regNo=$p(patInfoStr,"^",7)    //登记号
	.s docDesc=$p(patInfoStr,"^",11)
	.s nurseDesc=$p(patInfoStr,"^",12)
	.s diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(AdmId)
	.s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(AdmId)
    .s inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(AdmId)
    .s inDate=$p(inTimeStr,"^",1)
    .s inDate=$zd(inDate,3)
    .s inTime=$p(inTimeStr,"^",2)
    .s inTime=$zt(inTime,2)
    .s inDateTime=inDate_"&nbsp;"_inTime
	
	//w $g(Name)_"#"_$g(bedNum)_"#"_$g(OBSValueList(+$h-2))_"#"_$g(OBSValueList(+$h-1))_"#"_$g(OBSValueList(+$h))_"#"_$g(flag)_"#"_$g(sex)_"#"_$g(Papmidr)_"#"_$g(age)_"#"_$g(MedicareNo)_"#"_$g(AdmReason)_"#"_$g(regNo),!
	q $g(Name)_"#"_$g(bedNum)_"#"_$g(OBSValueList(+$h-2))_"#"_$g(OBSValueList(+$h-1))_"#"_$g(OBSValueList(+$h))_"#"_$g(flag)_"#"_$g(sex)_"#"_$g(Papmidr)_"#"_$g(age)_"#"_$g(MedicareNo)_"#"_$g(AdmReason)_"#"_$g(regNo)_"#"_$g(docDesc)_"#"_$g(nurseDesc)_"#"_$g(diagnoseDesc)_"#"_$g(inDay)_"#"_$g(inDateTime)
}

}
