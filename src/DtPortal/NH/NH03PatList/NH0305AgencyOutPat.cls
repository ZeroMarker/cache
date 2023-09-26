/// DtPortal.NH.NH03PatList.NH0305AgencyOutPat
/// 描述:查询护士长患者列表待办出院患者的信息
/// 编写者：程鹏
/// 编写日期: 2018-11-22
Class DtPortal.NH.NH03PatList.NH0305AgencyOutPat Extends %RegisteredObject
{

/// Creator： bmz
/// CreatDate： 2014-12-04
/// Description: 查询护士长患者列表待办出院患者的信息
/// Input：  UserCode         
/// Return： 
/// 服务代码 NH03.05.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH03PatList.NH0305AgencyOutPat","NH030501AgencyOutPat","hs01",1)	
Query NH030501AgencyOutPat(UserCode As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,inTime:%String,PAAdm:%String,PatTotal:%String,JFType:%String,PatShare:%String,PatDeposit:%String,PatQfTotal:%String,inDateTime")
{
}

ClassMethod NH030501AgencyOutPatExecute(ByRef qHandle As %Binary, UserCode As %String, WardId As %String) As %Status
{
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:WardId="" $$$OK
	
	//取今日出院/明日出院医嘱ID
	
	s arcimID=##Class(DtPortal.Configure.arcim).getArcImID("TODAYDISCHARGE^TOMMORROWDISCHARGE",1)	//今日出院^明日出院
	
	Set admIdStr=""
	Set admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",UserCode,WardId)
	Quit:admIdStr="" $$$OK
	Set inNNum=$l(admIdStr,"^")

	f i=1:1:inNNum d
	.s EpisodeId=$p(admIdStr,"^",i)
	.q:EpisodeId=""
	.s EstDischConfirmed=""
	.s flag=##class(DtPortal.Common.PaadmService).IsHaveArc(EpisodeId,arcimID,+$h)   //判断是否待办出院
	.s EstDischConfirmed=$p(^PAADM(EpisodeId,2),"^",25)  //医生医疗结算标记
	.q:((flag="")&&(EstDischConfirmed'="Y"))
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
	.s inDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(EpisodeId)
    .s inTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeId)
    .s inDate=$p(inTimeStr,"^",1)
    .s inDate=$zd(inDate,3)
    .s inTime=$p(inTimeStr,"^",2)
    .s inTime=$zt(inTime,2)
    .s inDateTime=inDate_"&nbsp;"_inTime
    
	.s arrPatStr=##class(DtPortal.Common.PaadmService).IsArrears(EpisodeId)
	.s QFflag=$p(arrPatStr,"^",1)
	.s PatTotal=$p(arrPatStr,"^",2)  //总费用 $fn(+$g(PatQfTotal),"",2)
	.s PatQfTotal=$p(arrPatStr,"^",3) //欠费总额信息
	.s PAAdm=EpisodeId
	.d agencyOutPat 
  	q $$$OK
agencyOutPat
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inTime,PAAdm,PatTotal,JFType,PatShare,PatDeposit,PatQfTotal,inDateTime)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
