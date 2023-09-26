Class User.DHCBPPatRegister Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPPR_RowId, SqlTableName = DHC_BP_PatRegister, StorageStrategy = CacheStorage ]
{

Relationship ChildDHCBPPatRegVisitStatus As User.DHCBPPatRegVisitStatus [ Cardinality = children, Inverse = BPPRVSParref ];

Index Date On BPPRDate As Exact;

Index PaPatMas On BPPRPaPatMasDr As Exact;

Index Status On BPPRStatus As Exact;

Index PatBPNo On BPPRPatBPNo As Exact;

Property BPPRPaPatMasDr As %String [ SqlColumnNumber = 2, SqlFieldName = BPPR_PaPatMas_Dr ];

Property BPPRAddress As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BPPR_Address ];

Property BPPRTelephone As %String [ SqlColumnNumber = 4, SqlFieldName = BPPR_Telephone ];

//联系人

Property BPPRContact As %String [ SqlColumnNumber = 5, SqlFieldName = BPPR_Contact ];

//介绍人

Property BPPRIntroducer As %String [ SqlColumnNumber = 6, SqlFieldName = BPPR_Introducer ];

Property BPPRDiagnosis As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BPPR_Diagnosis ];

Property BPPRCreateUserDr As %String [ SqlColumnNumber = 8, SqlFieldName = BPPR_CreateUser_Dr ];

//登记日期

Property BPPRDate As %Date [ SqlColumnNumber = 9, SqlFieldName = BPPR_Date ];

//登记时间

Property BPPRTime As %Time [ SqlColumnNumber = 10, SqlFieldName = BPPR_Time ];

//主管医生

Property BPPRMainDoctorCtcpDr As %String [ SqlColumnNumber = 11, SqlFieldName = BPPR_MainDoctorCtcp_Dr ];

//主管护士

Property BPPRMainNurseCtcpDr As %String [ SqlColumnNumber = 12, SqlFieldName = BPPR_MainNurseCtcp_Dr ];

/// 首次血液净化日期
Property BPPRStartDate As %Date [ SqlColumnNumber = 13, SqlFieldName = BPPR_StartDate ];

/// 转归日期
Property BPPREndDate As %Date [ SqlColumnNumber = 14, SqlFieldName = BPPR_EndDate ];

//正常/转归

Property BPPRStatus As %String(DISPLAYLIST = ",Normal,Discharge", MAXLEN = 9, SELECTIVITY = "33.3333%", VALUELIST = ",N,D") [ SqlColumnNumber = 15, SqlFieldName = BPPR_Status ];

//转归状态

Property BPPRBPCVisitStatusDr As User.DHCBPCVisitStatus [ SqlColumnNumber = 16, SqlFieldName = BPPR_BPCVisitStatus_Dr ];

Property BPPRBPCDeceaseReasonDr As User.DHCBPCDeceaseReason [ SqlColumnNumber = 17, SqlFieldName = BPPR_BPCDeceaseReason_Dr ];

//血液净化编号

Property BPPRPatBPNo As %String [ SqlColumnNumber = 18, SqlFieldName = BPPR_PatBPNo ];

//最大净化次数

Property BPPRPatBPCount As %Integer [ SqlColumnNumber = 19, SqlFieldName = BPPR_PatBPCount ];

Property BPPRPatSource As %String [ SqlColumnNumber = 20, SqlFieldName = BPPR_PatSource ];

//感染（多选）：乙肝、丙肝、梅毒、艾滋病

Property BPPRInfection As %String [ SqlColumnNumber = 21, SqlFieldName = BPPR_Infection ];

//持续治疗病人

Property BPPRIsMaintenanceTherapy As %Boolean [ SqlColumnNumber = 22, SqlFieldName = BPPR_IsMaintenanceTherapy ];

//其他死亡原因

Property BPPROtherDeceaseReason As %String [ SqlColumnNumber = 23, SqlFieldName = BPPR_OtherDeceaseReason ];

//病人就诊类型

Property BPPRPatClinicType As %String(DISPLAYLIST = ",Outpatient,Inpatient,Emergency", MAXLEN = 10, SELECTIVITY = "25%", VALUELIST = ",O,I,E") [ SqlColumnNumber = 24, SqlFieldName = BPPR_PatClinicType ];

//病人来源科室

Property BPPRPatSourcreDeptDr As %String [ SqlColumnNumber = 25, SqlFieldName = BPPR_PatSourcreDept_Dr ];

// 常规病人，临时病人

Property BPPRPatType As %String(DISPLAYLIST = ",Normal,Temporary", MAXLEN = 9, SELECTIVITY = "33.3333%", VALUELIST = ",N,T") [ SqlColumnNumber = 26, SqlFieldName = BPPR_PatType ];

