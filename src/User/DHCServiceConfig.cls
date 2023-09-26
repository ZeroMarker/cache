Class User.DHCServiceConfig Extends (%Persistent, User.Abstract) [ SqlRowIdName = SC_RowId, SqlTableName = DHC_ServiceConfig ]
{

/// 接口类型
Property SCType As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = SC_Type ];

/// Cache服务器IP地址,如果有多个ECP,使用逗号隔开
Property SCLocalIP As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 3, SqlFieldName = SC_LocalIP ];

/// 用户名
Property SCUser As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = SC_User ];

/// 密码
Property SCPassWord As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = SC_PassWord ];

/// 是否启用
Property SCUseFlag As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = SC_UseFlag ];

Property SCToken As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = SC_Token ];

Property SCTokenDate As %Date [ SqlColumnNumber = 8, SqlFieldName = SC_TokenDate ];

Property SCTokenTime As %Time [ SqlColumnNumber = 9, SqlFieldName = SC_TokenTime ];

Index Type On SCType As Exact;

Index IP On SCLocalIP As Exact;

Index TypeIP On (SCType As Exact, SCLocalIP As Exact);

Storage Default
{
<Data name="DHCServiceConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SCType</Value>
</Value>
<Value name="3">
<Value>SCLocalIP</Value>
</Value>
<Value name="4">
<Value>SCUser</Value>
</Value>
<Value name="5">
<Value>SCPassWord</Value>
</Value>
<Value name="6">
<Value>SCUseFlag</Value>
</Value>
<Value name="7">
<Value>SCToken</Value>
</Value>
<Value name="8">
<Value>SCTokenDate</Value>
</Value>
<Value name="9">
<Value>SCTokenTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCServiceConfigD</DataLocation>
<DefaultData>DHCServiceConfigDefaultData</DefaultData>
<IdLocation>^User.DHCServiceConfigD</IdLocation>
<IndexLocation>^User.DHCServiceConfigI</IndexLocation>
<SqlRowIdName>SC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCServiceConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
