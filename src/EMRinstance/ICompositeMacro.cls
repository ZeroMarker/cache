/// 描述：实例数据-宏对象打散表
/// 编写者：Candyxu
/// 编写日期：2017-12-02
Class EMRinstance.ICompositeMacro Extends (%Persistent, %XML.Adaptor)
{

Index IdxForUpdate On (InstanceDataID, SectionCode, CompositeCode, MacroCode) [ Unique ];

Index IdxForGetSection On (InstanceDataID, CompositeCode, MacroCode, SectionCode) [ Unique ];

Index IdxForLink On (EpisodeID, TemplateID, SectionCode, CompositeCode, MacroCode, InstanceDataID) [ Unique ];

Property PatientID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property ChartItemID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property SectionCode As %String(TRUNCATE = 1);

Property CompositeCode As %String(TRUNCATE = 1);

Property MacroCode As %String(TRUNCATE = 1);

Property DisplayName As %String(TRUNCATE = 1);

Property Text As %GlobalCharacterStream(LOCATION = "^DHCEMRI.ICompositeMacroS");

Property StyleText As %GlobalCharacterStream(LOCATION = "^DHCEMRI.ICompositeMacroS");

Storage Default
{
<Data name="ICompositeMacroDefaultData">
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
<Value>DisplayName</Value>
</Value>
<Value name="12">
<Value>Text</Value>
</Value>
<Value name="13">
<Value>StyleText</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.ICompositeMacroD</DataLocation>
<DefaultData>ICompositeMacroDefaultData</DefaultData>
<IdLocation>^DHCEMRI.ICompositeMacroD</IdLocation>
<IndexLocation>^DHCEMRI.ICompositeMacroI</IndexLocation>
<StreamLocation>^DHCEMRI.ICompositeMacroS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
