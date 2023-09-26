/// 名称:DtPortal.NH.NH02Message.NH0211FallRisk
/// 描述:护士长患者提示信息的跌倒（坠床）风险
/// 编写者：bmz
/// 编写日期: 2014-12-16
Class DtPortal.NH.NH02Message.NH0211FallRisk Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： bmz
/// CreatDate： 2014-12-16
/// Description: 查询护士长患者提示信息的跌倒（坠床）风险信息
/// Input：  userCode         
/// Return： 
/// 服务代码 NH02.11.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0211FallRisk","NH021101","2156","")
Query NH021101(userCode As %String, wardId As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,inDateTime:%String,emrUser:%String,emrDate:%String")
{
}

ClassMethod NH021101Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String) As %Status
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
	
	
	//取填写了压疮评估单的患者，取最后一次录的数据
	set findDays="30"
	
	f i=1:1:inNNum d
	.s EpisodeId=""
	.s EpisodeId=$p(admIdStr,"^",i)
	.q:EpisodeId=""
	.s str=##class(NurMp.Sources.RecordInterface).FallRisk(EpisodeId)
	.s emrDate="",emrUser=""
	.;w !,str
	.s emrDate1=$p($p(str,"#",1),"^",1)
	.s emrUser1=$p($p(str,"#",1),"^",2)  //报告人1
	.s emrDate2=$p($p(str,"#",2),"^",1)
	.s emrUser2=$p($p(str,"#",2),"^",2)   //报告人2
	.s emrDate3=$p($p(str,"#",3),"^",1)
	.s emrUser3=$p($p(str,"#",3),"^",2)   //报告人3
	.s emrDate4=$p($p(str,"#",4),"^",1)
	.s emrUser4=$p($p(str,"#",4),"^",2)   //报告人4
	.s emrDate5=$p($p(str,"#",5),"^",1)
	.s emrUser5=$p($p(str,"#",5),"^",2)   //报告人5
	.i (emrDate1'="")&&(emrUser1'="")&&((+$h-$zdh(emrDate1,3))<findDays) s emrDate=emrDate1,emrUser=emrUser1	
	.i (emrDate2'="")&&(emrUser2'="")&&((+$h-$zd(emrDate1,3))<findDays) s emrDate=emrDate2,emrUser=emrUser2
	.i (emrDate3'="")&&(emrUser3'="")&&((+$h-$zd(emrDate1,3))<findDays) s emrDate=emrDate3,emrUser=emrUser3
	.i (emrDate4'="")&&(emrUser4'="")&&((+$h-$zd(emrDate1,3))<findDays) s emrDate=emrDate4,emrUser=emrUser4
	.i (emrDate5'="")&&(emrUser5'="")&&((+$h-$zd(emrDate1,3))<findDays) s emrDate=emrDate5,emrUser=emrUser5
	
	.i (emrDate'="")&&(emrUser'="") d
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
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inDateTime,emrUser,emrDate)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
