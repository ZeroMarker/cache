Class DWR.MSG.PacsView Extends (%Persistent, %XML.Adaptor)
{

Property localAETitle As %String;

Property localPort As %String;

Property localSyntax As %String;

Property serverDesc As %String;

Property serverAETitle As %String;

Property serverAddress As %String;

Property serverPort As %String;

Property serverRetrieve As %String;

Property serverTLS As %String;

Property serverSyntax As %String;

Property patId As %String;

Property accNum As %String;

Storage Default
{
<Data name="PacsViewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>localAETitle</Value>
</Value>
<Value name="3">
<Value>localPort</Value>
</Value>
<Value name="4">
<Value>localSyntax</Value>
</Value>
<Value name="5">
<Value>serverDesc</Value>
</Value>
<Value name="6">
<Value>serverAETitle</Value>
</Value>
<Value name="7">
<Value>serverAddress</Value>
</Value>
<Value name="8">
<Value>serverPort</Value>
</Value>
<Value name="9">
<Value>serverRetrieve</Value>
</Value>
<Value name="10">
<Value>serverTLS</Value>
</Value>
<Value name="11">
<Value>serverSyntax</Value>
</Value>
<Value name="12">
<Value>patId</Value>
</Value>
<Value name="13">
<Value>accNum</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.PacsViewD</DataLocation>
<DefaultData>PacsViewDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.PacsViewD</IdLocation>
<IndexLocation>^DWR.MSG.PacsViewI</IndexLocation>
<StreamLocation>^DWR.MSG.PacsViewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
