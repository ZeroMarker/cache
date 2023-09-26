/// 鉴定过程仪器日志
Class dbo.IDPMachineLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = IDP_MachineLog ]
{

Index IndexMaster On (VisitNumberReportDR, AssayDate, AssayTime) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKIDPMachineLogReportDR created via DDL
ForeignKey FKIDPMachineLogReportDR(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_IDPMachineLogReportDR ];

/// Foreign Key FKIDPMachineLogMachineParameterDR created via DDL
ForeignKey FKIDPMachineLogMachineParameterDR(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_IDPMachineLogMachineParameterDR ];

/// DDL Primary Key Specification
Index PKIDPMACHINELOG On RowID [ PrimaryKey, SqlName = PK_IDP_MACHINELOG, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 报告
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 传输日期
Property AssayDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 传输时间
Property AssayTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 类型
Property Type As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 结果
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

/// 仪器
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 状态
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="IDPMachineLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>AssayDate</Value>
</Value>
<Value name="4">
<Value>AssayTime</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
<Value name="6">
<Value>Result</Value>
</Value>
<Value name="7">
<Value>MachineParameterDR</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^dbo.IDPMachineLogD</DataLocation>
<DefaultData>IDPMachineLogDefaultData</DefaultData>
<IdLocation>^dbo.IDPMachineLogD</IdLocation>
<IndexLocation>^dbo.IDPMachineLogI</IndexLocation>
<StreamLocation>^dbo.IDPMachineLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
