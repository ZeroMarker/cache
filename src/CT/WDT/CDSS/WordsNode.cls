/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：识别词流程节点表V2.0
/// Table：CT.WDT.CDSS.WordsNode
Class CT.WDT.CDSS.WordsNode Extends (%Persistent, User.Abstract)
{

/// 识别词字典表指针
Property WordsDR As CT.WDT.CDSS.IdentifyWords [ Required ];

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

Index WordsDRIndex On WordsDR As Exact;

Index WordsDRTypeIndex On (WordsDR As Exact, FlowChartNum As Exact, NodeType As Exact);

/// 2021-09-06 GXP 新增
Index ChartNumIndex On (WordsDR As Exact, FlowChartNum As Exact, NodeNum As Exact);

/// 2022-03-23 ZWW 新增
Index WordsTypeIndex On (WordsDR As Exact, NodeType As Exact);

/// 2022-03-23 ZWW 新增
Index WordsChartIndex On (WordsDR As Exact, FlowChartNum As Exact);

Storage Default
{
<Data name="WordsNodeDefaultData">
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
</Data>
<DataLocation>^CT.WDT.CDSS.WordsNodeD</DataLocation>
<DefaultData>WordsNodeDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.WordsNodeD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.WordsNodeI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.WordsNodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
