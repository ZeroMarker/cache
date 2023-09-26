/// 报告文本结果
Class dbo.RPVisitNumberReportText Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberReportText ]
{

Index IndexMaster On (VisitNumberReportDR, ReportType) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key TestSetTemplateTestSet created via DDL
ForeignKey FKVisitNumberReportTextVisitNumberReport(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_VisitNumberReportTextVisitNumberReport ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本报告  
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 检测项目  
Property ReportType As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 4 ];

/// 检测内容  
Property ReportText As %GlobalBinaryStream [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="RPVisitNumberReportTextDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>ReportType</Value>
</Value>
<Value name="4">
<Value>ReportText</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberReportTextD</DataLocation>
<DefaultData>RPVisitNumberReportTextDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberReportTextD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberReportTextI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberReportTextS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
