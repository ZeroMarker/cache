Class User.DHCBPMonthlySummary Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPMS_RowId, SqlTableName = DHC_BP_MonthlySummary, StorageStrategy = NewStorage1 ]
{

Index Register On BPMSBPPatRegisterDr;

Property BPMSBPPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 2, SqlFieldName = BPMS_BPPatRegister_Dr ];

/// 月小结年份
Property BPMSDateYear As %String [ SqlColumnNumber = 3, SqlFieldName = BPMS_DateYear ];

/// 月小结月份
Property BPMSDateMonth As %String [ SqlColumnNumber = 4, SqlFieldName = BPMS_DateMonth ];

/// 透析方案周总次数
Property BPMSSchemeWeekTimes As %String [ SqlColumnNumber = 5, SqlFieldName = BPMS_SchemeWeekTimes ];

/// 透析方案每次小时数
Property BPMSSchemeNumHour As %String [ SqlColumnNumber = 6, SqlFieldName = BPMS_SchemeNumHour ];

/// 本月透析总次数
Property BPMSNumber As %String [ SqlColumnNumber = 7, SqlFieldName = BPMS_Number ];

/// 本月HD次数
Property BPMSHDNumber As %String [ SqlColumnNumber = 8, SqlFieldName = BPMS_HDNumber ];

/// 本月HF次数
Property BPMSHFNumber As %String [ SqlColumnNumber = 9, SqlFieldName = BPMS_HFNumber ];

/// 本月HDF次数
Property BPMSHDFNumber As %String [ SqlColumnNumber = 10, SqlFieldName = BPMS_HDFNumber ];

/// 透析液处方钾（最近）
Property BPMSK As %String [ SqlColumnNumber = 11, SqlFieldName = BPMS_K ];

/// 透析液处方钙
Property BPMSCA As %String [ SqlColumnNumber = 12, SqlFieldName = BPMS_CA ];

/// 透析液处方血流量
Property BPMSBF As %String [ SqlColumnNumber = 13, SqlFieldName = BPMS_BF ];

/// 透析液处方电导度
Property BPMSConductivity As %String [ SqlColumnNumber = 14, SqlFieldName = BPMS_Conductivity ];

/// 生活自理
Property BPMSSelfHelp As %String [ SqlColumnNumber = 15, SqlFieldName = BPMS_SelfHelp ];

/// 睡眠
Property BPMSSleep As %String [ SqlColumnNumber = 16, SqlFieldName = BPMS_Sleep ];

/// 饮食
Property BPMSFood As %String [ SqlColumnNumber = 17, SqlFieldName = BPMS_Food ];

/// 营养
Property BPMSNutrition As %String [ SqlColumnNumber = 18, SqlFieldName = BPMS_Nutrition ];

/// 服药
Property BPMSDose As %String [ SqlColumnNumber = 19, SqlFieldName = BPMS_Dose ];

/// 血管通路
Property BPMSVascularAccessDr As User.DHCBPCVascularAccess [ SqlColumnNumber = 20, SqlFieldName = BPMS_VascularAccess_Dr ];

/// 部位
Property BPMSBodySiteDr As %String [ SqlColumnNumber = 21, SqlFieldName = BPMS_BodySite_Dr ];

/// 通路情况
Property BPMSVASituation As %String [ SqlColumnNumber = 22, SqlFieldName = BPMS_VASituation ];

/// 异常通路情况
Property BPMSVAASituation As %String [ SqlColumnNumber = 23, SqlFieldName = BPMS_VAAbnormalSituation ];

/// 异常通路情况其他
Property BPMSVAASituationOther As %String [ SqlColumnNumber = 24, SqlFieldName = BPMS_VAASituationOther ];

/// 抗凝方式
Property BPMSAnticoagulantModeDr As User.DHCBPCAnticoagulantMode [ SqlColumnNumber = 25, SqlFieldName = BPMS_AnticoagulantMode_Dr ];

/// 本月干体重
Property BPMSDryWeight As %String [ SqlColumnNumber = 26, SqlFieldName = BPMS_DryWeight ];

/// 尿量
Property BPMSUrineVolume As %String [ SqlColumnNumber = 27, SqlFieldName = BPMS_UrineVolume ];

/// 治疗依存性
Property BPMSTheraDependence As %String [ SqlColumnNumber = 28, SqlFieldName = BPMS_TheraDependence ];

/// 透析间期体重增加超标
Property BPMSOverweight As %String [ SqlColumnNumber = 29, SqlFieldName = BPMS_Overweight ];

/// 急诊透析次数
Property BPMSEmergencyTimes As %String [ SqlColumnNumber = 30, SqlFieldName = BPMS_EmergencyTimes ];

