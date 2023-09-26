/// DtPortal.NH.NH03PatList.NH0301AdmitPat
/// 描述:查询护士长患者列表在院患者的信息
/// 编写者：程鹏
/// 编写日期: 2018-11-21
Class DtPortal.NH.NH03PatList.NH0301AdmitPat Extends %RegisteredObject
{

/// 名称:DtPortal.NH.NH03PatList.NH0305InpatientPat
/// CreatDate： 2014-12-04
/// Description: 查询护士长患者列表在院患者的信息
/// Input：  userCode         
/// Return： 
/// 服务代码 NH03.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH03PatList.NH0301AdmitPat","NH030101AdmitPat","hs01",2)
Query NH030101AdmitPat(UserCode As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,inDateTime:%String,EpisodeId:%String")
{
}

ClassMethod NH030101AdmitPatExecute(ByRef qHandle As %Binary, UserCode As %String, WardId As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:WardId="" $$$OK
	
	Set admIdStr=""
	Set admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",UserCode,WardId)
	Quit:admIdStr="" $$$OK
	Set inNNum=$l(admIdStr,"^")
	
	f i=1:1:inNNum d
	.s EpisodeId=""
	.s EpisodeId=$p(admIdStr,"^",i)
	.s admDate=$P($g(^PAADM(EpisodeId)),"^",6)
	.s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)
 	.s bedCode=$p(patInfoStr,"^",1)
 	.s name=$p(patInfoStr,"^",2)
 	.s sex=$p(patInfoStr,"^",3)
 	.s age=$p(patInfoStr,"^",4)
 	.s medicareNo=$p(patInfoStr,"^",5)   //病案号
 	.s admReason=$p(patInfoStr,"^",6)    //费用类型
 	.s regNo=$p(patInfoStr,"^",7)    //登记号
 	.s docDesc=$p(patInfoStr,"^",11)
	.s nurseDesc=$p(patInfoStr,"^",12)
	.s diagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeId)
	.s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)
    .s inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeId)
    .s inDate=$p(inTimeStr,"^",1)
    .s dae=inDate

    .s inDate=$zd(inDate,3)
    .s inTime=$p(inTimeStr,"^",2)
    .s inTime=$zt(inTime,2)
    .s inDateTime=""
    .i (dae'="") s inDateTime=inDate_"&nbsp;"_inTime
	.d inpatientList 
	
 
  	q $$$OK
inpatientList
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inDateTime,EpisodeId)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
