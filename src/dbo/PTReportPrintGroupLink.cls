/// 打印模板分组明细
Class dbo.PTReportPrintGroupLink Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = PT_ReportPrintGroupLink ]
{

/// Foreign Key FKPTReportPrintPrintDR created via DDL
ForeignKey FKPTReportPrintPrintDR(ReportPrintDR) References dbo.PTReportPrint(PKPTREPORTPRINT) [ SqlName = FK_PT_ReportPrintPrintDR ];

/// Foreign Key FKPTReportPrintGroupDR created via DDL
ForeignKey FKPTReportPrintGroupDR(ReportPrintGroupDR) References dbo.PTReportPrintGroup(PKPTREPORTPRINTGroup) [ SqlName = FK_PT_ReportPrintGroupDR ];

Index IndexReportPrintGroup On (ReportPrintGroupDR, ReportPrintDR) [ SqlName = Index_ReportPrintGroup, Type = index, Unique ];

Index IndexReportPrint On (ReportPrintDR, ReportPrintGroupDR) [ SqlName = Index_ReportPrint, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKPTREPORTPRINTGROUPLINK On RowID [ PrimaryKey, SqlName = PK_PT_REPORTPRINTGROUPLINK, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 分组
Property ReportPrintGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 模板
Property ReportPrintDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="PTReportPrintGroupLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReportPrintGroupDR</Value>
</Value>
<Value name="3">
<Value>ReportPrintDR</Value>
</Value>
</Data>
<DataLocation>^dbo.PTReportPrintGroupLinkD</DataLocation>
<DefaultData>PTReportPrintGroupLinkDefaultData</DefaultData>
<IdLocation>^dbo.PTReportPrintGroupLinkD</IdLocation>
<IndexLocation>^dbo.PTReportPrintGroupLinkI</IndexLocation>
<StreamLocation>^dbo.PTReportPrintGroupLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
