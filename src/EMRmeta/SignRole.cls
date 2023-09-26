/// 名称：		EMRmeta.SignRole
/// 描述：		签名角色表
/// 编写者：	yejian
/// 编写时间：	2020-7-29
Class EMRmeta.SignRole Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock ]
{

Index NameIndex On Name [ Unique ];

Index IdxNameCanSignOnCheck On (Name, CanSignOnCheck);

Index IdxNameNotValidate On (Name, NotValidate);

Index IdxActionCode On ActionCode;

Index IdxRoleLevel On RoleLevel;

Property Name As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

/// EMRmeta.EMRAction表的ActionCode
Property ActionCode As %String(TRUNCATE = 1);

/// 1：使用 0：停用
Property IsValid As %String(TRUNCATE = 1);

/// 级别：数值越大级别越高（验证和失效）
Property RoleLevel As %Integer;

/// 前缀，如果为1，则前面加斜杠
Property SignPrefix As %String(TRUNCATE = 1);

/// 是否可以在多级医师审核单元(Name为"Check")上签名 1：可以 0或空：不可以
Property CanSignOnCheck As %String(TRUNCATE = 1);

/// 是否不验证签名用户，任何人都可签 1：是 0或空：不是
Property NotValidate As %String(TRUNCATE = 1);

Storage Default
{
<Data name="SignRoleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>IsValid</Value>
</Value>
<Value name="6">
<Value>EMRActionID</Value>
</Value>
<Value name="7">
<Value>ActionCode</Value>
</Value>
<Value name="8">
<Value>RoleLevel</Value>
</Value>
<Value name="9">
<Value>SignPrefix</Value>
</Value>
<Value name="10">
<Value>CanSignOnCheck</Value>
</Value>
<Value name="11">
<Value>NotValidate</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.SignRoleD</DataLocation>
<DefaultData>SignRoleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.SignRoleD</IdLocation>
<IndexLocation>^DHCEMRM.SignRoleI</IndexLocation>
<StreamLocation>^DHCEMRM.SignRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
