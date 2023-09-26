/// 鉴定元素包
Class dbo.BTIDPPak Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_Pak ]
{

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTIDPPAK On RowID [ PrimaryKey, SqlName = PK_BTIDP_PAK, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 128) [ SqlColumnNumber = 4 ];

/// 说明
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 5 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTIDPPakDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>Remark</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPPakD</DataLocation>
<DefaultData>BTIDPPakDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPPakD</IdLocation>
<IndexLocation>^dbo.BTIDPPakI</IndexLocation>
<StreamLocation>^dbo.BTIDPPakS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
