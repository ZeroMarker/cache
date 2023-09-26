/// 名称: DHCHAI.AMC.CSRuleExpTSrv
/// 描述: 疑似病例筛查规则解析---病程阳性症状或体征
/// 编写者：pylian
/// 编写日期: 2020-04-21
Class DHCHAI.AMC.CSRuleExpTSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.AMC.CSRuleExpTSrv).GetResult()
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
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," T",xRuleDr))
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
	//入院诊断
    Set AdmDiagList=##class(DHCHAI.AMC.CSResultSrv).GetAdmDiagnos(aEpisodeDr)
	//RME-Radiology	语义-症状或体征
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("RME-Symptom")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	//症状或体征异常结果
	Kill arrResult
	Set AdmDate=""
	Set xActDate=aDateFrom-1
	For {
		Set xActDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",aEpisodeDr,ItemDr,xActDate))
		Quit:xActDate=""
		Quit:xActDate>aDateTo
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",aEpisodeDr,ItemDr,xActDate,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:obj.CCIsActive'=1
			Continue:obj.CCIsAbFlag'=1
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCActDate
			Set ActTime=obj.CCActTime
			Set RepDate=obj.CCRepDate
			Continue:ActDate=""
		
			//筛查结果
			Set Result=obj.CCResult
			Continue:Result=""
				
			//入院日期
			Set AdmDate=obj.CCEpisodeDr.PAAdmDate

			For len=1:1:$l(Result,";") {
				Set KeyWord= $p(Result,";",len)
				Continue:KeyWord=""
				//CCResult中存储的为主题词（关键词）,分类有感染诊断、症状或体征(感染)、症状或体征等		
				Set ThemeTypeDr="",WordType="",WordAttr=""
				Set ThemeTypeDr=$o(^DHCHAI.RME.ThemeTypeI("IndexCode"," INF-HAI",0))
	            If (ThemeTypeDr'="") {
		            Set ThemeWordDr=$o(^DHCHAI.RME.ThemeWordsI("IndexKeyWord",ThemeTypeDr," "_KeyWord,0))
		            If (ThemeWordDr'="") {
			            Set ThemeWordData=$g(^DHCHAI.RME.ThemeWordsD(ThemeWordDr))
			            Set WordTypeDr=$lg(ThemeWordData,6)
			            Set WordAttr=$lg(ThemeWordData,12)     //特异指标、一般指标
			            If (WordTypeDr'="")  {
				            Set ThWordTypeData=$g(^DHCHAI.RME.ThWordTypeD(WordTypeDr))
			           		Set WordType=$lg(ThWordTypeData,2)  //感染诊断、症状或体征(感染)、症状或体征等
			            }
		            }
	            }
					
				If (WordAttr=1) {      
					Set arrResult(ActDate,"RST",KeyWord,xID)=$lb(xID,KeyWord,ActDate,ActTime)  //特异指标
				}Else {   
					Set arrResult(ActDate,"Normal",KeyWord)=KeyWord  //一般指标
				}
			}
			//判断是否入院48小时后项目
			Set flg=##class(DHCHAI.AMC.CSResultSrv).CheckIs48HourRst(obj)
			Set arrResult(ActDate,"48H",+flg)=""
			
		}
	}
	Quit:$o(arrResult(0))="" return
	Quit:AdmDate="" return
	
    
	Set IsCheck48=##class(DHCHAI.BT.Config).GetValByCode("IRScreenIsCheck48")  //0：不计入，1：计入
    //ZW arrResult
	Set xActDate=0
	For {
		Set xActDate=$o(arrResult(xActDate))
		Quit:xActDate=""
		Continue:xActDate<aDateFrom
		Continue:xActDate>aDateTo
		
		Set IsI48Hour=$d(arrResult(xActDate,"48H",0))
		Continue:(IsCheck48=0)&&(IsI48Hour=1)  //检查是否入院48小时项目
		
		//感染规则判断及结果输出
		Set xResult="",ResultList=""
		For {
			Set xResult=$o(arrResult(xActDate,"RST",xResult))
			Quit:xResult=""
			
			Set InfSuPosDr=""       //推荐感染部位
			Set InfSuPosDr2=""  	//疑似感染部位
			
			//查找诊断对应疑似感染部位
			Set tSuPoss=##class(DHCHAI.AMC.CSResultSrv).GetPosByDiagnos(xResult)
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
								
					Continue:(","_AdmDiagList_",")[(","_InfPosID_"^"_InfPos_",")   //推荐部位与入院感染部位一致	
					Continue:$listfind(InfSuPosDr2,tSuPosDr)>0
					Set InfSuPosDr2=InfSuPosDr2_$lb(tSuPosDr)
				}
			}
			Set InfSuPosDr2=##class(DHCHAI.Utils.CommonSrv).ListToString(InfSuPosDr2,"#")
		
			//触发次数、触发日期、多耐结果
			Set ResultCnt=0
			Set ResultDate=xActDate
			Set xID=0
			For {
				Set xID=$o(arrResult(xActDate,"RST",xResult,xID))
				Quit:xID=""
				
				Set tResultInfo=$g(arrResult(xActDate,"RST",xResult,xID))
				Continue:tResultInfo=""
				Set ResultCnt=ResultCnt+1
			}
			Continue:ResultCnt<1		
			
			
			Set NormalList=""
			For xDate=(xActDate-14):1:xActDate {
				Set xNormalRet="",NormalKey=""
				For {
					Set xNormalRet=$o(arrResult(xDate,"Normal",xNormalRet))		
					Quit:xNormalRet=""
			        
					Set NormalKey=NormalKey_"、"_xNormalRet
				}
				Continue:NormalKey=""
				Set NormalKey=$e(NormalKey,2,$l(NormalKey))
				
				Set NormalList =NormalList_$lb(NormalKey_"("_$zdt(xDate,3)_")")
			}
			
			Set NormalList=##class(DHCHAI.Utils.CommonSrv).ListToString(NormalList,"，")
			Set Details =NormalList
						
			//疑似关键词
			Set InfSuKeys=xResult
			Set:NormalList'="" InfSuKeys=InfSuKeys_" (症状："_NormalList_")"
			//显示结果
			Set ResultNote=ItmScreenDesc_" ("_xResult_")"		
			Set ItmScreenTxt=xResult
			
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
