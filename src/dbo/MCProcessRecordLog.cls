/// 鉴定过程日志
Class dbo.MCProcessRecordLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = MC_ProcessRecordLog ]
{

/// Foreign Key FKMCProcessRecordLogActUserDR created via DDL
ForeignKey FKMCProcessRecordLogActUserDR(ActUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MCProcessRecordLogActUserDR ];

Index IndexVisitNumberReportID On (VisitNumberReportID, ActDate, ActTime) [ SqlName = Index_VisitNumberReportID, Type = index ];

/// DDL Primary Key Specification
Index PKMCPROCESSRECORDLOG On RowID [ PrimaryKey, SqlName = PK_MC_PROCESSRECORDLOG, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 报告主键
Property VisitNumberReportID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 操作
Property Oper As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

/// 操作信息
Property OperInfo As %Library.String(COLLATION = "Exact", MAXLEN = 2000) [ SqlColumnNumber = 5 ];

/// 操作人
Property ActUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 操作日期
Property ActDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 操作时间
Property ActTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Storage Default
{
<Data name="MCProcessRecordLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportID</Value>
</Value>
<Value name="3">
<Value>Oper</Value>
</Value>
<Value name="4">
<Value>OperInfo</Value>
</Value>
<Value name="5">
<Value>ActUserDR</Value>
</Value>
<Value name="6">
<Value>ActDate</Value>
</Value>
<Value name="7">
<Value>ActTime</Value>
</Value>
</Data>
<DataLocation>^dbo.MCProcessRecordLogD</DataLocation>
<DefaultData>MCProcessRecordLogDefaultData</DefaultData>
<IdLocation>^dbo.MCProcessRecordLogD</IdLocation>
<IndexLocation>^dbo.MCProcessRecordLogI</IndexLocation>
<StreamLocation>^dbo.MCProcessRecordLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
