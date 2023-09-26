/// 角色与知识树的关联表
Class EPRmeta.MainRoleKBTree Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlTableName = MainRoleKBTree ]
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
<DataLocation>^EPRmeta.MainRoleKBTreeD</DataLocation>
<DefaultData>MainRoleKBTreeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRmeta.MainRoleKBTreeD</IdLocation>
<IndexLocation>^EPRmeta.MainRoleKBTreeI</IndexLocation>
<StreamLocation>^EPRmeta.MainRoleKBTreeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
