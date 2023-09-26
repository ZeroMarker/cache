/// 系统语言包
Class dbo.SYSLanguagePak Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_LanguagePak ]
{

/// Foreign Key FKSYSLanguagePakSYSLanguageDR created via DDL
ForeignKey FKSYSLanguagePakSYSLanguageDR(SYSLanguageDR) References dbo.SYSLanguage(PKSYSLANGUAGE) [ SqlName = FK_SYSLanguagePakSYSLanguageDR ];

/// DDL Primary Key Specification
Index PKSYSLANGUAGEPAK On RowID [ PrimaryKey, SqlName = PK_SYS_LANGUAGEPAK, Type = index, Unique ];

Index IndexSYSLanguageDR On (SYSLanguageDR, BLLCode, GetCode) [ SqlName = Index_SYSLanguageDR, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 语言
Property SYSLanguageDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 业务代码
Property BLLCode As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ Required, SqlColumnNumber = 4 ];

/// 获取代码
Property GetCode As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ Required, SqlColumnNumber = 5 ];

/// 返回数据
Property RetData As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ Required, SqlColumnNumber = 6 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

/// 说明
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ Required, SqlColumnNumber = 9 ];

Storage Default
{
<Data name="SYSLanguagePakDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SYSLanguageDR</Value>
</Value>
<Value name="3">
<Value>BLLCode</Value>
</Value>
<Value name="4">
<Value>GetCode</Value>
</Value>
<Value name="5">
<Value>RetData</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSLanguagePakD</DataLocation>
<DefaultData>SYSLanguagePakDefaultData</DefaultData>
<IdLocation>^dbo.SYSLanguagePakD</IdLocation>
<IndexLocation>^dbo.SYSLanguagePakI</IndexLocation>
<StreamLocation>^dbo.SYSLanguagePakS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
