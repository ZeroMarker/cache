/// creator:xbl
/// date:20170714
/// desc:角色设置
Class DHCNMG.Set.MgRoles Extends %Persistent
{

Relationship GrpChildSub As DHCNMG.Set.MgRoleGroup [ Cardinality = children, Inverse = Parref ];

Relationship MenuChildSub As DHCNMG.Set.MgRoleMenu [ Cardinality = children, Inverse = Parref ];

Relationship NurseChildSub As DHCNMG.Set.MgRoleNurse [ Cardinality = children, Inverse = Parref ];

/// 角色代码
Property RoleCode As %String [ SqlColumnNumber = 2, SqlFieldName = RoleCode ];

/// 角色描述
Property RoleDesc As %String [ SqlColumnNumber = 3, SqlFieldName = RoleDesc ];

/// 角色说明
Property RoleRemark As %String(MAXLEN = 10000) [ SqlColumnNumber = 4, SqlFieldName = Role_Remark ];

/// 启用状态
Property RoleStatus As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = Role_Status ];

/// 级别
Property RoleLevel As %Integer [ SqlColumnNumber = 6, SqlFieldName = Role_Level ];

/// 序号
Property RoleSort As %Integer [ SqlColumnNumber = 7, SqlFieldName = Role_Sort ];

Index code On (RoleStatus, RoleCode);

Index desc On (RoleStatus, RoleDesc) [ Unique ];

Index Sort On RoleSort;

Storage Default
{
<Data name="MgRolesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleCode</Value>
</Value>
<Value name="3">
<Value>RoleDesc</Value>
</Value>
<Value name="4">
<Value>RoleRemark</Value>
</Value>
<Value name="5">
<Value>RoleStatus</Value>
</Value>
<Value name="6">
<Value>RoleLevel</Value>
</Value>
<Value name="7">
<Value>RoleSort</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Set.MgRolesD</DataLocation>
<DefaultData>MgRolesDefaultData</DefaultData>
<IdLocation>^DHCNMG.Set.MgRolesD</IdLocation>
<IndexLocation>^DHCNMG.Set.MgRolesI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgRolesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
