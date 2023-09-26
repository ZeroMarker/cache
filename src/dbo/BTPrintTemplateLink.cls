///     
Class dbo.BTPrintTemplateLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_PrintTemplateLink, StorageStrategy = Default ]
{

Index IndexMaster On (ReportType, LinkMainID, LinkSubID) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTPRINTTEMPLATELINK On RowID [ PrimaryKey, SqlName = PK_BT_PRINTTEMPLATELINK, Type = index, Unique ];

/// Foreign Key FKPrintTemplateLink created via DDL
ForeignKey FKPrintTemplateLink(PrintTemplateDR) References dbo.BTPrintTemplate(PKBTPRINTTEMPLATE) [ SqlName = FK_PrintTemplateLink ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReportType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

Property LinkMainID As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

Property LinkSubID As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 5 ];

Property PrintTemplateDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTPrintTemplateLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReportType</Value>
</Value>
<Value name="3">
<Value>LinkMainID</Value>
</Value>
<Value name="4">
<Value>LinkSubID</Value>
</Value>
<Value name="5">
<Value>PrintTemplateDR</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^dbo.BTPrintTemplateLinkD</DataLocation>
<DefaultData>BTPrintTemplateLinkDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTPrintTemplateLinkD</IdLocation>
<IndexLocation>^dbo.BTPrintTemplateLinkI</IndexLocation>
<StreamLocation>^dbo.BTPrintTemplateLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
