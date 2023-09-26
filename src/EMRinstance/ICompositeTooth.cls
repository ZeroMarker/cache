/// Desc：实例数据-牙位图打散表
/// Creator:    niucaicai
/// CreateDate: 2020-07-10
Class EMRinstance.ICompositeTooth Extends (%Persistent, %XML.Adaptor)
{

Index IdxForUpdate On (InstanceDataID, SectionCode, CompositeCode, ToothImageCode) [ Unique ];

Index IdxForDelete On (InstanceDataID, ToothImageCode);

Property PatientID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property ChartItemID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property SectionCode As %String(TRUNCATE = 1);

Property CompositeCode As %String(TRUNCATE = 1);

Property ToothImageCode As %String(TRUNCATE = 1);

Property SourceCode As %String(TRUNCATE = 1);

Property SourceCCode As %String(TRUNCATE = 1);

Property KBNodeID As %String(TRUNCATE = 1);

Property DisplayName As %String(TRUNCATE = 1);

Property Text As %String(TRUNCATE = 1);

Property ShowMode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ICompositeToothDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>ChartItemID</Value>
</Value>
<Value name="5">
<Value>InstanceDataID</Value>
</Value>
<Value name="6">
<Value>TemplateID</Value>
</Value>
<Value name="7">
<Value>TemplateVersion</Value>
</Value>
<Value name="8">
<Value>SectionCode</Value>
</Value>
<Value name="9">
<Value>CompositeCode</Value>
</Value>
<Value name="10">
<Value>ToothImageCode</Value>
</Value>
<Value name="11">
<Value>SourceCode</Value>
</Value>
<Value name="12">
<Value>SourceCCode</Value>
</Value>
<Value name="13">
<Value>KBNodeID</Value>
</Value>
<Value name="14">
<Value>DisplayName</Value>
</Value>
<Value name="15">
<Value>Text</Value>
</Value>
<Value name="16">
<Value>ShowMode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.ICompositeToothD</DataLocation>
<DefaultData>ICompositeToothDefaultData</DefaultData>
<IdLocation>^DHCEMRI.ICompositeToothD</IdLocation>
<IndexLocation>^DHCEMRI.ICompositeToothI</IndexLocation>
<StreamLocation>^DHCEMRI.ICompositeToothS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
