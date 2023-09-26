Class EPRservice.Quality.OperationLogic.EvaluationLogic Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Desc: 质控评价计算
/// Creator:Candyxu
/// CreateDate:2012-11-22
ClassMethod DoOperation(pEpisodeID As %String, pRuleIDs As %String, pAction As %String = "") As %String [ Abstract ]
{
}

/// Desc: 获取质控评估值的描述
/// Creator:Candyxu
/// CreateDate:2012-11-22
ClassMethod GetEvaluationValue(pValue As %String) As %String [ Abstract ]
{
}

/// Desc:质控查询级别计算临时global
/// Creator：Candyxu
/// CreateDate:2012-12-04
ClassMethod GetSearchReport(pGrade As %String, pAUniqueKey As %String, pDisLocID As %String, pDisWardID As %String, pAdmDoctorID As %String, pQualityType As %String) [ Abstract ]
{
}

/// Desc: 运行态病历得分
/// Creator:Candyxu
/// CreateDate:2012-12-05
ClassMethod GetJITMonitorScore() As %String [ Abstract ]
{
}

/// Desc:报表临时临时global
/// Creator:Candyxu
/// CreateDate：2012-12-11
ClassMethod GetQualityReportGloable(pGrade As %String, PStyle As %String, pAUniqueKey As %String, pDisLocID As %String, pAdmDoctorID As %String) [ Abstract ]
{
}

/// Desc:最终评价
/// Creator:Candyxu
/// CreateDate:2012-12-28
ClassMethod GetLastEvaluation(pEpisodeID As %String) As %String [ Abstract ]
{
}

}
