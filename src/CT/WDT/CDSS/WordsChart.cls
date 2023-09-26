/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：识别词流程图Json信息表V2.0 （用于还原流程图）
/// Table：CT.WDT.CDSS.WordsChart
Class CT.WDT.CDSS.WordsChart Extends (%Persistent, User.Abstract)
{

/// 识别词字典表指针
Property WordsDR As CT.WDT.CDSS.IdentifyWords [ Required ];

/// 流程图Json信息
Property FlowChartJson As %GlobalCharacterStream;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index WordsDRIndex On WordsDR As Exact;

Storage Default
{
<Data name="WordsChartDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WordsDR</Value>
</Value>
<Value name="3">
<Value>FlowChartJson</Value>
</Value>
<Value name="4">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.WordsChartD</DataLocation>
<DefaultData>WordsChartDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.WordsChartD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.WordsChartI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.WordsChartS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
