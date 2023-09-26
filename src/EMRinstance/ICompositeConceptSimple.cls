/// 名称:EMRinstance.ICompositeConceptSimple
/// 描述:实例数据-医学元素简单单元打散表
/// 编写者：Candyxu
/// 编写日期: 2015-08-07
Class EMRinstance.ICompositeConceptSimple Extends (%Persistent, %XML.Adaptor)
{

Index IdxForUpdate On (InstanceDataID, SectionCode, CompositeCode, ConceptCode, SimpleItemCode) [ Unique ];

Index IdxForGetSection On (InstanceDataID, CompositeCode, ConceptCode, SimpleItemCode, SectionCode) [ Unique ];

Index IdxForLink On (EpisodeID, TemplateID, SectionCode, CompositeCode, ConceptCode, SimpleItemCode, InstanceDataID) [ Unique ];

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

Property ConceptCode As %String(TRUNCATE = 1);

Property SimpleItemCode As %String(TRUNCATE = 1);

Property ValueCode As %String(MAXLEN = 500, TRUNCATE = 1);

Property DataValue As %String(MAXLEN = 32000, TRUNCATE = 1);

Property DataRef As %String(MAXLEN = 100, TRUNCATE = 1);

Property Separator As %String(MAXLEN = 100, TRUNCATE = 1);

Property Type As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="ICompositeConceptSimpleDefaultData">
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
<Value>ConceptCode</Value>
</Value>
<Value name="14">
<Value>SimpleItemCode</Value>
</Value>
<Value name="15">
<Value>ValueCode</Value>
</Value>
<Value name="16">
<Value>DataValue</Value>
</Value>
<Value name="17">
<Value>DataRef</Value>
</Value>
<Value name="18">
<Value>Separator</Value>
</Value>
<Value name="19">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.IConceptSimpleD</DataLocation>
<DefaultData>ICompositeConceptSimpleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.IConceptSimpleD</IdLocation>
<IndexLocation>^DHCEMRI.IConceptSimpleI</IndexLocation>
<StreamLocation>^DHCEMRI.IConceptSimpleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
