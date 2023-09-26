/// 名称: DHCHAI.IRC.CSRule00Srv
/// 描述: 疑似病例筛查规则--自报感染
/// 编写者：zhufei
/// 编写日期: 2017-09-14
Class DHCHAI.IRC.CSRule00Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.IRC.CSRule00Srv).GetResult("自报感染",9,.arr)
ClassMethod GetResult(aItmScreen As %String, aEpisodeID As %String, ByRef %ArrayResult As %ArrayOfDataTypes) As %String
{
	New (aItmScreen,aEpisodeID,%ArrayResult)
	Set return=0
	Quit:(aItmScreen="")||(aEpisodeID="") return
	Quit:'$IsObject(%ArrayResult) return
	
	Set objItmScreen=##class(DHCHAI.IR.CCItmScreen).GetObjByDesc(aItmScreen)
	Quit:'$IsObject(objItmScreen) return
	Quit:objItmScreen.CCIsActive'=1 return
	Set ItmScreenID=objItmScreen.%Id()
	Set ItmScreenDesc=objItmScreen.CCDesc
	Set:objItmScreen.CCDesc2'="" ItmScreenDesc=objItmScreen.CCDesc2
	
	//（*）启用自报感染{A1}疑似筛查条件
	Set Arg1=objItmScreen.CCArg1
	Set Arg1=+Arg1
	
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.IR.INFDiagnosI("IndexPaadm",aEpisodeID,xID))
		Quit:xID=""
		
		Set obj=##class(DHCHAI.IR.INFDiagnos).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:'$IsObject(obj.IRInfPosDr)
		Set InfDiagnosDr=obj.%Id()
		Set InfPosDr=obj.IRInfPosDr.%Id()
		Set InfPosDesc=obj.IRInfPosDr.BTDesc
		
		Set InfDate=obj.IRInfDate
		Continue:InfDate=""
		Set InfXDate=obj.IRInfXDate
		Set InfPosDesc=obj.IRInfPosDr.BTDesc
		Set InfSubDesc=""
		If $IsObject(obj.IRInfSubDr) {
			Set InfSubDesc=obj.IRInfSubDr.BTDesc
		}
		Set IsReportDiag=obj.IRIsReportDiag
		
		Set ItmScreenTxt=InfPosDesc
		Set ResultCnt=1
		Set ResultNote=$s(InfSubDesc'="":InfPosDesc_"（"_InfSubDesc_"）",1:InfPosDesc)
		Set FromDate=InfDate
		Set ToDate=InfXDate
		Set ResultDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(FromDate)_"～"
		Set:ToDate'="" ResultDate=ResultDate_##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ToDate)
		Set RstFromDate=FromDate
		Set RstToDate=ToDate
		
		//处理感染转归日期问题 add by zf 2017-12-01
		Set:RstToDate="" RstToDate=obj.IREpisodeDr.PADischDate
		Set:RstToDate="" RstToDate=+$h
		
		Set RstStatus=2 //感染诊断
		Set listReports=##class(DHCHAI.IR.INFRepExt).GetINFReports("DHCHAI.IR.INFDiagnos",InfDiagnosDr)
		Set ReportCnt=listReports.Count()
		
		// 处理临床上报的感染诊断并且关联报告已经删除add by liyi 2017-12-06
		If (IsReportDiag=1)&&(ReportCnt=0){
			Continue
		}
		If ReportCnt>0 {
			Set OprStatus=1
			Set ResultNote="报告诊断->"_ResultNote
			If Arg1>0 {
				Set RstStatus=1
				Set OprStatus=0
			}
		} Else {
			Set OprStatus=0
			Set ResultNote="确诊诊断->"_ResultNote
		}
		
		Set SuInfDates=##Class(%ListOfDataTypes).%New()
		Set SuInfData=$lb(InfDate,"","",InfDate,InfXDate)
		Do SuInfDates.Insert(SuInfData)
		
		Set obj=##class(DHCHAI.IRC.CSRecord).GetObj(ItmScreenID)
		Continue:'$IsObject(obj)
		Set obj.CSItmScreenTxt = ItmScreenTxt
		Set obj.CSResultNote   = ResultNote
		Set obj.CSResultDate   = ResultDate
		Set obj.CSResultCnt    = ResultCnt
		Set obj.CSRstFromDate  = RstFromDate
		Set obj.CSRstToDate    = RstToDate
		Set obj.CSRstStatus    = RstStatus
		Set obj.CSOprStatus    = OprStatus
		Set obj.CSInfSuKeys    = "自报感染"
		Set obj.CSInfDiagnosDr = InfDiagnosDr
		Set obj.CSInfPosDr     = InfPosDr
		Set obj.CSInfPosDesc   = InfPosDesc
		Set obj.CSSuInfDates   = SuInfDates  //疑似感染日期（日期区间）
		Set obj.CSIsCheckSx    = 0 //不检查阳性症状或体征
		
		Set ArrCnt=%ArrayResult.Count()
		Do %ArrayResult.SetAt(obj,ArrCnt+1)
	}
	Set return=%ArrayResult.Count()
	Quit return
}

}
