Class EPRmeta.GlossaryTemplateItemGroup Extends %Persistent
{

Property TemplateID As %String;

Property TemplateName As %String;

Property TemValue As %String;

Property TemDesc As %String;

Property Name As %String;

Property Sequence As %Integer;

Property GroupCode As %String;

Property Type As %String;

Index IdxGroupCodeSeq On (GroupCode, Sequence);

Storage Default
{
<Data name="GloTemplateItmGrpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateID</Value>
</Value>
<Value name="3">
<Value>TemplateName</Value>
</Value>
<Value name="4">
<Value>TemValue</Value>
</Value>
<Value name="5">
<Value>TemDesc</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>GroupCode</Value>
</Value>
<Value name="9">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.GloTemplateItmGrpD</DataLocation>
<DefaultData>GloTemplateItmGrpDefaultData</DefaultData>
<IdLocation>^DHCEPRM.GloTemplateItmGrpD</IdLocation>
<IndexLocation>^DHCEPRM.GloTemplateItmGrpI</IndexLocation>
<StreamLocation>^DHCEPRM.GloTemplateItmGrpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
