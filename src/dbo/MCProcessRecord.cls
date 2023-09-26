///     
Class dbo.MCProcessRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = MC_ProcessRecord, StorageStrategy = Default ]
{

Index IndexActDate On ActDate [ SqlName = Index_ActDate, Type = index ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexDataMaster On (VisitNumberReportDR, OrderNo) [ SqlName = Index_DataMaster, Type = index ];

Index IndexMethodDR On (VisitNumberReportDR, MethodDR) [ SqlName = Index_MethodDR, Type = index ];

Index IndexReportDate On (VisitNumberReportDR, ActDate) [ SqlName = Index_ReportDate, Type = index ];

Index IndexOrgIndentify On OrgIndentifyDR [ SqlName = Index_OrgIndentify, Type = index ];

Index IndexProcessActDate On (ProcessDR, ActDate) [ SqlName = Index_ProcessActDate, Type = index ];

/// DDL Primary Key Specification
Index PKMCPROCESSRECORD On RowID [ PrimaryKey, SqlName = PK_MC_PROCESSRECORD, Type = index, Unique ];

/// Foreign Key FKMCPRActUser created via DDL
ForeignKey FKMCPRActUser(ActUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MC_PR_ActUser ];

/// Foreign Key FKMCPRAddUser created via DDL
ForeignKey FKMCPRAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MC_PR_AddUser ];

/// Foreign Key FKMCPREndUser created via DDL
ForeignKey FKMCPREndUser(EndUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MC_PR_EndUser ];

/// Foreign Key FKMCPRMethod created via DDL
ForeignKey FKMCPRMethod(MethodDR) References dbo.BTMCMethod(PKBTMCMETHOD) [ SqlName = FK_MC_PR_Method ];

/// Foreign Key FKMCPROrgIndentify created via DDL
ForeignKey FKMCPROrgIndentify(OrgIndentifyDR) References dbo.MCOrgIndentify(PKMCORGINDENTIFY) [ SqlName = FK_MC_PR_OrgIndentify ];

/// Foreign Key FKMCPRProcess created via DDL
ForeignKey FKMCPRProcess(ProcessDR) References dbo.BTMCProcess(PKBTMCPROCESS) [ SqlName = FK_MC_PR_Process ];

/// Foreign Key FKMCPRVNReport created via DDL
ForeignKey FKMCPRVNReport(VisitNumberReportDR) References dbo.RPVisitNumberReport(PKRPVISITNUMBERREPORT) [ SqlName = FK_MC_PR_VNReport ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ProcessDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 128) [ SqlColumnNumber = 6 ];

Property MethodDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 255) [ SqlColumnNumber = 8 ];

Property OrgIndentifyDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property Memo As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

Property State As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property AddType As %Library.Boolean [ SqlColumnNumber = 12 ];

Property IsOther As %Library.Boolean [ SqlColumnNumber = 13 ];

Property ActUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 14 ];

Property ActDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 15 ];

Property ActTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 16 ];

Property EndUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property EndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 20 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 21 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 22 ];

/// 是否离心
Property HasCentrifugal As %Library.Boolean [ SqlColumnNumber = 23 ];

// 是否复查

Property HasRecheck As %Library.Boolean [ SqlColumnNumber = 24 ];

/// 复查方式（鉴定，药敏）
Property RecheckWayBTDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 复查备注
Property RecheckMemo As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 26 ];

/// 确认菌
Property ConfirmedOrg As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 27 ];

/// 确认菌名称
Property ConfirmedOrgName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 28 ];

/// 确认菌项目
Property ConfirmedOrgTestCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 29 ];

Storage Default
{
<Data name="MCProcessRecordDefaultData">
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
<Value>ProcessDR</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>MethodDR</Value>
</Value>
<Value name="7">
<Value>Result</Value>
</Value>
<Value name="8">
<Value>OrgIndentifyDR</Value>
</Value>
<Value name="9">
<Value>Memo</Value>
</Value>
<Value name="10">
<Value>State</Value>
</Value>
<Value name="11">
<Value>AddType</Value>
</Value>
<Value name="12">
<Value>IsOther</Value>
</Value>
<Value name="13">
<Value>ActUserDR</Value>
</Value>
<Value name="14">
<Value>ActDate</Value>
</Value>
<Value name="15">
<Value>ActTime</Value>
</Value>
<Value name="16">
<Value>EndUserDR</Value>
</Value>
<Value name="17">
<Value>EndDate</Value>
</Value>
<Value name="18">
<Value>EndTime</Value>
</Value>
<Value name="19">
<Value>AddUserDR</Value>
</Value>
<Value name="20">
<Value>AddDate</Value>
</Value>
<Value name="21">
<Value>AddTime</Value>
</Value>
<Value name="22">
<Value>HasCentrifugal</Value>
</Value>
<Value name="23">
<Value>HasRecheck</Value>
</Value>
<Value name="24">
<Value>RecheckWayBTDR</Value>
</Value>
<Value name="25">
<Value>RecheckMemo</Value>
</Value>
<Value name="26">
<Value>ConfirmedOrg</Value>
</Value>
<Value name="27">
<Value>ConfirmedOrgName</Value>
</Value>
<Value name="28">
<Value>ConfirmedOrgTestCode</Value>
</Value>
</Data>
<DataLocation>^dbo.MCProcessRecordD</DataLocation>
<DefaultData>MCProcessRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.MCProcessRecordD</IdLocation>
<IndexLocation>^dbo.MCProcessRecordI</IndexLocation>
<StreamLocation>^dbo.MCProcessRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
