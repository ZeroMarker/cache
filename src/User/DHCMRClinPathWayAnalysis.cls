/// 基础配置字典
Class User.DHCMRClinPathWayAnalysis Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = CPWA_RowId, SqlTableName = DHC_MR_ClinPathWayAnalysis ]
{

/// CPWA_Paadm  就诊号
Property CPWAPaadm As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CPWA_Paadm ];

/// CPWA_AdmStatus  在院/出院(Admit/Dischage)
Property CPWAAdmStatus As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CPWA_AdmStatus ];

/// CPWA_Diagnos  诊断列表（诊断ICD/诊断描述,逗号分隔）
Property CPWADiagnos As %String(MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CPWA_Diagnos ];

/// CPWA_CPWDID 病种/路径
Property CPWACPWDID As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CPWA_CPWDID ];

/// CPWA_AdmitDate  入院日期
Property CPWAAdmitDate As %Date [ SqlColumnNumber = 6, SqlFieldName = CPWA_AdmitDate ];

/// CPWA_DischDate  出院日期
Property CPWADischDate As %Date [ SqlColumnNumber = 7, SqlFieldName = CPWA_DischDate ];

/// CPWA_OutStatus  治愈/好转/死亡(Cure/Improve/Death)
Property CPWAOutStatus As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CPWA_OutStatus ];

/// CPWA_IsInHospInf  是否院感患者(Yes/No)
Property CPWAIsInHospInf As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CPWA_IsInHospInf ];

/// CPWA_IsOperPat  是否手术患者(Yes/No)
Property CPWAIsOperPat As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CPWA_IsOperPat ];

/// CPWA_OperDate  手术日期（第一次）
Property CPWAOperDate As %Date [ SqlColumnNumber = 11, SqlFieldName = CPWA_OperDate ];

/// CPWA_IsOperInf  是否手术部位感染患者（第一次）(Yes/No)
Property CPWAIsOperInf As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CPWA_IsOperInf ];

/// CPWA_HospCost  住院费用
Property CPWAHospCost As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = CPWA_HospCost ];

/// CPWA_DrugCost  住院药费
Property CPWADrugCost As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = CPWA_DrugCost ];

/// CPWA_LabCost  检验费用
Property CPWALabCost As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CPWA_LabCost ];

/// CPWA_CheckCost  检查费用
Property CPWACheckCost As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CPWA_CheckCost ];

/// CPWA_PharmacyCost  抗生素费用
Property CPWAPharmacyCost As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = CPWA_PharmacyCost ];

/// CPWA_PharmacyDays  抗生素使用天数
Property CPWAPharmacyDays As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = CPWA_PharmacyDays ];

/// CPWA_Is3Pharmacy  是否三线抗生素患者(Yes/No)
Property CPWAIs3Pharmacy As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = CPWA_Is3Pharmacy ];

/// CPWA_CPWLoc  路径科室
Property CPWACPWLoc As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = CPWA_CPWLocID ];

/// CPWA_PathWayID 出入径记录
Property CPWAPathWayID As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = CPWA_PathWayID ];

/// CPWA_RegLocID 入院科室
Property CPWARegLocID As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = CPWA_RegLocID ];

/// CPWA_RegWardID 入院病区
Property CPWARegWardID As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = CPWA_RegWardID ];

/// CPWA_DischLocID 出院科室
Property CPWADischLocID As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = CPWA_DischLocID ];

/// CPWA_DischWardID 出院病区
Property CPWADischWardID As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = CPWA_DischWardID ];

/// CPWA_TimesOperFlag 非计划重返手术患者标记
Property CPWATimesOperFlag As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = CPWA_TimesOperFlag ];

/// CPWA_TimesOperFlag 预防抗菌药物使用患者标记
Property CPWAIsPreDrugFlag As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = CPWA_IsPreDrugFlag ];

/// CPWA_TimesInHospFlag 再住院天数
Property CPWAIsTimesInHospFlag As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = CPWA_IsTimesInHospFlag ];

/// CPWA_TimesInHospFlag 出现常见并发症患者标记
Property CPWAIsComplicationFlag As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = CPWA_IsComplicationFlag ];

/// CPWA_MaterialCost 材料费/耗材费
Property CPWAMaterialCost As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = CPWA_MaterialCost ];

/// CPWA_ProprMedCost 中成药费
Property CPWAProprMedCost As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = CPWA_ProprMedCost ];

/// CPWA_HerbalMedCost 中草药费
Property CPWAHerbalMedCost As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = CPWA_HerbalMedCost ];

/// CPWA_WesternMedCost 西药费
Property CPWAWesternMedCost As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = CPWAWesternMedCost ];

/// CPWA_TherapyCost 治疗费
Property CPWATherapyCost As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = CPWA_TherapyCost ];