Property BPPRAdmDr As %String [ SqlColumnNumber = 27, SqlFieldName = BPPR_Adm_Dr ];

//病人来源科室电话

Property BPPRPatSouceTel As %String [ SqlColumnNumber = 28, SqlFieldName = BPPR_PatSouceTel ];

//病人血透原因 指向诊断表Id

Property BPPRMRCICDDr As %String [ SqlColumnNumber = 29, SqlFieldName = BPPR_MRCICD_Dr ];

//病人死亡疾病 指向诊断表Id

Property BPPRDeceaseMRCICDDr As %String [ SqlColumnNumber = 30, SqlFieldName = BPPR_DeceaseMRCICD_Dr ];

Property BPPRPatDeptDr As %String [ SqlColumnNumber = 31, SqlFieldName = BPPR_PatDeptDr ];

Property BPPRUpdateUserDr As %String [ SqlColumnNumber = 32, SqlFieldName = BPPR_UpdateUser_Dr ];

Property BPPRUpdateDate As %Date [ SqlColumnNumber = 33, SqlFieldName = BPPR_UpdateDate ];

Property BPPRUpdateTime As %Time [ SqlColumnNumber = 34, SqlFieldName = BPPR_UpdateTime ];

Property BPPRPatLocationDr As %String [ SqlColumnNumber = 35, SqlFieldName = BPPR_PatLocationDr ];

Storage CacheStorage
{
<Data name="DHCBPPatRegisterClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPPatRegisterDefaultData">
<Value name="1">
<Value>BPPRPaPatMasDr</Value>
</Value>
<Value name="2">
<Value>BPPRAddress</Value>
</Value>
<Value name="3">
<Value>BPPRTelephone</Value>
</Value>
<Value name="4">
<Value>BPPRContact</Value>
</Value>
<Value name="5">
<Value>BPPRIntroducer</Value>
</Value>
<Value name="6">
<Value>BPPRDiagnosis</Value>
</Value>
<Value name="7">
<Value>BPPRCreateUserDr</Value>
</Value>
<Value name="8">
<Value>BPPRDate</Value>
</Value>
<Value name="9">
<Value>BPPRTime</Value>
</Value>
<Value name="10">
<Value>BPPRMainDoctorCtcpDr</Value>
</Value>
<Value name="11">
<Value>BPPRMainNurseCtcpDr</Value>
</Value>
<Value name="12">
<Value>BPPRStartDate</Value>
</Value>
<Value name="13">
<Value>BPPREndDate</Value>
</Value>
<Value name="14">
<Value>BPPRStatus</Value>
</Value>
<Value name="15">
<Value>BPPRBPCVisitStatusDr</Value>
</Value>
<Value name="16">
<Value>BPPRBPCDeceaseReasonDr</Value>
</Value>
<Value name="17">
<Value>BPPRPatBPNo</Value>
</Value>
<Value name="18">
<Value>BPPRPatBPCount</Value>
</Value>
<Value name="19">
<Value>BPPRPatSource</Value>
</Value>
<Value name="20">
<Value>BPPRInfection</Value>
</Value>
<Value name="21">
<Value>BPPRIsMaintenanceTherapy</Value>
</Value>
<Value name="22">
<Value>BPPROtherDeceaseReason</Value>
</Value>
<Value name="23">
<Value>BPPRPatClinicType</Value>
</Value>
<Value name="24">
<Value>BPPRPatSourcreDeptDr</Value>
</Value>
<Value name="25">
<Value>BPPRPatType</Value>
</Value>
<Value name="26">
<Value>BPPRAdmDr</Value>
</Value>
<Value name="27">
<Value>BPPRPatSouceTel</Value>
</Value>
<Value name="28">
<Value>BPPRMRCICDDr</Value>
</Value>
<Value name="29">
<Value>BPPRDeceaseMRCICDDr</Value>
</Value>
<Value name="30">
<Value>BPPRPatDeptDr</Value>
</Value>
<Value name="31">
<Value>BPPRUpdateUserDr</Value>
</Value>
<Value name="32">
<Value>BPPRUpdateDate</Value>
</Value>
<Value name="33">
<Value>BPPRUpdateTime</Value>
</Value>
<Value name="34">
<Value>BPPRPatLocationDr</Value>
</Value>
</Data>
<DataLocation>^DHCBPPatRegister</DataLocation>
<DefaultData>DHCBPPatRegisterDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPPatRegister</IdLocation>
<IndexLocation>^DHCBPPatRegister(0)</IndexLocation>
<StreamLocation>^User.DHCBPPatRegisterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
