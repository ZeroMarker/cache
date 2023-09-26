///     
Class dbo.MCTestResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = MC_TestResult, StorageStrategy = Default ]
{

Index IndexDataMaster On (ProcessRecordDR, TestItemDR) [ SqlName = Index_DataMaster, Type = index, Unique ];

Index IndexSequence On (ProcessRecordDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKMCTESTRESULT On RowID [ PrimaryKey, SqlName = PK_MC_TESTRESULT, Type = index, Unique ];

/// Foreign Key FKMCTestResultPR created via DDL
ForeignKey FKMCTestResultPR(ProcessRecordDR) References dbo.MCProcessRecord(PKMCPROCESSRECORD) [ SqlName = FK_MC_TestResult_PR ];

/// Foreign Key FKMCTestResultTestItem created via DDL
ForeignKey FKMCTestResultTestItem(TestItemDR) References dbo.BTMCTestItem(PKBTMCTESTITEM) [ SqlName = FK_MC_TestResult_TestItem ];

/// Foreign Key FKMCTestResultVisitNumberReport created via DDL
ForeignKey FKMCTestResultVisitNumberReport(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_MC_TestResult_VisitNumberReport ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ProcessRecordDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property TestItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 6 ];

Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

Property AbFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 9 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="MCTestResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProcessRecordDR</Value>
</Value>
<Value name="3">
<Value>TestItemDR</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>Unit</Value>
</Value>
<Value name="6">
<Value>RefRanges</Value>
</Value>
<Value name="7">
<Value>AbFlag</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>VisitNumberReportDR</Value>
</Value>
</Data>
<DataLocation>^dbo.MCTestResultD</DataLocation>
<DefaultData>MCTestResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.MCTestResultD</IdLocation>
<IndexLocation>^dbo.MCTestResultI</IndexLocation>
<StreamLocation>^dbo.MCTestResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
