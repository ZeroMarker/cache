/// 名称: DHCHAI.AMC.CSRuleExpPSrv
/// 描述: 疑似病例筛查规则解析---请感染科会诊
/// 编写者：zhufei
/// 编写日期: 2019-06-11
Class DHCHAI.AMC.CSRuleExpPSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// set arr=##class(%ArrayOfDataTypes).%New()
/// w ##class(DHCHAI.AMC.CSRuleExpPSrv).GetResult()
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
		Set xRuleDr=$o(^DHCHAI.IR.CRuleInfSuRuleI("IdxofRuleType"," P",xRuleDr))
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
	//OE-Consult	医嘱-请会诊
	Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjByCode("RME-Consult")
	Quit:'$IsObject(objItem) return
	Quit:objItem.CCIsActive'=1 return
	Set ItemDr=objItem.%Id()
	//请会诊结果
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
			Continue:obj.CCIsAbFlag'=1 
			Set SCode=obj.CCSCode
			Set ActDate=obj.CCRepDate
			Set ActTime=obj.CCActTime
			Set RepDate=obj.CCRepDate
			Set RepTime=obj.CCRepTime
			Continue:ActDate=""
					
			Set ObjectID=obj.CCObjectID
			Set objEmC=##class(DHCHAI.DP.EmConsult).GetObjById(ObjectID)
			Continue:'$IsObject(objEmC)
			Continue:'$IsObject(objEmC.ECCLocDr)
			Continue:'$IsObject(objEmC.ECRLocDr)
			Set CLocDesc=objEmC.ECCLocDr.BTDesc  //会诊科室
			Set RLocDesc=objEmC.ECRLocDr.BTDesc  //申请科室
			
			//会诊意见
			Set Opintion=obj.CCResult
				
			//入院日期
			Set AdmDate=obj.CCEpisodeDr.PAAdmDate
			
			Set arrResult(RepDate,"RST",xID)=$lb(xID,Opintion,CLocDesc,RepDate,RepTime)
		}
	}
	Quit:$o(arrResult(0))="" return
	
	//感染规则判断及结果输出
	Set xRepDate=0
	For {
		Set xRepDate=$o(arrResult(xRepDate))
		Quit:xRepDate=""
		
		//触发次数、触发日期、多耐结果
		Set InfSuPosDr=""       //推荐感染部位
		Set InfSuPosDr2=""  	//疑似感染部位
		Set ResultCnt=0
		Set ResultDate=xRepDate
		Set xID=0
		For {
			Set xID=$o(arrResult(xRepDate,"RST",xID))
			Quit:xID=""
			
			Set tResultInfo=$g(arrResult(xRepDate,"RST",xID))
			Continue:tResultInfo=""
						
		    Set Opintion=$lg(tResultInfo,2)
			Set RecLocDesc=$lg(tResultInfo,3)
			
			//查找诊断对应疑似感染部位
			Set InfPosList=""		
			Set tSuPoss=##class(DHCHAI.AMC.CSResultSrv).GetPosByDiagnos(Opintion)
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
		Set tSymptomInfo=##class(DHCHAI.AMC.CSResultSrv).CheckSymptom(aEpisodeDr,xRepDate,InfSuPosDr,InfSuPosDr2,RuleDr)
		Set SyResult=+$p(tSymptomInfo,"^",1)
		Set SyInfPosDr=$p(tSymptomInfo,"^",2)
		//Continue:(SyInfPosDr="")&&(SyResult<1)  //未确认感染部位，又不满足组合条件
		Set SySuPosDr=$p(tSymptomInfo,"^",3)
		Set InfSuDate=$p(tSymptomInfo,"^",4)
		Set:InfSuDate="" InfSuDate=xRepDate
		Set ObsAbDay=$p(tSymptomInfo,"^",5)
		Set EmrSuKey=$p(tSymptomInfo,"^",6)
		
		//疑似关键词
		Set InfSuKeys="请感染科会诊"
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
		Set obj.CSInfSuRuleDr  = RuleDr          //规则
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
