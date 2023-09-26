Class User.CSSDClean Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_Clean ]
{

/// 1 表示验收通过,2 表示验收没有通过
Property CSSDCCleanMethod As User.CSSDCleanType [ Required, SqlColumnNumber = 2, SqlFieldName = CSSDC_CleanMethod ];

Property CSSDCDate As %Date [ SqlColumnNumber = 3, SqlFieldName = CSSDC_Date ];

Property CSSDCLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = CSSDC_Loc_DR ];

Property CSSDCTime As %Time [ SqlColumnNumber = 5, SqlFieldName = CSSDC_Time ];

Property CSSDCUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = CSSDC_User_DR ];

/// 一次清洗生成一个号
Property CSSDCNo As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 8, SqlFieldName = CSSDC_No ];

/// 清洗的机器的号
Property CSSDCMachineNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 9, SqlFieldName = CSSDC_MachineNo ];

Property CSSDCCleaner As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = CSSDC_CleanerDR ];

Property CSSDCChker As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = CSSDC_ChkerDR ];

Property CSSDCChkTime As %Time [ SqlColumnNumber = 12, SqlFieldName = CSSDC_ChkTime ];

Property CSSDCIsCreateLbl As %Integer [ SqlColumnNumber = 13, SqlFieldName = CSSDC_IsCreateLbl ];

Property CSSDCResult As %Integer [ SqlColumnNumber = 14, SqlFieldName = CSSDC_Result ];

Property CSSDCCleanProgress As %Integer [ SqlColumnNumber = 15, SqlFieldName = CSSDC_CleanProgress ];

Property CSSDCCleanLTime As %Time [ SqlColumnNumber = 16, SqlFieldName = CSSDC_CleanLTime ];

Property CSSDCleanVehicleLbl As %String(COLLATION = "Exact") [ SqlColumnNumber = 17, SqlFieldName = CSSDC_CleanVehicleLbl ];

Property CSSDCIsCmtEnterMachine As %String(COLLATION = "Exact") [ SqlColumnNumber = 18, SqlFieldName = CSSDC_IsCmtEnterMachine ];

/// 存机器id
Property CSSDCMachine As User.CSSDMachineConfig [ SqlColumnNumber = 19, SqlFieldName = CSSDC_MachineConfigDr ];

/// 清洗主表与回收主表关联字段
Property CSSDCCallBackDr As User.CSSDPackageCallback [ SqlColumnNumber = 21, SqlFieldName = CSSDC_Callback_Dr ];

/// E-外来标志  MC-混合清洗标志,既有外来器械又有其他包
Property CSSDCFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Ext,MixClean,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",E,MC,N") [ InitialExpression = "N", SqlColumnNumber = 22, SqlFieldName = CSSDC_Flag ];

Property CSSDCChkDate As %Date [ SqlColumnNumber = 23, SqlFieldName = CSSDC_ChkDate ];

/// 测漏
Property CSSDCLeakLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 24, SqlFieldName = CSSDC_LeakLabel ];

/// 机器数据文件名
Property CSSDSRFileName As %String(COLLATION = "Exact") [ SqlColumnNumber = 25, SqlFieldName = CSSDC_FileName ];

/// 某机器当天第几次
Property CSSDSRNum As %Integer [ SqlColumnNumber = 26, SqlFieldName = CSSDC_Num ];

/// 创建日期
Property CSSDCCreateDate As %Date [ SqlColumnNumber = 27, SqlFieldName = CSSDC_CreateDate ];

/// 创建时间
Property CSSDCCreateTime As %Time [ SqlColumnNumber = 28, SqlFieldName = CSSDC_CreateTime ];

Index CSSDCNoIndex On CSSDCNo As Exact;

Index IndexDateLoc On (CSSDCDate As Exact, CSSDCLocDr As Exact);

Index IndexMachineNoDate On (CSSDCMachineNo As Exact, CSSDCDate As Exact);

Index IndexCleanCallBack On CSSDCCallBackDr As Exact;

Index IndexMachineNoDateLocDr On (CSSDCMachineNo As Exact, CSSDCDate As Exact, CSSDCLocDr As Exact);

Index IndexMachineDRDateDr On (CSSDCMachine As Exact, CSSDCDate As Exact);

Index IndexCSSDCDate On CSSDCDate As Exact;

Storage Default
{
<Data name="CSSDCleanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDCCleanMethod</Value>
</Value>
<Value name="3">
<Value>CSSDCDate</Value>
</Value>
<Value name="4">
<Value>CSSDCLocDr</Value>
</Value>
<Value name="5">
<Value>CSSDCTime</Value>
</Value>
<Value name="6">
<Value>CSSDCUserDr</Value>
</Value>
<Value name="7"/>
<Value name="8">
<Value>CSSDCNo</Value>
</Value>
<Value name="9">
<Value>CSSDCMachineNo</Value>
</Value>
<Value name="10">
<Value>CSSDCCleaner</Value>
</Value>
<Value name="11">
<Value>CSSDCChker</Value>
</Value>
<Value name="12">
<Value>CSSDCChkTime</Value>
</Value>
<Value name="13">
<Value>CSSDCIsCreateLbl</Value>
</Value>
<Value name="14">
<Value>CSSDCResult</Value>
</Value>
<Value name="15">
<Value>CSSDCCleanProgress</Value>
</Value>
<Value name="16">
<Value>CSSDCCleanLTime</Value>
</Value>
<Value name="17">
<Value>CSSDCleanVehicleLbl</Value>
</Value>
<Value name="18">
<Value>CSSDCIsCmtEnterMachine</Value>
</Value>
<Value name="19">
<Value>CSSDCMachine</Value>
</Value>
<Value name="20"/>
<Value name="21">
<Value>CSSDCCallBackDr</Value>
</Value>
<Value name="22">
<Value>CSSDCFlag</Value>
</Value>
<Value name="23">
<Value>CSSDCChkDate</Value>
</Value>
<Value name="24">
<Value>CSSDCLeakLabel</Value>
</Value>
<Value name="25">
<Value>CSSDSRFileName</Value>
</Value>
<Value name="26">
<Value>CSSDSRNum</Value>
</Value>
<Value name="27">
<Value>CSSDCCreateDate</Value>
</Value>
<Value name="28">
<Value>CSSDCCreateTime</Value>
</Value>
</Data>
<DataLocation>^User.CSSDCleanD</DataLocation>
<DefaultData>CSSDCleanDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDCleanD</IdLocation>
<IndexLocation>^User.CSSDCleanI</IndexLocation>
<StreamLocation>^User.CSSDCleanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
