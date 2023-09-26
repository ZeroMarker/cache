/// 用户登录科室
Class DHCCL.Config.UserLogonLoc Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = UserLogonLoc ]
{

Property LogonUser As DHCCL.Config.SecureUser [ Required, SqlColumnNumber = 2 ];

Property LogonGroup As DHCCL.Code.SecureGroup [ Required, SqlColumnNumber = 3 ];

Property Hospital As DHCCL.Config.Hospital [ SqlColumnNumber = 4 ];

Property ActiveDate As %Date [ SqlColumnNumber = 5 ];

Property ExpireDate As %Date [ SqlColumnNumber = 6 ];

Property ExternalID As %String [ SqlColumnNumber = 7 ];

Index LUser On LogonUser;

Index Ext On ExternalID;

ForeignKey FKUser(LogonUser) References DHCCL.Config.SecureUser() [ OnDelete = cascade ];

Storage Default
{
<Data name="UserLogonLocDefaultData">
<Value name="1">
<Value>LogonUser</Value>
</Value>
<Value name="2">
<Value>LogonGroup</Value>
</Value>
<Value name="3">
<Value>Hospital</Value>
</Value>
<Value name="4">
<Value>ActiveDate</Value>
</Value>
<Value name="5">
<Value>ExpireDate</Value>
</Value>
<Value name="6">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.UserLogonLocD</DataLocation>
<DefaultData>UserLogonLocDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.UserLogonLocD</IdLocation>
<IndexLocation>^DHCCL.Config.UserLogonLocI</IndexLocation>
<StreamLocation>^DHCCL.Config.UserLogonLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
