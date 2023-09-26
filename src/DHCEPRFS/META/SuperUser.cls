/// Desc:用户表
/// Createdate:2013-07-09
Class DHCEPRFS.META.SuperUser Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 标识编号
Property SupCode As %String(TRUNCATE = 1);

/// 密码
Property SupPassWord As %String(TRUNCATE = 1);

/// 用户编号
Property SupUserID As %Library.String(TRUNCATE = 1);

Property SupUserName As %Library.String(TRUNCATE = 1);

/// 角色表：DHCEPRFS.META.MainRole
Property RoleID As %String(TRUNCATE = 1);

Property IsAdmin As %String(TRUNCATE = 1);

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
<Value>RoleID</Value>
</Value>
<Value name="4">
<Value>SupCode</Value>
</Value>
<Value name="5">
<Value>SupPassWord</Value>
</Value>
<Value name="6">
<Value>SupUserID</Value>
</Value>
<Value name="7">
<Value>SupUserName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.SuperUserD</DataLocation>
<DefaultData>SuperUserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.SuperUserD</IdLocation>
<IndexLocation>^DHCEPRFS.META.SuperUserI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.SuperUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
