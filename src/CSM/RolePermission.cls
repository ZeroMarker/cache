/// 角色应用权限表
Class CSM.RolePermission Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 角色所属应用ID，来自Application表的ApplicationID
Property ApplicationID As %Integer;

/// 角色应用权限ID
/// Property PermissionID As %Integer [ Required ];
/// 页面代码
Property PageCode As %String(MAXLEN = 20, TRUNCATE = 1) [ Required ];

/// 角色ID，来自sys_Roles表中RoleID
Property RoleID As %Integer [ Required ];

/// 权限值
Property PermissionValue As %Integer;

///  Index MainIdx On PermissionID [ PrimaryKey, Unique ];

Storage Default
{
<Data name="RolePermissionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ApplicationID</Value>
</Value>
<Value name="3">
<Value>PageCode</Value>
</Value>
<Value name="4">
<Value>PermissionID</Value>
</Value>
<Value name="5">
<Value>PermissionValue</Value>
</Value>
<Value name="6">
<Value>RoleID</Value>
</Value>
</Data>
<DataLocation>^CSM.RolePermissionD</DataLocation>
<DefaultData>RolePermissionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.RolePermissionD</IdLocation>
<IndexLocation>^CSM.RolePermissionI</IndexLocation>
<StreamLocation>^CSM.RolePermissionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
