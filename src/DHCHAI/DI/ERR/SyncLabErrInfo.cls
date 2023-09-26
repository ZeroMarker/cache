/// 名称: DHCHAI.DI.ERR.SyncLabErrInfo
/// 描述: 同步东华检验数据（修改、作废的数据）
/// 编写者：zhufei
/// 编写日期: 2018-03-24
Class DHCHAI.DI.ERR.SyncLabErrInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Do ##class(DHCHAI.DI.ERR.SyncLabErrInfo).SyncLabErrByEpis("LIS01","HIS01||28")
ClassMethod SyncLabErrByEpis(aSCode As %String, aEpisodeIDX As %String, aFromDate As %String = "", aToDate As %String = "") As %List
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
	
	Set LabRepVer=##class(DHCHAI.BT.Config).GetValByCode("DPLabReportVer")
	Quit:(LabRepVer'="LIS1.0")&&(LabRepVer'="LIS2.0")&&(LabRepVer'="LISC1.0")&&(LabRepVer'="LISC2.0") return
	If LabRepVer="LISC1.0" {
		Quit return
	}
	Set UpdateDateList="",UpdateDateList=""
	Set xVisitNumber=""
	For {
		Set xVisitNumber=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",EpisodeDr,xVisitNumber))
		Quit:xVisitNumber=""
		
		Set xTestSet=""
		For {
			Set xTestSet=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumber,xTestSet))
			Quit:xTestSet=""
			
			Set xOrder=""
			For {
				Set xOrder=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumber,xTestSet,xOrder))
				Quit:xOrder=""
				
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xVisitNumber,xTestSet,xOrder,xID))
					Quit:xID=""
					
					Set obj=##class(DHCHAI.DP.LabVisitReport).GetObjById(xID)
				
					Continue:'$IsObject(obj)
					Continue:'$IsObject(obj.LabVisitNumberDr)
					Continue:obj.LabVisitNumberDr.LabSCode'=aSCode
					Set VisitNumberXCode=obj.LabVisitNumberDr.LabXCode
					Set IsActive=obj.LabIsActive
					Set UpdateDate=obj.LabUpdateDate
					Set UpdateTime=obj.LabUpdateTime
					Set XCode=obj.LabXCode
					Continue:XCode=""
					Set LabInfo=""
					If LabRepVer="LIS1.0" {
						If $l(XCode,"||")=3 {
							Set Epis=$p(XCode,"||",1)
							Set TS=$p(XCode,"||",2)
							Set Cnt=$p(XCode,"||",3)
							Continue:(Epis="")||(TS="")||(Cnt="")
							Set LabInfo=$g(^TEPI(Epis,1,TS,Cnt))
							If LabInfo="" {
								If IsActive=1 {
									Do ##class(DHCHAI.DP.LabVisitReport).CancelById(xID)
									Continue
								}
							} Else {
								Set timAuthDate   = $p(LabInfo,"\",4)     // 审核日期
								Set timUpdateDate = $p(LabInfo,"\",4)     // 修改日期
								Set timUpdateTime = $p(LabInfo,"\",5)     // 修改时间
								Set:$l(timUpdateTime) timUpdateTime=timUpdateTime*60
								If (timUpdateDate>UpdateDate)||((timUpdateDate=UpdateDate)&(timUpdateTime>UpdateTime)) {
									Continue:$listfind(UpdateDateList,timAuthDate)>0
									Set UpdateDateList=UpdateDateList_$lb(timAuthDate)
								}
							}
						}
					} Else {
						If LabRepVer="LIS2.0" {	
							Set ReportID=$p(XCode,"||",1)
							Set RepOrder=$p(XCode,"||",2)
							Continue:(ReportID="")||(RepOrder="")
							Set LabInfo=$g(^dbo.RPVisitNumberReportD(ReportID))
							If LabInfo="" {
								If IsActive=1 {
									Do ##class(DHCHAI.DP.LabVisitReport).CancelById(xID)
									Continue
								}
							} Else {
								Set timAuthDate   = $lg(LabInfo,19)     // 审核日期
								Set:timAuthDate'="" timAuthDate=$zdh(timAuthDate,8)
								
								// 根据标本日志找到最近的一次审核or取消审核记录时间
								Set xOperDate ="",timUpdateDate="",timUpdateTime=""
								For {
									Set xOperDate = $o(^dbo.RPVisitNumberRecordI("IndexMaster",VisitNumberXCode,xOperDate),-1)
									Quit:xOperDate=""
									Quit:timUpdateDate'=""
									
									Set xOperTime = ""
									For {
										Set xOperTime = $o(^dbo.RPVisitNumberRecordI("IndexMaster",VisitNumberXCode,xOperDate,xOperTime),-1)
										Quit:xOperTime=""
										Quit:timUpdateDate'=""
										
										Set xRecordID=""
										For {
											Set xRecordID = $o(^dbo.RPVisitNumberRecordI("IndexMaster",VisitNumberXCode,xOperDate,xOperTime,xRecordID))
											Quit:xRecordID=""
											
											Set OperInfo = $g(^dbo.RPVisitNumberRecordD(xRecordID))
											Continue:OperInfo=""
											Set OperTypeDr = $lg(OperInfo,7)
											Continue:OperTypeDr=""
											Set OperTypeStr =  $g(^dbo.BTOperatorTypeD(OperTypeDr))
											Continue:OperTypeStr=""
											Set OperType = $lg(OperTypeStr,3)
											Continue:OperType=""
											Continue:OperType'["审核"
											
											Set timUpdateDate=$lg(OperInfo,3)	// 修改日期
											Set timUpdateTime=$lg(OperInfo,4)	// 修改时间
										}
									}
								}
								Set:timUpdateDate'="" timUpdateDate=$zdh(timUpdateDate,8)
								If (timUpdateDate>UpdateDate)||((timUpdateDate=UpdateDate)&(timUpdateTime>UpdateTime)) {
									Do ##class(DHCHAI.DP.LabVisitReport).CancelById(xID)
									Continue:$listfind(UpdateDateList,timAuthDate)>0
									Set UpdateDateList=UpdateDateList_$lb(timAuthDate)
								}
							}
						} ElseIf LabRepVer="LISC2.0" {
							
							If ($p(XCode,"||",3)'="") {
								Set ReportID=$p(XCode,"||",1)_"||"_$p(XCode,"||",2)
							}else {
								Set ReportID=$p(XCode,"||",1)
							}
							Continue:(ReportID="")
							Set xReportID=$o(^Busi.ENS.EnsLISReportResultI("LISREPORTRESULTPKey",ReportID,0))
							Continue:(xReportID="")
							Set LabInfo=$g(^Busi.ENS.EnsLISReportResultD(xReportID))
							
							If LabInfo="" {
								If IsActive=1 {
									Do ##class(DHCHAI.DP.LabVisitReport).CancelById(xID)
									Continue
								}
							} Else {
								Set timAuthDate=$lg(LabInfo,107)
								Set timUpdateDate=$lg(LabInfo,104)
								Set timUpdateTime=$lg(LabInfo,105)
								If (timUpdateDate>UpdateDate)||((timUpdateDate=UpdateDate)&(timUpdateTime>UpdateTime)) {
									Do ##class(DHCHAI.DP.LabVisitReport).CancelById(xID)
									Continue:$listfind(UpdateDateList,timAuthDate)>0
									Set UpdateDateList=UpdateDateList_$lb(timAuthDate)
								}
							
							}
						}	
					}
				}
			}
		}
    }
    For indList=1:1:$ll(UpdateDateList){
	    Set xDate=$listget(UpdateDateList,indList)
	    Continue:xDate=""
	    
	    //同步数据
    	Set Cnt=##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabRepByDate(aSCode,aEpisodeIDX,xDate,xDate)
    	Set Count=Count+Cnt
    }
    Set return=Count
	Quit return
}

}
