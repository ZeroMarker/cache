/// 名称: DHCHAI.DI.ERR.SyncEmrErrInfo
/// 描述: 同步东华病历数据（修改、删除的数据）
/// 编写者：zhufei
/// 编写日期: 2018-03-24
Class DHCHAI.DI.ERR.SyncEmrErrInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCHAI.DI.ERR.SyncEmrErrInfo).SyncEmrErrByEpis("EMR01","HIS01||28")
ClassMethod SyncEmrErrByEpis(aSCode As %String, aEpisodeIDX As %String, aFromDate As %String = "", aToDate As %String = "") As %List
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
		Set xID=$o(^DHCHAI.DP.EmrRecordI("IndexEpisodeDr",EpisodeDr,xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.EmrRecord).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.EmrSCode'=aSCode
		Set IsActive=obj.EmrIsActive
		Set UpdateDate=obj.EmrUpdateDate
		Set UpdateTime=obj.EmrUpdateTime
		Set XCode=obj.EmrXCode
		Continue:XCode=""
		
		//处理新旧版本电子病历更新删除记录导致所有记录IsActive都无效的bug
		Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(XCode)
		If '$IsObject(objInstance) {
			Set objInstance=##Class(EPRinstance.InstanceData).%OpenId(XCode)
		}
		If objInstance'="" Do objInstance.%Close()
		If '$IsObject(objInstance) {
			If IsActive=1 {
				Do ##class(DHCHAI.DP.EmrRecord).CancelById(xID)
				Continue
			}
		} Else {
			If objInstance.Status="Delete" {
				If IsActive=1 {
					Do ##class(DHCHAI.DP.EmrRecord).CancelById(xID)
					Continue
				}
			} Else {
				Set timDocDate    = objInstance.CreateDate     // 记录日期
				Set timUpdateDate = objInstance.ModifyDate     // 修改日期
				Set timUpdateTime = objInstance.ModifyTime     // 修改时间
				If (timUpdateDate>UpdateDate)||((timUpdateDate=UpdateDate)&(timUpdateTime>UpdateTime)) {
					Continue:$listfind(UpdateDateList,timUpdateDate)>0
					Set UpdateDateList=UpdateDateList_$lb(timUpdateDate)
				}
			}
		}
    }
    For indList=1:1:$ll(UpdateDateList){
	    Set xDate=$listget(UpdateDateList,indList)
	    Continue:xDate=""
	    
	    //同步数据
    	Set Cnt=##class(DHCHAI.DI.DHS.SyncEmrInfo).SyncEmrByDateAdm(aSCode,aEpisodeIDX,xDate,xDate)
    	Set Count=Count+Cnt
    }
    Set return=Count
	Quit return
}

}
