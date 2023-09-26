Class EPRservice.Quality.OperationLogic.ScoreEvaluation Extends EPRservice.Quality.OperationLogic.EvaluationLogic [ ClassType = "", Not ProcedureBlock ]
{

/// Desc:计算分数
/// Creator:Candyxu
/// CreateDate:2012-11-22
/// Input:pEpisodeID:就诊号;pRuleIDs:质控标准代码,多个以^分隔
/// OutPut:级别^特殊判断ID^特殊判断个数^一般判断ID^一般判断个数^总触犯个数
///       所谓特殊判断为几个...相当于... 例如：6个以上轻级相当于1个中级
ClassMethod DoOperation(pEpisodeID As %String, pRuleIDs As %String, pAction As %String = "") As %String
{
	q:((pEpisodeID = "") || (pRuleIDs = "")) "0"
	s Result = ##Class(EPRservice.Quality.BOQualityReport).GetMRScoreAndGradeByID(pEpisodeID,pRuleIDs,pAction)
	q Result
}

/// Desc:取分数值
/// Creator:Candyxu
/// CreateDate:2012-11-22
/// Input:pValue 质控条目评估值
ClassMethod GetEvaluationValue(pValue As %String) As %String
{
    q pValue
}

/// Desc:报表临时global
/// Creator:Candyxu
/// CreateDate:2012-12-04
/// Input:pGrade 级别,pAUniqueKey 唯一识别值,pDisLocID 科室ID,pDisWardID 病区ID,pAdmDoctorID 医生ID
ClassMethod GetSearchReport(pGrade As %String, pAUniqueKey As %String, pDisLocID As %String, pDisWardID As %String, pAdmDoctorID As %String, pQualityType As %String)
{
	s:(pGrade = "甲") ^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"First") = (+$g(^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"First"))) + 1
	s:(pGrade = "乙") ^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"Second") = (+$g(^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"Second"))) + 1
	s:(pGrade = "丙") ^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"Third") = (+$g(^CacheTemp("EPRQuality",pQualityType,pAUniqueKey,pDisLocID,pDisWardID,pAdmDoctorID,"Third"))) + 1
}

/// Desc: 报表临时global
/// Creator:Candyxu
/// CreateDate:2012-12-11
/// Input:pGrade 级别,PStyle 类型,pAUniqueKey 唯一识别值,pDisLocID 科室ID,pAdmDoctorID 医生ID
ClassMethod GetQualityReportGloable(pGrade As %String, PStyle As %String, pAUniqueKey As %String, pDisLocID As %String, pAdmDoctorID As %String)
{
	s:(pGrade = "甲") ^CacheTemp("EPRQuality",PStyle,pAUniqueKey,pDisLocID,pAdmDoctorID,"First") = (+$g(^CacheTemp("EPRQuality",PStyle,pAUniqueKey,pDisLocID,pAdmDoctorID,"First"))) + 1
	s:(pGrade = "乙") ^CacheTemp("EPRQuality",PStyle,pAUniqueKey,pDisLocID,pAdmDoctorID,"Second") = (+$g(^CacheTemp("EPRQuality",PStyle,pAUniqueKey,pDisLocID,pAdmDoctorID,"Second"))) + 1
	s:(pGrade = "丙") ^CacheTemp("EPRQuality",PStyle,pAUniqueKey,pDisLocID,pAdmDoctorID,"Third") = (+$g(^CacheTemp("EPRQuality",PStyle,pAUniqueKey,pDisLocID,pAdmDoctorID,"Third"))) + 1
}

ClassMethod GetLastEvaluation(pEpisodeID As %String) As %String
{
	s ret = ##Class(EPRservice.Quality.DataAccess.BOQualityResult).GetLastScore(pEpisodeID)
	s Score = $p($g(ret),"^",1)
	s Grade = $p($g(ret),"^",2)
	q "病历级别:"_Grade_" | "_"病历分数"_Score
}

}
