Class EMRmeta.CTProperty Extends %Persistent
{

Index IdxParentIDCode On (ParentID, PropertyCode) [ Unique ];

Index IdxCode On PropertyCode [ Unique ];

Property PropertyCode As %String(TRUNCATE = 1);

Property PropertyName As %String(TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CTPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PropertyDesc</Value>
</Value>
<Value name="3">
<Value>PropertyName</Value>
</Value>
<Value name="4">
<Value>PropertyCode</Value>
</Value>
<Value name="5">
<Value>PropertyType</Value>
</Value>
<Value name="6">
<Value>ParentID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CTPropertyD</DataLocation>
<DefaultData>CTPropertyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.CTPropertyD</IdLocation>
<IndexLocation>^DHCEMRM.CTPropertyI</IndexLocation>
<StreamLocation>^DHCEMRM.CTPropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
