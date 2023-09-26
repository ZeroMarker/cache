/// 名称: DHCHAI.IRS.CRuleTestAbSrv
/// 描述: 常规检验相关服务
/// 编写者：zhufei
/// 编写日期: 2017-05-12
Class DHCHAI.IRS.CRuleTestAbSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-05-12
/// Description:  根据检验项目筛查规则
/// Table：       DHCHAI.IR.CRuleTestAb*、DHCHAI.DP.Result
/// Input：       aSCode : 子系统代码
///               aTCCode : 检验项目代码
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CRuleTestAbSrv).GetRuleByTCCode()
ClassMethod GetRuleByTCCode(aSCode As %String, aTCCode As %String, aSpecimen As %String) As %String
{
	New (aSCode,aTCCode,aSpecimen)
	Set return=""
	Quit:(aSCode="")||(aTCCode="") return
	
	/*
	Set objTCM=##class(DHCHAI.DP.LabTCMap).GetObjByTCCode()
		Continue:'$IsObject(objTCM)
		Set TCMID=objTCM.%Id()
		
		Index IdxofTestCodeDr On BTTestCodeDr [ Unique ];
		*/
	//Set return=RuleID
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-12
/// Description:  检查结果是否满足规则
/// Table：       DHCHAI.IR.CRuleTestAb*、DHCHAI.DP.Result
/// Input：       aRuleID : 规则ID
///               aResult : 结果
///               aAbFlag : 异常标志
/// Return：      返回String
/// w ##class(DHCHAI.IRS.CRuleTestAbSrv).CheckRuleByResult()
ClassMethod CheckRuleByResult(aRuleID As %String, aResult As %String, aAbFlag As %String) As %String
{
	New (aRuleID,aResult,aAbFlag)
	Set return=""
	Quit:(aRuleID="") return
	/*
	Set objTCMap=##class(DHCHAI.DP.LabTCMap).GetObjById(xTCMap)
	Continue:'$IsObject(objTCMap)
	Set TCCode=objTCMap.BTTCCode
	Continue:TCCode=""
	Set SCode=objTCMap.BTSCode
	Continue:SCode=""
	
	Set objRule=objTCMap.Parref
	Continue:'$IsObject(objRule)
	Set RuleID=objRule.%Id()
	Set TestSet=objRule.BTTestSet
	Set TestCode=objRule.BTTestCode
	Set MaxAgeM=objRule.BTMaxAgeM
	Set MinAgeM=objRule.BTMinAgeM
	Set MaxAgeF=objRule.BTMaxAgeF
	Set MinAgeF=objRule.BTMinAgeF
	
	Set ^TMP("DHCHAI.IR.CRuleTestAb",+$h,"TC",SCode,TCCode)=$lb(RuleID,TestSet,TestCode)
	Set ^TMP("DHCHAI.IR.CRuleTestAb",+$h,"TC",SCode,TCCode,"M")=$lb(MaxAgeM,MinAgeM)
	Set ^TMP("DHCHAI.IR.CRuleTestAb",+$h,"TC",SCode,TCCode,"F")=$lb(MaxAgeF,MinAgeF)
	
	Set Count=objRule.ChildTR.Count()
	For indTR=1:1:Count {
		Set objTR=objRule.ChildTR.GetAt(indTR)
		Continue:'$IsObject(objTR)
		Continue:'$IsObject(objTR.BTTestResultDr)
		Set TestResult=objTR.BTTestResultDr.BTTestRes
		Set TestResultM=objTR.BTTestResultDr.BTMapText
		Set:TestResult'="" ^TMP("DHCHAI.IR.CRuleTestAb",+$h,"TR",RuleID,"D",TestResult)=""
		Set:TestResultM'="" ^TMP("DHCHAI.IR.CRuleTestAb",+$h,"TR",RuleID,"M",TestResultM)=""
	}
	
	Set Count=objRule.ChildTRF.Count()
	For indTRF=1:1:Count {
		Set objTRF=objRule.ChildTRF.GetAt(indTRF)
		Continue:'$IsObject(objTRF)
		Continue:'$IsObject(objTRF.BTTestAbFlagDr)
		Set AbFlag=objTRF.BTTestAbFlagDr.BTAbFlag
		Set AbFlagM=objTRF.BTTestAbFlagDr.BTMapText
		Set:AbFlag'="" ^TMP("DHCHAI.IR.CRuleTestAb",+$h,"TRF",RuleID,"D",AbFlag)=""
		Set:AbFlagM'="" ^TMP("DHCHAI.IR.CRuleTestAb",+$h,"TRF",RuleID,"M",AbFlagM)=""
	}
	
	Set Count=objRule.ChildTSP.Count()
	For indTSP=1:1:Count {
		Set objTSP=objRule.ChildTSP.GetAt(indTSP)
		Continue:'$IsObject(objTSP)
		Continue:'$IsObject(objTSP.BTTestSpecDr)
		Set SpecDesc=objTSP.BTTestSpecDr.BTSpecDesc
		If $IsObject(objTSP.BTTestSpecDr.BTMapItemDr){
			Set SpecDescM=objTSP.BTTestSpecDr.BTMapItemDr.%Id()
		} Else {
			Set SpecDescM=""
		}
		Set:SpecDesc'="" ^TMP("DHCHAI.IR.CRuleTestAb",+$h,"TSP",RuleID,"D",SpecDesc)=""
		Set:SpecDescM'="" ^TMP("DHCHAI.IR.CRuleTestAb",+$h,"TSP",RuleID,"M",SpecDescM)=""
	}*/
	
	/*
	Set objTCM=##class(DHCHAI.DP.LabTCMap).GetObjByTCCode()
		Continue:'$IsObject(objTCM)
		Set TCMID=objTCM.%Id()
		
		Index IdxofTestCodeDr On BTTestCodeDr [ Unique ];
		*/
	//Set return=RuleID_"^"_RuleRst
	Quit return
}

}
