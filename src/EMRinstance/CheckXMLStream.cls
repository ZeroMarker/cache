/// Desc:检查流问题
Class EMRinstance.CheckXMLStream Extends %Persistent
{

Property InstanceID As %String(TRUNCATE = 1);

Property CheckXMLStream As %GlobalBinaryStream(LOCATION = "^DHCEMRI.CheckXMLStreamS");

Storage Default
{
<Data name="CheckXMLStreamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceID</Value>
</Value>
<Value name="3">
<Value>CheckXMLStream</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.CheckXMLStreamD</DataLocation>
<DefaultData>CheckXMLStreamDefaultData</DefaultData>
<IdLocation>^DHCEMRI.CheckXMLStreamD</IdLocation>
<IndexLocation>^DHCEMRI.CheckXMLStreamI</IndexLocation>
<StreamLocation>^DHCEMRI.CheckXMLStreamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
