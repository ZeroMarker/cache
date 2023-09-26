Class DHCEPRRBAC.META.PrivateDomainDefinition Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property RPDName As %String(TRUNCATE = 1);

Property RPDCode As %String(TRUNCATE = 1);

Property RPDDesc As %String(TRUNCATE = 1);

Property RPDLevel As %String(TRUNCATE = 1);

Property RPDActive As %String(TRUNCATE = 1);

Property RPDType As %String(TRUNCATE = 1);

Index IdxMain On RPDLevel [ Unique ];

Storage Default
{
<Data name="PrivateDomainDefinitionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RPDName</Value>
</Value>
<Value name="3">
<Value>RPDCode</Value>
</Value>
<Value name="4">
<Value>RPDDesc</Value>
</Value>
<Value name="5">
<Value>RPDLevel</Value>
</Value>
<Value name="6">
<Value>RPDActive</Value>
</Value>
<Value name="7">
<Value>RPDType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.META.PrivDDFD</DataLocation>
<DefaultData>PrivateDomainDefinitionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.META.PrivDDFD</IdLocation>
<IndexLocation>^DHCEPRRBAC.META.PrivDDFI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.META.PrivDDFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
