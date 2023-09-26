Class DHCEPRFS.META.QueryUserGroup Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//子用户ID

Property QueryUserID As %String;

//父用户ID

Property ParentQueryUserID As %String;

Index IdxQueryUserID On QueryUserID;

Index IdxParentQueryUserID On ParentQueryUserID;

Storage Default
{
<Data name="QueryUserGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QueryUserID</Value>
</Value>
<Value name="3">
<Value>ParentQueryUserID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QueryUserGroupD</DataLocation>
<DefaultData>QueryUserGroupDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.QueryUserGroupD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QueryUserGroupI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QueryUserGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
