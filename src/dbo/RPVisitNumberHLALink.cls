Class dbo.RPVisitNumberHLALink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberHLALink, StorageStrategy = Default ]
{

Index IndexReportID On (VisitNumberReportDR, Sequence) [ SqlName = Index_ReportID, Type = index ];

Index IndexReportAdmNo On (VisitNumberReportDR, AdmNo) [ SqlName = Index_ReportAdmNo, Type = index ];

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
Property Species As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 6 ];

/// 扩展结果  
Property Age As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 定性结果  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 8 ];

/// guanxi  
Property RelationShip As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 9 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="RPVisitNumberHLALinkDefaultData">
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
<Value>Species</Value>
</Value>
<Value name="6">
<Value>Age</Value>
</Value>
<Value name="7">
<Value>Code</Value>
</Value>
<Value name="8">
<Value>RelationShip</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberHLALinkD</DataLocation>
<DefaultData>RPVisitNumberHLALinkDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberHLALinkD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberHLALinkI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberHLALinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
