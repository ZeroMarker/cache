/// 角色权限表
Class EMRmeta.MainRoleFunction Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 角色ID
Property RoleID As %String(TRUNCATE = 1);

/// 功能描述
Property FuncName As %String(TRUNCATE = 1);

/// 开始时间
Property DataFrom As %Date;

/// 截止时间
Property DataTo As %Date;

Storage Default
{
<Data name="MainRoleFunctionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleID</Value>
</Value>
<Value name="3">
<Value>FuncName</Value>
</Value>
<Value name="4">
<Value>DataFrom</Value>
</Value>
<Value name="5">
<Value>DataTo</Value>
</Value>
<Value name="6">
<Value>RoleName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.MainRoleFunctionD</DataLocation>
<DefaultData>MainRoleFunctionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.MainRoleFunctionD</IdLocation>
<IndexLocation>^DHCEMRM.MainRoleFunctionI</IndexLocation>
<StreamLocation>^DHCEMRM.MainRoleFunctionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
