/// 名称: DHCHAI.AMC.CSRuleExpFSrv
/// 描述: 疑似病例筛查规则解析---医生诊断
/// 编写者：zhufei
/// 编写日期: 2019-06-11
Class DHCHAI.AMC.CSRuleExpFSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.AMC.CSRuleExpFSrv).GetResult()
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
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," F",xRuleDr))
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
   
    //医生诊断异常结果
	Kill arrResult
	Set AdmDate=""
    Set ItmMastList = $lb("RME-AdmDiagnos","RME-Diagnos") 
    For indList =1:1:$l(ItmMastList) {
	    Set ItmMastCode = $lg(ItmMastList,indList)
	    Continue:ItmMastCode=""
      
		Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode(ItmMastCode)   //语义-诊断
		Continue:'$IsObject(objItem) 
		Continue:objItem.CCIsActive'=1 
		Set ItemDr=objItem.%Id()		

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
				Continue:obj.CCIsAbFlag'=1    //统计入院诊断中的手术感染、出院诊断所有的诊断
				Set SCode=obj.CCSCode
				Set ActDate=obj.CCActDate
				Set ActTime=obj.CCActTime
				Set RepDate=obj.CCRepDate
				Continue:ActDate=""
				
				//诊断
				Set Diagnos=obj.CCResult
				
				//入院日期
				Set AdmDate=obj.CCEpisodeDr.PAAdmDate
				
				Set arrResult(Diagnos,"RST",ActDate,xID)=$lb(xID,Diagnos,"",ActDate,ActTime)
			}
		}
    }
  
	Quit:$o(arrResult(0))="" return
	Quit:AdmDate="" return

	//感染规则判断及结果输出
	Set xDiagnos=""
	For {
		Set xDiagnos=$o(arrResult(xDiagnos))
		Quit:xDiagnos=""
		
		Set InfSuPosDr=""       //推荐感染部位
		//查找诊断对应疑似感染部位
		Set tSuPosDr=##class(DHCHAI.IRC.CSResultSrv).GetPosByDiagnos(xDiagnos)
		If tSuPosDr'="" {
			If $listfind(InfSuPosDr,tSuPosDr)<1 {
				Set InfSuPosDr=InfSuPosDr_$lb(tSuPosDr)
			}
		}
		Set InfSuPosDr=##class(DHCHAI.Utils.CommonSrv).ListToString(InfSuPosDr,"#")
		
		Set xActDate=0
		For {
			Set xActDate=$o(arrResult(xDiagnos,"RST",xActDate))
			Quit:xActDate=""
			Continue:xActDate<aDateFrom
			Continue:xActDate>aDateTo
		
			//触发次数、触发日期、多耐结果
			Set ResultCnt=0
			Set ResultDate=xActDate
			Set xID=0
			For {
				Set xID=$o(arrResult(xDiagnos,"RST",xActDate,xID))
				Quit:xID=""
				
				Set tResultInfo=$g(arrResult(xDiagnos,"RST",xActDate,xID))
				Continue:tResultInfo=""
				Set ResultCnt=ResultCnt+1
			}
			Continue:ResultCnt<1
		
			//疑似关键词
			Set InfSuKeys=xDiagnos
			//显示结果
			Set ResultNote=ItmScreenDesc_" ("_xDiagnos_")"			
			Set ItmScreenTxt=""
				
			Set obj=##class(DHCHAI.IRC.CSRecord).GetObj(ItmScreenDr)
			Continue:'$IsObject(obj)
			Set obj.CSItmScreenTxt = ItmScreenTxt    //附加项目描述
			Set obj.CSResultNote   = ResultNote      //显示结果
			Set obj.CSResultDate   = ResultDate      //结果日期
			Set obj.CSResultCnt    = ResultCnt       //结果数量
			Set obj.CSInfSuKeys    = InfSuKeys       //疑似关键词
			Set obj.CSInfSuPosDr   = InfSuPosDr      //推荐感染部位
			Set obj.CSInfSuDate    = ResultDate       //推荐感染日期
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
