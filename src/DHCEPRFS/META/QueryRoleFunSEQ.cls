/// Desc:权限角色
/// Creator:Candy
Class DHCEPRFS.META.QueryRoleFunSEQ Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

/// 角色ID
Property RoleID As %String(TRUNCATE = 1);

/// 所有（包含父角色）权限ID
Property AllFuncID As %String(MAXLEN = 15000, TRUNCATE = 1);

Index IdxRoleID On RoleID [ Unique ];

Storage Default
{
<Data name="QueryRoleFunSEQDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleID</Value>
</Value>
<Value name="3">
<Value>AllFuncID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QueryRoleFunSEQD</DataLocation>
<DefaultData>QueryRoleFunSEQDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.QueryRoleFunSEQD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QueryRoleFunSEQI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QueryRoleFunSEQS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
