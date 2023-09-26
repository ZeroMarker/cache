/// 名称: DHCHAI.IRC.CSRule00Srv
/// 描述: 疑似病例筛查规则--再入院
/// 编写者：chenjb
/// 编写日期: 2017-10-31
Class DHCHAI.IRC.CSRule11Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.IRC.CSRule11Srv).GetResult("再入院",1831,.arr)
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
	
	//未手术出院后{A1}天，再入院
	//手术出院后{A2}天，再入院
	Set Arg1=objItmScreen.CCArg1
	Set Arg2=objItmScreen.CCArg2
	Set Arg1=+Arg1
	Set Arg2=+Arg2
	
	Set OperDates=##class("DHCHAI.DPS.OROperAnaesSrv").GetOperDates(aEpisodeID)  //取手术日期
	Set DiffDay = Arg1
	if (OperDates'=""){
		//有手术
		Set DiffDay = Arg2
	}
	
	Set LastDisDateTime =##class(DHCHAI.IRC.CSGetDateSrv).GetLastAdmDate(aEpisodeID)   //上次就诊出院时间
	Quit:(LastDisDateTime="")||(LastDisDateTime=",") return  //无上次就诊信息
	Set objEpisode = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objEpisode) return
	Set AdmDate = objEpisode.PAAdmDate
	Set DisDate = $p(LastDisDateTime,",",1)
	Quit:(AdmDate-DisDate)>DiffDay return
	
	Set ItmScreenTxt=""
	Set ResultCnt=1
	Set ResultNote=aItmScreen
	Set FromDate=DisDate
	Set ToDate=AdmDate
	//Set ResultDate=$zd(FromDate,3)_"～"
	//Set:ToDate'="" ResultDate=ResultDate_$zd(ToDate,3)
	Set ResultDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(FromDate)_"～"
	Set:ToDate'="" ResultDate=ResultDate_##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ToDate)
	Set RstFromDate=FromDate
	Set RstToDate=ToDate
	
	Set obj=##class(DHCHAI.IRC.CSRecord).GetObj(ItmScreenID)
	Quit:'$IsObject(obj) return
	
	Set obj.CSItmScreenTxt = ItmScreenTxt
	Set obj.CSResultNote   = ResultNote
	Set obj.CSResultDate   = ResultDate
	Set obj.CSResultCnt    = ResultCnt
	Set obj.CSRstFromDate  = RstFromDate
	Set obj.CSRstToDate    = RstToDate
	Set obj.CSRstStatus    = 1
	Set obj.CSInfSuKeys    = "再入院"
	Set obj.CSInfDiagnosDr = ""
	Set obj.CSInfPosDr     = ""
	Set obj.CSInfPosDesc   = ""
	Set obj.CSIsCheckSx    = 1 //是否检查阳性症状或体征
	Set obj.CSIsCheckFe    = 1 //是否检查发热
	
	Set ArrCnt=%ArrayResult.Count()
	Do %ArrayResult.SetAt(obj,ArrCnt+1)
	
	Set return=%ArrayResult.Count()
	Quit return
}

}