/// CPWA_ChTherapyCost 中医治疗费
Property CPWAChTherapyCost As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = CPWA_ChTherapyCost ];

/// CPWA_CharaTherapyCost 中医特色疗法费
Property CPWACharaTherapyCost As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = CPWA_CharaTherapyCost ];

/// CPWA_IsPiecesMed 中药饮片[是/否]
Property CPWAIsPiecesMed As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = CPWA_IsPiecesMed ];

/// CPWA_IsProprMed 中成药[是/否]
Property CPWAIsProprMed As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = CPWA_IsProprMed ];

/// CPWA_IsCharaTherapy 中医特色疗法[是/否]
Property CPWAIsCharaTherapy As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 39, SqlFieldName = CPWA_IsCharaTherapy ];

/// CPWA_PharmacyInfo 抗生素使用情况(接口)[ Used_"^"_isKSS1_$C(1)_isKSS2_$C(1)_isKSS3_$C(1)_isZL_$C(1)_isYF ]
Property CPWAPharmacyInfo As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 40, SqlFieldName = CPWA_PharmacyInfo ];

Index IndexDischDate On CPWADischDate As Exact;

Index IndexPaadm On CPWAPaadm As Exact;

Index IndexAdmStatus On CPWAAdmStatus As Exact;

Index IndexRegLoc On CPWARegLocID As Exact;

Index IndexRegWard On CPWARegWardID As Exact;

Index IndexDischLoc On CPWADischLocID As Exact;

Index IndexDischWard On CPWADischWardID As Exact;

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWAPaadm</Value>
</Value>
<Value name="3">
<Value>CPWAAdmStatus</Value>
</Value>
<Value name="4">
<Value>CPWADiagnos</Value>
</Value>
<Value name="5">
<Value>CPWACPWDID</Value>
</Value>
<Value name="6">
<Value>CPWAAdmitDate</Value>
</Value>
<Value name="7">
<Value>CPWADischDate</Value>
</Value>
<Value name="8">
<Value>CPWAOutStatus</Value>
</Value>
<Value name="9">
<Value>CPWAIsInHospInf</Value>
</Value>
<Value name="10">
<Value>CPWAIsOperPat</Value>
</Value>
<Value name="11">
<Value>CPWAOperDate</Value>
</Value>
<Value name="12">
<Value>CPWAIsOperInf</Value>
</Value>
<Value name="13">
<Value>CPWAHospCost</Value>
</Value>
<Value name="14">
<Value>CPWADrugCost</Value>
</Value>
<Value name="15">
<Value>CPWALabCost</Value>
</Value>
<Value name="16">
<Value>CPWACheckCost</Value>
</Value>
<Value name="17">
<Value>CPWAPharmacyCost</Value>
</Value>
<Value name="18">
<Value>CPWAPharmacyDays</Value>
</Value>
<Value name="19">
<Value>CPWAIs3Pharmacy</Value>
</Value>
<Value name="20">
<Value>CPWACPWLoc</Value>
</Value>
<Value name="21">
<Value>CPWAPathWayID</Value>
</Value>
<Value name="22">
<Value>CPWARegLocID</Value>
</Value>
<Value name="23">
<Value>CPWARegWardID</Value>
</Value>
<Value name="24">
<Value>CPWADischLocID</Value>
</Value>
<Value name="25">
<Value>CPWADischWardID</Value>
</Value>
<Value name="26">
<Value>CPWATimesOperFlag</Value>
</Value>
<Value name="27">
<Value>CPWAIsPreDrugFlag</Value>
</Value>
<Value name="28">
<Value>CPWAIsTimesInHospFlag</Value>
</Value>
<Value name="29">
<Value>CPWAIsComplicationFlag</Value>
</Value>
<Value name="30">
<Value>CPWAMaterialCost</Value>
</Value>
<Value name="31">
<Value>CPWAChTherapyCost</Value>
</Value>
<Value name="32">
<Value>CPWAHerbalMedCost</Value>
</Value>
<Value name="33">
<Value>CPWAIsCharaTherapy</Value>
</Value>
<Value name="34">
<Value>CPWAIsPiecesMed</Value>
</Value>
<Value name="35">
<Value>CPWAIsProprMed</Value>
</Value>
<Value name="36">
<Value>CPWAProprMedCost</Value>
</Value>
<Value name="37">
<Value>CPWATherapyCost</Value>
</Value>
<Value name="38">
<Value>CPWAWesternMedCost</Value>
</Value>
<Value name="39">
<Value>CPWACharaTherapyCost</Value>
</Value>
<Value name="40">
<Value>CPWAPharmacyInfo</Value>
</Value>
</Data>
<DataLocation>^DHCMR("CPWA")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMR("CPWA")</IdLocation>
<IndexLocation>^DHCMRi("CPWA",0)</IndexLocation>
<StreamLocation>^User.DHCMRClinPathWayAnalysisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
