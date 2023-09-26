///     
Class dbo.BTTranslate Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Translate ]
{

Index IndexData On (SYSLanguageDR, BLLModule, TransTableCode, Oper, OldData) [ SqlName = IndexCode, Type = index, Unique ];

/// Foreign Key FKBTTranslateSYSLanguageDR created via DDL
ForeignKey FKBTTranslateSYSLanguageDR(SYSLanguageDR) References dbo.SYSLanguage(PKSYSLANGUAGE) [ SqlName = FK_BTTranslateSYSLanguageDR ];

/// DDL Primary Key Specification
Index PKBTTRANSLATE On RowID [ PrimaryKey, SqlName = PK_BT_TRANSLATE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property SYSLanguageDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// Print：打印
Property BLLModule As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

Property TransTableCode As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 5 ];

Property OldData As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ Required, SqlColumnNumber = 6 ];

Property TransData As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ Required, SqlColumnNumber = 7 ];

/// 0：等于，1:包含,2:替换
Property Oper As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 8 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BTTranslateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SYSLanguageDR</Value>
</Value>
<Value name="3">
<Value>BLLModule</Value>
</Value>
<Value name="4">
<Value>TransTableCode</Value>
</Value>
<Value name="5">
<Value>OldData</Value>
</Value>
<Value name="6">
<Value>TransData</Value>
</Value>
<Value name="7">
<Value>Oper</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTranslateD</DataLocation>
<DefaultData>BTTranslateDefaultData</DefaultData>
<IdLocation>^dbo.BTTranslateD</IdLocation>
<IndexLocation>^dbo.BTTranslateI</IndexLocation>
<StreamLocation>^dbo.BTTranslateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
