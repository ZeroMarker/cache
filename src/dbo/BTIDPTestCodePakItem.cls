Class dbo.BTIDPTestCodePakItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_TestCodePakItem ]
{

Index IndexMaster On (IDPTestCodePakDR, Sequence, TestCodeDR) [ SqlName = Index_Master, Type = index ];

Index IndexTestCodeDR On (IDPTestCodePakDR, TestCodeDR) [ SqlName = Index_TestCodeDR, Type = index, Unique ];

/// Foreign Key FKBTIDPTestCodePakItemIDPTestCodePakDR created via DDL
ForeignKey FKBTIDPTestCodePakItemIDPTestCodePakDR(IDPTestCodePakDR) References dbo.BTIDPTestCodePak(PKBTIDPTESTCODEPAK) [ SqlName = FK_BTIDPTestCodePakItemIDPTestCodePakDR ];

/// Foreign Key FKBTIDPTestCodePakItemTestCodeDR created via DDL
ForeignKey FKBTIDPTestCodePakItemTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTIDPTestCodePakItemTestCodeDR ];

/// DDL Primary Key Specification
Index PKBTIDPELEMENTPAK On RowID [ PrimaryKey, SqlName = PK_BTIDP_PAKELEMENT, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 鉴定项目包
Property IDPTestCodePakDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 检验项目
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 默认结果
Property DefaultResult As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 5 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTIDPTestCodePakItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDPTestCodePakDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>DefaultResult</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPTestCodePakItemD</DataLocation>
<DefaultData>BTIDPTestCodePakItemDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPTestCodePakItemD</IdLocation>
<IndexLocation>^dbo.BTIDPTestCodePakItemI</IndexLocation>
<StreamLocation>^dbo.BTIDPTestCodePakItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
