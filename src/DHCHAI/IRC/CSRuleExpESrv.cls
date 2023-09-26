/// 名称: DHCHAI.IRC.CSRuleExpESrv
/// 描述: 疑似病例筛查规则解析---放射影像学检查异常
/// 编写者：zhufei
/// 编写日期: 2019-06-11
Class DHCHAI.IRC.CSRuleExpESrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.IRC.CSRuleExpESrv).GetResult()
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
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," E",xRuleDr))
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
    Set AdmDiagList=##class(DHCHAI.IRC.CSResultSrv).GetAdmDiagnos(aEpisodeDr)
	//RME-Radiology	语义-放射学检查
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("RME-Radiology")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	//放射影像异常结果
	Kill arrResult
	Set AdmDate=""
	Set xRepDate=aDateFrom-1
	For {
		Set xRepDate=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",aEpisodeDr,ItemDr,xRepDate))
		Quit:xRepDate=""
		Quit:xRepDate>aDateTo
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrRepDate",aEpisodeDr,ItemDr,xRepDate,xID))
			Quit:xID=""
			
			Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
			Continue:'$IsObject(obj)
			Continue:'$IsObject(obj.CCEpisodeDr)
			Continue:'$IsObject(obj.CCItemDr)
			Continue:obj.CCIsActive'=1
			Set SCode=obj.CCSCode
			Set RepDate=obj.CCRepDate
			Set RepTime=obj.CCRepTime
			Continue:RepDate=""
			
			//检查部位或项目
			Set CheckUnit=obj.CCUnit
			
			//筛查结果
			Set Result=obj.CCResult
			Continue:Result=""
			
			//入院日期
			Set AdmDate=obj.CCEpisodeDr.PAAdmDate
			
			Set arrResult(CheckUnit,"RST",RepDate,xID)=$lb(xID,CheckUnit,Result,RepDate,RepTime)
			
			//判断是否入院48小时后项目
			Set flg=##class(DHCHAI.IRC.CSResultSrv).CheckIs48HourRst(obj)
			Set arrResult(RepDate,"48H",+flg)=""
			
		}
	}
	Quit:$o(arrResult(0))="" return
	Quit:AdmDate="" return
	
	Set IsCheck48=##class(DHCHAI.BT.Config).GetValByCode("IRScreenIsCheck48")  //0：不计入，1：计入

	//感染规则判断及结果输出
	Set xCheckUnit=""
	For {
		Set xCheckUnit=$o(arrResult(xCheckUnit))
		Quit:xCheckUnit=""
		
		Set InfSuPosDr=""       //推荐感染部位
		Set InfSuPosDr2=""  	//疑似感染部位
		//查找检查部位或项目对应疑似感染部位
		Set tSuPosDr=##class(DHCHAI.IRC.CSResultSrv).GetPosByCheckUnit(xCheckUnit)
		If tSuPosDr'="" {
			If $listfind(InfSuPosDr2,tSuPosDr)<1 {
				Set InfSuPosDr2=InfSuPosDr2_$lb(tSuPosDr)
			}
		}
		Set InfSuPosDr2=##class(DHCHAI.Utils.CommonSrv).ListToString(InfSuPosDr2,"#")
		
		Set xRepDate=0
		For {
			Set xRepDate=$o(arrResult(xCheckUnit,"RST",xRepDate))
			Quit:xRepDate=""
			Continue:xRepDate<aDateFrom
			Continue:xRepDate>aDateTo
			
			Set IsI48Hour=$d(arrResult(xRepDate,"48H",0))
			Continue:(IsCheck48=0)&&(IsI48Hour=1)  //检查是否入院48小时项目
				
			//触发次数、触发日期、多耐结果
			Set ResultCnt=0
			Set ResultDate=xRepDate
			Set xID=0
			For {
				Set xID=$o(arrResult(xCheckUnit,"RST",xRepDate,xID))
				Quit:xID=""
				
				Set tResultInfo=$g(arrResult(xCheckUnit,"RST",xRepDate,xID))
				Continue:tResultInfo=""
				Set ResultCnt=ResultCnt+1
			}
			Continue:ResultCnt<1
			
			//合并检查阳性症状或体征
			Set tSymptomInfo=##class(DHCHAI.IRC.CSResultSrv).CheckSymptom(aEpisodeDr,xRepDate,InfSuPosDr,InfSuPosDr2,RuleDr)
			Set SyResult=+$p(tSymptomInfo,"^",1)
			Set SyInfPosDr=$p(tSymptomInfo,"^",2)
			//Continue:(SyInfPosDr="")&&(SyResult<1)  //未确认感染部位，又不满足组合条件
			Set SySuPosDr=$p(tSymptomInfo,"^",3)
			Set InfSuDate=$p(tSymptomInfo,"^",4)
			Set:InfSuDate="" InfSuDate=xRepDate
			Set ObsAbDay=$p(tSymptomInfo,"^",5)
			Set EmrSuKey=$p(tSymptomInfo,"^",6)
			
			//疑似关键词
			Set InfSuKeys=xCheckUnit
			Set:ObsAbDay'="" InfSuKeys=InfSuKeys_"#"_"发热"
			Set:EmrSuKey'="" InfSuKeys=InfSuKeys_"#"_EmrSuKey
			
			//显示结果
			Set ResultNote=ItmScreenDesc_" ("_xCheckUnit_")"
			
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
