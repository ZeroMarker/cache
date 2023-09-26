/// 鉴定日志
Class dbo.IDPResultLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = IDP_ResultLog ]
{

/// Foreign Key FKIDPResultLogVisitNumberReportDR created via DDL
ForeignKey FKIDPResultLogVisitNumberReportDR(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_IDPResultLogVisitNumberReportDR ];

/// Foreign Key FKIDPResultLogOperUserDR created via DDL
ForeignKey FKIDPResultLogOperUserDR(OperUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_IDPResultLogOperUserDR ];

/// DDL Primary Key Specification
Index PKIDPRESULTLOG On RowID [ PrimaryKey, SqlName = PK_IDP_RESULTLOG, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 报告
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 操作
Property Oper As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 4 ];

/// 操作说明
Property OperRemark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 5 ];

/// 操作者
Property OperUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 操作日期
Property OperDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 操作时间
Property OperTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Storage Default
{
<Data name="IDPResultLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>Oper</Value>
</Value>
<Value name="4">
<Value>OperRemark</Value>
</Value>
<Value name="5">
<Value>OperUserDR</Value>
</Value>
<Value name="6">
<Value>OperDate</Value>
</Value>
<Value name="7">
<Value>OperTime</Value>
</Value>
</Data>
<DataLocation>^dbo.IDPResultLogD</DataLocation>
<DefaultData>IDPResultLogDefaultData</DefaultData>
<IdLocation>^dbo.IDPResultLogD</IdLocation>
<IndexLocation>^dbo.IDPResultLogI</IndexLocation>
<StreamLocation>^dbo.IDPResultLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
