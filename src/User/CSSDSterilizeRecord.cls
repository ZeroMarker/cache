/// 灭菌主表
Class User.CSSDSterilizeRecord Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDSR_Rowid, SqlTableName = CSSD_SterilizeRecord ]
{

Relationship Monitor As User.CSSDSterilizeMonitor [ Cardinality = children, Inverse = SMParRef ];

Property CSSDSRDate As %Date [ SqlColumnNumber = 2, SqlFieldName = CSSDSR_Date ];

/// 灭菌批号对应厂商存储的机器数据文件名
Property CSSDSRFileName As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CSSDSR_FileName ];

Property CSSDSRNo As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 4, SqlFieldName = CSSDSR_No ];

Property CSSDSRPressure As %Numeric [ SqlColumnNumber = 5, SqlFieldName = CSSDSR_Pressure ];

Property CSSDSRTemperature As %Numeric [ SqlColumnNumber = 6, SqlFieldName = CSSDSR_Temperature ];

/// 是否物理监测
Property CSSDSRIsPhy As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CSSDSR_IsPhy ];

Property CSSDSRTime As %Time [ SqlColumnNumber = 8, SqlFieldName = CSSDSR_Time ];

Property CSSDSRUserDr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = CSSDSR_User_DR ];

/// 物理监测结果
Property CSSDSRPhyResult As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CSSDSR_PhyResult ];

Property CSSDSRWorkStatus As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CSSDSR_WorkStatus ];

Property CSSDSRBatLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 12, SqlFieldName = CSSDSR_BatLabel ];

Property CSSDSRBdLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 13, SqlFieldName = CSSDSR_BD_Label ];

Property CSSDSRBdPressure As %Numeric [ SqlColumnNumber = 14, SqlFieldName = CSSDSR_BD_Pressure ];

Property CSSDSRBdTemperature As %Numeric [ SqlColumnNumber = 15, SqlFieldName = CSSDSR_BD_Temperature ];

Property CSSDSRBdTime As %Numeric [ SqlColumnNumber = 16, SqlFieldName = CSSDSR_BD_Time ];

Property CSSDSRLocDr As User.CTLoc [ SqlColumnNumber = 17, SqlFieldName = CSSDSR_Loc_DR ];

Property CSSDSRMachineNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 18, SqlFieldName = CSSDSR_MachineNo ];

Property CSSDSRComplateFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Finish,Yes,No", MAXLEN = 3, VALUELIST = ",F,Y,N") [ InitialExpression = "N", SqlColumnNumber = 19, SqlFieldName = CSSDSR_ComplateFlag ];

Property CSSDSRInformRecallDate As %String(COLLATION = "Exact") [ SqlColumnNumber = 20, SqlFieldName = CSSDSR_InformRecallDate ];

Property CSSDSRInformRecallReason As %String(COLLATION = "Exact") [ SqlColumnNumber = 21, SqlFieldName = CSSDSR_InformRecallReason ];

Property CSSDSRInformRecallUser As User.SSUser [ SqlColumnNumber = 22, SqlFieldName = CSSDSR_InformRecallUser ];

Property CSSDSRRecallFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 23, SqlFieldName = CSSDSR_RecallFlag ];

Property CSSDSRUsedTime As %Numeric [ SqlColumnNumber = 24, SqlFieldName = CSSDSR_UsedTime ];

Property CSSDSRCHKUserDR As User.SSUser [ SqlColumnNumber = 25, SqlFieldName = CSSDSR_CHKUser_DR ];

Property CSSDSRCHKTime As %Time [ SqlColumnNumber = 26, SqlFieldName = CSSDSR_CHKTime ];

Property CSSDSRIsCHK As %String(COLLATION = "Exact") [ SqlColumnNumber = 27, SqlFieldName = CSSDSR_IsCHK ];

Property CSSDSRCarLBL As %String(COLLATION = "Exact") [ SqlColumnNumber = 28, SqlFieldName = CSSDSR_CarLBL ];

Property CSSDSRBDResult As %String(COLLATION = "Exact") [ SqlColumnNumber = 29, SqlFieldName = CSSDSR_BD_Result ];

Property CSSDSRChkFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 30, SqlFieldName = CSSDSR_ChkFlag ];

Property CSSDSRProgress As %String(COLLATION = "Exact") [ SqlColumnNumber = 31, SqlFieldName = CSSDSR_Progress ];

Property CSSDSRThreeMResult As %String(COLLATION = "Exact") [ SqlColumnNumber = 32, SqlFieldName = CSSDSR_ThreeMResult ];

/// 是否已经确认进灭菌
Property CSSDSRIsCmtEnterMachine As %String(COLLATION = "Exact") [ SqlColumnNumber = 33, SqlFieldName = CSSDSR_IsCmtEnterMachine ];

Property CSSDFLAGREASON As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = CSSDSR_FLAGREASON ];

Property CSSDSRMachineNoDR As User.CSSDMachineConfig [ SqlColumnNumber = 35, SqlFieldName = CSSDSR_MachineNo_DR ];

