/// 服务白名单
Class dbo.SYSServerWhiteList Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_ServerWhiteList ]
{

/// DDL Primary Key Specification
Index PKSYSSERVERWHITELIST On RowID [ PrimaryKey, SqlName = PK_SYS_SERVERWHITELIST, Type = index, Unique ];

Index IndexCode On (Code, IP) [ SqlName = Index_Code, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 接口代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 3 ];

/// 调用客户端  
Property IP As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 允许调用  {1:true,0:false}
Property AllowUse As %Library.Boolean [ SqlColumnNumber = 5 ];

/// 接口说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="SYSServerWhiteListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>IP</Value>
</Value>
<Value name="4">
<Value>AllowUse</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSServerWhiteListD</DataLocation>
<DefaultData>SYSServerWhiteListDefaultData</DefaultData>
<IdLocation>^dbo.SYSServerWhiteListD</IdLocation>
<IndexLocation>^dbo.SYSServerWhiteListI</IndexLocation>
<StreamLocation>^dbo.SYSServerWhiteListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
