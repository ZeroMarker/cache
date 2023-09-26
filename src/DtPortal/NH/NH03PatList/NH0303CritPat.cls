/// DtPortal.NH.NH03PatList.NH0303CritPat
/// 描述:查询护士长患者列表危重患者的信息
/// 编写者：程鹏
/// 编写日期: 2018-11-22
Class DtPortal.NH.NH03PatList.NH0303CritPat Extends %RegisteredObject
{

/// 名称:DtPortal.NH.NH03PatList.NH0303CritPat
/// CreatDate： 2018-11-22
/// Description: 查询护士长患者列表危重患者的信息
/// Input：  UserCode,Type 1-病危 2-病重     
/// Return： 
/// 服务代码 NH03.03.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH03PatList.NH0303CritPat","NH030301CritPat","2156","1",1)
Query NH030301CritPat(UserCode As %String, Type As %String, WardId As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,sex:%String,age:%String,medicareNo:%String,admReason:%String,regNo:%String,docDesc:%String,nurseDesc:%String,diagnoseDesc:%String,inDay:%String,inTime:%String,locDesc:%String,nurseLevel:%String,inDateTime")
{
}

ClassMethod NH030301CritPatExecute(ByRef qHandle As %Binary, UserCode As %String, Type As %String, WardId As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:WardId="" $$$OK
	Quit:Type="" $$$OK
	
	//取病危和病重医嘱ID
	s SeriouslyID=""
	s SeriouslyID=##Class(DtPortal.Configure.arcim).getArcImID("SERIOUSLY",1)	//病重
	s CriticallyID=""
	s CriticallyID=##Class(DtPortal.Configure.arcim).getArcImID("CRITICALLY",1)	//病危
	
	//获取护理级别code
	s NurseLevelID=##Class(DtPortal.Configure.arcim).getArcImID("NURSELEVEL",1)	//获取code
	
	s arcimID=""
	s arcimStr=""
	i (SeriouslyID="")||(CriticallyID="")  Quit $$$OK
	
	s:Type=1 arcimID=CriticallyID,arcimStr="CRITICALLY"
	s:Type=2 arcimID=SeriouslyID,arcimStr="SERIOUSLY"
	

	Set admIdStr=""
	Set admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",UserCode,WardId)
	Quit:admIdStr="" $$$OK
	Set inNNum=$l(admIdStr,"^")
	
	f i=1:1:inNNum d
	.s EpisodeId=""
	.s EpisodeId=$p(admIdStr,"^",i)
	.s admDate=$P($g(^PAADM(EpisodeId)),"^",6)
	
	.s flag=""
	.s flag=##class(DtPortal.Common.PaadmService).IsHaveArc(EpisodeId,arcimID,+$h)
	.q:flag=""
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
    .//取护理级别
 	.s nurseLevel=##class(DtPortal.Common.PaadmService).IsHaveArc(EpisodeId,NurseLevelID,+$h)
 	
	.d specailList 
	
 
  	q $$$OK
specailList
    s Data=$lb(bedCode,name,sex,age,medicareNo,admReason,regNo,docDesc,nurseDesc,diagnoseDesc,inDay,inTime,locDesc,nurseLevel,inDateTime)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

}
