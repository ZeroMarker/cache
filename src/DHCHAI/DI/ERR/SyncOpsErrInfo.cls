/// 名称: DHCHAI.DI.ERR.SyncOpsErrInfo
/// 描述: 同步东华手麻数据（修改、作废的数据）
/// 编写者：zhufei
/// 编写日期: 2018-03-24
Class DHCHAI.DI.ERR.SyncOpsErrInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Do ##class(DHCHAI.DI.ERR.SyncOpsErrInfo).SyncOperErrByEpis("OPS01","HIS01||28")
ClassMethod SyncOperErrByEpis(aSCode As %String, aEpisodeIDX As %String, aFromDate As %String = "", aToDate As %String = "") As %List
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
		Set xID=$o(^DHCHAI.DP.OROperAnaesI("IndexEpisodeDr",EpisodeDr,xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.OROperAnaes).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.ORSCode'=aSCode
		Set IsActive=obj.ORIsActive
		Set UpdateDate=obj.ORUpdateDate
		Set UpdateTime=obj.ORUpdateTime
		Set XCode=obj.ORXCode
		Continue:XCode=""
		
		Set OperInfo=$g(^DHCANOPArrange(XCode))
		If OperInfo="" {
			If IsActive=1 {
				Do ##class(DHCHAI.DP.OROperAnaes).CancelById(xID)
				Continue
			}
		} Else {
			Set timOperDate   = $p(OperInfo,"^",14)     // 手术日期
			Set timUpdateDate = $p(OperInfo,"^",14)     // 修改日期(手术日期)
			Set timUpdateTime = $p(OperInfo,"^",15)     // 修改时间(手术时间)
			Continue:(timUpdateDate="")||(timUpdateTime="")
			//If (timUpdateDate>UpdateDate)||((timUpdateDate=UpdateDate)&(timUpdateTime>UpdateTime)) {
			//	Continue:$listfind(UpdateDateList,timOperDate)>0
			//	Set UpdateDateList=UpdateDateList_$lb(timOperDate)
			//}
		}
    }
    For indList=1:1:$ll(UpdateDateList){
	    Set xDate=$listget(UpdateDateList,indList)
	    Continue:xDate=""
	    
	    //同步数据
    	Set Cnt=##class(DHCHAI.DI.DHS.SyncOpsInfo).SyncOperByDateAdm(aSCode,aEpisodeIDX,xDate,xDate)
    	Set Count=Count+Cnt
    }
    Set return=Count
	Quit return
}

/// Do ##class(DHCHAI.DI.ERR.SyncOpsErrInfo).SyncEMROperErrByEpis("EMR01","HIS01||2889")
ClassMethod SyncEMROperErrByEpis(aSCode As %String, aEpisodeIDX As %String, aFromDate As %String = "", aToDate As %String = "") As %List
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
		Set xID=$o(^DHCHAI.DP.OROperationI("IndexEpisodeDr",EpisodeDr,xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.OROperation).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.ORSCode'=aSCode
		Set IsActive=obj.ORIsActive
		Set UpdateDate=obj.ORUpdateDate
		Set UpdateTime=obj.ORUpdateTime
		Set OperSource=obj.OROperSource
		Continue:OperSource'="E"
		Set XCode=obj.ORXCode
		Continue:XCode=""
			
		//处理新旧版本电子病历更新删除记录导致所有记录IsActive都无效的bug
		Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(XCode)
		If '$IsObject(objInstance) {
			Set objInstance=##Class(EPRinstance.InstanceData).%OpenId(XCode)
		}
		If objInstance'="" Do objInstance.%Close()
		If '$IsObject(objInstance) {
			If IsActive=1 {
				Do ##class(DHCHAI.DP.OROperation).CancelById(xID)
				Continue
			}
		} Else {
			If objInstance.Status="Delete" {
				If IsActive=1 {
					Do ##class(DHCHAI.DP.OROperation).CancelById(xID)
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
    	Set Cnt= ##class(DHCHAI.DI.DHS.SyncMrInfo).SyncEMROperByDateAdm(aSCode,aEpisodeIDX,xDate,xDate)
    	Set Count=Count+Cnt
    }
    
    Set return=Count
	Quit return
}

/// Do ##class(DHCHAI.DI.ERR.SyncOpsErrInfo).SyncWMROperErrByEpis("MRS01","HIS01||2889")
ClassMethod SyncWMROperErrByEpis(aSCode As %String, aEpisodeIDX As %String, aFromDate As %String = "", aToDate As %String = "") As %List
{
	New (aSCode,aEpisodeIDX,aFromDate,aToDate)
	Set return=0,Count=0
	Quit:(aSCode="")||(aEpisodeIDX="") return
	
	//开始日期和结束日期范围内的数据，不检查错误
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set:aFromDate="" aFromDate=+$h
	Set:aToDate="" aToDate=+$h
	
	Set WMRSystemVer=##class(DHCHAI.BT.Config).GetValByCode("DPWMRSystemVer")
	Quit:( WMRSystemVer'="WMR3.0")&&(WMRSystemVer'="WMR4.0") return
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objEpisode) return
	Set EpisodeDr=objEpisode.%Id()
	
	Set UpdateDateList=""
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.OROperationI("IndexEpisodeDr",EpisodeDr,xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.DP.OROperation).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.ORSCode'=aSCode
		Set IsActive=obj.ORIsActive
		Set UpdateDate=obj.ORUpdateDate
		Set UpdateTime=obj.ORUpdateTime
		Set OperSource=obj.OROperSource
		Continue:OperSource'="F"
		Set XCode=obj.ORXCode
		Continue:XCode=""
		Set OperInfo=""
		If (WMRSystemVer="WMR3.0"){
			Set xTypeID=0
			For {
				Set xTypeID=$o(^DHCWMR.FP.FrontPageI("FPO","IndexTypeIndex",$p(XCode,"||",1),xTypeID))
				Quit:xTypeID=""
				
				Set xIndex=""
				For {
					Set xIndex=$o(^DHCWMR.FP.FrontPageI("FPO","IndexTypeIndex",$p(XCode,"||",1),xTypeID,xIndex))
					Quit:xIndex=""
					
					Set OperInfo=$g(^DHCWMR.FP.FrontPageI("FPO","IndexTypeIndex",$p(XCode,"||",1),xTypeID,xIndex,$p(XCode,"||",2)))
				}
			}
		}
		If (WMRSystemVer="WMR4.0") {
			Set xIndex=""
			For {
				Set xIndex=$o(^MA.IPMR.FP.DataMasterI("Oper","IndexFCIndex",$p(XCode,"||",1),xIndex))
				Quit:xIndex=""
				Set OperInfo=$g(^MA.IPMR.FP.DataMasterI("Oper","IndexFCIndex",$p(XCode,"||",1),xIndex,$p(XCode,"||",2)))
			}
		}
	
		If OperInfo="" {
			If IsActive=1 {
				Do ##class(DHCHAI.DP.OROperation).CancelById(xID)
				Continue
			}
		} 

    }    
    Set return=Count
	Quit return
}

}
