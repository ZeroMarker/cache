Class dbo.RPVisitNumberMultiResist Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberMultiResist ]
{

/// Foreign Key FKVisitNumberMultiResistResult created via DDL
ForeignKey FKVisitNumberMultiResistResult(VisitNumberReportResultDR) References dbo.RPVisitNumberReportResult(PKRPVISITNUMBERREPORTRESULT) [ SqlName = FK_VisitNumberMultiResistResult ];

/// Foreign Key FKVisitNumberMultiResistCreateUser created via DDL
ForeignKey FKVisitNumberMultiResistCreateUser(CreateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberMultiResistCreateUser ];

/// Foreign Key FKVisitNumberMultiResistWGMachine created via DDL
ForeignKey FKVisitNumberMultiResistWGMachine(WGMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_VisitNumberMultiResistWGMachine ];

/// Foreign Key FKVisitNumberMultiResistOrganism created via DDL
ForeignKey FKVisitNumberMultiResistOrganism(OrganismDR) References dbo.BTOrganism(PKBTORGANISM) [ SqlName = FK_VisitNumberMultiResistOrganism ];

/// Foreign Key FKVisitNumberMultiResistCallUserDR created via DDL 
ForeignKey FKVisitNumberMultiResistCallUserDR(CallUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberMultiResistCallUserDR ];

/// Foreign Key FKVisitNumberMultiResistCancelTypeDR created via DDL 
ForeignKey FKVisitNumberMultiResistCancelTypeDR(CancelTypeDR) References dbo.BTMultiResistCancelType(PKBTMULTIRESISTCANCELTYPE) [ SqlName = FK_VisitNumberMultiResistCancelTypeDR ];

Index IndexMaster On (VisitNumberReportResultDR, CreateDate, CreateTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexStatus On (Status, SendStatus) [ SqlName = Index_Status, Type = index ];

Index IndexCreateDate On CreateDate [ SqlName = Index_CreateDate, Type = index ];

Index IndexWGMachine On (WGMachineDR, CreateDate) [ SqlName = Index_WGMachine, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERMULTIRESIST On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERMULTIRESIST, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 报告结果*
Property VisitNumberReportResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 创建日期*
Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 创建时间*
Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 创建用户
Property CreateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 发送消息平台日期
Property SendDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 发送消息平台时间
Property SendTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 发送消息平台是否成功
Property SendStatus As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 消息平台预警弹框日期
Property AlarmDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 消息平台预警弹框时间
Property AlarmTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 工作小组
Property WGMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 细菌
Property OrganismDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 多耐结果
Property TextRes As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 14 ];

/// 状态 C取消，A审核  S 网络上报 P电话上报 B 网络加电话上报 N不需上报
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 15 ];

/// 临床护士处理日期
Property NurseDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 临床护士处理时间
Property NurseTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 临床护士处理人员
Property NurseCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 18 ];

/// 临床护士处理意见
Property NurseRemark As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 19 ];

/// 临床医生处理日期
Property DoctorDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 临床医生处理时间
Property DoctorTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 临床医生处理人员
Property DoctorCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 22 ];

/// 临床医生处理意见
Property DoctorRemark As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 23 ];

/// 电话日期
Property PhoneDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 电话时间
Property PhoneTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 电话人员
Property PhoneCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 26 ];

/// 电话结果
Property PhoneRemark As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 27 ];

/// 处理是否完成
Property Finish As %Library.Boolean [ SqlColumnNumber = 28 ];

/// 多耐说明
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 29 ];

/// 打电话人
Property CallUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

/// 电话
Property Phone As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 31 ];

/// 再次电话日期
Property RePhoneDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 32 ];

/// 再次电话时间
Property RePhoneTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 33 ];

/// 再次电话人员
Property RePhoneCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 34 ];

/// 再次电话结果
Property RePhoneRemark As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 35 ];

/// 再次打电话人
Property ReCallUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 36 ];

/// 再次电话
Property RePhone As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 37 ];

/// 取消类型
Property CancelTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 38 ];

/// 取消说明
Property CancelRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 39 ];

Storage Default
{
<Data name="RPVisitNumberMultiResistDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberReportResultDR</Value>
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
<Value>SendDate</Value>
</Value>
<Value name="7">
<Value>SendTime</Value>
</Value>
<Value name="8">
<Value>SendStatus</Value>
</Value>
<Value name="9">
<Value>AlarmDate</Value>
</Value>
<Value name="10">
<Value>AlarmTime</Value>
</Value>
<Value name="11">
<Value>WGMachineDR</Value>
</Value>
<Value name="12">
<Value>OrganismDR</Value>
</Value>
<Value name="13">
<Value>TextRes</Value>
</Value>
<Value name="14">
<Value>Status</Value>
</Value>
<Value name="15">
<Value>NurseDate</Value>
</Value>
<Value name="16">
<Value>NurseTime</Value>
</Value>
<Value name="17">
<Value>NurseCode</Value>
</Value>
<Value name="18">
<Value>NurseRemark</Value>
</Value>
<Value name="19">
<Value>DoctorDate</Value>
</Value>
<Value name="20">
<Value>DoctorTime</Value>
</Value>
<Value name="21">
<Value>DoctorCode</Value>
</Value>
<Value name="22">
<Value>DoctorRemark</Value>
</Value>
<Value name="23">
<Value>PhoneDate</Value>
</Value>
<Value name="24">
<Value>PhoneTime</Value>
</Value>
<Value name="25">
<Value>PhoneCode</Value>
</Value>
<Value name="26">
<Value>PhoneRemark</Value>
</Value>
<Value name="27">
<Value>Finish</Value>
</Value>
<Value name="28">
<Value>Remark</Value>
</Value>
<Value name="29">
<Value>CallUserDR</Value>
</Value>
<Value name="30">
<Value>Phone</Value>
</Value>
<Value name="31">
<Value>RePhoneDate</Value>
</Value>
<Value name="32">
<Value>RePhoneTime</Value>
</Value>
<Value name="33">
<Value>RePhoneCode</Value>
</Value>
<Value name="34">
<Value>RePhoneRemark</Value>
</Value>
<Value name="35">
<Value>ReCallUserDR</Value>
</Value>
<Value name="36">
<Value>RePhone</Value>
</Value>
<Value name="37">
<Value>CancelTypeDR</Value>
</Value>
<Value name="38">
<Value>CancelRemark</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberMultiResistD</DataLocation>
<DefaultData>RPVisitNumberMultiResistDefaultData</DefaultData>
<IdLocation>^dbo.RPVisitNumberMultiResistD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberMultiResistI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberMultiResistS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
