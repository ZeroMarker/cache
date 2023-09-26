/// ClassName:    DtPortal.NH.NH02Message.NH0235ChangeBed
/// Description:  床位变更服务
/// Creator：     yupeng
/// CreatDate:    2018-09-20
Class DtPortal.NH.NH02Message.NH0235ChangeBed Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0235ChangeBed","NH023501","hs01","1")
/// NH02.35.01 床位变更详情表格
/// Creator：     limushuang
Query NH023501(userCode As %String, wardId As %String) As DtPortal.Query(ROWSPEC = "EpisodeID,currentbedNo,oldbedNo,stdate,Time,regNo,patName")
{
}

ClassMethod NH023501Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String) As %Status
{
	New (qHandle,userCode,wardId)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:wardId="" $$$OK
	set TransChildTemp=""
	Set admIdStr=""
	Set admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",userCode,wardId)
	Quit:admIdStr="" $$$OK
	Set inNumLength=$l(admIdStr,"^")
	f i=1:1:inNumLength d
	.s EpisodeID=""
	.s EpisodeID=$p(admIdStr,"^",i)
	.q:EpisodeID=""
	.s stdate=+$H,currentbeddr=0
	.s stTime=""
	.f  s stTime=$o(^PAADMi("TransDateTime1",EpisodeID,stdate,stTime))  q:stTime=""  d
	..s TransChild=""
	..f  s TransChild=$o(^PAADMi("TransDateTime1",EpisodeID,stdate,stTime,TransChild))  q:TransChild=""  d
	...s currentbeddr=$p($g(^PAADM(EpisodeID,"TRANS",TransChild)),"^",8)		;转床后床号
	...q:(currentbeddr="")!(currentbeddr=0)
	...s Time=stTime
	...s TransChildTemp=TransChild
	.q:TransChildTemp=""
	.q:currentbeddr=0
	.s oldchild=TransChildTemp,inflag=""
	.f  s oldchild=$o(^PAADM(EpisodeID,"TRANS",oldchild),-1) q:(oldchild=0)||(inflag=1)  d
	..s oldwardid=$p($g(^PAADM(EpisodeID,"TRANS",oldchild)),"^",9)
	..q:oldwardid'=wardId		;同病区
	..s oldbeddr=$p($G(^PAADM(EpisodeID,"TRANS",oldchild)),"^",8)
	..q:(oldbeddr="")||(oldbeddr=currentbeddr)||(oldbeddr=0)					;转床前床号
	..s inflag=1
	..;w currentbeddr_"^"_oldbeddr,!	
	..s currentbedNo=..GetBedNo(wardId,currentbeddr)
	..s oldbedNo=..GetBedNo(wardId,oldbeddr)
	..s stdate=$zd(stdate,3)
	..s Time=$zt(Time,1)

	..s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
 	..s bedCode=$p(patInfoStr,"^",1)
 	..s patName=$p(patInfoStr,"^",2)
 	..s sex=$p(patInfoStr,"^",3)
 	..s age=$p(patInfoStr,"^",4)
 	..s MedCareNo=$p(patInfoStr,"^",5)   //病案号
 	..s admReason=$p(patInfoStr,"^",6)    //费用类型
 	..s regNo=$p(patInfoStr,"^",7)    //登记号
	
    ..d patinfo
 	Quit $$$OK
patinfo
 	s Data=$lb(EpisodeID,currentbedNo,oldbedNo,stdate,Time,regNo,patName)
 	s ^||CacheTemp(repid,ind)=Data
 	s ind=ind+1
}

/// 根据床位id取床号
/// w ##class(DtPortal.NH.NH02Message.NH0235ChangeBed).GetBedNo("6")
ClassMethod GetBedNo(wardId, beddr)
{
	s bedSub=$p(beddr,"||",2)
	i bedSub'="" s bedCode=$p($g(^PAWARD(wardId,"BED",bedSub)),"^",1)
    e  s bedCode=""
	q bedCode
}

}
