/// 名称: DHCHAI.AMC.CSRuleExpIBSrv
/// 描述: 疑似病例筛查规则解析---抗感染治疗---停药48h后启用治疗性抗菌药物
/// 编写者：pylian
/// 编写日期: 2020-08-25
Class DHCHAI.AMC.CSRuleExpICSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.AMC.CSRuleExpICSrv).GetResult()
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
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," IC",xRuleDr))
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
		Set RuleNote = objRule.BTRuleNote
	
		Set arrRuleExp(xRuleDr)=$lb(xRuleDr,ItmScreenDr,ItmScreenDesc)
		
	}
	Set RuleDr=$o(arrRuleExp(0))
	Quit:RuleDr="" return
	Set tRuleInfo=$g(arrRuleExp(RuleDr))
	Set ItmScreenDr=$lg(tRuleInfo,2)
	Set ItmScreenDesc=$lg(tRuleInfo,3)
	//停药48h后启用治疗性抗菌药物
	Set ArgStr=##class(DHCHAI.IR.CRuleInfSuRuleExp).GetRuleExpArgs(RuleDr,"停药48h后启用治疗性抗菌药物")
	Quit:ArgStr="" return
	Set AbDic=$p(ArgStr,"^",1)   //值域设置(启用抗菌药物用药目的设定)
	Set:AbDic="" AbDic="治疗"
	Set AbDay=+$p(ArgStr,"^",4)   //限定天数(启用抗菌药物天数设定)
	Set:AbDay<1 AbDay=3

	//OE-AntiUse	医嘱-抗菌用药
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("OE-AntiUse")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	//抗菌用药结果
	Kill arrResult
	Set AdmDate=""
	Set xActDate=0
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
			Continue:ActTime=""   //时间为空影响判断
		
			//抗菌用药
			Set AntiDesc=obj.CCAntiDesc
			Continue:AntiDesc=""
			Set objMap=##class(DHCHAI.DP.OEAntiMastMap).GetObjByAntiDesc(SCode,AntiDesc)
			Continue:'$IsObject(objMap)
			Continue:'$IsObject(objMap.BTMapItemDr)
			Set AntiDesc=objMap.BTMapItemDr.BTName
			Continue:AntiDesc=""
			
			//入院日期
			Set AdmDate=obj.CCEpisodeDr.PAAdmDate
			Set Priority="临时医嘱",XDate="",XTime="",UsePurpose=""
			Set objOrdItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(obj.CCObjectID)
			If $IsObject(objOrdItem){
				Set Priority=objOrdItem.OEPriority
				Set XDate=objOrdItem.OEXDate
				Set XTime=objOrdItem.OEXTime
				Set UsePurpose=objOrdItem.OEAntUsePurpose
			}
		
			Set UsePurposeMapStr =  ##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"AntiMedPurpose",UsePurpose)
			Set AntiUsePurpose = $p(UsePurposeMapStr,"^",3)
		
			If Priority["长期" {
				Set:XDate="" XDate=+$h
				For tActDate=ActDate:1:XDate {
					Set arrResult(tActDate,"RST",AntiDesc,xID)=$lb(xID,AntiDesc,ActDate,ActTime)
				}
				If (AbDic[AntiUsePurpose) {  //治疗用药  （AbDic可多值拼接，如需包括治疗+预防，维护多值）
					Set arrResult("CRST",ActDate,ActTime,xID)=$lb(xID,AntiDesc,ActDate,ActTime,XDate,XTime)
				}
			} Else {
				Set arrResult(ActDate,"RST",AntiDesc,xID)=$lb(xID,AntiDesc,ActDate,ActTime)
				If (AbDic[AntiUsePurpose) {  //治疗用药  （AbDic可多值拼接，如需包括治疗+预防，维护多值）
					Set arrResult("CRST",ActDate,ActTime,xID)=$lb(xID,AntiDesc,ActDate,ActTime,XDate,XTime)
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
	Set AntiFirstTime=""
	Set xActDate=0
	For {
		Set xActDate=$o(arrResult("CRST",xActDate))
		Quit:xActDate=""
		Continue:xActDate<aDateFrom  
		Continue:xActDate>aDateTo
		Quit:xActDate<(AdmDate+AbDay)  //入院3天内使用抗菌用药，直接退出循环
	
		Set IsI48Hour=$d(arrResult(xActDate,"48H",0))
		Continue:(IsCheck48=0)&&(IsI48Hour=1)  //检查是否入院48小时项目
			
		Set Flg =0	
	    Set xActTime=""
		For {
			Set xActTime=$o(arrResult("CRST",xActDate,xActTime))
			Quit:xActTime=""
			Quit:Flg=1  //入院3天内使用抗菌
			
			For indDay=1:1:15 { //最大日期范围，可按需求调整为出院日期
			  Set xID=""
			  For {
				  Set xID =$o(arrResult(xActDate-indDay,"RST",xID))
				  Quit:xID=""
				  Quit:Flg=1
				  Set tAntiInfo = $g(arrResult(xActDate-indDay,"RST",xID))
				  Set ActDate = $lg(tAntiInfo,3)
				  Set ActTime = $lg(tAntiInfo,4)
				  Set XDate = $lg(tAntiInfo,5)
				  Set XTime = $lg(tAntiInfo,6)
				  If (xActDate-XDate)>2 {   //间隔大于2天
				  	Set Flg=1
				  	Continue
				  }ElseIf(xActDate-XDate)=2 {
					 Set Flg=1
					 Continue:xActTime>XTime
				  }
				  Set Flg=0
			  }
			}
		}
	    Continue:Flg'=1
	    
		//触发次数、触发日期
		Set InfSuPosDr=""       //推荐感染部位
		Set InfSuPosDr2=""  	//疑似感染部位
		Set ResultDate=xActDate
		
		//合并检查阳性症状或体征
		Set tSymptomInfo=##class(DHCHAI.AMC.CSResultSrv).CheckSymptom(aEpisodeDr,xActDate,InfSuPosDr,InfSuPosDr2,RuleDr)
		Set SyResult=+$p(tSymptomInfo,"^",1)
		Set SyInfPosDr=$p(tSymptomInfo,"^",2)
		Continue:(SyInfPosDr="")&&(SyResult<1)  //未确认感染部位，又不满足组合条件
		Set SySuPosDr=$p(tSymptomInfo,"^",3)
		Set InfSuDate=$p(tSymptomInfo,"^",4)
		Set:InfSuDate="" InfSuDate=xActDate
		Set ObsAbDay=$p(tSymptomInfo,"^",5)
		Set EmrSuKey=$p(tSymptomInfo,"^",6)
		
		//疑似关键词
		Set InfSuKeys="抗菌用药"
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
		Set obj.CSResultCnt    = 1               //结果数量
		Set obj.CSInfSuKeys    = InfSuKeys       //疑似关键词
		Set obj.CSInfSuPosDr   = InfSuPosDr      //推荐感染部位
		Set obj.CSInfSuDate    = InfSuDate       //推荐感染日期
		Set obj.CSInfSuRuleDr  = RuleDr         //规则
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
