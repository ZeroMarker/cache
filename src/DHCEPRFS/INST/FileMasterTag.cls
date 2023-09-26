Class DHCEPRFS.INST.FileMasterTag Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property FileMasterID As %Integer [ Required ];

Property Tag As %String(TRUNCATE = 1) [ Required ];

Index IdxTag On (Tag, FileMasterID);

Storage Default
{
<Data name="FileTagDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FileMasterID</Value>
</Value>
<Value name="3">
<Value>Tag</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.FileMasterTagD</DataLocation>
<DefaultData>FileTagDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.FileMasterTagD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.FileMasterTagI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.FileMasterTagS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
