Class User.DHCIFWorkItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Work_Code
Property WorkCode As %String(TRUNCATE = 1);

/// Work_Desc
Property WorkDesc As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCIFWorkItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkCode</Value>
</Value>
<Value name="3">
<Value>WorkDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCIFWorkItemD</DataLocation>
<DefaultData>DHCIFWorkItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCIFWorkItemD</IdLocation>
<IndexLocation>^User.DHCIFWorkItemI</IndexLocation>
<StreamLocation>^User.DHCIFWorkItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
