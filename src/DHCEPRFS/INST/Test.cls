Class DHCEPRFS.INST.Test Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Test As %String(TRUNCATE = 1);

Storage Default
{
<Data name="TestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Test</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.TestD</DataLocation>
<DefaultData>TestDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.TestD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.TestI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.TestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
