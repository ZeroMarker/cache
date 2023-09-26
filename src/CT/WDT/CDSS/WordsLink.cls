/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：识别词流程线表V2.0
/// Table：CT.WDT.CDSS.WordsLink
Class CT.WDT.CDSS.WordsLink Extends (%Persistent, User.Abstract)
{

/// 识别词字典表指针
Property WordsDR As CT.WDT.CDSS.IdentifyWords [ Required ];

/// 流程图顺序号（一个界面可能有多个流程图）
Property FlowChartNum As %Integer [ Required ];

/// 流程图上一个节点
Property PreNode As CT.WDT.CDSS.WordsNode [ Required ];

/// 流程图下一个节点
Property NextNode As CT.WDT.CDSS.WordsNode;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index WordsDRIndex On WordsDR As Exact;

Index PreNodeIndex On PreNode;

Index NextNodeIndex On NextNode;

/// 2021-09-06 GXP 新增
Index UniqueIndex On (WordsDR As Exact, FlowChartNum As Exact, PreNode As Exact, NextNode As Exact);

/// 2022-03-16 ZWW 新增
Index WordsFlowIndex On (WordsDR As Exact, FlowChartNum As Exact);

/// 2022-08-10 ZWW 新增
Index WordsPreNodeIndex On (WordsDR As Exact, PreNode As Exact);

Storage Default
{
<Data name="WordsLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WordsDR</Value>
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
</Data>
<DataLocation>^CT.WDT.CDSS.WordsLinkD</DataLocation>
<DefaultData>WordsLinkDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.WordsLinkD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.WordsLinkI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.WordsLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
