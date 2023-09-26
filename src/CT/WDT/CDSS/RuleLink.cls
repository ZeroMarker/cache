/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：诊疗流程线表V2.0
/// Table：CT.WDT.CDSS.RuleLink
Class CT.WDT.CDSS.RuleLink Extends (%Persistent, User.Abstract)
{

/// 规则字典表指针
Property RuleDR As CT.WDT.CDSS.RuleDict [ Required ];

/// 流程图顺序号（一个界面可能有多个流程图）
Property FlowChartNum As %Integer [ Required ];

/// 流程图上一个节点
Property PreNode As CT.WDT.CDSS.RuleNode [ Required ];

/// 流程图下一个节点
Property NextNode As CT.WDT.CDSS.RuleNode;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 图类型
Property RuleTypeDR As CT.WDT.CDSS.ChartType;

Index RuleDRIndex On RuleDR;

Index PreNodeIndex On PreNode;

Index NextNodeIndex On NextNode;

Index RuleTypeDRIndex On (RuleDR As Exact, RuleTypeDR As Exact);

/// 2022-03-21 ZWW 新增
Index TypeChartIndex On (RuleDR As Exact, RuleTypeDR As Exact, FlowChartNum As Exact);

/// 2022-06-09 ZWW 新增
Index PreRuleTypeIndex On (RuleDR As Exact, RuleTypeDR As Exact, PreNode As Exact);

/// 2022-06-15 ZWW 新增
Index RulePreNodeIndex On (RuleDR As Exact, PreNode As Exact);

/// 2022-06-15 ZWW 新增
Index RuleNextNodeIndex On (RuleDR As Exact, NextNode As Exact);

Storage Default
{
<Data name="RuleLinkDefaultData">
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
<Value>PreNode</Value>
</Value>
<Value name="5">
<Value>NextNode</Value>
</Value>
<Value name="6">
<Value>Remarks</Value>
</Value>
<Value name="7">
<Value>RuleTypeDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.RuleLinkD</DataLocation>
<DefaultData>RuleLinkDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.RuleLinkD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.RuleLinkI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.RuleLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
