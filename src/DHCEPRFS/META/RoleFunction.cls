/// Desc:角色权限表
/// Createdate:2013-7-19
Class DHCEPRFS.META.RoleFunction Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxRoleID On RoleID;

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
<Data name="RoleFunctionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataFrom</Value>
</Value>
<Value name="3">
<Value>DataTo</Value>
</Value>
<Value name="4">
<Value>FuncName</Value>
</Value>
<Value name="5">
<Value>RoleID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.RoleFunctionD</DataLocation>
<DefaultData>RoleFunctionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.RoleFunctionD</IdLocation>
<IndexLocation>^DHCEPRFS.META.RoleFunctionI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.RoleFunctionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