Property CSSDSRProgressDR As User.CSSDBaseCode [ SqlColumnNumber = 36, SqlFieldName = CSSDSR_Progress_DR ];

/// 生物验收人
Property CSSDSRBioCHKUserDR As User.SSUser [ SqlColumnNumber = 37, SqlFieldName = CSSDSR_BioCHKUser_DR ];

/// 生物验收时间
Property CSSDSRBioCHKTime As %Time [ SqlColumnNumber = 38, SqlFieldName = CSSDSR_BioCHKTime ];

/// 是否生物监测
Property CSSDSRIsBio As %String(COLLATION = "Exact") [ SqlColumnNumber = 39, SqlFieldName = CSSDSR_IsBio ];

/// 是否化学监测
Property CSSDSRIsChe As %String(COLLATION = "Exact") [ SqlColumnNumber = 40, SqlFieldName = CSSDSR_IsChe ];

/// 化学验收人
Property CSSDSRCheCHKUserDR As User.SSUser [ SqlColumnNumber = 41, SqlFieldName = CSSDSR_CheCHKUser_DR ];

/// 化学验收时间
Property CSSDSRCheCHKTime As %Time [ SqlColumnNumber = 42, SqlFieldName = CSSDSR_CheCHKTime ];

/// 化学监测结果
Property CSSDSRCheResult As %String(COLLATION = "Exact") [ SqlColumnNumber = 43, SqlFieldName = CSSDSR_CheResult ];

/// 绿色通道标识
Property CSSDSRGreenFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 44, SqlFieldName = CSSDSR_GreenFlag ];

/// 侧漏
Property CSSDSRLeakLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 45, SqlFieldName = CSSDSR_LeakLabel ];

/// 验收日期
Property CSSDSRCheckDate As %Date [ SqlColumnNumber = 46, SqlFieldName = CSSDSR_CheckDate ];

/// 生物验收日期
Property CSSDSRBioCHKDate As %Date [ SqlColumnNumber = 47, SqlFieldName = CSSDSR_BioCHKDate ];

/// 化学验收日期
Property CSSDSRCheCHKDate As %Date [ SqlColumnNumber = 48, SqlFieldName = CSSDSR_CheCHKDate ];

/// 物理验收人
Property CSSDSRPhyCHKUserDR As User.SSUser [ SqlColumnNumber = 49, SqlFieldName = CSSDSR_PhyCHKUser_DR ];

/// 物理验收时间
Property CSSDSRPhyCHKTime As %Time [ SqlColumnNumber = 50, SqlFieldName = CSSDSR_PhyCHKTime ];

/// 物理验收日期
Property CSSDSRPhyCHKDate As %Date [ SqlColumnNumber = 51, SqlFieldName = CSSDSR_PhyCHKDate ];

/// 某机器当天第几次
Property CSSDSRNum As %Integer [ SqlColumnNumber = 52, SqlFieldName = CSSDSR_Num ];

/// 重新灭菌时,指向老的灭菌单id
Property CSSDSRSRDR As User.CSSDSterilizeRecord [ SqlColumnNumber = 53, SqlFieldName = CSSDSR_SR_DR ];

/// 备注
Property CSSDSRRemark As %String(COLLATION = "Exact") [ SqlColumnNumber = 54, SqlFieldName = CSSDSR_Remark ];

/// 灭菌【BD 0 正常 1 测漏 2】
Property CSSDSRFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 55, SqlFieldName = CSSDSR_Flag ];

/// 创建日期
Property CSSDSRCreateDate As %Date [ SqlColumnNumber = 56, SqlFieldName = CSSDSR_CreateDate ];

/// 创建时间
Property CSSDSRCreateTime As %Time [ SqlColumnNumber = 57, SqlFieldName = CSSDSR_CreateTime ];

Index CSSDSRNoIndex On CSSDSRNo As Exact;

Index IndexMachineNoDRDateBD On (CSSDSRMachineNoDR As Exact, CSSDSRDate As Exact, CSSDSRBdLabel As Exact);

Index IndexDateLoc On (CSSDSRDate As Exact, CSSDSRLocDr As Exact);

Index IndexComplateFlag On CSSDSRComplateFlag As Exact;

Index IndexCSSDSRMachineNoDate On (CSSDSRMachineNoDR As Exact, CSSDSRDate As Exact);

Index IndexMachineNoDRDateLeak On (CSSDSRMachineNoDR As Exact, CSSDSRDate As Exact, CSSDSRLeakLabel As Exact);

Index IndexMachineNoDRDateBat On (CSSDSRMachineNoDR As Exact, CSSDSRDate As Exact, CSSDSRIsBio As Exact);

Index IndexMachineNoDRDateLocDr On (CSSDSRMachineNoDR As Exact, CSSDSRDate As Exact, CSSDSRLocDr As Exact);

Index IndexCSSDSRDate On CSSDSRDate As Exact;

Index MachineDateLocFlag On (CSSDSRMachineNoDR As Exact, CSSDSRDate As Exact, CSSDSRLocDr As Exact, CSSDSRFlag As Exact);

Index IndexCSSDSRCarLBL On CSSDSRCarLBL As exact;

