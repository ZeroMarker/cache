Class CIS.AN.LogonLog Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = LogonLog ]
{

/// 登录用户
Property LogonUser As User.SSUser [ Required, SqlColumnNumber = 2 ];

/// 登录日期
Property LogonDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 3 ];

/// 登录时间
Property LogonTime As %Time [ InitialExpression = {$p($h,",",2)}, Required, SqlColumnNumber = 4 ];

/// 登录组
Property LogonGroup As User.SSLogonGroup [ Required, SqlColumnNumber = 5 ];

/// 客户端IP
Property ClientIP As %String [ SqlColumnNumber = 6 ];

Index ILogonDate On LogonDate;

Index IUser On LogonUser;

Storage Default
{
<Data name="LogonLogDefaultData">
<Value name="1">
<Value>LogonUser</Value>
</Value>
<Value name="2">
<Value>LogonDate</Value>
</Value>
<Value name="3">
<Value>LogonTime</Value>
</Value>
<Value name="4">
<Value>LogonGroup</Value>
</Value>
<Value name="5">
<Value>ClientIP</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.LogonLogD</DataLocation>
<DefaultData>LogonLogDefaultData</DefaultData>
<IdLocation>^CIS.AN.LogonLogD</IdLocation>
<IndexLocation>^CIS.AN.LogonLogI</IndexLocation>
<StreamLocation>^CIS.AN.LogonLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
