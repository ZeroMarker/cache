Class CHSSWeb.HISInterface.PersonHealthRecordInfo Extends %Persistent
{

Property Info As %String;

Storage Default
{
<Data name="PersonHealthRecordInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Info</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonHealth8B8D</DataLocation>
<DefaultData>PersonHealthRecordInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonHealth8B8D</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonHealth8B8I</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonHealth8B8S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
