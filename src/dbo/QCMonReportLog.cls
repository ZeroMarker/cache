/// 质控月报
Class dbo.QCMonReportLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_MonReportLog ]
{

/// Foreign Key FKQCMonReportLogMonReportDR created via DDL
ForeignKey FKQCMonReportLogMonReportDR(MonReportDR) References dbo.QCMonReport(PKQCMONREPORT) [ SqlName = FK_QCMonReportLogMonReportDR ];

/// Foreign Key FKQCMonReportLogUserDR created via DDL
ForeignKey FKQCMonReportLogUserDR(UserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_QCMonReportLogUserDR ];

/// Foreign Key FKQCMonReportLogWorkGroupDR created via DDL
ForeignKey FKQCMonReportLogWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_QCMonReportLogWorkGroupDR ];

/// DDL Primary Key Specification
Index PKQCMONREPORTLOG On RowID [ PrimaryKey, SqlName = PK_QC_MONREPORTLOG, Type = index, Unique ];

Index IndexMaster On (MonReportDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexUser On (UserDR, AddDate) [ SqlName = Index_User, Type = index ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexWorkGroup On (WorkGroupDR, AddDate) [ SqlName = Index_WorkGroup, Type = index ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 质控月报
Property MonReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 添加日期
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 添加时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 添加人
Property UserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 操作说明
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 7 ];

/// 操作类型{"10","创建","20":"提交审批","30":"组长审批","40":"完成","11":"组长退回","12":"质控员退回"}
Property OPType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 8 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

/// IP地址
Property IPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="QCMonReportLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MonReportDR</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>UserDR</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>OPType</Value>
</Value>
<Value name="8">
<Value>WorkGroupDR</Value>
</Value>
<Value name="9">
<Value>IPAddress</Value>
</Value>
</Data>
<DataLocation>^dbo.QCMonReportLogD</DataLocation>
<DefaultData>QCMonReportLogDefaultData</DefaultData>
<IdLocation>^dbo.QCMonReportLogD</IdLocation>
<IndexLocation>^dbo.QCMonReportLogI</IndexLocation>
<StreamLocation>^dbo.QCMonReportLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
