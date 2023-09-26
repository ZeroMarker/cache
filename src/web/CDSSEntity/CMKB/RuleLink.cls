/// Description：诊疗流程线表
/// Table：CT.WDT.CDSS.RuleNode
Class web.CDSSEntity.CMKB.RuleLink Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.RuleLink";

/// LinkRowId
Property LinkRowId As %String;

/// 规则字典表指针
Property RuleDR As %String;

/// 流程图顺序号（一个界面可能有多个流程图）
Property FlowChartNum As %String;

/// 流程图上一个节点
Property PreNode As %String;

/// 流程图下一个节点
Property NextNode As %String;

/// 备注
Property Remarks As %String;

/// 图类型
Property RuleTypeDR As %String;

}
