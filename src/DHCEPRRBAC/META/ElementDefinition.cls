Class DHCEPRRBAC.META.ElementDefinition Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxElementCode On ElementCode;

Property ElementName As %String(TRUNCATE = 1);

Property ElementCode As %String(TRUNCATE = 1);

Property ElementCodeType As %String(TRUNCATE = 1);

Property ElementDesc As %String(TRUNCATE = 1);

Property ElementType As %String(TRUNCATE = 1);

Property ElementActive As %String(TRUNCATE = 1);

Index IdxMain On (ElementType, ElementCodeType, ElementCode) [ Unique ];

Storage Default
{
<Data name="ElementDefinitionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ElementName</Value>
</Value>
<Value name="3">
<Value>ElementCode</Value>
</Value>
<Value name="4">
<Value>ElementDesc</Value>
</Value>
<Value name="5">
<Value>ElementType</Value>
</Value>
<Value name="6">
<Value>ElementLevel</Value>
</Value>
<Value name="7">
<Value>ElementActive</Value>
</Value>
<Value name="8">
<Value>ElementCodeType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.META.ElementDFD</DataLocation>
<DefaultData>ElementDefinitionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.META.ElementDFD</IdLocation>
<IndexLocation>^DHCEPRRBAC.META.ElementDFI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.META.ElementDFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
