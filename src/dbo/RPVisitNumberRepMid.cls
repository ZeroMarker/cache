/// 中间报告
Class dbo.RPVisitNumberRepMid Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberRepMid, StorageStrategy = Default ]
{

/// Foreign Key FKVisitNumberRepMid created via DDL
ForeignKey FKVisitNumberRepMid(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_VisitNumberRepMid ];

/// Foreign Key FKVisitNumberRepMidAUser created via DDL
ForeignKey FKVisitNumberRepMidAUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberRepMidAUser ];

/// Foreign Key FKVisitNumberRepMidEUser created via DDL
ForeignKey FKVisitNumberRepMidEUser(EntryUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberRepMidEUser ];

Index IndexAuthDate On AuthDate [ SqlName = Index_AuthDate, Type = index ];

Index IndexMidReport On (VisitNumberReportDR, OrderNo) [ SqlName = Index_MidReport, Type = index, Unique ];

Index IndexMaster On (VisitNumberReportDR, Status) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERREPMID On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERREPMID, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本报告  
Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 序号  
Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 初审日期  
Property EntryDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 初审时间  
Property EntryTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 初审者  
Property EntryUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 审核日期  
Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 审核时间  
Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 审核者  
Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 报告状态  {1:初审,2:审核,3:取消审核}
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 11 ];

/// 审核方式  
Property AuthType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 12 ];

/// 是否阅读  {1:true,0:false}
Property Readed As %Library.Boolean [ SqlColumnNumber = 13 ];

/// 首次阅读日期  
Property FirstReadDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 首次阅读时间  
Property FirstReadTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 首次阅读医生  
Property FirstReadDoctorID As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 16 ];

/// 报告主评价  
Property MajorConclusion As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 17 ];

/// 提示信息  
Property PromptMessage As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="RPVisitNumberRepMidDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="3">
<Value>OrderNo</Value>
</Value>
<Value name="4">
<Value>EntryDate</Value>
</Value>
<Value name="5">
<Value>EntryTime</Value>
</Value>
<Value name="6">
<Value>EntryUserDR</Value>
</Value>
<Value name="7">
<Value>AuthDate</Value>
</Value>
<Value name="8">
<Value>AuthTime</Value>
</Value>
<Value name="9">
<Value>AuthUserDR</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>AuthType</Value>
</Value>
<Value name="12">
<Value>Readed</Value>
</Value>
<Value name="13">
<Value>FirstReadDate</Value>
</Value>
<Value name="14">
<Value>FirstReadTime</Value>
</Value>
<Value name="15">
<Value>FirstReadDoctorID</Value>
</Value>
<Value name="16">
<Value>MajorConclusion</Value>
</Value>
<Value name="17">
<Value>PromptMessage</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberRepMidD</DataLocation>
<DefaultData>RPVisitNumberRepMidDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberRepMidD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberRepMidI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberRepMidS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
