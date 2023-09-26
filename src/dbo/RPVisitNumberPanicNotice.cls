/// 危急值说明
Class dbo.RPVisitNumberPanicNotice Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberPanicNotice, StorageStrategy = Default ]
{

/// Foreign Key FKVisitNumberPanicReportNotice created via DDL
ForeignKey FKVisitNumberPanicReportNotice(VisitNumberReportPanicDR) References dbo.RPVisitNumberPanicReport(PKRPVISITNUMBERPANICREPORT) [ SqlName = FK_VisitNumberPanicReportNotice ];

/// Foreign Key FKVisitNumberPanicReportNoticeCreateUser created via DDL
ForeignKey FKVisitNumberPanicReportNoticeCreateUser(CreateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberPanicReportNoticeCreateUser ];

/// Foreign Key FKVisitNumberPanicReportNoticeCreateUser created via DDL
ForeignKey FKVisitNumberPanicReportNoticeUpdateUser(UpdateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberPanicReportNoticeUpdateUser ];

Index IndexMaster On (VisitNumberReportPanicDR, CreateDate, CreateTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexNoticeDate On NoticeDate [ SqlName = Index_NoticeDate, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERPANICNOTICE On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERPANICNOTICE, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本危急报告  
Property VisitNumberReportPanicDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 创建日期  
Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 创建时间  
Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 创建用户  
Property CreateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 通知日期  
Property NoticeDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 通知时间  
Property NoticeTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 通知临床人员  
Property MedicalStaff As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 9 ];

/// 通知临床电话  
Property MedicalPhone As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 10 ];

/// 通知人  
Property NoticePatient As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// 通知电话  
Property NoticePhone As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 12 ];

/// 通知结果  
Property NoticeNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 13 ];

/// 处理是否完成  {1:true,0:false}
Property Finish As %Library.Boolean [ SqlColumnNumber = 14 ];

/// IsSendBackToLIS  {1:true,0:false}
Property IsSendBackToLIS As %Library.Boolean [ SqlColumnNumber = 15 ];

/// ReDealUserDR  
Property ReDealUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// ReDealDate  
Property ReDealDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// ReDealTime  
Property ReDealTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// ReDealNotes  
Property ReDealNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 19 ];

/// ReDealToPerson  
Property ReDealToPerson As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 20 ];

/// ReDealPhoneNo  
Property ReDealPhoneNo As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 21 ];

/// 打电话人  
Property CallUser As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 22 ];

/// 打电话日期  
Property CallDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 打电话时间  
Property CallTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// IsSendBackToLIS  {1:true,0:false}
Property IsRepeat As %Library.Boolean [ SqlColumnNumber = 25 ];

/// UpdateUserDR  
Property UpdateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

/// UpdateDate  
Property UpdateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

/// UpdateTime  
Property UpdateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 28 ];

Storage Default
{
<Data name="RPVisitNumberPanicNoticeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportPanicDR</Value>
</Value>
<Value name="3">
<Value>CreateDate</Value>
</Value>
<Value name="4">
<Value>CreateTime</Value>
</Value>
<Value name="5">
<Value>CreateUserDR</Value>
</Value>
<Value name="6">
<Value>NoticeDate</Value>
</Value>
<Value name="7">
<Value>NoticeTime</Value>
</Value>
<Value name="8">
<Value>MedicalStaff</Value>
</Value>
<Value name="9">
<Value>MedicalPhone</Value>
</Value>
<Value name="10">
<Value>NoticePatient</Value>
</Value>
<Value name="11">
<Value>NoticePhone</Value>
</Value>
<Value name="12">
<Value>NoticeNotes</Value>
</Value>
<Value name="13">
<Value>Finish</Value>
</Value>
<Value name="14">
<Value>IsSendBackToLIS</Value>
</Value>
<Value name="15">
<Value>ReDealUserDR</Value>
</Value>
<Value name="16">
<Value>ReDealDate</Value>
</Value>
<Value name="17">
<Value>ReDealTime</Value>
</Value>
<Value name="18">
<Value>ReDealNotes</Value>
</Value>
<Value name="19">
<Value>ReDealToPerson</Value>
</Value>
<Value name="20">
<Value>ReDealPhoneNo</Value>
</Value>
<Value name="21">
<Value>CallUser</Value>
</Value>
<Value name="22">
<Value>CallDate</Value>
</Value>
<Value name="23">
<Value>CallTime</Value>
</Value>
<Value name="24">
<Value>IsRepeat</Value>
</Value>
<Value name="25">
<Value>UpdateUserDR</Value>
</Value>
<Value name="26">
<Value>UpdateDate</Value>
</Value>
<Value name="27">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberPanicNoticeD</DataLocation>
<DefaultData>RPVisitNumberPanicNoticeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberPanicNoticeD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberPanicNoticeI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberPanicNoticeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
