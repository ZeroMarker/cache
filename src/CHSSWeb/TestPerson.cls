Class CHSSWeb.TestPerson Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Property Name As %String(TRUNCATE = 1);

Property Memo As %GlobalCharacterStream(LOCATION = "^CHSSWeb.TestPerson.Image");

Property Picture As %FileBinaryStream(LOCATION = "f:\stream");

Property ddd As %GlobalBinaryStream;

Storage Default
{
<Data name="TestPersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Memo</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Picture</Value>
</Value>
<Value name="5">
<Value>ddd</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.TestPersonD</DataLocation>
<DefaultData>TestPersonDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.TestPersonD</IdLocation>
<IndexLocation>^CHSSWeb.TestPersonI</IndexLocation>
<StreamLocation>^CHSSWeb.TestPersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
