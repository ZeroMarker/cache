Class dbo.RPVisitNumberReportCheckValid Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberReportCheckValid, StorageStrategy = Default ]
{

Index IndexReportItem On (VisitNumberReportDR, ValidType, CheckValidRulesID) [ SqlName = Index_ReportItem, Type = index, Unique ];

/// Foreign Key FKVisitNumberReportCheckValid created via DDL
ForeignKey FKVisitNumberReportCheckValid(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_VisitNumberReportCheckValid ];

Property RowID As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property CheckValidRulesID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ValidType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 5 ];

Property ValidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 6 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Property PreResult As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

Property RuleData As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="RPVisitNumberReportCheckValidDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>CheckValidRulesID</Value>
</Value>
<Value name="4">
<Value>ValidType</Value>
</Value>
<Value name="5">
<Value>ValidFlag</Value>
</Value>
<Value name="6">
<Value>Result</Value>
</Value>
<Value name="7">
<Value>PreResult</Value>
</Value>
<Value name="8">
<Value>RuleData</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberReportValidD</DataLocation>
<DefaultData>RPVisitNumberReportCheckValidDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberReportValidD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberReportValidI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberReportValidS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
