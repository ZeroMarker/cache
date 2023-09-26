Class EMRinstance.TextCollector Extends %Persistent
{

Property usrID As %String;

Property content As %String(MAXLEN = 9999);

Property summary As %String;

Property category As %String;

Index IdxUsrID On usrID;

Storage Default
{
<Data name="TextCollectorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>usrID</Value>
</Value>
<Value name="3">
<Value>content</Value>
</Value>
<Value name="4">
<Value>summary</Value>
</Value>
<Value name="5">
<Value>category</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.TextCollectorD</DataLocation>
<DefaultData>TextCollectorDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.TextCollectorD</IdLocation>
<IndexLocation>^DHCEMRI.TextCollectorI</IndexLocation>
<StreamLocation>^DHCEMRI.TextCollectorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
