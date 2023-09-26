Class DHCEPRRBAC.META.RoleMapping Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property RoleID As %String(TRUNCATE = 1);

Property FunctionCode As %String(TRUNCATE = 1);

Property FunctionDesc As %String(TRUNCATE = 1);

Property IsActive As %String(TRUNCATE = 1);

Index IdxMain On (FunctionCode, RoleID) [ Unique ];

Storage Default
{
<Data name="RoleMappingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleID</Value>
</Value>
<Value name="3">
<Value>FunctionCode</Value>
</Value>
<Value name="4">
<Value>FunctionDesc</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.META.RoleMappingD</DataLocation>
<DefaultData>RoleMappingDefaultData</DefaultData>
<IdLocation>^DHCEPRRBAC.META.RoleMappingD</IdLocation>
<IndexLocation>^DHCEPRRBAC.META.RoleMappingI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.META.RoleMappingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
