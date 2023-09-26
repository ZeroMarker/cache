/// 名称: DHCHAI.DI.DHS.SyncLocInfo
/// 描述: 特殊处理科室字典信息
/// 编写者：zhufei
/// 编写日期: 2017-10-27
Class DHCHAI.DI.DHS.SyncLocInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 测试方法
/// w ##class(DHCHAI.DI.DHS.SyncLocInfo).Test("2017-07-01","2017-07-01")
ClassMethod Test(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return = ""
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateFrom'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	
	//按就诊执行监控和筛查
	Set CurrTime = $h
	Set arrEpisodeDr=##class(DHCHAI.Task.DPAdmListSrv).GetEpisodeDrByDate(aDateFrom,aDateTo)
	For indEpis=1:1:arrEpisodeDr.Count() {
		Set xEpisodeDr=arrEpisodeDr.GetAt(indEpis)
		Continue:xEpisodeDr=""
		
		Write "EpisodeDr="_xEpisodeDr,!
		
		//根据就诊科室同步科室是否有效
		Do ##Class(DHCHAI.DI.DHS.SyncLocInfo).SetLocActByAdm(xEpisodeDr)
	}
	Write "按就诊执行监控和筛查用时："_($p($h,",",2)-$p(CurrTime,",",2))_"s",!
	
	Quit "OK"
}

/// Creator：     mayanpeng
/// CreatDate：   2017-10-19
/// Description:  通过就诊表将全部存在在院病人的科室置为有效
/// 			  先运行sql：Update DHCHAI_BT.Location SET BTIsActive = 0
/// w ##Class(DHCHAI.DI.DHS.SyncLocInfo).SetLocActByAdm()
ClassMethod SetLocActByAdm(aEpisodeDr As %String) As %String
{
	New (aEpisodeDr)
	Set return="",Count=0
	Quit:aEpisodeDr="" return
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objAdm) return
	
	If $IsObject(objAdm.PAAdmLocDr) {
		Set LocDr=objAdm.PAAdmLocDr.%Id()
		Do SetLocActive
	}
	
	If $IsObject(objAdm.PAAdmWardDr) {
		Set LocDr=objAdm.PAAdmWardDr.%Id()
		Do SetLocActive
	}
	
	Set return=Count
	Quit return
	
SetLocActive
	Set obj=##class(DHCHAI.BT.Location).GetObjById(LocDr)
	Quit:'$IsObject(obj)
	Quit:obj.BTIsActive=1
	
	Set obj=##class(DHCHAI.BT.Location).%OpenId(LocDr)
	Set obj.BTIsActive=1
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
	}Else{
		Set Count = Count + 1
	}
	Quit
}

}
