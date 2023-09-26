/// 报告签名数据
Class dbo.RPVisitNumberReportSign Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberReportSign, StorageStrategy = Default ]
{

/// Foreign Key FKVisitNumberReportSign created via DDL
ForeignKey FKVisitNumberReportSign(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_VisitNumberReportSign ];

Index IndexDate On (SignDate, AuthType) [ SqlName = Index_Date, Type = index ];

Index IndexMaster On (VisitNumberReportDR, AuthType, OrderNo) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERREPORTSIGN On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERREPORTSIGN, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本报告  
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 审核类型  {E:初审,A:审核}
Property AuthType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 签名字符串  
Property DigitSignString As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 6 ];

/// 签名时间戳  
Property DigitSignTime As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 7 ];

/// 原始结果  
Property ReportData As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 8 ];

/// 签名日期  
Property SignDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 签名时间  
Property SignTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 签名用户KEY  
Property SignUserKey As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="RPVisitNumberReportSignDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>AuthType</Value>
</Value>
<Value name="4">
<Value>OrderNo</Value>
</Value>
<Value name="5">
<Value>DigitSignString</Value>
</Value>
<Value name="6">
<Value>DigitSignTime</Value>
</Value>
<Value name="7">
<Value>ReportData</Value>
</Value>
<Value name="8">
<Value>SignDate</Value>
</Value>
<Value name="9">
<Value>SignTime</Value>
</Value>
<Value name="10">
<Value>SignUserKey</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberReportSignD</DataLocation>
<DefaultData>RPVisitNumberReportSignDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberReportSignD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberReportSignI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberReportSignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
