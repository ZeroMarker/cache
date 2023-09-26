/// 名称:EMRmeta.SuperUser
/// 描述:用户信息
/// 编写者：yejian
/// 编写日期: 2014-2-12
Class EMRmeta.SuperUser Extends %Persistent [ Not Abstract, ClassType = persistent, Not Final, ProcedureBlock ]
{

Property IsAdmin As %String(TRUNCATE = 1);

/// 标识编号
Property SupCode As %String(TRUNCATE = 1);

/// 密码
Property SupPassWord As %String(TRUNCATE = 1);

/// 用户编号
Property SupUserID As %Library.String(TRUNCATE = 1);

Property SupUserName As %Library.String(TRUNCATE = 1);

/// 角色表：EPRMeta.MainRole
Property RoleID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="SuperUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IsAdmin</Value>
</Value>
<Value name="3">
<Value>SupCode</Value>
</Value>
<Value name="4">
<Value>SupPassWord</Value>
</Value>
<Value name="5">
<Value>SupUserID</Value>
</Value>
<Value name="6">
<Value>SupUserName</Value>
</Value>
<Value name="7">
<Value>RoleID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.SuperUserD</DataLocation>
<DefaultData>SuperUserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.SuperUserD</IdLocation>
<IndexLocation>^DHCEMRM.SuperUserI</IndexLocation>
<StreamLocation>^DHCEMRM.SuperUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
