Class DHCEPRFS.META.FilterQueryItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property ItemID As %String(TRUNCATE = 1);

Property ItemName As %String(TRUNCATE = 1);

Property ItemGroupID As %String(TRUNCATE = 1);

Property ItemGroupName As %String(TRUNCATE = 1);

Index IdxItemGroupID On ItemGroupID;

Index IdxItemID On ItemID;

Storage Default
{
<Data name="FilterQueryItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemName</Value>
</Value>
<Value name="3">
<Value>ItemGroup</Value>
</Value>
<Value name="4">
<Value>ItemID</Value>
</Value>
<Value name="5">
<Value>ItemGroupID</Value>
</Value>
<Value name="6">
<Value>ItemGroupName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.FilterQueryItemD</DataLocation>
<DefaultData>FilterQueryItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.FilterQueryItemD</IdLocation>
<IndexLocation>^DHCEPRFS.META.FilterQueryItemI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.FilterQueryItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
