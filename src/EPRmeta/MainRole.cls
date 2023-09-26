/// 名称: 电子病历维护程序角色表
/// 描述: 角色
/// 编写者：LingChen
/// 编写日期: 2010-10-22
Class EPRmeta.MainRole Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxRoleName On RoleName [ Unique ];

/// 角色名称
Property RoleName As %String(TRUNCATE = 1);

/// 角色描述
Property RoleDesc As %String(TRUNCATE = 1);

Storage Default
{
<Data name="MainRoleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleDesc</Value>
</Value>
<Value name="3">
<Value>RoleName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.MainRoleD</DataLocation>
<DefaultData>MainRoleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.MainRoleD</IdLocation>
<IndexLocation>^DHCEPRM.MainRoleI</IndexLocation>
<StreamLocation>^DHCEPRM.MainRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
