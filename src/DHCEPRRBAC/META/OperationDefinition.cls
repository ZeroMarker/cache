Class DHCEPRRBAC.META.OperationDefinition Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property OpName As %String(TRUNCATE = 1);

Property OpCode As %String(TRUNCATE = 1);

Property OpDesc As %String(TRUNCATE = 1);

Property OpActive As %String(TRUNCATE = 1);

Property DefaultOp As %String(TRUNCATE = 1);

Index IdxMain On OpCode [ Unique ];

Index IdxDefaultOp On DefaultOp;

Storage Default
{
<Data name="OperationDefinitionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OpName</Value>
</Value>
<Value name="3">
<Value>OpCode</Value>
</Value>
<Value name="4">
<Value>OpDesc</Value>
</Value>
<Value name="5">
<Value>OpActive</Value>
</Value>
<Value name="6">
<Value>DefaultOp</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.META.OperDFD</DataLocation>
<DefaultData>OperationDefinitionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.META.OperDFD</IdLocation>
<IndexLocation>^DHCEPRRBAC.META.OperDFI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.META.OperDFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
