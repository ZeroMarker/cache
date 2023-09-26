Class dbo.RPMachinePanicRes Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_MachinePanicRes, StorageStrategy = Default ]
{

Index IndexMaster On (WorkGroupMachineDR, ReceiveDate, AssayNo, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexEpisodeNo On (AssayNo, ReceiveDate) [ SqlName = Index_EpisodeNo, Type = index ];

Index IndexMachine On (OriMachineDR, AssayNo, ReceiveDate) [ SqlName = Index_Machine, Type = index ];

Index IndexTestCode On (AssayNo, TestCodeDR, WorkGroupMachineDR) [ SqlName = Index_TestCode, Type = index ];

Index IndexAssayNoWGM On (AssayNo, WorkGroupMachineDR) [ SqlName = Index_AssayNoWGM, Type = index ];

/// Foreign Key FKMachinePanicResWorkGroup created via DDL
ForeignKey FKMachinePanicResWorkGroup(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_MachinePanicResWorkGroup ];

/// Foreign Key FKMachinePanicResTC created via DDL
ForeignKey FKMachinePanicResTC(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_MachinePanicResTC ];

/// Foreign Key FKMachinePanicResVerifyUserDR created via DDL
ForeignKey FKMachinePanicResVerifyUserDR(VerifyUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MachinePanicResVerifyUserDR ];

/// Foreign Key FKMachinePanicResAuthUserDR created via DDL
ForeignKey FKMachinePanicResAuthUserDR(AuthUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MachinePanicResAuthUserDR ];

/// Foreign Key FKMachinePanicResPanicResultDR created via DDL
ForeignKey FKMachinePanicResPanicResultDR(PanicResultDR) References dbo.RPVisitNumberPanicResult(PKRPVISITNUMBERPANICRESULT) [ SqlName = FK_MachinePanicResPanicResultDR ];

/// Foreign Key FKMachinePanicResOriMachineDR created via DDL
ForeignKey FKMachinePanicResOriMachineDR(OriMachineDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachinePanicResOriMachineDR ];

/// Foreign Key FKMachinePanicResChkMachineDR created via DDL
ForeignKey FKMachinePanicResChkMachineDR(ChkMachineDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachinePanicResChkMachineDR ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 工作小组
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 日期
Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 检测号
Property AssayNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 5 ];

/// 检测项目
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 结果
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 7 ];

/// 定性结果
Property TextRes As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 8 ];

/// 发生日期
Property OccurDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 发生时间
Property OccurTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 预警日期
Property WarnDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 预警时间
Property WarnTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 复查结果
Property ChkResult As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 13 ];

/// 复查定性结果
Property ChkTextRes As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 14 ];

/// 复查结果日期
Property ChkDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 复查结果时间
Property ChkTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 复核日期
Property VerifyDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 复核时间
Property VerifyTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 复核用户
Property VerifyUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 审核日期
Property AuthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 审核时间
Property AuthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 审核用户
Property AuthUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 状态：{1:待复查，2：待确认，3：已确认,4:已审核}
Property Status As %Library.TinyInt [ SqlColumnNumber = 23 ];

/// 危急报告结果ID
Property PanicResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 结果选择标记：{0:原始结果，1：复查结果}
Property ResType As %Library.TinyInt [ SqlColumnNumber = 25 ];

/// 原始仪器
Property OriMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

/// 复查仪器
Property ChkMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

Storage Default
{
<Data name="RPMachinePanicResDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>ReceiveDate</Value>
</Value>
<Value name="4">
<Value>AssayNo</Value>
</Value>
<Value name="5">
<Value>TestCodeDR</Value>
</Value>
<Value name="6">
<Value>Result</Value>
</Value>
<Value name="7">
<Value>TextRes</Value>
</Value>
<Value name="8">
<Value>OccurDate</Value>
</Value>
<Value name="9">
<Value>OccurTime</Value>
</Value>
<Value name="10">
<Value>WarnDate</Value>
</Value>
<Value name="11">
<Value>WarnTime</Value>
</Value>
<Value name="12">
<Value>ChkResult</Value>
</Value>
<Value name="13">
<Value>ChkTextRes</Value>
</Value>
<Value name="14">
<Value>ChkDate</Value>
</Value>
<Value name="15">
<Value>ChkTime</Value>
</Value>
<Value name="16">
<Value>VerifyDate</Value>
</Value>
<Value name="17">
<Value>VerifyTime</Value>
</Value>
<Value name="18">
<Value>VerifyUserDR</Value>
</Value>
<Value name="19">
<Value>AuthDate</Value>
</Value>
<Value name="20">
<Value>AuthTime</Value>
</Value>
<Value name="21">
<Value>AuthUserDR</Value>
</Value>
<Value name="22">
<Value>Status</Value>
</Value>
<Value name="23">
<Value>PanicResultDR</Value>
</Value>
<Value name="24">
<Value>ResType</Value>
</Value>
<Value name="25">
<Value>OriMachineDR</Value>
</Value>
<Value name="26">
<Value>ChkMachineDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMachinePanicResD</DataLocation>
<DefaultData>RPMachinePanicResDefaultData</DefaultData>
<IdLocation>^dbo.RPMachinePanicResD</IdLocation>
<IndexLocation>^dbo.RPMachinePanicResI</IndexLocation>
<StreamLocation>^dbo.RPMachinePanicResS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
