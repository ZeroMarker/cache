/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：诊疗流程图Json信息表V2.0 （用于还原流程图）
/// Table：CT.WDT.CDSS.RuleChart
Class CT.WDT.CDSS.RuleChart Extends (%Persistent, User.Abstract)
{

/// 规则字典表指针
Property RuleDR As CT.WDT.CDSS.RuleDict [ Required ];

/// 流程图Json信息
Property FlowChartJson As %GlobalCharacterStream;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 图类型
Property RuleTypeDR As CT.WDT.CDSS.ChartType;

Index RuleDRIndex On RuleDR As Exact;

Index RuleTypeDRIndex On (RuleDR As Exact, RuleTypeDR As Exact);

Storage Default
{
<Data name="RuleChartDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleDR</Value>
</Value>
<Value name="3">
<Value>FlowChartJson</Value>
</Value>
<Value name="4">
<Value>Remarks</Value>
</Value>
<Value name="5">
<Value>RuleTypeDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.RuleChartD</DataLocation>
<DefaultData>RuleChartDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.RuleChartD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.RuleChartI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.RuleChartS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
