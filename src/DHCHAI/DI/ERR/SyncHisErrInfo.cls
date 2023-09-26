/// 名称: DHCHAI.DI.ERR.SyncHisErrInfo
/// 描述: 同步东华HIS数据（修改、作废的数据）
/// 编写者：zhufei
/// 编写日期: 2018-03-24
Class DHCHAI.DI.ERR.SyncHisErrInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Do ##class(DHCHAI.DI.ERR.SyncHisErrInfo).SyncOrdErrByEpis("HIS01","HIS01||28")
ClassMethod SyncOrdErrByEpis(aSCode As %String, aEpisodeIDX As %String, aFromDate As %String = "", aToDate As %String = "") As %List
{
	New (aSCode,aEpisodeIDX,aFromDate,aToDate)
	Set return=0,Count=0
	Quit:(aSCode="")||(aEpisodeIDX="") return
	
	//开始日期和结束日期范围内的数据，不检查错误
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set:aFromDate="" aFromDate=+$h
	Set:aToDate="" aToDate=+$h
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objEpisode) return
	Set EpisodeDr=objEpisode.%Id()
	
	Set UpdateDateList=""
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisodeDr",EpisodeDr,xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.OESCode'=aSCode
		Set IsActive=obj.OEIsActive
		Set UpdateDate=obj.OEUpdateDate
		Set UpdateTime=obj.OEUpdateTime
		Set XCode=obj.OEXCode
		Continue:XCode=""
		
		Set OrdInfo=$g(^OEORD(+XCode,"I",+$p(XCode,"||",2),1))
		If OrdInfo="" {
			If IsActive=1 {
				Do ##class(DHCHAI.DP.OEOrdItem).CancelById(xID)
				Continue
			}
		} Else {
			Set timSttDate    = $p($g(^OEORD(+XCode,"I",+$p(XCode,"||",2),1)),"^",9)  // 开始日期
			Set timXDate      = $p($g(^OEORD(+XCode,"I",+$p(XCode,"||",2),3)),"^",34) // 停止日期
			//取更新日期时间
			Set timChl=$o(^OEORD(+XCode,"I",+$p(XCode,"||",2),"ST",""),-1)
			Continue:(+timChl)<0
			Set timUpdateDate = $p($g(^OEORD(+XCode,"I",+$p(XCode,"||",2),"ST",+timChl)),"^",1) // 修改日期
			Set timUpdateTime = $p($g(^OEORD(+XCode,"I",+$p(XCode,"||",2),"ST",+timChl)),"^",2) // 修改时间
			Continue:(timUpdateDate="")||(timUpdateTime="")
			If (timUpdateDate>UpdateDate)||((timUpdateDate=UpdateDate)&(timUpdateTime>UpdateTime)) {
				If $listfind(UpdateDateList,timSttDate)<1 {
					Set UpdateDateList=UpdateDateList_$lb(timSttDate)
				}
				If $listfind(UpdateDateList,timXDate)<1 {
					Set UpdateDateList=UpdateDateList_$lb(timXDate)
				}
			}
		}
    }
    For indList=1:1:$ll(UpdateDateList){
	    Set xDate=$listget(UpdateDateList,indList)
	    Continue:xDate=""
	    
	    //同步数据
    	Set Cnt=##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmOEOrdItem(aSCode,aEpisodeIDX,xDate,xDate)
    	Set Count=Count+Cnt
    }
    Set return=Count
	Quit return
}

}
