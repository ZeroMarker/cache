/// Description：识别词流程节点表
/// Table：CT.WDT.CDSS.WordsNode
Class web.CDSSEntity.CMKB.WordsNode Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.WordsNode";

/// NodeRowId
Property NodeRowId As %String;

/// 识别词字典表指针
Property WordsDR As %String;

/// 流程图顺序号（一个界面可能有多个流程图）
Property FlowChartNum As %String;

/// 节点顺序号
Property NodeNum As %String;

/// 节点类型（开始、结束、基本信息-年龄、基本信息-性别、诊断条件、主要条件、否定条件、推荐检验/检查、推荐评估表、推荐护理措施、推荐治疗方案、推荐治疗方案-药品、推荐治疗方案-手术）
Property NodeType As %String;

/// 需满足条件个数
Property MeetConditionNum As %String;

/// 备注
Property Remarks As %String;

/// left坐标
Property ChartLeft As %String;

/// top坐标
Property ChartTop As %String;

}
