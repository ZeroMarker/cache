///     
Class dbo.BTPrintTemplate Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_PrintTemplate, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTPRINTTEMPLATE On RowID [ PrimaryKey, SqlName = PK_BT_PRINTTEMPLATE, Type = index, Unique ];

/// Foreign Key FKPrintTemplatePaper created via DDL
ForeignKey FKPrintTemplatePaper(PaperSizeDR) References dbo.BTPrintPaper(PKBTPRINTPAPER) [ SqlName = FK_PrintTemplatePaper ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 4 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property PaperSizeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Orientation As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 7 ];

Property PaperTop As %Library.Float [ SqlColumnNumber = 8 ];

Property PaperBottom As %Library.Float [ SqlColumnNumber = 9 ];

Property PaperLeft As %Library.Float [ SqlColumnNumber = 10 ];

Property PaperRight As %Library.Float [ SqlColumnNumber = 11 ];

Property ArchivesMargin As %Library.Float [ SqlColumnNumber = 12 ];

Property FixedReportEnd As %Library.Boolean [ SqlColumnNumber = 13 ];

Property Pages As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 15 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 17 ];

Storage Default
{
<Data name="BTPrintTemplateDefaultData">
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
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>PaperSizeDR</Value>
</Value>
<Value name="6">
<Value>Orientation</Value>
</Value>
<Value name="7">
<Value>PaperTop</Value>
</Value>
<Value name="8">
<Value>PaperBottom</Value>
</Value>
<Value name="9">
<Value>PaperLeft</Value>
</Value>
<Value name="10">
<Value>PaperRight</Value>
</Value>
<Value name="11">
<Value>ArchivesMargin</Value>
</Value>
<Value name="12">
<Value>FixedReportEnd</Value>
</Value>
<Value name="13">
<Value>Pages</Value>
</Value>
<Value name="14">
<Value>Remark</Value>
</Value>
<Value name="15">
<Value>Sequence</Value>
</Value>
<Value name="16">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTPrintTemplateD</DataLocation>
<DefaultData>BTPrintTemplateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTPrintTemplateD</IdLocation>
<IndexLocation>^dbo.BTPrintTemplateI</IndexLocation>
<StreamLocation>^dbo.BTPrintTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
