/// 名称: DHCHAI.AMC.CSRuleExpOSrv
/// 描述: 疑似病例筛查规则解析---再入院
/// 编写者：zhufei
/// 编写日期: 2019-06-11
Class DHCHAI.AMC.CSRuleExpOSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.AMC.CSRuleExpOSrv).GetResult()
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
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," O",xRuleDr))
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
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"手术患者疑似感染再入院")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"手术患者")=ArgStr
		}
		
		Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(xRuleDr,"普通患者疑似感染再入院")
		If ArgStr'="" {
			Set arrRuleExp(xRuleDr,"普通患者")=ArgStr
		}
	
		Continue:$o(arrRuleExp(xRuleDr,""))=""
		Set arrRuleExp(xRuleDr)=$lb(xRuleDr,ItmScreenDr,ItmScreenDesc)
	}
	Quit:$o(arrRuleExp(0))="" return
	
	//再入院信息
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set PAPatientID = objEpisode.PAPatientIDx
	Set CurrAdmDate=objEpisode.PAAdmDate
	Set CurrAdmTime=objEpisode.PAAdmTime
	//当前所在科室会发生变化故取转科记录的第一条科室记录为本次就诊科室
	Set CurrAdmLoc=""
	Set xDate=0
	For {
		Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","E",aEpisodeDr,xDate))
		Quit:xDate=""
		Quit:CurrAdmLoc'=""
		Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate","E",aEpisodeDr,xDate,0))
		Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xID)
		Continue:'$IsObject(objTrans)
		Continue:'$IsObject(objTrans.PATransLocDr)
		Set CurrAdmLoc=objTrans.PATransLocDr.%Id()
	}
	
	Set PreEpisodeDr="",PreAdmDate="",PreAdmTime=""
	Set AdmLoc=""
	Set xEpisodeDr=""
	For {
		Set xEpisodeDr=$o(^DHCHAI.DP.PAAdmI("IndexPatientIDx",PAPatientID,xEpisodeDr))
		Quit:xEpisodeDr=""
		
		Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeDr)
		Quit:'$IsObject(objEpisode)
		Continue:objEpisode.PAAdmType'="I"  //判断住院病人
		Continue:objEpisode.PAVisitStatus'="D"
		Continue:'$IsObject(objEpisode.PADischLocDr)
		Set DischLoc = objEpisode.PADischLocDr.%Id()
		Continue:DischLoc'=CurrAdmLoc   // add 20221124 疑似感染再入院条件增加判断本次就诊科室=上次出院科室
		Set AdmDate=objEpisode.PAAdmDate
		Set AdmTime=objEpisode.PAAdmTime
		Set DischDate=objEpisode.PADischDate
		Set DischTime=objEpisode.PADischTime
		Continue:AdmDate>CurrAdmDate
		Continue:(AdmDate=CurrAdmDate)&&(AdmTime>=CurrAdmTime)

		If PreEpisodeDr="" {
			Set PreEpisodeDr=xEpisodeDr
			Set PreDischDate=DischDate
			Set PreDischTime=DischTime
		} Else {
			Continue:DischDate>PreDischDate
			Continue:(DischDate=PreDischDate)&&(DischTime>=PreDischTime)
			Set PreEpisodeDr=xEpisodeDr
			Set PreDischDate=DischDate
			Set PreDischTime=DischTime
		}
		Continue:'$IsObject(objEpisode.PAAdmLocDr)
		Set AdmLoc=objEpisode.PAAdmLocDr.BTDesc
	}
	Quit:PreEpisodeDr="" return
	Set OperDates=##class("DHCHAI.DPS.OROperAnaesSrv").GetOperDates(PreEpisodeDr)  //取手术日期
	
	//感染规则判断及结果输出
	Set xRuleDr=0
	For {
		Set xRuleDr=$o(arrRuleExp(xRuleDr))
		Quit:xRuleDr=""
		
		Set tRuleInfo=$g(arrRuleExp(xRuleDr))
		Set ItmScreenDr=$lg(tRuleInfo,2)
		Set ItmScreenDesc=$lg(tRuleInfo,3)
		
		If $d(arrRuleExp(xRuleDr,"手术患者")) {
			Set PatType="手术患者"
		} Else {
			Set PatType="普通患者"
		}
		Set tRuleArgStr=$g(arrRuleExp(xRuleDr,PatType))
		Continue:tRuleArgStr=""
		Set AbDay=+$p(tRuleArgStr,"^",4)   //限定天数
		Set:AbDay<1 AbDay=7
		Continue:(CurrAdmDate-PreDischDate)<1  //当天出当天入，考虑中途结算
		Continue:(CurrAdmDate-PreDischDate)>AbDay
		
		Set ResultDate=CurrAdmDate
		Set ResultCnt=1
		
		Set InfSuPosDr=""       //推荐感染部位
		Set InfSuPosDr2=""  	//疑似感染部位
		Set tSuPosDr=##class(DHCHAI.AMC.CSResultSrv).GetPosByLoc(AdmLoc)
		If tSuPosDr'="" {
			If $listfind(InfSuPosDr2,tSuPosDr)<1 {
				Set InfSuPosDr2=InfSuPosDr2_$lb(tSuPosDr)
			}
		}
		Set InfSuPosDr2=##class(DHCHAI.Utils.CommonSrv).ListToString(InfSuPosDr2,"#")
		
		//合并检查阳性症状或体征
		Set tSymptomInfo=##class(DHCHAI.AMC.CSResultSrv).CheckSymptom(aEpisodeDr,CurrAdmDate,InfSuPosDr,InfSuPosDr2,xRuleDr)
		Set SyResult=+$p(tSymptomInfo,"^",1)
		Set SyInfPosDr=$p(tSymptomInfo,"^",2)
		//Continue:(SyInfPosDr="")&&(SyResult<1)  //未确认感染部位，又不满足组合条件
		Set SySuPosDr=$p(tSymptomInfo,"^",3)
		Set InfSuDate=$p(tSymptomInfo,"^",4)
		Set:InfSuDate="" InfSuDate=xActDate
		Set ObsAbDay=$p(tSymptomInfo,"^",5)
		Set EmrSuKey=$p(tSymptomInfo,"^",6)
		
		//疑似关键词
		Set InfSuKeys="再入院"
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
		Set obj.CSInfSuRuleDr  = xRuleDr         //规则(多值#分隔)
		Set obj.CSRstStatus    = 1               //结果状态(0触发疑似指标、1触发组合条件)

		Set ArrCnt=%ArrayResult.Count()
		Do %ArrayResult.SetAt(obj,ArrCnt+1)
	}
	Kill arrResult
	Kill arrRuleExp
	
	Set return=%ArrayResult.Count()
	Quit return
}

}
