/// 名称:EMRinstance.ICompositeSample
/// 描述:实例数据-简单单元打散表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRinstance.ICompositeSample Extends %Persistent
{

Index IdxForUpdate On (InstanceDataID, SectionCode, CompositeCode, KBNodeID, SimpleItemCode) [ Unique ];

Index IdxForLink On (EpisodeID, TemplateID, SectionCode, CompositeCode, KBNodeID, SimpleItemCode, InstanceDataID) [ Unique ];

Property BindKBCode As %String(TRUNCATE = 1);

Property ChartItemID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property KBNodeID As %String(TRUNCATE = 1);

Property ListNo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property SectionCode As %String(TRUNCATE = 1);

Property CompositeCode As %String(TRUNCATE = 1);

Property SimpleItemCode As %String(TRUNCATE = 1);

Property ValueCode As %String(MAXLEN = 500, TRUNCATE = 1);

Property DataValue As %String(MAXLEN = 32000, TRUNCATE = 1);

Storage Default
{
<Data name="ICompositeSampleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BindKBCode</Value>
</Value>
<Value name="3">
<Value>ChartItemID</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>InstanceDataID</Value>
</Value>
<Value name="6">
<Value>KBNodeID</Value>
</Value>
<Value name="7">
<Value>ListNo</Value>
</Value>
<Value name="8">
<Value>PatientID</Value>
</Value>
<Value name="9">
<Value>TemplateID</Value>
</Value>
<Value name="10">
<Value>TemplateVersion</Value>
</Value>
<Value name="11">
<Value>SectionCode</Value>
</Value>
<Value name="12">
<Value>CompositeCode</Value>
</Value>
<Value name="13">
<Value>SimpleItemCode</Value>
</Value>
<Value name="14">
<Value>ValueCode</Value>
</Value>
<Value name="15">
<Value>DataValue</Value>
</Value>
</Data>
<DataLocation>^EMRinstance.ICompositeSampleD</DataLocation>
<DefaultData>ICompositeSampleDefaultData</DefaultData>
<IdLocation>^EMRinstance.ICompositeSampleD</IdLocation>
<IndexLocation>^EMRinstance.ICompositeSampleI</IndexLocation>
<StreamLocation>^EMRinstance.ICompositeSampleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
