/// 名称: DHCHAI.DI.ERR.SyncNisErrInfo
/// 描述: 同步东华护理数据（修改、作废的数据）
/// 编写者：zhufei
/// 编写日期: 2018-03-24
Class DHCHAI.DI.ERR.SyncNisErrInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Do ##class(DHCHAI.DI.ERR.SyncNisErrInfo).SyncNisErrByEpis("NIS01","HIS01||28")
ClassMethod SyncNisErrByEpis(aSCode As %String, aEpisodeIDX As %String, aFromDate As %String = "", aToDate As %String = "") As %List
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
		Set xID=$o(^DHCHAI.DP.MRObservationsI("IndexEpisodeDr",EpisodeDr,xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.MRObservations).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.OBSCode'=aSCode
		Set IsActive=obj.OBIsActive
		Set UpdateDate=obj.OBUpdateDate
		Set UpdateTime=obj.OBUpdateTime
		Set XCode=obj.OBXCode
		Continue:XCode=""
		
		Set OBSInfo=$g(^MR(+XCode,"OBS",+$p(XCode,"||",2)))
		If OBSInfo="" {
			If IsActive=1 {
				Do ##class(DHCHAI.DP.MRObservations).CancelById(xID)
				Continue
			}
		} Else {
			Set timEntryDate  = $p(OBSInfo,"^",3)      // 记录日期
			Set timUpdateDate = $p(OBSInfo,"^",11)     // 修改日期
			Set timUpdateTime = $p(OBSInfo,"^",12)     // 修改时间
			If (timUpdateDate>UpdateDate)||((timUpdateDate=UpdateDate)&(timUpdateTime>UpdateTime)) {
				Continue:$listfind(UpdateDateList,timEntryDate)>0
				Set UpdateDateList=UpdateDateList_$lb(timEntryDate)
			}
		}
    }
    For indList=1:1:$ll(UpdateDateList){
	    Set xDate=$listget(UpdateDateList,indList)
	    Continue:xDate=""
	    
	    //同步数据
    	Set Cnt=##class(DHCHAI.DI.DHS.SyncNisInfo).SyncNisByDateAdm(aSCode,aEpisodeIDX,xDate,xDate)
    	Set Count=Count+Cnt
    }
    Set return=Count
	Quit return
}

}
