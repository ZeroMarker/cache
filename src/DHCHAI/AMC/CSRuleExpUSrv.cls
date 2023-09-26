/// 名称: DHCHAI.AMC.CSRuleExpUSrv
/// 描述: 疑似病例筛查规则解析--手工添加感染诊断
/// 编写者：pylian
/// 编写日期: 2020-05-25
Class DHCHAI.AMC.CSRuleExpUSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.AMC.CSRuleExpUSrv).GetResult()
ClassMethod GetResult(aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String, ByRef %ArrayResult As %ArrayOfDataTypes) As %String
{
	New (aEpisodeDr,aDateFrom,aDateTo,%ArrayResult)
	Set return=0
	Quit:(aEpisodeDr="")||(aDateFrom="")||(aDateTo="") return
	Quit:'$IsObject(%ArrayResult) return
	
	//规则表达式
	Kill arrRuleExp
	Set RuleKeywords=""
	Set xRuleDr=0
	For {
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," U",xRuleDr))
		Quit:xRuleDr=""
		
		Set objRule=##class(DHCHAI.IR.CRuleInfSuRule).GetObjById(xRuleDr)
		Continue:'$IsObject(objRule)
		Continue:objRule.BTIsActive'=1
		Continue:'$IsObject(objRule.BTItmScreenDr)
		Set ItmScreenDr=objRule.BTItmScreenDr.%Id()
		Set ItmScreenDesc=objRule.BTItmScreenDr.CCDesc
		Set ItmScreenDesc2=objRule.BTItmScreenDr.CCDesc2
		Set:ItmScreenDesc2'="" ItmScreenDesc=ItmScreenDesc2
		Set arrRuleExp(xRuleDr)=$lb(xRuleDr,ItmScreenDr,ItmScreenDesc)
	}
	//感染规则筛查参数
	Set RuleDr=$o(arrRuleExp(0))
	Quit:RuleDr="" return
	Set tRuleInfo=$g(arrRuleExp(RuleDr))
	Set ItmScreenDr=$lg(tRuleInfo,2)
	Set ItmScreenDesc=$lg(tRuleInfo,3)
	
	Set ItmScreenID=""
	Set ItmScreenID=$o(^DHCHAI.IR.CCItmScreenI("IdxofDesc","手工添加感染诊断",0))  //疑似筛查项目
	Quit:ItmScreenID=""
	
	//常规检验异常结果
	Kill arrResult
	Set AdmDate=""
	Set xItmScreenTxt=""
	For {
		Set xItmScreenTxt=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",aEpisodeDr,ItmScreenID,xItmScreenTxt))
		Quit:xItmScreenTxt=""
		
		Set xScreenID=""
		For {
			Set xScreenID=$o(^DHCHAI.IR.CCScreeningI("IndexEpisodeItmScreen",aEpisodeDr,ItmScreenID,xItmScreenTxt,xScreenID))
			Quit:xScreenID=""
			
			Set obj=##class(DHCHAI.IR.CCScreening).GetObjById(xScreenID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CSInfSuPosDr)
			Set ItmScreenTxt=obj.CSItmScreenTxt
			Set InfSuPosDr =obj.CSInfSuPosDr.%Id()	
			Set Status=obj.CSStatus
			Set RstFromDate=obj.CSRstFromDate
			Set RstToDate=obj.CSRstToDate
			Set ActDate=obj.CSActDate
			Set ActTime=obj.CSActTime
			//入院日期
			Set AdmDate=obj.CSEpisodeDr.PAAdmDate
			
			Set arrResult(xScreenID,"RST",RstFromDate)=$lb(xScreenID,xItmScreenTxt,InfSuPosDr,Status,RstFromDate,RstToDate,ActDate,ActTime)			
		}
	}
	Quit:$o(arrResult(0))="" return
	Quit:AdmDate="" return

	//感染规则判断及结果输出
	Set xScreenID=""
	For {
		Set xScreenID=$o(arrResult(xScreenID))
		Quit:xScreenID=""
	    
		Set xActDate=0
		For {
			Set xActDate=$o(arrResult(xScreenID,"RST",xActDate))
			Quit:xActDate=""
			Continue:xActDate<aDateFrom
			Continue:xActDate>aDateTo
			
			//触发次数、触发日期、多耐结果
			Set InfSuPosDr=""       //推荐感染部位
			Set InfSuPosDr2=""  	//疑似感染部位
			Set ResultCnt=1
			Set ResultDate=xActDate
		
			Set tResultInfo=$g(arrResult(xScreenID,"RST",xActDate))
			Set ItmScreenTxt=$lg(tResultInfo,2)
			Set InfSuPosDr2=$lg(tResultInfo,3)
			Set Status=$lg(tResultInfo,4)
			Set RstFromDate=$lg(tResultInfo,5)
			Set RstToDate=$lg(tResultInfo,6)				
			Set ResultNote=ItmScreenDesc
			
			//如果确诊，以确诊感染部位为准；如果未确诊，以疑似感染部位为准
			Set:InfSuPosDr="" InfSuPosDr=InfSuPosDr2
			
			Set obj=##class(DHCHAI.IRC.CSRecord).GetObj(ItmScreenDr)
			Continue:'$IsObject(obj)
			Set obj.CSItmScreenTxt = ItmScreenTxt    //附加项目描述
			Set obj.CSResultNote   = ResultNote      //显示结果
			Set obj.CSResultDate   = ResultDate      //结果日期
			Set obj.CSResultCnt    = ResultCnt       //结果数量
			Set obj.CSInfSuKeys    = ""              //疑似关键词
			Set obj.CSInfSuPosDr   = InfSuPosDr      //推荐感染部位
			Set obj.CSInfSuDate    = ResultDate      //推荐感染日期
			Set obj.CSInfSuRuleDr  = RuleDr          //规则(多值#分隔)
			Set obj.CSSpecimen     = ""              //标本(多值#分隔)
			Set obj.CSRstStatus    = 1               //结果状态(0触发疑似指标、1触发组合条件)
			Set obj.CSOprStatus    = Status
			
			Set ArrCnt=%ArrayResult.Count()
			Do %ArrayResult.SetAt(obj,ArrCnt+1)
		}
	}
	Kill arrResult
	Kill arrRuleExp
	
	Set return=%ArrayResult.Count()
	Quit return
}

}
