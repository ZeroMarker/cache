Class dbo.RPVisitNumberHLAResult Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberHLAResult, StorageStrategy = Default ]
{

Index IndexReportID On (VisitNumberReportDR, Sequence) [ SqlName = Index_ReportID, Type = index ];

Index IndexReportAdmNo On (VisitNumberReportDR, AdmNo) [ SqlName = Index_ReportAdmNo, Type = index ];

Index IndexAdmNoReportID On (AdmNo, VisitNumberReportDR) [ SqlName = Index_AdmNoReportID, Type = index ];

/// Foreign Key FKVisitNumberReportResult created via DDL
ForeignKey FKVisitNumberReportHLALink(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_VisitNumberReportHLALink ];

/// RowID  
Property RowID As %Library.Numeric(MAXVAL = 999999999999999999, MINVAL = -999999999999999999, SCALE = 0) [ Identity, SqlColumnNumber = 2 ];

/// 标本报告  
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 检测项目  
Property AdmNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 结果  
Property PatName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

/// 定性结果  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 6 ];

/// 扩展结果  
Property HLAA As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

/// 扩展结果  
Property HLAB As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

/// 扩展结果  
Property HLAC As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 9 ];

/// 扩展结果  
Property HLADRB As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

/// 扩展结果  
Property HLADQB As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 11 ];

/// 扩展结果  
Property HLADPB As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 12 ];

/// guanxi  
Property RelationShip As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 13 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

///       
Property KIRC As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

/// 扩展结果  
Property KIRT As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 16 ];

/// 扩展结果  
Property KIRNum As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 17 ];

/// 扩展结果  
Property KIRResult As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="RPVisitNumberHLAResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>AdmNo</Value>
</Value>
<Value name="4">
<Value>PatName</Value>
</Value>
<Value name="5">
<Value>Code</Value>
</Value>
<Value name="6">
<Value>HLAA</Value>
</Value>
<Value name="7">
<Value>HLAB</Value>
</Value>
<Value name="8">
<Value>HLAC</Value>
</Value>
<Value name="9">
<Value>HLADRB</Value>
</Value>
<Value name="10">
<Value>HLADQB</Value>
</Value>
<Value name="11">
<Value>HLADPB</Value>
</Value>
<Value name="12">
<Value>RelationShip</Value>
</Value>
<Value name="13">
<Value>Sequence</Value>
</Value>
<Value name="14">
<Value>KIRC</Value>
</Value>
<Value name="15">
<Value>KIRT</Value>
</Value>
<Value name="16">
<Value>KIRNum</Value>
</Value>
<Value name="17">
<Value>KIRResult</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberHLAResultD</DataLocation>
<DefaultData>RPVisitNumberHLAResultDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberHLAResultD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberHLAResultI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberHLAResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
