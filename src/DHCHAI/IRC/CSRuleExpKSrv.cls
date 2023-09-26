/// 名称: DHCHAI.IRC.CSRuleExpKSrv
/// 描述: 疑似病例筛查规则解析---腹泻(大便次数异常)
/// 编写者：zhufei
/// 编写日期: 2019-06-11
Class DHCHAI.IRC.CSRuleExpKSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.IRC.CSRuleExpKSrv).GetResult()
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
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," K",xRuleDr))
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
	}
	Quit:$o(arrRuleExp(0))="" return
	
	//腹泻疑似诊断
	Set SuPosDr=$o(^DHCHAI.BT.InfSuPosI("IdxofBTDiagnos","感染性腹泻",0))
	Quit:SuPosDr="" return
	Set objSuPos=##class(DHCHAI.BT.InfSuPos).GetObjById(SuPosDr)
	Quit:'$IsObject(objSuPos) return
	Set SuPosDesc=objSuPos.BTDiagnos
	
	//MR-ObsDiarr	护理-腹泻
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("MR-ObsDiarr")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	//腹泻(大便次数)结果
	Kill arrResult
	Set AdmDate=""
	Set PatAge=""
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
			
			Set Result=obj.CCResult
			Set TextRes=obj.CCTextRes
			Set Summary=obj.CCSummary
			
			//入院日期
			Set AdmDate=obj.CCEpisodeDr.PAAdmDate
			
			//年龄
			Set PatAge=obj.CCEpisodeDr.PAAge
			
			Set arrResult(ActDate,"RST",Result,xID)=$lb(xID,Result,Summary,ActDate,ActTime)
			//判断是否入院48小时后项目
			Set flg=##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst(obj)
			Set arrResult(ActDate,"48H",+flg)=""
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
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"年龄")
		If ArgStr'="" {
			Set AgeMax=+$p(ArgStr,"^",2)   //年龄上限
			Set AgeMin=+$p(ArgStr,"^",3)   //年龄下限
			Continue:(AgeMax'="")&&(PatAge>AgeMax)
			Continue:(AgeMin'="")&&(PatAge<AgeMin)
		} Else {
			Continue:(PatAge<1)  //小于1岁
		}
		
		Set tRuleInfo=$g(arrRuleExp(xRuleDr))
		Set ItmScreenDr=$lg(tRuleInfo,2)
		Set ItmScreenDesc=$lg(tRuleInfo,3)
		
		//持续发热参数
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"腹泻(大便次数)")
		Continue:ArgStr=""
		Set ObsMax=+$p(ArgStr,"^",2)   //大便次数上限
		Set:ObsMax<3 ObsMax=3
		Set ObsDay=+$p(ArgStr,"^",4)   //持续天数
		Set:ObsDay<=1 ObsDay=3
	
		Set xActDate=0
		For {
			Set xActDate=$o(arrResult(xActDate))
			Quit:xActDate=""
			Continue:xActDate<aDateFrom
			Continue:xActDate>aDateTo
			
			Set IsI48Hour=$d(arrResult(xActDate,"48H",0))
			Continue:(IsCheck48=0)&&(IsI48Hour=1)  //检查是否入院48小时项目
			
		
			//判断是否腹泻
			Set IsObsDiarr=0
			Set xResult=""
			For {
				Set xResult=$o(arrResult(xActDate,"RST",xResult))
				Quit:xResult=""
				
				If xResult["※" {    //※表示腹泻
					Set IsObsDiarr=1
				} Else {
					Set tResult=+xResult
					If (ObsMax'="")&&(tResult>=ObsMax) {
						Set IsObsDiarr=1
					}
				}
			}
			Continue:IsObsDiarr<1
			
			//判断是否持续腹泻ObsDay天
			Set CurrActDate=0,AbCnt=0
			Set yActDate=(xActDate-ObsDay)
			For {
				Set yActDate=$o(arrResult(yActDate))
				Quit:yActDate=""
				Quit:yActDate>(xActDate+ObsDay-1)
				
				If (yActDate-CurrActDate)>1 {
					Set AbCnt=1
				} Else {
					Set AbCnt=AbCnt+1
				}
				Set CurrActDate=yActDate
			}
			Continue:AbCnt<ObsDay
		
			//触发次数、触发日期、多耐结果
			Set InfSuPosDr=""       //推荐感染部位
			Set InfSuPosDr2=SuPosDr //疑似感染部位
			Set ResultCnt=1
			Set ResultDate=xActDate
			
			//合并检查阳性症状或体征
			Set tSymptomInfo=##class(DHCHAI.IRC.CSResultSrv).CheckSymptom(aEpisodeDr,xActDate,InfSuPosDr,InfSuPosDr2,xRuleDr)
			Set SyResult=+$p(tSymptomInfo,"^",1)
			Set SyInfPosDr=$p(tSymptomInfo,"^",2)
			Continue:(SyInfPosDr="")&&(SyResult<1)  //未确认感染部位，又不满足组合条件
			Set SySuPosDr=$p(tSymptomInfo,"^",3)
			Set InfSuDate=$p(tSymptomInfo,"^",4)
			Set:InfSuDate="" InfSuDate=xActDate
			Set ObsAbDay=$p(tSymptomInfo,"^",5)
			Set EmrSuKey=$p(tSymptomInfo,"^",6)
			
			//疑似关键词
			Set InfSuKeys="腹泻"
			Set:ObsAbDay'="" InfSuKeys=InfSuKeys_"#"_"发热"
			Set:EmrSuKey'="" InfSuKeys=InfSuKeys_"#"_EmrSuKey
			
			//显示结果
			Set ResultNote=ItmScreenDesc
			
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
			Set obj.CSInfSuRuleDr  = xRuleDr         //规则
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
