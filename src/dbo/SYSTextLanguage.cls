///     
Class dbo.SYSTextLanguage Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_TextLanguage ]
{

/// Foreign Key FKSYSTextLanguageTextDR created via DDL
ForeignKey FKSYSTextLanguageTextDR(TextDR) References dbo.SYSText(PKSYSTEXT) [ SqlName = FK_SYSTextLanguageTextDR ];

/// Foreign Key FKSYSTextLanguageSYSLanguageDR created via DDL
ForeignKey FKSYSTextLanguageSYSLanguageDR(SYSLanguageDR) References dbo.SYSLanguage(PKSYSLANGUAGE) [ SqlName = FK_SYSTextLanguageSYSLanguageDR ];

/// DDL Primary Key Specification
Index PKSYSTEXTLANGUAGE On RowID [ PrimaryKey, SqlName = PK_SYS_TEXTLANGUAGE, Type = index, Unique ];

Index IndexMaster On (TextDR, SYSLanguageDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TextDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property SYSLanguageDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TransText As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="SYSTextLanguageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TextDR</Value>
</Value>
<Value name="3">
<Value>SYSLanguageDR</Value>
</Value>
<Value name="4">
<Value>TransText</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSTextLanguageD</DataLocation>
<DefaultData>SYSTextLanguageDefaultData</DefaultData>
<IdLocation>^dbo.SYSTextLanguageD</IdLocation>
<IndexLocation>^dbo.SYSTextLanguageI</IndexLocation>
<StreamLocation>^dbo.SYSTextLanguageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
