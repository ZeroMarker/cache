/// 名称: DHCHAI.IRC.CSRuleExpQSrv
/// 描述: 疑似病例筛查规则解析---清创手术
/// 编写者：pylian
/// 编写日期: 2019-12-11
Class DHCHAI.IRC.CSRuleExpQSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.IRC.CSRuleExpQSrv).GetResult()
ClassMethod GetResult(aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String, ByRef %ArrayResult As %ArrayOfDataTypes) As %String
{
	New (aEpisodeDr,aDateFrom,aDateTo,%ArrayResult)
	Set return=0
	Quit:(aEpisodeDr="")||(aDateFrom="")||(aDateTo="") return
	Quit:'$IsObject(%ArrayResult) return
	
	//规则表达式
	Kill arrRuleExp
	Set xRuleDr=0
	For {
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," Q",xRuleDr))
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
   
	//OR-Debridement	手术-清创手术
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("OR-Debridement")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return	
	Set ItemDr=objItem.%Id()
	
	//清创手术
	Kill arrResult
	Set xActDate=aDateFrom-1
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aDateTo
	    
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
		    
			Continue:obj.CCIsActive'=1
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCActDate
			Set ActTime=obj.CCActTime
			Continue:ActDate=""
			
			//手术名称
			Set OperDesc=obj.CCResult
			Set arrResult(OperDesc,"RST",ActDate,xID)=$lb(xID,OperDesc,ActDate,ActTime)
		}
	}

	Quit:$o(arrResult(0))="" return
	
	//感染规则判断及结果输出
	Set xOperDesc=""
	For {
		Set xOperDesc=$o(arrResult(xOperDesc))
		Quit:xOperDesc=""
		
		Set xActDate=0
		For {
			Set xActDate=$o(arrResult(xOperDesc,"RST",xActDate))
			Quit:xActDate=""
			Continue:xActDate<aDateFrom
			Continue:xActDate>aDateTo
			
			//触发次数、触发日期
			Set ResultCnt=0
			Set ResultDate=xActDate
			Set xID=0
			For {
				Set xID=$o(arrResult(xOperDesc,"RST",xActDate,xID))
				Quit:xID=""
				
				Set tResultInfo=$g(arrResult(xOperDesc,"RST",xActDate,xID))
				Continue:tResultInfo=""
				Set ResultCnt=ResultCnt+1
			}
			Continue:ResultCnt<1
			
			//显示结果
			Set ResultNote=ItmScreenDesc_" ("_xOperDesc_")"			
			
			Set obj=##class(DHCHAI.IRC.CSRecord).GetObj(ItmScreenDr)
			Continue:'$IsObject(obj)
			Set obj.CSItmScreenTxt = ""              //附加项目描述
			Set obj.CSResultNote   = ResultNote      //显示结果
			Set obj.CSResultDate   = ResultDate      //结果日期
			Set obj.CSResultCnt    = ResultCnt       //结果数量
			Set obj.CSInfSuKeys    = "清创手术"      //疑似关键词
			Set obj.CSInfSuPosDr   = ""              //推荐感染部位（手术部位感染？？？？？）
			Set obj.CSInfSuDate    = ResultDate      //推荐感染日期
			Set obj.CSInfSuRuleDr  = RuleDr          //规则
			Set obj.CSRstStatus    = 1               //结果状态(0触发疑似指标、1触发组合条件)
			
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
