Class User.DHCRegistrationFee Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCRegistrationFee ]
{

Index ADM On RegfeeAdmDr;

Index RBASDr On RegfeeRBASDr;

Property RegfeeAdmDr As PAAdm [ SqlColumnNumber = 2 ];

Property RegfeeArcDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property RegfeeArcPrice As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property RegfeeBespFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 挂号日期
Property RegfeeDate As %Date [ SqlColumnNumber = 6 ];

/// 挂号科室
Property RegfeeDepDr As CTLoc [ SqlColumnNumber = 7 ];

Property RegfeeDoFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// 挂号医生
Property RegfeeDocDr As CTCareProv [ SqlColumnNumber = 9 ];

Property RegfeeLookPrice As %String(TRUNCATE = 1) [ SqlColumnNumber = 10 ];

Property RegfeeName As %String(TRUNCATE = 1) [ SqlColumnNumber = 11 ];

/// 排号
Property RegfeeNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 12 ];

Property RegfeePrint As %String(TRUNCATE = 1) [ SqlColumnNumber = 13 ];

/// 排班记录
Property RegfeeRBASDr As RBApptSchedule [ SqlColumnNumber = 14 ];

/// 诊室
Property RegfeeRoomDr As CTLoc [ SqlColumnNumber = 15 ];

/// 就诊号级别
Property RegfeeSessionTypeDr As RBCSessionType [ SqlColumnNumber = 16 ];

Property RegfeeTime As %Time [ SqlColumnNumber = 17 ];

/// 时段
Property RegfeeTimeRangeDr As DHCTimeRange [ SqlColumnNumber = 18 ];

Property RegfeeUserDr As SSUser [ SqlColumnNumber = 19 ];

/// 发票RowId
Property Regfeetemp1 As DHCINVPRT [ SqlColumnNumber = 20 ];

Property Regfeetemp2 As %String(TRUNCATE = 1) [ SqlColumnNumber = 21 ];

/// 转诊纪录
Property RegTransferFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 22 ];

Property RegTransferReDoc As CTCareProv [ SqlColumnNumber = 23 ];

Property RegfeeInsuAdmDr As PAAdm [ SqlColumnNumber = 24 ];

/// 现金支付(医保)
Property RegfeeInsuCash As %String(TRUNCATE = 1) [ SqlColumnNumber = 25 ];

/// 账户支付(医保)
Property RegfeeInsuCount As %String(TRUNCATE = 1) [ SqlColumnNumber = 26 ];

/// 基金支付(医保)
Property RegfeeInsuFund As %String(TRUNCATE = 1) [ SqlColumnNumber = 27 ];

/// 统筹支付(医保)
Property RegfeeInsuOverallPlanning As %String(TRUNCATE = 1) [ SqlColumnNumber = 28 ];

/// 其他支付(医保)
Property RegfeeInsuOther As %String(TRUNCATE = 1) [ SqlColumnNumber = 29 ];

/// 保险公司(保险)
Property RegfeeInsuCoDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 30 ];

/// 自付比例(保险)
Property RegfeeInsuCoProDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 31 ];

/// 自负比例付款金额(保险)
Property RegfeeInsuCoPatPay As %String(TRUNCATE = 1) [ SqlColumnNumber = 32 ];

/// 打印用户
Property RegfeePrintUserDR As SSUser [ SqlColumnNumber = 33 ];

/// 打印日期
Property RegfeePrintDate As %Date [ SqlColumnNumber = 34 ];

/// 打印时间
Property RegfeePrintTime As %Time [ SqlColumnNumber = 35 ];

/// 取票结算关联
Property RegfeeInvReportDR As User.DHCINVPRTReports [ SqlColumnNumber = 36 ];

/// 取票结算用户
Property RegfeeHandinUserDR As SSUser [ SqlColumnNumber = 37 ];

/// 取票结算日期
Property RegfeeHandinDate As %Date [ SqlColumnNumber = 38 ];

/// 取票结算时间
Property RegfeeHandinTime As %Time [ SqlColumnNumber = 39 ];

/// 预约方式来源的序号,用于在挂号重新排序后的序号.适用不改变原来的序号规则,重新产生客户化的排序序号
Property RegfeeMethodSeqNo As %String [ SqlColumnNumber = 40 ];

/// 交易流水号,用于第三方接口的交易流水号存储
Property RegfeeTransactionId As %String [ SqlColumnNumber = 41 ];

/// 计算字段,方便外键关联查询
Property RegfeeAdmDrSql As PAAdm [ SqlColumnNumber = 42, SqlComputeCode = {s {RegfeeAdmDrSql}={RegfeeAdmDr}}, SqlComputed, SqlComputeOnChange = RegfeeAdmDr, SqlFieldName = RegfeeAdmDrSql, Transient ];

/// 计算字段,方便外键关联查询
Property RegfeeDepDrSql As CTLoc [ SqlColumnNumber = 43, SqlComputeCode = {s {RegfeeDepDrSql}={RegfeeDepDr}}, SqlComputed, SqlComputeOnChange = RegfeeDepDr, SqlFieldName = RegfeeDepDrSql, Transient ];

/// 计算字段,方便外键关联查询
Property RegfeeDocDrSql As CTCareProv [ SqlColumnNumber = 44, SqlComputeCode = {s {RegfeeDocDrSql}={RegfeeDocDr}}, SqlComputed, SqlComputeOnChange = RegfeeDocDr, SqlFieldName = RegfeeDocDrSql, Transient ];

