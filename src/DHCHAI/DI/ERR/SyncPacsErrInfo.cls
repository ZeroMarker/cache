/// 名称: DHCHAI.DI.ERR.SyncPacsErrInfo
/// 描述: 同步东华检查报告数据（修改、作废的数据）
/// 编写者：zhufei
/// 编写日期: 2018-03-24
Class DHCHAI.DI.ERR.SyncPacsErrInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Do ##class(DHCHAI.DI.ERR.SyncPacsErrInfo).SyncPacsErrByEpis("RIS01","HIS01||88")
ClassMethod SyncPacsErrByEpis(aSCode As %String, aEpisodeIDX As %String, aFromDate As %String = "", aToDate As %String = "") As %List
{
	New (aSCode,aEpisodeIDX,aFromDate,aToDate)
	Set return=0,Count=0
	Quit:(aSCode="")||(aEpisodeIDX="") return
	
	//开始日期和结束日期范围内的数据，不检查错误
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set:aFromDate="" aFromDate=+$h
	Set:aToDate="" aToDate=+$h
	
	Set RisRepVer=##class(DHCHAI.BT.Config).GetValByCode("DPRisReportVer")
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objEpisode) return
	Set EpisodeDr=objEpisode.%Id()
	
	Set UpdateDateList=""
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.RBReportI("IndexEpisodeDr",EpisodeDr,xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.RBReport).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.RBSCode'=aSCode
		Set IsActive=obj.RBIsActive
		Set UpdateDate=obj.RBUpdateDate
		Set UpdateTime=obj.RBUpdateTime
		Set XCode=obj.RBXCode
		Continue:XCode=""
		
		If (RisRepVer="RISC1.0"){   //xml格式的接口未知，暂不处理
			Continue   
		}ElseIf (RisRepVer="RISC2.0"){ 
			Set RISInfo=$g(^Busi.ENS.EnsRISReportResultD(XCode))
			Set timReportDate  = $p(RISInfo,"^",10)      // 报告日期
			Set timUpdateDate = $p(RISInfo,"^",29)      // 修改日期
			Set timUpdateTime = $p(RISInfo,"^",30)     // 修改时间

		}Else {
			Set RISInfo=$g(^DHCRBStudy("Report",XCode))
			Set timReportDate  = $p(RISInfo,"^",9)      // 报告日期
			Set timUpdateDate = $p(RISInfo,"^",9)      // 修改日期
			Set timUpdateTime = $p(RISInfo,"^",10)     // 修改时间
		}
		If RISInfo="" {
			If IsActive=1 {
				Do ##class(DHCHAI.DP.RBReport).CancelById(xID)
				Continue
			}
		} Else {
			If (timUpdateDate>UpdateDate)||((timUpdateDate=UpdateDate)&(timUpdateTime>UpdateTime)) {
				Continue:$listfind(UpdateDateList,timReportDate)>0
				Set UpdateDateList=UpdateDateList_$lb(timReportDate)
			}
		}
    }
    For indList=1:1:$ll(UpdateDateList){
	    Set xDate=$listget(UpdateDateList,indList)
	    Continue:xDate=""
	    
	    //同步数据
    	Set Cnt=##class(DHCHAI.DI.DHS.SyncPacsInfo).SyncPacsByDateAdm(aSCode,aEpisodeIDX,xDate,xDate)
    	Set Count=Count+Cnt
    }
    Set return=Count
	Quit return
}

}