/// 急诊透析原因
Property BPMSEmergencyReason As %String [ SqlColumnNumber = 31, SqlFieldName = BPMS_EmergencyReason ];

/// 急诊透析原因其他
Property BPMSEReasonOther As %String [ SqlColumnNumber = 32, SqlFieldName = BPMS_EReasonOther ];

/// 透析期间血压
Property BPMSPeriodBloodPressure As %String [ SqlColumnNumber = 33, SqlFieldName = BPMS_PeriodBloodPressure ];

/// 透析中血压
Property BPMSInBloodPressure As %String [ SqlColumnNumber = 34, SqlFieldName = BPMS_InBloodPressure ];

/// 透析中并发症
Property BPMSComplication As %String [ SqlColumnNumber = 35, SqlFieldName = BPMS_Complication ];

/// 本月用药情况
Property BPMSMedicationSituation As %String [ SqlColumnNumber = 36, SqlFieldName = BPMS_MedicationSituation ];

/// 透前肌酐
Property BPMSFrontCreatinine As %String [ SqlColumnNumber = 37, SqlFieldName = BPMS_FrontCreatinine ];

/// 透前尿素
Property BPMSFrontUrea As %String [ SqlColumnNumber = 38, SqlFieldName = BPMS_FrontUrea ];

/// 透前尿酸
Property BPMSFrontUricAcid As %String [ SqlColumnNumber = 39, SqlFieldName = BPMS_FrontUricAcid ];

/// 透前K
Property BPMSFrontK As %String [ SqlColumnNumber = 40, SqlFieldName = BPMS_FrontK ];

/// 透前Na
Property BPMSFrontNa As %String [ SqlColumnNumber = 41, SqlFieldName = BPMS_FrontNa ];

/// 透前Ca
Property BPMSFrontCa As %String [ SqlColumnNumber = 42, SqlFieldName = BPMS_FrontCa ];

/// 透前Cl
Property BPMSFrontCl As %String [ SqlColumnNumber = 43, SqlFieldName = BPMS_FrontCl ];

/// 透前P
Property BPMSFrontP As %String [ SqlColumnNumber = 44, SqlFieldName = BPMS_FrontP ];

/// 透前HCO3
Property BPMSFrontHCO3 As %String [ SqlColumnNumber = 45, SqlFieldName = BPMS_FrontHCO3 ];

/// 透后肌酐
Property BPMSAfterCreatinine As %String [ SqlColumnNumber = 46, SqlFieldName = BPMS_AfterCreatinine ];

/// 透后尿素
Property BPMSAfterUrea As %String [ SqlColumnNumber = 47, SqlFieldName = BPMS_AfterUrea ];

/// 透后尿酸
Property BPMSAfterUricAcid As %String [ SqlColumnNumber = 48, SqlFieldName = BPMS_AfterUricAcid ];

/// 透后K
Property BPMSAfterK As %String [ SqlColumnNumber = 49, SqlFieldName = BPMS_AfterK ];

/// 透后Na
Property BPMSAfterNa As %String [ SqlColumnNumber = 50, SqlFieldName = BPMS_AfterNa ];

/// 透后Ca
Property BPMSAfterCa As %String [ SqlColumnNumber = 51, SqlFieldName = BPMS_AfterCa ];

/// 透后Cl
Property BPMSAfterCl As %String [ SqlColumnNumber = 52, SqlFieldName = BPMS_AfterCl ];

/// 透后P
Property BPMSAfterP As %String [ SqlColumnNumber = 53, SqlFieldName = BPMS_AfterP ];

/// 透后HCO3
Property BPMSAfterHCO3 As %String [ SqlColumnNumber = 54, SqlFieldName = BPMS_AfterHCO3 ];

/// 传染病学监测
Property BPMSIDD As %String [ SqlColumnNumber = 55, SqlFieldName = BPMS_IDD ];

/// 乙肝标志物
Property BPMSHBM As %String [ SqlColumnNumber = 56, SqlFieldName = BPMS_HBM ];

Property BPMSCreateCtcpDr As %String [ SqlColumnNumber = 57, SqlFieldName = BPMS_CreateCtcp_Dr ];

Property BPMSCreateDate As %Date [ SqlColumnNumber = 58, SqlFieldName = BPMS_CreateDate ];

Property BPMSCreateTime As %Time [ SqlColumnNumber = 59, SqlFieldName = BPMS_CreateTime ];

/// 透析中并发症其他
Property BPMSCOther As %String [ SqlColumnNumber = 60, SqlFieldName = BPMS_COther ];

