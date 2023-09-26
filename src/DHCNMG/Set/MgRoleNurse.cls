/// creator:guozj
/// createdate:20171116
/// description:角色关联人员
Class DHCNMG.Set.MgRoleNurse Extends %Persistent
{

Relationship Parref As DHCNMG.Set.MgRoles [ Cardinality = parent, Inverse = NurseChildSub ];

/// 人员表ID
Property RoleNurse As %String [ SqlColumnNumber = 2, SqlFieldName = Role_Nurse ];

/// 开始日期
Property RoleStDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Role_StDate ];

/// 截止日期
Property RoleEndDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Role_EndDate ];

Index par On Parref;

Index nurse On (Parref, RoleNurse);

Index Record On RoleNurse;

Storage Default
{
<Data name="MgRoleNurseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleNurse</Value>
</Value>
<Value name="3">
<Value>RoleStDate</Value>
</Value>
<Value name="4">
<Value>RoleEndDate</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("NurseChildSub")</DataLocation>
<DefaultData>MgRoleNurseDefaultData</DefaultData>
<IdLocation>^DHCNMG.Set.MgRolesC("NurseChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Set.MgRoleNurseI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgRoleNurseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
