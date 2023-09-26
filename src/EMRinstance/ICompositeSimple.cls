/// 名称:EMRinstance.ICompositeSimple
/// 描述:实例数据-简单单元打散表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
/// 修改者：Candyxu 2014-7-1 
Class EMRinstance.ICompositeSimple Extends (%Persistent, %XML.Adaptor)
{

Index IdxForUpdate On (InstanceDataID, SectionCode, CompositeCode, SimpleItemCode) [ Unique ];

Index IdxForGetSection On (InstanceDataID, CompositeCode, SimpleItemCode, SectionCode) [ Unique ];

Index IdxForLink On (EpisodeID, TemplateID, SectionCode, CompositeCode, SimpleItemCode, InstanceDataID) [ Unique ];

Index IdxForKBNode On (EpisodeID, TemplateID, KBNodeID, SectionCode, CompositeCode, SimpleItemCode, InstanceDataID);

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

Property DataRef As %String(MAXLEN = 100, TRUNCATE = 1);

Property Separator As %String(MAXLEN = 100, TRUNCATE = 1);

Property Type As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="ICompositeSimpleDefaultData">
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
<Value name="16">
<Value>DataRef</Value>
</Value>
<Value name="17">
<Value>Separator</Value>
</Value>
<Value name="18">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.ICompositeSimpleD</DataLocation>
<DefaultData>ICompositeSimpleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.ICompositeSimpleD</IdLocation>
<IndexLocation>^DHCEMRI.ICompositeSimpleI</IndexLocation>
<StreamLocation>^DHCEMRI.ICompositeSimpleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
