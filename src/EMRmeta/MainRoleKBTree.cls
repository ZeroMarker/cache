/// 角色与知识树的关联表
Class EMRmeta.MainRoleKBTree Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlTableName = MainRoleKBTree ]
{

/// 角色ID
Property RoleID As %String(TRUNCATE = 1);

/// 知识树的ID
Property KBTreeID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="MainRoleKBTreeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KBTreeID</Value>
</Value>
<Value name="3">
<Value>RoleID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.MainRoleKBTreeD</DataLocation>
<DefaultData>MainRoleKBTreeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.MainRoleKBTreeD</IdLocation>
<IndexLocation>^DHCEMRM.MainRoleKBTreeI</IndexLocation>
<StreamLocation>^DHCEMRM.MainRoleKBTreeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
