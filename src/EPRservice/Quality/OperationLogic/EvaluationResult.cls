Class EPRservice.Quality.OperationLogic.EvaluationResult Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, LegacyInstanceContext, Not ProcedureBlock ]
{

Property ClassEvaluation As EvaluationLogic;

Property EvaluationType As %String(TRUNCATE = 1);

/// Desc: 实例类
/// Creator:Candyxu
/// CreateDate:2012-11-22
/// Debug: do ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).CreateInstance()
ClassMethod CreateInstance() As EPRservice.Quality.OperationLogic.EvaluationResult
{
	s obj = ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).%New()
	//赋初值
	s obj.ClassEvaluation = ##Class(EPRservice.Quality.OperationLogic.ScoreEvaluation).%New()
	s qPID = $o(^DHCEPRM.QualityParamsI("IdxCode","EvaluationType",""))
	q:(qPID = "") obj
	
	s obj.EvaluationType = $li(^DHCEPRM.QualityParamsD(qPID),2)
	if (obj.EvaluationType = "Grade")
	{
		s obj.ClassEvaluation = ##Class(EPRservice.Quality.OperationLogic.GradeEvaluation).%New()
	}
	q obj
}

/// Desc：根据参数调用按分数评级还是按等级评级
/// Creator:Candyxu
/// CreateDate:2012-11-22
/// Input:TempClassEvaluation{EPRservice.Quality.OperationLogic.GradeEvaluation或EPRservice.Quality.OperationLogic.ScoreEvaluation
/// OutPut:级别^特殊判断ID^特殊判断个数^一般判断ID^一般判断个数^总触犯个数
ClassMethod GetEvaluationResultByParam(TempClassEvaluation As EPRservice.Quality.OperationLogic.EvaluationLogic, pEpisodeID As %String, pRuleIDs As %String)
{
	q:((pEpisodeID = "") || (pRuleIDs = "")) "0"
	s ClassEvaluation = TempClassEvaluation 
	q ClassEvaluation.DoOperation(pEpisodeID,pRuleIDs)
}

/// Desc:获取评价条目值
/// Creator:Candyxu
/// CreateDate:2012-11-22
/// Input:pEpisodeID 就诊号;pRuleIDs 质控标准ID
/// Output:级别^特殊判断ID^特殊判断个数^一般判断ID^一般判断个数^总触犯个数
///       所谓特殊判断为几个...相当于... 例如：6个以上轻级相当于1个中级
Method GetEvaluationResult(pEpisodeID As %String, pRuleIDs As %String, pAction As %String = "") As %String
{
	s Result = ""
    q:((pEpisodeID = "") || (pRuleIDs = "") || (%this.ClassEvaluation = "")) Result
	s Result = %this.ClassEvaluation.DoOperation(pEpisodeID,pRuleIDs,pAction)
	q Result
}

/// Desc:取分数或等级的值
/// Creator:Candyxu
/// CreateDate:2012-11-22
/// Input:pValue 质控条目评估值
Method GetEvaluationValue(pValue As %String) As %String
{
	q:(pValue = "") ""
	q %this.ClassEvaluation.GetEvaluationValue(pValue)
}

/// Desc:质控查询级别计算临时global
/// Creator:Candyxu
/// CreateDate:2012-12-04
/// Input:pGrade 级别,pAUniqueKey 唯一识别值,pDisLocID 科室ID,pDisWardID 病区ID,pAdmDoctorID 医生ID
Method GetSearchReport(pGrade As %String, pAUniqueKey As %String, pDisLocID As %String, pDisWardID As %String, pAdmDoctorID As %String, pQualityType As %String)
{
	q:(pGrade = "") ""
	d %this.ClassEvaluation.GetSearchReport(pGrade,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,pQualityType)
}

/// Desc: 报表临时global
/// Creator:Candyxu
/// CreateDate:2012-12-11
/// Input:pGrade 级别,PStyle 类型,pAUniqueKey 唯一识别值,pDisLocID 科室ID,pAdmDoctorID 医生ID
Method GetQualityReportGloable(pGrade As %String, PStyle As %String, pAUniqueKey As %String, pDisLocID As %String, pAdmDoctorID As %String)
{
	q:(pGrade = "") ""
	d %this.ClassEvaluation.GetQualityReportGloable(pGrade,PStyle,pAUniqueKey,pDisLocID,pAdmDoctorID)
}

/// Desc: 最终评价显示
/// Creator:Candyxu
/// CreateDate:2012-12-11
/// Debug: w ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).GetLastEvaluation(493054)
Method GetLastEvaluation(pEpisodeID As %String) As %String
{
	s ret = ""
	q:(pEpisodeID = "") ret
	s ret = %this.ClassEvaluation.GetLastEvaluation(pEpisodeID)
	q ret
}

}
