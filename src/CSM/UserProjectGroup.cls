/// 用户－项目组－职能对应关系表
Class CSM.UserProjectGroup Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 登陆名
/// Property LoginName As %String(MAXLEN = 20) [ Required ];
/// 密码，md5加密字符
/// Property Password As %String(MAXLEN = 32) [ Required ];
/// 项目ID，为效率和查询简便而冗余
Property ProjectID As %Integer [ Required ];

/// 项目组ID
Property ProjGrpID As %Integer [ Required ];

/// 职能ID
Property RoleID As %Integer [ Required ];

/// 用户ID
Property UserID As %Integer [ Required ];

Index IdxProjectID On ProjectID;

/// 用户在一个项目组中只能出现一次
Index UniqueIdx On (ProjectID, ProjGrpID, UserID) [ Unique ];

Storage Default
{
<Data name="UserProjectGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LoginName</Value>
</Value>
<Value name="3">
<Value>Password</Value>
</Value>
<Value name="4">
<Value>ProjGrpID</Value>
</Value>
<Value name="5">
<Value>RoleID</Value>
</Value>
<Value name="6">
<Value>UPGID</Value>
</Value>
<Value name="7">
<Value>UserID</Value>
</Value>
<Value name="8">
<Value>ProjectID</Value>
</Value>
</Data>
<DataLocation>^CSM.UserProjectGroupD</DataLocation>
<DefaultData>UserProjectGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.UserProjectGroupD</IdLocation>
<IndexLocation>^CSM.UserProjectGroupI</IndexLocation>
<StreamLocation>^CSM.UserProjectGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
