/// Description：识别词流程图Json信息表
/// Table：CT.WDT.CDSS.WordsChart
Class web.CDSSEntity.CMKB.WordsChart Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.WordsChart";

/// ChartRowId
Property ChartRowId As %String;

/// 规则字典表指针
Property WordsDR As %String;

/// 流程图顺序号（一个界面可能有多个流程图）
Property FlowChartJson As web.BDP.sys.String;

/// 备注
Property Remarks As %String;

}
