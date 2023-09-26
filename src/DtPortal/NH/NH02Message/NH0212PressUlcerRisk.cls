/// 名称:DtPortal.NH.NH13PressUlcerRisk
/// 描述:护士长患者提示信息的压疮风险
/// 编写者：bmz
/// 编写日期: 2014-12-03
Class DtPortal.NH.NH02Message.NH0212PressUlcerRisk Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： bmz
/// CreatDate： 2014-12-03
/// Description: 查询护士长患者提示信息的压疮风险信息
/// Input：  userCode         
/// Return： 
/// 服务代码 NH02.12.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0212PressUlcerRisk","NH021201","2156","")
Query NH021201(userCode As %String, wardId As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,inDateTime:%String,pressScore:%String,emrUser:%String,emrDate:%String")
{
}

ClassMethod NH021201Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String) As %Status
{
	New (qHandle,userCode,wardId)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:wardId="" $$$OK
	
	Set admIdStr=""
	Set admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",userCode,wardId)
	Quit:admIdStr="" $$$OK
	Set inNNum=$l(admIdStr,"^")
	
	set findDays="30"
	//Set code="DHCNURXHFFYC"
	
	//Set code=$ZConvert(code,"U")
	
	//取填写了压疮评估单的患者，取最后一次录的数据
	
	f i=1:1:inNNum d
	.s EpisodeId=""
	.s EpisodeId=$p(admIdStr,"^",i)
	.q:EpisodeId=""
	.s str=##class(NurMp.Sources.RecordInterface).PressureSoreRisk(EpisodeId,$zd(+$h-findDays,3),$zd(+$h,3))
	.s emrDate="",emrUser=""
	.q:str=""
	.s emrDate=$p(str,"^",1)
	.s emrUser=$p(str,"^",2)  //报告人
	.s pressScore=$p(str,"^",3)  //分数
	.i (emrDate'="")&(emrUser'="") d
	..d getPatInfo
	..d PressUlcerRisk
	
	q $$$OK
	
	
getPatInfo
	s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)
 	s bedCode=$p(patInfoStr,"^",1)
 	s name=$p(patInfoStr,"^",2)
 	s sex=$p(patInfoStr,"^",3)
 	s age=$p(patInfoStr,"^",4)
 	s medicareNo=$p(patInfoStr,"^",5)   //病案号
 	s admReason=$p(patInfoStr,"^",6)    //费用类型
 	s regNo=$p(patInfoStr,"^",7)    //登记号
 	s docDesc=$p(patInfoStr,"^",11)
	s nurseDesc=$p(patInfoStr,"^",12)
	s diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)
	s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)
    s inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeId)
    s inDate=$p(inTimeStr,"^",1)
    s inDate=$zd(inDate,3)
    s inTime=$p(inTimeStr,"^",2)
    s inTime=$zt(inTime,2)
    s inDateTime=inDate_"&nbsp;"_inTime

	q
 

PressUlcerRisk
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inDateTime,pressScore,emrUser,emrDate)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
