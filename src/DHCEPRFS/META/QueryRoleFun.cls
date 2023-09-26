/// Desc:权限角色
/// Creator:Candy
Class DHCEPRFS.META.QueryRoleFun Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

/// 角色ID
Property RoleID As %String(TRUNCATE = 1);

/// 权限ID
Property FuncID As %String(MAXLEN = 15000, TRUNCATE = 1);

Index IdxRoleID On RoleID [ Unique ];

Storage Default
{
<Data name="QueryRoleFunDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FuncID</Value>
</Value>
<Value name="3">
<Value>RoleID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QueryRoleFunD</DataLocation>
<DefaultData>QueryRoleFunDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.QueryRoleFunD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QueryRoleFunI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QueryRoleFunS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