/// 本月透析总评价以及诊断治疗建议
Property BPMSEvaluationSuggestion As %String [ SqlColumnNumber = 61, SqlFieldName = BPMS_EvaluationSuggestion ];

Property BPMSStatus As %String(DISPLAYLIST = ",Normal,Delete", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,D") [ SqlColumnNumber = 62, SqlFieldName = BPMS_Status ];

Property BPMSUpdateCtcpDr As %String [ SqlColumnNumber = 63, SqlFieldName = BPMS_UpdateCtcp_Dr ];

Property BPMSUpdateDate As %Date [ SqlColumnNumber = 64, SqlFieldName = BPMS_UpdateDate ];

Property BPMSUpdateTime As %Time [ SqlColumnNumber = 65, SqlFieldName = BPMS_UpdateTime ];

/// Hb
Property BPMSHb As %String [ SqlColumnNumber = 66, SqlFieldName = BPMS_Hb ];

/// WBC
Property BPMSWBC As %String [ SqlColumnNumber = 67, SqlFieldName = BPMS_WBC ];

/// PLT
Property BPMSPLT As %String [ SqlColumnNumber = 68, SqlFieldName = BPMS_PLT ];

/// 转铁饱和度
Property BPMSTS As %String [ SqlColumnNumber = 69, SqlFieldName = BPMS_TS ];

/// 血清铁蛋白
Property BPMSSF As %String [ SqlColumnNumber = 70, SqlFieldName = BPMS_SF ];

/// iPTH
Property BPMSiPTH As %String [ SqlColumnNumber = 71, SqlFieldName = BPMS_iPTH ];

/// ALB
Property BPMSALB As %String [ SqlColumnNumber = 72, SqlFieldName = BPMS_ALB ];

/// ALT
Property BPMSALT As %String [ SqlColumnNumber = 73, SqlFieldName = BPMS_ALT ];

/// AST
Property BPMSAST As %String [ SqlColumnNumber = 74, SqlFieldName = BPMS_AST ];

/// GGT
Property BPMSGGT As %String [ SqlColumnNumber = 75, SqlFieldName = BPMS_GGT ];

/// AL
Property BPMSAL As %String [ SqlColumnNumber = 76, SqlFieldName = BPMS_AL ];

/// BIL
Property BPMSBIL As %String [ SqlColumnNumber = 77, SqlFieldName = BPMS_BIL ];

/// AST
Property BPMSdBIL As %String [ SqlColumnNumber = 78, SqlFieldName = BPMS_dBIL ];

/// UreaCL尿素清除率
Property BPMSUreaCL As %String [ SqlColumnNumber = 79, SqlFieldName = BPMS_UreaCL ];

Storage NewStorage1
{
<Data name="DHCBPMonthlySummaryClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPMonthlySummaryDefaultData">
<Value name="1">
<Value>BPMSBPPatRegisterDr</Value>
</Value>
<Value name="2">
<Value>BPMSDateYear</Value>
</Value>
<Value name="3">
<Value>BPMSDateMonth</Value>
</Value>
<Value name="4">
<Value>BPMSSchemeWeekTimes</Value>
</Value>
<Value name="5">
<Value>BPMSSchemeNumHour</Value>
</Value>
<Value name="6">
<Value>BPMSNumber</Value>
</Value>
<Value name="7">
<Value>BPMSHDNumber</Value>
</Value>
<Value name="8">
<Value>BPMSHFNumber</Value>
</Value>
<Value name="9">
<Value>BPMSHDFNumber</Value>
</Value>
<Value name="10">
<Value>BPMSK</Value>
</Value>
<Value name="11">
<Value>BPMSCA</Value>
</Value>
<Value name="12">
<Value>BPMSBF</Value>
</Value>
<Value name="13">
<Value>BPMSConductivity</Value>
</Value>
<Value name="14">
<Value>BPMSSelfHelp</Value>
</Value>
<Value name="15">
<Value>BPMSSleep</Value>
</Value>
<Value name="16">
<Value>BPMSFood</Value>
</Value>
<Value name="17">
<Value>BPMSNutrition</Value>
</Value>
<Value name="18">
<Value>BPMSDose</Value>
</Value>
<Value name="19">
<Value>BPMSVascularAccessDr</Value>
</Value>
<Value name="20">
<Value>BPMSBodySiteDr</Value>
</Value>
<Value name="21">
<Value>BPMSVASituation</Value>
</Value>
<Value name="22">
<Value>BPMSVAASituation</Value>
</Value>
<Value name="23">
<Value>BPMSVAASituationOther</Value>
</Value>
<Value name="24">
<Value>BPMSAnticoagulantModeDr</Value>
</Value>
<Value name="25">
<Value>BPMSDryWeight</Value>
</Value>
<Value name="26">
<Value>BPMSUrineVolume</Value>
</Value>
<Value name="27">
<Value>BPMSTheraDependence</Value>
</Value>
<Value name="28">
<Value>BPMSOverweight</Value>
</Value>
<Value name="29">
<Value>BPMSEmergencyTimes</Value>
</Value>
<Value name="30">
<Value>BPMSEmergencyReason</Value>
</Value>
<Value name="31">
<Value>BPMSEReasonOther</Value>
</Value>
<Value name="32">
<Value>BPMSPeriodBloodPressure</Value>
</Value>
<Value name="33">
<Value>BPMSInBloodPressure</Value>
</Value>
<Value name="34">
<Value>BPMSComplication</Value>
</Value>
<Value name="35">
<Value>BPMSMedicationSituation</Value>
</Value>
<Value name="36">
<Value>BPMSFrontCreatinine</Value>
</Value>
<Value name="37">
<Value>BPMSFrontUrea</Value>
</Value>
<Value name="38">
<Value>BPMSFrontUricAcid</Value>
</Value>
<Value name="39">
<Value>BPMSFrontK</Value>
</Value>
<Value name="40">
<Value>BPMSFrontNa</Value>
</Value>
<Value name="41">
<Value>BPMSFrontCa</Value>
</Value>
<Value name="42">
<Value>BPMSFrontCl</Value>
</Value>
<Value name="43">
<Value>BPMSFrontP</Value>
</Value>
<Value name="44">
<Value>BPMSFrontHCO3</Value>
</Value>
<Value name="45">
<Value>BPMSAfterCreatinine</Value>
</Value>
<Value name="46">
<Value>BPMSAfterUrea</Value>
</Value>
<Value name="47">
<Value>BPMSAfterUricAcid</Value>
</Value>
<Value name="48">
<Value>BPMSAfterK</Value>
</Value>
<Value name="49">
<Value>BPMSAfterNa</Value>
</Value>
<Value name="50">
<Value>BPMSAfterCa</Value>
</Value>
<Value name="51">
<Value>BPMSAfterCl</Value>
</Value>
<Value name="52">
<Value>BPMSAfterP</Value>
</Value>
<Value name="53">
<Value>BPMSAfterHCO3</Value>
</Value>
<Value name="54">
<Value>BPMSIDD</Value>
</Value>
<Value name="55">
<Value>BPMSHBM</Value>
</Value>
<Value name="56">
<Value>BPMSCreateCtcpDr</Value>
</Value>
<Value name="57">
<Value>BPMSCreateDate</Value>
</Value>
<Value name="58">
<Value>BPMSCreateTime</Value>
</Value>
<Value name="59">
<Value>BPMSCOther</Value>
</Value>
<Value name="60">
<Value>BPMSEvaluationSuggestion</Value>
</Value>
<Value name="61">
<Value>BPMSStatus</Value>
</Value>
<Value name="62">
<Value>BPMSUpdateCtcpDr</Value>
</Value>
<Value name="63">
<Value>BPMSUpdateDate</Value>
</Value>
<Value name="64">
<Value>BPMSUpdateTime</Value>
</Value>
<Value name="65">
<Value>BPMSHb</Value>
</Value>
<Value name="66">
<Value>BPMSWBC</Value>
</Value>
<Value name="67">
<Value>BPMSPLT</Value>
</Value>
<Value name="68">
<Value>BPMSTS</Value>
</Value>
<Value name="69">
<Value>BPMSSF</Value>
</Value>
<Value name="70">
<Value>BPMSiPTH</Value>
</Value>
<Value name="71">
<Value>BPMSALB</Value>
</Value>
<Value name="72">
<Value>BPMSALT</Value>
</Value>
<Value name="73">
<Value>BPMSAST</Value>
</Value>
<Value name="74">
<Value>BPMSGGT</Value>
</Value>
<Value name="75">
<Value>BPMSAL</Value>
</Value>
<Value name="76">
<Value>BPMSBIL</Value>
</Value>
<Value name="77">
<Value>BPMSdBIL</Value>
</Value>
<Value name="78">
<Value>BPMSUreaCL</Value>
</Value>
</Data>
<DataLocation>^DHCBPMonthlySummary</DataLocation>
<DefaultData>DHCBPMonthlySummaryDefaultData</DefaultData>
<IdLocation>^DHCBPMonthlySummary</IdLocation>
<IndexLocation>^DHCBPMonthlySummary(0)</IndexLocation>
<StreamLocation>^User.DHCBPMonthlySummaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
