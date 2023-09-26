/// Desc:查询角色表
/// Creator:Candy
Class DHCEPRFS.META.QueryRole Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

/// 角色名称
Property RoleName As %String(TRUNCATE = 1);

/// 角色描述
Property RoleDesc As %String(TRUNCATE = 1);

/// 父角色
Property ParentID As %String(TRUNCATE = 1);

Index IdxRoleName On RoleName [ Unique ];

Storage Default
{
<Data name="QueryRoleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleDesc</Value>
</Value>
<Value name="3">
<Value>RoleName</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QueryRoleD</DataLocation>
<DefaultData>QueryRoleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.QueryRoleD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QueryRoleI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QueryRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
