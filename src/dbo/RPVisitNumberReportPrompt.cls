Class dbo.RPVisitNumberReportPrompt Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberReportPrompt, StorageStrategy = Default ]
{

Index IndexReportValidType On (VisitNumberReportDR, ValidType) [ SqlName = Index_ReportValidType, Type = index ];

/// DDL Primary Key Specification
Index FKRPVisitNumberReportPrompt On RowID [ PrimaryKey, SqlName = FK_RP_VisitNumberReportPrompt, Type = index, Unique ];

/// Foreign Key FKVisitNumberReportCheckValid created via DDL
ForeignKey FKRPVisitNumberReportPromptID(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_RP_VisitNumberReportPromptID ];

Property RowID As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ValidType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

Property ValidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 5 ];

Property CheckValidRulesID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="RPVisitNumberReportPromptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>ValidType</Value>
</Value>
<Value name="4">
<Value>ValidFlag</Value>
</Value>
<Value name="5">
<Value>CheckValidRulesID</Value>
</Value>
<Value name="6">
<Value>RuleData</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberReportPromptD</DataLocation>
<DefaultData>RPVisitNumberReportPromptDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberReportPromptD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberReportPromptI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberReportPromptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
