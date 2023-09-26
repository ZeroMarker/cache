/// Description：诊疗流程图Json信息表
/// Table：CT.WDT.CDSS.RuleChart
Class web.CDSSEntity.CMKB.RuleChart Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.RuleChart";

/// ChartRowId
Property ChartRowId As %String;

/// 规则字典表指针
Property RuleDR As %String;

/// 流程图顺序号（一个界面可能有多个流程图）
Property FlowChartJson As web.BDP.sys.String;

/// 备注
Property Remarks As %String;

/// 图类型
Property RuleTypeDR As %String;

}
