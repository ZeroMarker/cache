/// 名称: DHCHAI.AMC.CSRuleExpDSrv
/// 描述: 疑似病例筛查规则解析--常规检验异常
/// 编写者：zhufei
/// 编写日期: 2019-06-11
Class DHCHAI.AMC.CSRuleExpDSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.AMC.CSRuleExpDSrv).GetResult()
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
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," D",xRuleDr))
		Quit:xRuleDr=""
		
		Set objRule=##class(DHCHAI.IR.CRuleInfSuRule).GetObjById(xRuleDr)
		Continue:'$IsObject(objRule)
		Continue:objRule.BTIsActive'=1
		Continue:'$IsObject(objRule.BTItmScreenDr)
		Set ItmScreenDr=objRule.BTItmScreenDr.%Id()
		Set objScreen = ##class(DHCHAI.IR.CCItmScreen).GetObjById(ItmScreenDr)
		Continue:'$IsObject(objScreen)
		Set ItmScreenDesc=objScreen.CCDesc
		Set ItmScreenDesc2=objScreen.CCDesc2
		Set:ItmScreenDesc2'="" ItmScreenDesc=ItmScreenDesc2
		Set arrRuleExp(xRuleDr)=$lb(xRuleDr,ItmScreenDr,ItmScreenDesc)
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"血常规异常")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"血常规")=ArgStr
			If $listfind(RuleKeywords,"血常规")<1 {
				Set RuleKeywords=RuleKeywords_$lb("血常规")
			}
		}
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"尿常规异常")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"尿常规")=ArgStr
			If $listfind(RuleKeywords,"尿常规")<1 {
				Set RuleKeywords=RuleKeywords_$lb("尿常规")
			}
		}
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"胸水常规异常")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"胸水常规")=ArgStr
			If $listfind(RuleKeywords,"胸水常规")<1 {
				Set RuleKeywords=RuleKeywords_$lb("胸水常规")
			}
		}
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"腹水常规异常")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"腹水常规")=ArgStr
			If $listfind(RuleKeywords,"腹水常规")<1 {
				Set RuleKeywords=RuleKeywords_$lb("腹水常规")
			}
		}
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"脑脊液常规异常")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"脑脊液常规")=ArgStr
			If $listfind(RuleKeywords,"脑脊液常规")<1 {
				Set RuleKeywords=RuleKeywords_$lb("脑脊液常规")
			}
		}
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"C-反应蛋白异常")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"C反应蛋白")=ArgStr
			If $listfind(RuleKeywords,"C反应蛋白")<1 {
				Set RuleKeywords=RuleKeywords_$lb("C反应蛋白")
			}
		}
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"降钙素原异常")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"降钙素原")=ArgStr
			If $listfind(RuleKeywords,"降钙素原")<1 {
				Set RuleKeywords=RuleKeywords_$lb("降钙素原")
			}
		}
	}
	Quit:$o(arrRuleExp(0))="" return
	//入院诊断
    Set AdmDiagList=##class(DHCHAI.AMC.CSResultSrv).GetAdmDiagnos(aEpisodeDr)
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
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCActDate
			Set ActTime=obj.CCActTime
			Set RepDate=obj.CCRepDate
			Continue:ActDate=""
			
			//关键词
			Set KeyWord=obj.CCKeyWordDr.CCDesc
			Continue:$listfind(RuleKeywords,KeyWord)<1
			
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
			
			Set arrResult(KeyWord,"RST",ActDate,xID)=$lb(xID,Specimen,KeyWord,ActDate,ActTime)
			
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
		Set AbCnt=+$p(tRuleArgStr,"^",5)   //限定次数
		Set:AbCnt<1 AbCnt=2
		Set AbDay=+$p(tRuleArgStr,"^",4)   //限定天数
		Set:AbDay<1 AbDay=7
		
		Set (OperPrevDateList,OperNextDateList)=""
		If (ItmScreenDesc["血常规")||(ItmScreenDesc["C反应蛋白")||(ItmScreenDesc["降钙素原") {
			//术前日期
			//Set OperPrevDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperPrevDateList(aEpisodeDr,AbDay)
			//术后日期
			Set OperNextDateList=##class(DHCHAI.IRC.CSGetDateSrv).GetOperNextDateList(aEpisodeDr,7)
		}
		
		Set xActDate=0
		For {
			Set xActDate=$o(arrResult(xKeyWord,"RST",xActDate))
			Quit:xActDate=""
			Continue:xActDate<aDateFrom
			Continue:xActDate>aDateTo
			
			Set IsI48Hour=$d(arrResult(xKeyWord,"48H",xActDate,0))
			Continue:(IsCheck48=0)&&(IsI48Hour=1)  //检查是否入院48小时项目	
		
			//术前n天排除
			//Continue:(OperPrevDateList'="")&($listfind(OperPrevDateList,xActDate)>0)
			//术后n天排除
			Continue:(OperNextDateList'="")&($listfind(OperNextDateList,xActDate)>0)
		
			//3日内血常规2次及以上异常
			Set ActSpecList="",IsInfFlag=0
			Set yActDate=xActDate-1
			For {
				Set yActDate=$o(arrResult(xKeyWord,"RST",yActDate))
				Quit:yActDate=""
				Quit:yActDate>(xActDate+AbDay)
				Quit:IsInfFlag>0
				
				Set xID=0
				For {
					Set xID=$o(arrResult(xKeyWord,"RST",yActDate,xID))
					Quit:xID=""
					Quit:IsInfFlag>0
					
					Set tResultInfo=$g(arrResult(xKeyWord,"RST",xActDate,xID))
					Set Specimen=$lg(tResultInfo,2)
					Set tActTime=$lg(tResultInfo,5)
					Continue:$listfind(ActSpecList,Specimen_"/"_yActDate_"/"_tActTime)>0
					Set ActSpecList=ActSpecList_$lb(Specimen_"/"_yActDate_"/"_tActTime)
					Continue:$ll(ActSpecList)<AbCnt
					Set IsInfFlag=1
				}
			}
			Continue:IsInfFlag<1
			
			//触发次数、触发日期、多耐结果
			Set InfSuPosDr=""       //推荐感染部位
			Set InfSuPosDr2=""  	//疑似感染部位
			Set ResultCnt=0
			Set ResultDate=xActDate
			Set Specimens=""
			Set xID=0
			For {
				Set xID=$o(arrResult(xKeyWord,"RST",xActDate,xID))
				Quit:xID=""
				
				Set tResultInfo=$g(arrResult(xKeyWord,"RST",xActDate,xID))
				Set Specimen=$lg(tResultInfo,2)
				
				
				If Specimen'="" {
					If $listfind(Specimens,Specimen)<1 {
						Set Specimens=Specimens_$lb(Specimen)
					}
				}
				//查找标本对应疑似感染部位
				Set InfPosList=""
				Set tSuPoss=##class(DHCHAI.AMC.CSResultSrv).GetPosBySpec(Specimen)
				If tSuPoss'="" {
					For indP=1:1:$ll(tSuPoss){
						Set tSuPosDr=$lg(tSuPoss,indP)
						Continue:tSuPosDr=""
						//推荐诊断、入院诊断一致不计为感染 
						Set objSuPos=##class(DHCHAI.BT.InfSuPos).GetObjById(tSuPosDr)
						Continue:'$IsObject(objSuPos)
						Continue:'$IsObject(objSuPos.BTInfPosDr)
						Set InfPosCode=objSuPos.BTInfPosDr.BTCode
						Set DiagFlag=objSuPos.BTInfPosDr.BTDiagFlag
						Set InfPosID = objSuPos.BTInfPosDr.%Id()
						Set InfPos = objSuPos.BTInfPosDr.BTDesc
						If (DiagFlag=1)&&(InfPos'="新生儿感染") {
							Set Code = $e(InfPosCode,1,2)
							Set objInf = ##class(DHCHAI.BT.InfPos).GetObjByCode(Code)
							Continue:'$IsObject(objInf)
							Set InfPosID = objInf.%Id()
							Set InfPos = objInf.BTDesc
						}
						
						Continue:$listfind(InfPosList,InfPos)>0 
						Set InfPosList=InfPosList_$lb(InfPos)
				
						Continue:(","_AdmDiagList_",")[(","_InfPosID_"^"_InfPos_",")   //推荐部位与入院感染部位一致	
					
						Continue:$listfind(InfSuPosDr2,tSuPosDr)>0
						Set InfSuPosDr2=InfSuPosDr2_$lb(tSuPosDr)
					}
				}
				Continue:(tSuPoss'="")&&(InfSuPosDr2="")
				Set ResultCnt=ResultCnt+1
			}
			Continue:ResultCnt<1
			Set InfSuPosDr2=##class(DHCHAI.Utils.CommonSrv).ListToString(InfSuPosDr2,"#")
			
			//合并检查阳性症状或体征
			Set tSymptomInfo=##class(DHCHAI.AMC.CSResultSrv).CheckSymptom(aEpisodeDr,xActDate,InfSuPosDr,InfSuPosDr2,xRuleDr)
			Set SyResult=+$p(tSymptomInfo,"^",1)
			Set SyInfPosDr=$p(tSymptomInfo,"^",2)
			Continue:(SyInfPosDr="")&&(SyResult<1)  //未确认感染部位，又不满足组合条件
			Set SySuPosDr=$p(tSymptomInfo,"^",3)
			Set InfSuDate=$p(tSymptomInfo,"^",4)
			Set:InfSuDate="" InfSuDate=xActDate
			Set ObsAbDay=$p(tSymptomInfo,"^",5)
			Set EmrSuKey=$p(tSymptomInfo,"^",6)
			
			//标本
			Set SpecimenStr=##class(DHCHAI.Utils.CommonSrv).ListToString(Specimens,"#")
			
			//疑似关键词
			Set InfSuKeys=SpecimenStr
			Set:ObsAbDay'="" InfSuKeys=InfSuKeys_"#"_"发热"
			Set:EmrSuKey'="" InfSuKeys=InfSuKeys_"#"_EmrSuKey
			
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
			Set obj.CSInfSuDate    = InfSuDate       //推荐感染日期
			Set obj.CSInfSuRuleDr  = xRuleDr         //规则(多值#分隔)
			Set obj.CSSpecimen     = SpecimenStr     //标本(多值#分隔)
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
