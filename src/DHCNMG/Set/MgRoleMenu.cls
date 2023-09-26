/// creator:xbl
/// date:20170714
/// desc:角色菜单
Class DHCNMG.Set.MgRoleMenu Extends %Persistent
{

/// 角色
Relationship Parref As DHCNMG.Set.MgRoles [ Cardinality = parent, Inverse = MenuChildSub ];

/// 菜单
Property RoleMenu As DHCNMG.Set.MgMenu [ SqlColumnNumber = 4, SqlFieldName = Role_Menu ];

/// 元素
Property RoleElements As list Of DHCNMG.Set.MgMenuElement [ SqlColumnNumber = 5, SqlFieldName = Role_Elements ];

Index Menu On RoleMenu;

Storage Default
{
<Data name="MgRoleMenuDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleMenu</Value>
</Value>
<Value name="3">
<Value>RoleElements</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Set.MgRoleMenuD</DataLocation>
<DefaultData>MgRoleMenuDefaultData</DefaultData>
<IdLocation>{%%PARENT}("MenuChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Set.MgRoleMenuI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgRoleMenuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
