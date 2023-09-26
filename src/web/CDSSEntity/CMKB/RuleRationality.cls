/// Description：诊疗节点内容表（预警规则-合理性）
/// Table：CT.WDT.CDSS.RuleRationality
Class web.CDSSEntity.CMKB.RuleRationality Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.RuleRationality";

/// RationalityRowId
Property RationalityRowId As %String;

/// 流程图节点
Property NodeDR As %String;

/// 顺序
Property Sequence As %String;

/// 提醒内容
Property WarningContent As %String;

/// 禁忌级别（A-绝对、R-相对、M-注意事项）
Property TabooLevel As %String;

/// 备注
Property Remarks As %String;

/// 治疗方案来源（文献或者教程名称）
Property TreatSource As %String;

Property RuleBasisDR As %String;

}
