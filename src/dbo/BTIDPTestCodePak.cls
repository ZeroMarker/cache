Class dbo.BTIDPTestCodePak Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_TestCodePak ]
{

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexIDPElementSeq On (IDPElementDR, Sequence) [ SqlName = Index_IDPElementSeq, Type = index ];

/// DDL Primary Key Specification
Index PKBTIDPTESTCODEPAK On RowID [ PrimaryKey, SqlName = PK_BTIDP_TESTCODEPAK, Type = index, Unique ];

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

/// 鉴定元素
Property IDPElementDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTIDPTestCodePakDefaultData">
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
<Value name="7">
<Value>IDPElementDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPTestCodePakD</DataLocation>
<DefaultData>BTIDPTestCodePakDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPTestCodePakD</IdLocation>
<IndexLocation>^dbo.BTIDPTestCodePakI</IndexLocation>
<StreamLocation>^dbo.BTIDPTestCodePakS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
