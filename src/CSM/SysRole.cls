/// 角色表
Class CSM.SysRole Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 缺省职能，只能有一个职能是缺省的，值为1
Property IsDefault As %String(MAXLEN = 1, TRUNCATE = 1);

/// 介绍
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1) [ Required ];

///       Index MainIdx On RoleID [ PrimaryKey, Unique ];

Storage Default
{
<Data name="SysRoleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>RoleID</Value>
</Value>
<Value name="4">
<Value>RoleName</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>IsDefault</Value>
</Value>
</Data>
<DataLocation>^CSM.SysRoleD</DataLocation>
<DefaultData>SysRoleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.SysRoleD</IdLocation>
<IndexLocation>^CSM.SysRoleI</IndexLocation>
<StreamLocation>^CSM.SysRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
