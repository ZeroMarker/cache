/// Desc:角色表
/// Createdate:2013-7-19
Class DHCEPRFS.META.UserRole Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxRoleName On RoleName [ Unique ];

/// 角色名称
Property RoleName As %String(TRUNCATE = 1);

/// 角色描述
Property RoleDesc As %String(TRUNCATE = 1);

Storage Default
{
<Data name="UserRoleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleDesc</Value>
</Value>
<Value name="3">
<Value>RoleName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.UserRoleD</DataLocation>
<DefaultData>UserRoleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.UserRoleD</IdLocation>
<IndexLocation>^DHCEPRFS.META.UserRoleI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.UserRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
