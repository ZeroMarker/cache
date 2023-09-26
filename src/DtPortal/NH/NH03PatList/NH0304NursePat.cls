/// 名称:DtPortal.NH.NH03PatList.NH0304NursePat
/// 描述:查询护士长患者列表护理患者的信息
/// 编写者：程鹏
/// 编写日期: 2018-11-22
Class DtPortal.NH.NH03PatList.NH0304NursePat Extends %RegisteredObject
{

/// 名称:DtPortal.NH.NH03NursePatientList
/// CreatDate： 2014-12-04
/// Description: 查询护士长患者列表护理患者的信息
/// Input：  UserCode,Type 1-特级护理 2-一级护理     
/// Return： 
/// 服务代码 NH03.04.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH03PatList.NH0304NursePat","NH030401NursePat","hs01","FIRSTCLSCARE","4")
Query NH030401NursePat(UserCode As %String, Type As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,inTime:%String,locDesc:%String,inDateTime")
{
}

ClassMethod NH030401NursePatExecute(ByRef qHandle As %Binary, UserCode As %String, Type As %String, WardId As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:WardId="" $$$OK
	Quit:Type="" $$$OK
	
	s arcimID=##Class(DtPortal.Configure.arcim).getArcImID(Type,1)	
	
	Set admIdStr=""
	Set admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",UserCode,WardId)
	Quit:admIdStr="" $$$OK
	Set inNNum=$l(admIdStr,"^")
	
	f i=1:1:inNNum d
	.s EpisodeId=""
	.s EpisodeId=$p(admIdStr,"^",i)
	.s admDate=$P($g(^PAADM(EpisodeId)),"^",6)
	
	.s nurDesc=##class(DtPortal.Common.PaadmService).IsHaveArc(EpisodeId,arcimID,+$h)
	.q:nurDesc=""
	.s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)

 	.s bedCode=$p(patInfoStr,"^",1)
 	.s name=$p(patInfoStr,"^",2)
 	.s sex=$p(patInfoStr,"^",3)
 	.s age=$p(patInfoStr,"^",4)
 	.s medicareNo=$p(patInfoStr,"^",5)   //病案号
 	.s admReason=$p(patInfoStr,"^",6)    //费用类型
 	.s regNo=$p(patInfoStr,"^",7)    //登记号
 	.s nurseDesc=$p(patInfoStr,"^",12)
 	.s docDesc=$p(patInfoStr,"^",11)
	.s locDesc=$p(patInfoStr,"^",9)
	.s diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)
    
    .s inDateTime=##class(Nur.CommonInterface.Patient).getInDeptDateTime(EpisodeId)
    .s dateTemp=$p(inDateTime," ",1)
    .s dateTemp=##class(websys.Conversions).DateHtmlToLogical(dateTemp)
    .s inDateTime=$zd(dateTemp,3)_"&nbsp;"_$p(inDateTime," ",2)
    .s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)
	.d nursePatientList 
	
 
  	q $$$OK
nursePatientList
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inTime,locDesc,inDateTime)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
