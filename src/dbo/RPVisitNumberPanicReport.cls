/// 
Class dbo.RPVisitNumberPanicReport Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberPanicReport, StorageStrategy = Default ]
{

/// Foreign Key FKVisitNumberPanicReport created via DDL
ForeignKey FKVisitNumberPanicReport(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_VisitNumberPanicReport ];

/// Foreign Key FKVisitNumberPanicReportAuthUser created via DDL
ForeignKey FKVisitNumberPanicReportAuthUser(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberPanicReportAuthUser ];

/// Foreign Key FKVisitNumberPanicReportCreateUser created via DDL
ForeignKey FKVisitNumberPanicReportCreateUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberPanicReportCreateUser ];

/// Foreign Key FKVisitNumberPanicReportEntryUser created via DDL
ForeignKey FKVisitNumberPanicReportEntryUser(EntryUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberPanicReportEntryUser ];

/// Foreign Key FKVisitNumberPanicReportWorkGroup created via DDL
ForeignKey FKVisitNumberPanicReportWorkGroup(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_VisitNumberPanicReportWorkGroup ];

/// Foreign Key FKVisitNumberPanicReportAuthUser created via DDL
ForeignKey FKVisitNumberPanicReportCancelUserDR(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberPanicReportCancelUserDR ];

Index IndexAuthUser On (AuthDate, AuthUserDR) [ SqlName = Index_AuthUser, Type = index ];

Index IndexMaster On (VisitNumberDR, AddDate, AddTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexReportID On (VisitNumberReportID, AddDate, AddTime) [ SqlName = Index_ReportID, Type = index ];

Index IndexWorkGroupMachine On (WorkGroupMachineDR, AuthDate) [ SqlName = Index_WorkGroupMachine, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERPANICREPORT On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERPANICREPORT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本*
Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 工作小组*
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 创建日期*
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 创建时间*
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 创建者
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 初核日期
Property EntryDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 初核时间
Property EntryTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 初核者
Property EntryUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 审核日期
Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 审核时间
Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 审核者
Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 报告主评价
Property MajorConclusion As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 14 ];

/// 报告次评价
Property MinorConclusion As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 15 ];

/// 是否完成阅读
Property Readed As %Library.Boolean [ SqlColumnNumber = 16 ];

/// 是否完成通知
Property Notice As %Library.Boolean [ SqlColumnNumber = 17 ];

/// 发送方式
Property SendMode As %Library.String(MAXLEN = 1) [ SqlColumnNumber = 18 ];

/// 接收护士
Property ReceiveNurse As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 19 ];

/// 护士接收日期
Property NurseRecDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 护士接收时间
Property NurseRecTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 接收医生
Property ReceiveDoctor As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 22 ];

/// 医生接收日期
Property DoctorRecDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 医生接收时间
Property DoctorRecTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 医生接收备注
Property DoctorRecRemark As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 25 ];

/// 是否返回LIS
Property IsSendBackToLIS As %Library.Boolean [ SqlColumnNumber = 26 ];

/// 报告ID
Property VisitNumberReportID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

/// 说明
Property Remark As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 28 ];

/// 首次弹框提示日期
Property WarnDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 29 ];

/// 首次弹框提示日期
Property WarnTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

/// 首次弹框提示时间
Property OneSMSDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

/// 一级短信发送日期
Property OneSMSTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

/// 二级短信发送日期
Property TowSMSDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 33 ];

/// 二级短信发送时间
Property TowSMSTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 34 ];

/// 危急值是否撤回
Property IsCancelled As %Library.Boolean [ SqlColumnNumber = 35 ];

/// 危急值撤回人
Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 36 ];

/// 危急值撤回日期
Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 37 ];

/// 危急值撤回时间
Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 38 ];

/// 护士接收备注
Property NurseRecRemark As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 39 ];

/// 危急值撤销意见
Property CancelRemark As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 40 ];

Storage Default
{
<Data name="RPVisitNumberPanicReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>AddUserDR</Value>
</Value>
<Value name="7">
<Value>EntryDate</Value>
</Value>
<Value name="8">
<Value>EntryTime</Value>
</Value>
<Value name="9">
<Value>EntryUserDR</Value>
</Value>
<Value name="10">
<Value>AuthDate</Value>
</Value>
<Value name="11">
<Value>AuthTime</Value>
</Value>
<Value name="12">
<Value>AuthUserDR</Value>
</Value>
<Value name="13">
<Value>MajorConclusion</Value>
</Value>
<Value name="14">
<Value>MinorConclusion</Value>
</Value>
<Value name="15">
<Value>Readed</Value>
</Value>
<Value name="16">
<Value>Notice</Value>
</Value>
<Value name="17">
<Value>SendMode</Value>
</Value>
<Value name="18">
<Value>ReceiveNurse</Value>
</Value>
<Value name="19">
<Value>NurseRecDate</Value>
</Value>
<Value name="20">
<Value>NurseRecTime</Value>
</Value>
<Value name="21">
<Value>ReceiveDoctor</Value>
</Value>
<Value name="22">
<Value>DoctorRecDate</Value>
</Value>
<Value name="23">
<Value>DoctorRecTime</Value>
</Value>
<Value name="24">
<Value>DoctorRecRemark</Value>
</Value>
<Value name="25">
<Value>IsSendBackToLIS</Value>
</Value>
<Value name="26">
<Value>VisitNumberReportID</Value>
</Value>
<Value name="27">
<Value>Remark</Value>
</Value>
<Value name="28">
<Value>WarnDate</Value>
</Value>
<Value name="29">
<Value>WarnTime</Value>
</Value>
<Value name="30">
<Value>OneSMSDate</Value>
</Value>
<Value name="31">
<Value>OneSMSTime</Value>
</Value>
<Value name="32">
<Value>TowSMSDate</Value>
</Value>
<Value name="33">
<Value>TowSMSTime</Value>
</Value>
<Value name="34">
<Value>IsCancelled</Value>
</Value>
<Value name="35">
<Value>CancelUserDR</Value>
</Value>
<Value name="36">
<Value>CancelDate</Value>
</Value>
<Value name="37">
<Value>CancelTime</Value>
</Value>
<Value name="38">
<Value>NurseRecRemark</Value>
</Value>
<Value name="39">
<Value>CancelRemark</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberPanicReportD</DataLocation>
<DefaultData>RPVisitNumberPanicReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberPanicReportD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberPanicReportI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberPanicReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
