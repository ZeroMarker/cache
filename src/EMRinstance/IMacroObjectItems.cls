/// 描述：实例数据-宏对象打散子表
/// 编写者：Candyxu
/// 编写日期：2017-12-02
Class EMRinstance.IMacroObjectItems Extends (%Persistent, %XML.Adaptor)
{

Index IdxForUpdate On (InstanceDataID, SectionCode, CompositeCode, MacroCode, Name, Property);

Index IdxForGetSection On (InstanceDataID, CompositeCode, MacroCode, SectionCode);

Index IdxForLink On (EpisodeID, TemplateID, SectionCode, CompositeCode, MacroCode, InstanceDataID, Name, Property);

Index IdxInstanceData On InstanceDataID;

Property PatientID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property ChartItemID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property SectionCode As %String(TRUNCATE = 1);

Property CompositeCode As %String(TRUNCATE = 1);

Property MacroCode As %String(TRUNCATE = 1);

Property MacroID As %String(TRUNCATE = 1);

Property Type As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property Property As %String(TRUNCATE = 1);

Property Value As %String(TRUNCATE = 1);

Storage Default
{
<Data name="IMacroObjectItemsDefaultData">
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
<Value>MacroCode</Value>
</Value>
<Value name="11">
<Value>MacroID</Value>
</Value>
<Value name="12">
<Value>Type</Value>
</Value>
<Value name="13">
<Value>Property</Value>
</Value>
<Value name="14">
<Value>Value</Value>
</Value>
<Value name="15">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.IMacroObjectItemsD</DataLocation>
<DefaultData>IMacroObjectItemsDefaultData</DefaultData>
<IdLocation>^DHCEMRI.IMacroObjectItemsD</IdLocation>
<IndexLocation>^DHCEMRI.IMacroObjectItemsI</IndexLocation>
<StreamLocation>^DHCEMRI.IMacroObjectItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
