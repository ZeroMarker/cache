/// 名称: DHCHAI.IRC.CSRuleExpVSrv
/// 描述: 疑似病例筛查规则解析--常规检验异常（支原体病毒核酸检测）
/// 编写者：pylian
/// 编写日期: 2020-06-04
Class DHCHAI.IRC.CSRuleExpVSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.IRC.CSRuleExpVSrv).GetResult()
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
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," V",xRuleDr))
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
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"流感样症状监测")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"流感样症状监测")=ArgStr
			If $listfind(RuleKeywords,"流感样症状监测")<1 {
				Set RuleKeywords=RuleKeywords_$lb("流感样症状监测")
			}
		}
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"水痘带状疱疹病毒")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"水痘带状疱疹病毒")=ArgStr
			If $listfind(RuleKeywords,"水痘带状疱疹病毒")<1 {
				Set RuleKeywords=RuleKeywords_$lb("水痘带状疱疹病毒")
			}
		}
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"麻疹病毒")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"麻疹病毒")=ArgStr
			If $listfind(RuleKeywords,"麻疹病毒")<1 {
				Set RuleKeywords=RuleKeywords_$lb("麻疹病毒")
			}
		}
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"肺炎支原体")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"肺炎支原体")=ArgStr
			If $listfind(RuleKeywords,"肺炎支原体")<1 {
				Set RuleKeywords=RuleKeywords_$lb("肺炎支原体")
			}
		}
		
			Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"新型冠状病毒")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"新型冠状病毒")=ArgStr
			If $listfind(RuleKeywords,"新型冠状病毒")<1 {
				Set RuleKeywords=RuleKeywords_$lb("新型冠状病毒")
			}
		}
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"难辨梭菌")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"难辨梭菌")=ArgStr
			If $listfind(RuleKeywords,"难辨梭菌")<1 {
				Set RuleKeywords=RuleKeywords_$lb("难辨梭菌")
			}
		}
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"轮状病毒")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"轮状病毒")=ArgStr
			If $listfind(RuleKeywords,"轮状病毒")<1 {
				Set RuleKeywords=RuleKeywords_$lb("轮状病毒")
			}
		}
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"诺如病毒")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"诺如病毒")=ArgStr
			If $listfind(RuleKeywords,"诺如病毒")<1 {
				Set RuleKeywords=RuleKeywords_$lb("诺如病毒")
			}
		}
	
	}
	Quit:$o(arrRuleExp(0))="" return
	
	//LAB-TestAb	检验-常规检验异常
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("LAB-TestAb")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	//常规检验异常结果
	Kill arrResult
	Set AdmDate=""
	Set xActDate=aDateFrom-1
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aDateTo
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeDr,ItemDr,xActDate,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:'$IsObject(obj.CCKeyWordDr)
			Continue:obj.CCIsActive'=1
			Continue:obj.CCIsAbFlag'=1
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCActDate
			Set ActTime=obj.CCActTime
			Set RepDate=obj.CCRepDate
			Continue:ActDate=""
			
			//关键词
			Set KeyWord=obj.CCKeyWordDr.CCDesc
			Continue:$listfind(RuleKeywords,KeyWord)<1
			Set Summary=obj.CCSummary
			Continue:Summary=""
			//标本
			Set Specimen=obj.CCSpecimen
			Continue:Specimen=""
			Set objSpecMap=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
			Continue:'$IsObject(objSpecMap)
			Continue:objSpecMap.BTIsActive'=1
			Continue:'$IsObject(objSpecMap.BTMapItemDr)
			Continue:objSpecMap.BTMapItemDr.BTIsActive'=1
			Set Specimen=objSpecMap.BTMapItemDr.BTSpecDesc
			
			//入院日期
			Set AdmDate=obj.CCEpisodeDr.PAAdmDate
			
			Set arrResult(KeyWord,"RST",ActDate,xID)=$lb(xID,Specimen,Summary,ActDate,ActTime)
			
			//判断是否入院48小时后项目
			Set flg=##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst(obj)
			Set arrResult(KeyWord,"48H",ActDate,+flg)=""
			
		}
	}
	Quit:$o(arrResult(0))="" return
	Quit:AdmDate="" return
	
	Set IsCheck48=##class(DHCHAI.BT.Config).GetValByCode("IRScreenIsCheck48")  //0：不计入，1：计入

	//感染规则判断及结果输出
	Set xRuleDr=0
	For {
		Set xRuleDr=$o(arrRuleExp(xRuleDr))
		Quit:xRuleDr=""
		
		Set tRuleInfo=$g(arrRuleExp(xRuleDr))
		Set ItmScreenDr=$lg(tRuleInfo,2)
		Set ItmScreenDesc=$lg(tRuleInfo,3)
		
		Set xKeyWord=$o(arrRuleExp(xRuleDr,""))
		Continue:xKeyWord=""
		Set tRuleArgStr=$g(arrRuleExp(xRuleDr,xKeyWord))
		Continue:tRuleArgStr=""
	
		Set xActDate=0
		For {
			Set xActDate=$o(arrResult(xKeyWord,"RST",xActDate))
			Quit:xActDate=""
			Continue:xActDate<aDateFrom
			Continue:xActDate>aDateTo
			
			Set IsI48Hour=$d(arrResult(xKeyWord,"48H",xActDate,0))
			//Continue:(IsCheck48=0)&&(IsI48Hour=1)  //检查是否入院48小时项目	
			
			//触发次数、触发日期、多耐结果
			Set InfSuPosDr=""       //推荐感染部位
			Set InfSuPosDr2=""  	//疑似感染部位
			Set ResultCnt=0
			Set ResultDate=xActDate
			Set Specimens="",Summarys=""
			Set xID=0
			For {
				Set xID=$o(arrResult(xKeyWord,"RST",xActDate,xID))
				Quit:xID=""
				
				Set tResultInfo=$g(arrResult(xKeyWord,"RST",xActDate,xID))
				Set Specimen=$lg(tResultInfo,2)
				Set Summary=$lg(tResultInfo,3)
				If Summary'="" {
					If $listfind(Summarys,(Summary_"("_$zdt(xActDate,3)_")"))<1 {
						Set Summarys=Summarys_$lb(Summary_"("_$zdt(xActDate,3)_")")
					}
				}
				If Specimen'="" {
					If $listfind(Specimens,Specimen)<1 {
						Set Specimens=Specimens_$lb(Specimen)
					}
				}
			     //查找关键词对应疑似感染部位
				Set tSuPosDr=##class(DHCHAI.IRC.CSResultSrv).GetPosByKeyWord(Summary)
				If tSuPosDr'="" {
					If $listfind(InfSuPosDr2,tSuPosDr)<1 {
						Set InfSuPosDr2=InfSuPosDr2_$lb(tSuPosDr)
					}
				}
				
				Set ResultCnt=ResultCnt+1
			}
			Continue:ResultCnt<1
            Set InfSuPosDr2=##class(DHCHAI.Utils.CommonSrv).ListToString(InfSuPosDr2,"#")
			//标本
			Set SpecimenStr=##class(DHCHAI.Utils.CommonSrv).ListToString(Specimens,"#")
			//检验结果
			Set SummaryStr=##class(DHCHAI.Utils.CommonSrv).ListToString(Summarys,"#")
			Set Details = SummaryStr
			//疑似关键词
			Set InfSuKeys=SpecimenStr
			//显示结果
			Set ResultNote=ItmScreenDesc
			Set:SpecimenStr'="" ResultNote=ResultNote_"("_$tr(SpecimenStr,"#","、")_")"
			Set ItmScreenTxt=""
			
			//如果确诊，以确诊感染部位为准；如果未确诊，以疑似感染部位为准
			Set:InfSuPosDr="" InfSuPosDr=InfSuPosDr2
			
			Set obj=##class(DHCHAI.IRC.CSRecord).GetObj(ItmScreenDr)
			Continue:'$IsObject(obj)
			Set obj.CSItmScreenTxt = ItmScreenTxt    //附加项目描述
			Set obj.CSResultNote   = ResultNote      //显示结果
			Set obj.CSResultDate   = ResultDate      //结果日期
			Set obj.CSResultCnt    = ResultCnt       //结果数量
			Set obj.CSInfSuKeys    = InfSuKeys       //疑似关键词
			Set obj.CSInfSuPosDr   = InfSuPosDr      //推荐感染部位
			Set obj.CSInfSuDate    = ResultDate      //推荐感染日期
			Set obj.CSInfSuRuleDr  = xRuleDr         //规则(多值#分隔)
			Set obj.CSSpecimen     = SpecimenStr     //标本(多值#分隔)
			Set obj.CSRstStatus    = 1               //结果状态(0触发疑似指标、1触发组合条件)
			Set obj.CSDetails      = Details         //病毒支原体检测结果明细
			
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
