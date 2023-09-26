/// Description：诊疗节点内容表（辅助诊疗-推荐辅助检验检查、推荐评估表、推荐护理措施、推荐治疗方案）
/// Table：CT.WDT.CDSS.RuleResult
Class web.CDSSEntity.CMKB.RuleResult Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.RuleResult";

/// ResultRowId
Property ResultRowId As %String;

/// 流程图节点
Property NodeDR As %String;

/// 顺序
Property Sequence As %String;

/// 推荐类别（Lab-检验/Exam-检查/Ass-评估表/Treat-治疗方案）
Property RecommendType As %String;

/// 检验/检查/评估表/治疗方案（存id）
Property RecommendResult As %String;

/// 备注
Property Remarks As %String;

/// 是否基础评估表(1是，0否)
Property BaseTable As %String;

/// 治疗方案来源（文献或者教程名称）
Property TreatSource As %String;

/// 来源截图(弃用)
Property SourceImg As web.BDP.sys.String;

Property RuleBasisDR As %String;

}
