/// Desc:用户角色表
/// Creator:Candy
Class DHCEPRFS.META.QueryUserRole Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

/// 用户ID
Property UserID As %String;

/// 角色ID
Property RoleID As %String;

Index IdxUserID On UserID;

Index IdxRoleID On RoleID;

Storage Default
{
<Data name="QueryUserRoleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleID</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QueryUserRoleD</DataLocation>
<DefaultData>QueryUserRoleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.QueryUserRoleD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QueryUserRoleI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QueryUserRoleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
