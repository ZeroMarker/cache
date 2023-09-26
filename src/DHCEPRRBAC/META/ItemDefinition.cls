Class DHCEPRRBAC.META.ItemDefinition Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxItemCode On ItemCode;

Property ItemName As %String(TRUNCATE = 1);

Property ItemCode As %String(TRUNCATE = 1);

Property ItemDesc As %String(TRUNCATE = 1);

Property ItemType As %String(TRUNCATE = 1);

Property ItemActive As %String(TRUNCATE = 1);

Index IdxMain On (ItemType, ItemCode) [ Unique ];

Storage Default
{
<Data name="ItemDefinitionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemName</Value>
</Value>
<Value name="3">
<Value>ItemCode</Value>
</Value>
<Value name="4">
<Value>ItemDesc</Value>
</Value>
<Value name="5">
<Value>ItemType</Value>
</Value>
<Value name="6">
<Value>ItemActive</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.META.ItemDFD</DataLocation>
<DefaultData>ItemDefinitionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.META.ItemDFD</IdLocation>
<IndexLocation>^DHCEPRRBAC.META.ItemDFI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.META.ItemDFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
