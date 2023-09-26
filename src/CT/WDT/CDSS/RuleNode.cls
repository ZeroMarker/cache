/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：诊疗流程节点表V2.0
/// Table：CT.WDT.CDSS.RuleNode
Class CT.WDT.CDSS.RuleNode Extends (%Persistent, User.Abstract)
{

/// 规则字典表指针
Property RuleDR As CT.WDT.CDSS.RuleDict [ Required ];

/// 流程图顺序号（一个界面可能有多个流程图）
Property FlowChartNum As %Integer [ Required ];

/// 节点顺序号
Property NodeNum As %Integer;

/// 节点类型（开始、结束、基本信息-年龄、基本信息-性别、诊断条件、主要条件、否定条件、推荐检验/检查、推荐评估表、推荐护理措施、推荐治疗方案、推荐治疗方案-药品、推荐治疗方案-手术）
Property NodeType As CT.WDT.CDSS.NodeType;

/// 需满足条件个数
Property MeetConditionNum As %Integer;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// left坐标
Property ChartLeft As %String;

/// top坐标
Property ChartTop As %String;

/// 图类型
Property RuleTypeDR As CT.WDT.CDSS.ChartType;

Index RuleDRIndex On RuleDR As Exact;

Index TypeIndex On NodeType As Exact;

Index RuleDRTypeIndex On (RuleDR As Exact, FlowChartNum As Exact, NodeType As Exact);

Index RuleTypeDRIndex On (RuleDR As Exact, RuleTypeDR As Exact);

/// 2021-09-06 GXP 新增
Index ChartNumIndex On (RuleDR As Exact, RuleTypeDR As Exact, FlowChartNum As Exact, NodeNum As Exact);

/// 2021-10-14 DYN 新增
Index ChartTypeIndex On (RuleDR As Exact, FlowChartNum As Exact, RuleTypeDR As Exact);

Index TypeChartIndex On (RuleDR As Exact, RuleTypeDR As Exact, FlowChartNum As Exact);

/// 2022-03-24 ZWW 新增
Index RuleChartIndex On (RuleDR As Exact, FlowChartNum As Exact);

/// 2022-04-15 ZWW 新增
Index RuleDRNodeTypeIndex On (RuleDR As Exact, NodeType As Exact);

/// 2022-05-18 LDY 新增
Index RuleTypeIndex On (RuleTypeDR As Exact, RuleDR As Exact, FlowChartNum As Exact);

/// 2022-06-09 ZWW 新增
Index NodeRuleIndex On (RuleDR As Exact, RuleTypeDR As Exact, NodeType As Exact);

/// 2022-08-11 ZWW 新增
Index RuleChartTypeIndex On (RuleDR As Exact, RuleTypeDR As Exact, FlowChartNum As Exact, NodeType As Exact);

/// 2023-04-12 DYN 新增
Index RuleTypeChartIndex On (RuleDR As Exact, RuleTypeDR As Exact, NodeType As Exact, FlowChartNum As Exact);

Storage Default
{
<Data name="RuleNodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleDR</Value>
</Value>
<Value name="3">
<Value>FlowChartNum</Value>
</Value>
<Value name="4">
<Value>NodeNum</Value>
</Value>
<Value name="5">
<Value>NodeType</Value>
</Value>
<Value name="6">
<Value>MeetConditionNum</Value>
</Value>
<Value name="7">
<Value>Remarks</Value>
</Value>
<Value name="8">
<Value>ChartLeft</Value>
</Value>
<Value name="9">
<Value>ChartTop</Value>
</Value>
<Value name="10">
<Value>RuleTypeDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.RuleNodeD</DataLocation>
<DefaultData>RuleNodeDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.RuleNodeD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.RuleNodeI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.RuleNodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
