Class DHCEPRRBAC.META.RoleDefinition Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property RoleName As %String(TRUNCATE = 1);

Property RoleCode As %String(TRUNCATE = 1);

Property RoleDesc As %String(TRUNCATE = 1);

Property RoleActive As %String(TRUNCATE = 1);

Property DefaultRole As %String(TRUNCATE = 1);

Property RoleType As %String(TRUNCATE = 1);

Index IdxMain On RoleCode [ Unique ];

Index IdxDefaultRole On (RoleType, DefaultRole);

Storage Default
{
<Data name="RoleDefinitionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleName</Value>
</Value>
<Value name="3">
<Value>RoleCode</Value>
</Value>
<Value name="4">
<Value>RoleDesc</Value>
</Value>
<Value name="5">
<Value>RoleActive</Value>
</Value>
<Value name="6">
<Value>DefaultRole</Value>
</Value>
<Value name="7">
<Value>RoleType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.META.RoleDFD</DataLocation>
<DefaultData>RoleDefinitionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.META.RoleDFD</IdLocation>
<IndexLocation>^DHCEPRRBAC.META.RoleDFI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.META.RoleDFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
