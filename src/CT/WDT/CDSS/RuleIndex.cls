/// Creator:丁亚男
/// CreatDate:2021-08-12
/// Description：规则识别词索引表
/// Table：CT.WDT.CDSS.RuleIndex
Class CT.WDT.CDSS.RuleIndex Extends (%Persistent, User.Abstract)
{

/// 规则id
Property RuleDR As CT.WDT.CDSS.RuleDict [ Required ];

/// 识别词id
Property IdentifyWordsDR As CT.WDT.CDSS.IdentifyWords [ Required ];

/// 图类型
Property RuleTypeDR As CT.WDT.CDSS.ChartType;

/// 流程图顺序号（一个界面可能有多个流程图）
Property FlowChartNum As %Integer [ Required ];

/// 图类型
Property RealRuleTypeDR As CT.WDT.CDSS.ChartType;

Index RuleDRIndex On RuleDR;

Index IWDRIndex On IdentifyWordsDR;

Index RuleIWDRIndex On (RuleDR, IdentifyWordsDR);

Index IWRuleDRIndex On (IdentifyWordsDR, RuleDR);

Index IRTypeFlowIndex On (IdentifyWordsDR, RuleDR, RuleTypeDR As Exact, FlowChartNum);

Index RuleTypeFlowIndex On (RuleDR, RuleTypeDR, FlowChartNum, IdentifyWordsDR);

Index RealRuleTypeFlowIndex On (RuleDR, RealRuleTypeDR, FlowChartNum, IdentifyWordsDR);

Index RealTypeIndex On (IdentifyWordsDR, RealRuleTypeDR, FlowChartNum, RuleDR);

Storage Default
{
<Data name="RuleIndexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleDR</Value>
</Value>
<Value name="3">
<Value>IdentifyWordsDR</Value>
</Value>
<Value name="4">
<Value>RuleTypeDR</Value>
</Value>
<Value name="5">
<Value>FlowChartNum</Value>
</Value>
<Value name="6">
<Value>RealRuleTypeDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.RuleIndexD</DataLocation>
<DefaultData>RuleIndexDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.RuleIndexD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.RuleIndexI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.RuleIndexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
