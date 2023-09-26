Class dbo.RPReportSplitRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_ReportSplitRecord, StorageStrategy = Default ]
{

Index IndexMainSplit On (VisitNumberReportDR, SplitReportDR) [ SqlName = Index_MainSplit, Type = index ];

Index IndexMaster On (VisitNumberReportDR, TestCodeDR, SplitReportDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSplitReport On (SplitReportDR, TestCodeDR) [ SqlName = Index_SplitReport, Type = index, Unique ];

Index IndexOperateDate On (OperateDate, OperateTime, SplitReportDR) [ SqlName = Index_OperateDate, Type = index ];

/// Foreign Key FKVisitNumberReportRead created via DDL
ForeignKey FKRPReportSplitRecordSplitedReportDR(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_RPReportSplitRecordSplitedReportDR ];

/// Foreign Key FKVisitNumberReportResultTC created via DDL
ForeignKey FKRPReportSplitRecordTC(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_RPReportSplitRecordTC ];

/// Foreign Key FKVisitNumberReportRead created via DDL
ForeignKey FKRPReportSplitRecordReportDR(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_RPReportSplitRecordReportDR ];

/// Foreign Key FKVisitNumberRecordOperator created via DDL
ForeignKey FKRPReportSplitRecordOperator(OperateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPReportSplitRecordOperator ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SplitReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property OperateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property OperateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property OperateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="RPReportSplitRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>SplitReportDR</Value>
</Value>
<Value name="5">
<Value>OperateDate</Value>
</Value>
<Value name="6">
<Value>OperateTime</Value>
</Value>
<Value name="7">
<Value>OperateUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPReportSplitRecordD</DataLocation>
<DefaultData>RPReportSplitRecordDefaultData</DefaultData>
<IdLocation>^dbo.RPReportSplitRecordD</IdLocation>
<IndexLocation>^dbo.RPReportSplitRecordI</IndexLocation>
<StreamLocation>^dbo.RPReportSplitRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
