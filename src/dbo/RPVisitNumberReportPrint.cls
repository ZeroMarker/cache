/// 报告打印记录
Class dbo.RPVisitNumberReportPrint Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberReportPrint, StorageStrategy = Default ]
{

/// Foreign Key FKVisitNumberReportPrint created via DDL
ForeignKey FKVisitNumberReportPrint(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_VisitNumberReportPrint ];

/// Foreign Key FKVisitNumberReportPrintUser created via DDL
ForeignKey FKVisitNumberReportPrintUser(PrintUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberReportPrintUser ];

Index IndexMaster On (VisitNumberReportDR, PrintDate, PrintTime) [ SqlName = Index_Master, Type = index ];

Index IndexModuleID On (VisitNumberReportDR, ModuleID, PrintUserDR) [ SqlName = Index_ModuleID, Type = index ];

Index IndexPrintTime On (PrintDate, PrintTime) [ SqlName = Index_PrintTime, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERREPORTPRINT On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERREPORTPRINT, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本报告  
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 打印日期  
Property PrintDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 打印时间  
Property PrintTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 打印者  
Property PrintUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 模块名称  
Property ModuleID As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 7 ];

/// 客户端IP地址  
Property IPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 8 ];

/// 输出类型 0或空为打印1为PDF
Property OutType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="RPVisitNumberReportPrintDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>PrintDate</Value>
</Value>
<Value name="4">
<Value>PrintTime</Value>
</Value>
<Value name="5">
<Value>PrintUserDR</Value>
</Value>
<Value name="6">
<Value>ModuleID</Value>
</Value>
<Value name="7">
<Value>IPAddress</Value>
</Value>
<Value name="8">
<Value>OutType</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberReportPrintD</DataLocation>
<DefaultData>RPVisitNumberReportPrintDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberReportPrintD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberReportPrintI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberReportPrintS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
