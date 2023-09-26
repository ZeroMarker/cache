Class EMRmeta.CategoryType Extends %Persistent
{

Property TypeDescription As %String(TRUNCATE = 1);

Property TypeName As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CategoryTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypeDescription</Value>
</Value>
<Value name="3">
<Value>TypeName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CategoryTypeD</DataLocation>
<DefaultData>CategoryTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.CategoryTypeD</IdLocation>
<IndexLocation>^DHCEMRM.CategoryTypeI</IndexLocation>
<StreamLocation>^DHCEMRM.CategoryTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
