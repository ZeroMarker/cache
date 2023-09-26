/// Description：诊疗节点内容表（预警规则-并发症）
/// Table：CT.WDT.CDSS.RuleComplication
Class web.CDSSEntity.CMKB.RuleComplication Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.RuleComplication";

/// ComplicationRowId
Property ComplicationRowId As %String;

/// 流程图节点
Property NodeDR As %String;

/// 顺序
Property Sequence As %String;

/// 并发症
Property ComplicationDR As %String;

/// 要点
Property MainPoints As %String;

/// 备注
Property Remarks As %String;

/// 治疗方案来源（文献或者教程名称）
Property TreatSource As %String;

Property RuleBasisDR As %String;

}
