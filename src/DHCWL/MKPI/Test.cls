Class DHCWL.MKPI.Test Extends %Persistent
{

Property Name As %String;

Property Describes As %String;

Index NameI On Name As AlphaUp;

Storage Default
{
<Data name="TestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Describes</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.TestD</DataLocation>
<DefaultData>TestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.TestD</IdLocation>
<IndexLocation>^DHCWL.MKPI.TestI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.TestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
