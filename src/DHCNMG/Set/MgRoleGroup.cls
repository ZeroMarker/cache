/// creator:xbl
/// createdate:20170714
/// desc:角色管理HIS安全组
Class DHCNMG.Set.MgRoleGroup Extends %Persistent
{

/// 角色
Relationship Parref As DHCNMG.Set.MgRoles [ Cardinality = parent, Inverse = GrpChildSub ];

/// 安全组
Property RoleGroup As User.SSGroup [ SqlColumnNumber = 4, SqlFieldName = Role_Group ];

Index Group On RoleGroup;

Storage Default
{
<Data name="MgRoleGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleGroup</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("GrpChildSub")</DataLocation>
<DefaultData>MgRoleGroupDefaultData</DefaultData>
<IdLocation>^DHCNMG.Set.MgRolesC("GrpChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Set.MgRoleGroupI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgRoleGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