Storage Default
{
<Data name="CSSDSterilizeRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDSRDate</Value>
</Value>
<Value name="3">
<Value>CSSDSRFileName</Value>
</Value>
<Value name="4">
<Value>CSSDSRNo</Value>
</Value>
<Value name="5">
<Value>CSSDSRPressure</Value>
</Value>
<Value name="6">
<Value>CSSDSRTemperature</Value>
</Value>
<Value name="7">
<Value>CSSDSRIsPhy</Value>
</Value>
<Value name="8">
<Value>CSSDSRTime</Value>
</Value>
<Value name="9">
<Value>CSSDSRUserDr</Value>
</Value>
<Value name="10">
<Value>CSSDSRPhyResult</Value>
</Value>
<Value name="11">
<Value>CSSDSRWorkStatus</Value>
</Value>
<Value name="12">
<Value>CSSDSRBatLabel</Value>
</Value>
<Value name="13">
<Value>CSSDSRBdLabel</Value>
</Value>
<Value name="14">
<Value>CSSDSRBdPressure</Value>
</Value>
<Value name="15">
<Value>CSSDSRBdTemperature</Value>
</Value>
<Value name="16">
<Value>CSSDSRBdTime</Value>
</Value>
<Value name="17">
<Value>CSSDSRLocDr</Value>
</Value>
<Value name="18">
<Value>CSSDSRMachineNo</Value>
</Value>
<Value name="19">
<Value>CSSDSRComplateFlag</Value>
</Value>
<Value name="20">
<Value>CSSDSRInformRecallDate</Value>
</Value>
<Value name="21">
<Value>CSSDSRInformRecallReason</Value>
</Value>
<Value name="22">
<Value>CSSDSRInformRecallUser</Value>
</Value>
<Value name="23">
<Value>CSSDSRRecallFlag</Value>
</Value>
<Value name="24">
<Value>CSSDSRUsedTime</Value>
</Value>
<Value name="25">
<Value>CSSDSRCHKUserDR</Value>
</Value>
<Value name="26">
<Value>CSSDSRCHKTime</Value>
</Value>
<Value name="27">
<Value>CSSDSRIsCHK</Value>
</Value>
<Value name="28">
<Value>CSSDSRCarLBL</Value>
</Value>
<Value name="29">
<Value>CSSDSRBDResult</Value>
</Value>
<Value name="30">
<Value>CSSDSRChkFlag</Value>
</Value>
<Value name="31">
<Value>CSSDSRProgress</Value>
</Value>
<Value name="32">
<Value>CSSDSRThreeMResult</Value>
</Value>
<Value name="33">
<Value>CSSDSRIsCmtEnterMachine</Value>
</Value>
<Value name="34">
<Value>CSSDFLAGREASON</Value>
</Value>
<Value name="35">
<Value>CSSDSRMachineNoDR</Value>
</Value>
<Value name="36">
<Value>CSSDSRProgressDR</Value>
</Value>
<Value name="37">
<Value>CSSDSRBioCHKUserDR</Value>
</Value>
<Value name="38">
<Value>CSSDSRBioCHKTime</Value>
</Value>
<Value name="39">
<Value>CSSDSRIsBio</Value>
</Value>
<Value name="40">
<Value>CSSDSRIsChe</Value>
</Value>
<Value name="41">
<Value>CSSDSRCheCHKUserDR</Value>
</Value>
<Value name="42">
<Value>CSSDSRCheCHKTime</Value>
</Value>
<Value name="43">
<Value>CSSDSRCheResult</Value>
</Value>
<Value name="44">
<Value>CSSDSRGreenFlag</Value>
</Value>
<Value name="45">
<Value>CSSDSRLeakLabel</Value>
</Value>
<Value name="46">
<Value>CSSDSRCheckDate</Value>
</Value>
<Value name="47">
<Value>CSSDSRBioCHKDate</Value>
</Value>
<Value name="48">
<Value>CSSDSRCheCHKDate</Value>
</Value>
<Value name="49">
<Value>CSSDSRPhyCHKUserDR</Value>
</Value>
<Value name="50">
<Value>CSSDSRPhyCHKTime</Value>
</Value>
<Value name="51">
<Value>CSSDSRPhyCHKDate</Value>
</Value>
<Value name="52">
<Value>CSSDSRNum</Value>
</Value>
<Value name="53">
<Value>CSSDSRSRDR</Value>
</Value>
<Value name="54">
<Value>CSSDSRRemark</Value>
</Value>
<Value name="55">
<Value>CSSDSRFlag</Value>
</Value>
<Value name="56">
<Value>CSSDSRCreateDate</Value>
</Value>
<Value name="57">
<Value>CSSDSRCreateTime</Value>
</Value>
</Data>
<DataLocation>^User.CSSDSterilizeRecordD</DataLocation>
<DefaultData>CSSDSterilizeRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDSterilizeRecordD</IdLocation>
<IndexLocation>^User.CSSDSterilizeRecordI</IndexLocation>
<SqlRowIdName>CSSDSR_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDSterilizeRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