/// 计算字段,方便外键关联查询
Property RegfeeRBASDrSql As RBApptSchedule [ SqlColumnNumber = 45, SqlComputeCode = {s {RegfeeRBASDrSql}={RegfeeRBASDr}}, SqlComputed, SqlComputeOnChange = RegfeeRBASDr, SqlFieldName = RegfeeRBASDrSql, Transient ];

/// 计算字段,方便外键关联查询
Property RegfeeINVSql As DHCINVPRT [ SqlColumnNumber = 46, SqlComputeCode = {s {RegfeeINVSql}={Regfeetemp1}}, SqlComputed, SqlComputeOnChange = Regfeetemp1, SqlFieldName = RegfeeINVSql, Transient ];

/// 开启报到产生队列号后产生的号
Property RegfeeCreatNewSeqNo As %String [ SqlColumnNumber = 47 ];

/// 开启迟到产生惩罚的号
Property RegfeeCreatDelaySeqNo As %String [ SqlColumnNumber = 48 ];

/// 开启过号惩罚产生的号
Property RegfeeCreatCallDelaySeqNo As %String [ SqlColumnNumber = 49 ];

/// 分时段时间
Property RegfeeAPPRangeTime As %String [ SqlColumnNumber = 50 ];

/// 亚专业
Property RegfeeClinicGroupDR As RBCClinicGroup [ SqlColumnNumber = 51 ];

Index PrintDate On RegfeePrintDate;

Index PrintUserDate On (RegfeePrintUserDR, RegfeePrintDate);

Index InvReportDR On RegfeeInvReportDR;

Index HandinDate On RegfeeHandinDate;

Index HandinUserDate On (RegfeeHandinUserDR, RegfeeHandinDate);

Index RegDate On RegfeeDate;

Storage Default
{
<Data name="DHCRegistrationFeeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RegfeeAdmDr</Value>
</Value>
<Value name="3">
<Value>RegfeeArcDr</Value>
</Value>
<Value name="4">
<Value>RegfeeArcPrice</Value>
</Value>
<Value name="5">
<Value>RegfeeBespFlag</Value>
</Value>
<Value name="6">
<Value>RegfeeDoFlag</Value>
</Value>
<Value name="7">
<Value>RegfeeName</Value>
</Value>
<Value name="8">
<Value>RegfeeNo</Value>
</Value>
<Value name="9">
<Value>RegfeeLookPrice</Value>
</Value>
<Value name="10">
<Value>RegfeePrint</Value>
</Value>
<Value name="11">
<Value>Regfeetemp1</Value>
</Value>
<Value name="12">
<Value>Regfeetemp2</Value>
</Value>
<Value name="13">
<Value>RegfeeDepDr</Value>
</Value>
<Value name="14">
<Value>RegfeeDocDr</Value>
</Value>
<Value name="15">
<Value>RegfeeDate</Value>
</Value>
<Value name="16">
<Value>RegfeeTime</Value>
</Value>
<Value name="17">
<Value>RegfeeUserDr</Value>
</Value>
<Value name="18">
<Value>RegfeeRBASDr</Value>
</Value>
<Value name="19">
<Value>RegfeeSessionTypeDr</Value>
</Value>
<Value name="20">
<Value>RegfeeRoomDr</Value>
</Value>
<Value name="21">
<Value>RegfeeTimeRangeDr</Value>
</Value>
<Value name="22">
<Value>RegTransferFlag</Value>
</Value>
<Value name="23">
<Value>RegTransferReDoc</Value>
</Value>
<Value name="24">
<Value>RegfeeInsuAdmDr</Value>
</Value>
<Value name="25">
<Value>RegfeeInsuCash</Value>
</Value>
<Value name="26">
<Value>RegfeeInsuCount</Value>
</Value>
<Value name="27">
<Value>RegfeeInsuFund</Value>
</Value>
<Value name="28">
<Value>RegfeeInsuOverallPlanning</Value>
</Value>
<Value name="29">
<Value>RegfeeInsuOther</Value>
</Value>
<Value name="30">
<Value>RegfeeInsuCoDR</Value>
</Value>
<Value name="31">
<Value>RegfeeInsuCoProDR</Value>
</Value>
<Value name="32">
<Value>RegfeeInsuCoPatPay</Value>
</Value>
<Value name="33">
<Value>RegfeePrintUserDR</Value>
</Value>
<Value name="34">
<Value>RegfeePrintDate</Value>
</Value>
<Value name="35">
<Value>RegfeePrintTime</Value>
</Value>
<Value name="36">
<Value>RegfeeInvReportDR</Value>
</Value>
<Value name="37">
<Value>RegfeeHandinUserDR</Value>
</Value>
<Value name="38">
<Value>RegfeeHandinDate</Value>
</Value>
<Value name="39">
<Value>RegfeeHandinTime</Value>
</Value>
<Value name="40">
<Value>RegfeeMethodSeqNo</Value>
</Value>
<Value name="41">
<Value>RegfeeTransactionId</Value>
</Value>
<Value name="42">
<Value>RegfeeCreatNewSeqNo</Value>
</Value>
<Value name="43">
<Value>RegfeeCreatDelaySeqNo</Value>
</Value>
<Value name="44">
<Value>RegfeeCreatCallDelaySeqNo</Value>
</Value>
<Value name="45">
<Value>RegfeeAPPRangeTime</Value>
</Value>
<Value name="46">
<Value>RegfeeClinicGroupDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCRegistrationFeeD</DataLocation>
<DefaultData>DHCRegistrationFeeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCRegistrationFeeD</IdLocation>
<IndexLocation>^User.DHCRegistrationFeeI</IndexLocation>
<StreamLocation>^User.DHCRegistrationFeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
