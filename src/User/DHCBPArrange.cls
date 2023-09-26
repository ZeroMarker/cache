Class User.DHCBPArrange Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPA_RowId, SqlTableName = DHC_BP_Arrange, StorageStrategy = CacheStorage ]
{

Relationship ChildDHCBPArrangeEquipRunPara As User.DHCBPArrangeEquipRunPara [ Cardinality = children, Inverse = BPAERPParref ];

Index PatRegister On BPABPPatRegisterDr As Exact;

Index Adm On BPAAdmDr As Exact;

Index Date On BPADate As Exact;

Index BedStatus On (BPABPCBedDr, BPAStatus As AlphaUp);

Property BPABPPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 2, SqlFieldName = BPA_BPPatRegister_Dr ];

Property BPAAdmDr As %String [ SqlColumnNumber = 3, SqlFieldName = BPA_Adm_Dr ];

/// 透析方案指针
Property BPABPSchemeDr As User.DHCBPScheme [ SqlColumnNumber = 4, SqlFieldName = BPA_BPScheme_Dr ];

Property BPADate As %Date [ SqlColumnNumber = 5, SqlFieldName = BPA_Date ];

Property BPATime As %Time [ SqlColumnNumber = 6, SqlFieldName = BPA_Time ];

Property BPADaySeqNo As %String(DISPLAYLIST = ",AM,PM,Evening", MAXLEN = 7, SELECTIVITY = "25%", VALUELIST = ",A,P,E") [ SqlColumnNumber = 7, SqlFieldName = BPA_DaySeqNo ];

Property BPABPCBedDr As User.DHCBPCBed [ SqlColumnNumber = 8, SqlFieldName = BPA_BPCBed_Dr ];

/// 排班模式:固定/临时
Property BPAArrangeType As %String(DISPLAYLIST = ",Maintenance,Temp", MAXLEN = 11, SELECTIVITY = "33.3333%", VALUELIST = ",M,T") [ SqlColumnNumber = 9, SqlFieldName = BPA_ArrangeType ];

Property BPAStatus As %String(DISPLAYLIST = ",Apply,Decline,Receive,Monitor,Terminate,Finish", MAXLEN = 9, SELECTIVITY = "14.2857%", TRUNCATE = 1, VALUELIST = ",A,D,R,M,T,F") [ SqlColumnNumber = 10, SqlFieldName = BPA_Status ];

/// 治疗前体重
Property BPAStartWeight As %Float [ SqlColumnNumber = 11, SqlFieldName = BPA_StartWeight ];

/// 去除体重
Property BPASubtractiveWeight As %Float [ SqlColumnNumber = 12, SqlFieldName = BPA_SubtractiveWeight ];

/// 治疗中摄入量
Property BPAIntakeAmount As %Float [ SqlColumnNumber = 13, SqlFieldName = BPA_IntakeAmount ];

/// 预除水量(超滤量)
Property BPAPlanDewaterAmount As %Float [ SqlColumnNumber = 14, SqlFieldName = BPA_PlanDewaterAmount ];

/// 治疗后体重
Property BPAEndWeight As %Float [ SqlColumnNumber = 15, SqlFieldName = BPA_EndWeight ];

/// 实超滤量
Property BPADewaterAmount As %Float [ SqlColumnNumber = 16, SqlFieldName = BPA_DewaterAmount ];

/// 进食量
Property BPAFoodIntakeAmount As %Float [ SqlColumnNumber = 17, SqlFieldName = BPA_FoodIntakeAmount ];

/// 回血量
Property BPAResidualBloodAmount As %Float [ SqlColumnNumber = 18, SqlFieldName = BPA_ResidualBloodAmount ];

/// 透析(分钟)
Property BPATherapyDuration As %Float [ SqlColumnNumber = 19, SqlFieldName = BPA_TherapyTime ];

/// 冲管护士
Property BPAFlushPipeNurseCtcpDr As %String [ SqlColumnNumber = 20, SqlFieldName = BPA_FlushPipeNurseCtcp_Dr ];

/// 穿刺护士
Property BPAPunctureNurseCtcpDr As %String [ SqlColumnNumber = 21, SqlFieldName = BPA_PunctureNurseCtcp_Dr ];

/// 巡视护士
Property BPACirculatingNurseCtcpDr As %String [ SqlColumnNumber = 22, SqlFieldName = BPA_CirculatingNurseCtcp_Dr ];

/// 接管护士
Property BPAJoinPipeNurseCtcpDr As %String [ SqlColumnNumber = 23, SqlFieldName = BPA_JoinPipeNurseCtcp_Dr ];

/// 结束护士
Property BPACloseNurseCtcpDr As %String [ SqlColumnNumber = 24, SqlFieldName = BPA_CloseNurseCtcp_Dr ];

/// 血管通路方案指针
Property BPAVascularAccessDr As User.DHCBPVascularAccess [ SqlColumnNumber = 25, SqlFieldName = BPA_VascularAccess_Dr ];

/// 血液净化设备指针
Property BPABPCEquipDr As User.DHCBPCEquip [ SqlColumnNumber = 26, SqlFieldName = BPA_BPCEquip_Dr ];

/// 血液净化模式
Property BPABPCBPModeDr As User.DHCBPCBloodPurificationMode [ SqlColumnNumber = 27, SqlFieldName = BPA_BPCBPMode_Dr ];

/// 第二血液净化模式
Property BPASecondBPCBPModeDr As User.DHCBPCBloodPurificationMode [ SqlColumnNumber = 28, SqlFieldName = BPA_SecondBPCBPMode_Dr ];

/// 第三血液净化模式
Property BPAThirdBPCBPModeDr As User.DHCBPCBloodPurificationMode [ SqlColumnNumber = 29, SqlFieldName = BPA_ThirdBPCBPMode_Dr ];

/// 血液净化材料
Property BPABPCConsumableDr As User.DHCBPCConsumable [ SqlColumnNumber = 30, SqlFieldName = BPA_BPCConsumable_Dr ];

/// 第二血液净化材料
Property BPASecondBPCConsumableDr As User.DHCBPCConsumable [ SqlColumnNumber = 31, SqlFieldName = BPA_SecondBPCConsumable_Dr ];

/// 第三血液净化材料
Property BPAThirdBPCConsumableDr As User.DHCBPCConsumable [ SqlColumnNumber = 32, SqlFieldName = BPA_ThirdBPCConsumable_Dr ];

/// 运行模式(多选)
Property BPABPCEquipRunParaDr As %String [ SqlColumnNumber = 33, SqlFieldName = BPA_BPCEquipRunPara_Dr ];

/// 插过医嘱
Property BPAOrdered As %Boolean [ SqlColumnNumber = 34, SqlFieldName = BPA_Ordered ];

/// 凝血时间
Property BPACt As %Float [ SqlColumnNumber = 35, SqlFieldName = BPA_Ct ];

/// 活化凝血时间
Property BPAAct As %Float [ SqlColumnNumber = 36, SqlFieldName = BPA_Act ];

/// 口服补血剂
Property BPAOralHematin As %String [ SqlColumnNumber = 37, SqlFieldName = BPA_OralHematin ];

/// 注射补血针
Property BPAInjectHematin As %String [ SqlColumnNumber = 38, SqlFieldName = BPA_InjectHematin ];

/// 肝素量
Property BPAHeparin As %String [ SqlColumnNumber = 39, SqlFieldName = BPA_Heparin ];

/// 首推肝素量
Property BPAFirstHeparinAmount As %Float [ SqlColumnNumber = 40, SqlFieldName = BPA_FirstHeparinAmount ];

/// 透析前尿素
Property BPAPreDiaUrea As %Float [ SqlColumnNumber = 41, SqlFieldName = BPA_PreDiaUrea ];

/// 透析后尿素
Property BPAPostDiaUrea As %Float [ SqlColumnNumber = 42, SqlFieldName = BPA_PostDiaUrea ];

/// 钠浓度
Property BPANa As %Float [ SqlColumnNumber = 43, SqlFieldName = BPA_Na ];

/// 钾浓度
Property BPAK As %Float [ SqlColumnNumber = 44, SqlFieldName = BPA_K ];

/// 钙浓度
Property BPACa2 As %Float [ SqlColumnNumber = 45, SqlFieldName = BPA_Ca2 ];

/// 碳酸氢根浓度
Property BPAHCO3 As %Float [ SqlColumnNumber = 46, SqlFieldName = BPA_HCO3 ];

/// 血滤置换液输入方式（前置换、后置换液)
Property BPAFilterReplaceMode As %String [ SqlColumnNumber = 47, SqlFieldName = BPA_FilterReplaceMode ];

/// 血滤置换液量
Property BPAFilterReplaceAmount As %Float [ SqlColumnNumber = 48, SqlFieldName = BPA_FilterReplaceAmount ];

/// 机器运转效果
Property BPAEquipRunEffect As %String [ SqlColumnNumber = 49, SqlFieldName = BPA_EquipRunEffect ];

/// 透析器凝血
Property BPAGrume As %String [ SqlColumnNumber = 50, SqlFieldName = BPA_Grume ];

/// 管路凝血
Property BPAPipeGrume As %String [ SqlColumnNumber = 51, SqlFieldName = BPA_PipeGrume ];

/// 动静脉内瘘
Property BPAAVFEffect As %String [ SqlColumnNumber = 52, SqlFieldName = BPA_AVFStatus ];

/// 震颤
Property BPADindle As %String [ SqlColumnNumber = 53, SqlFieldName = BPA_Dindle ];

/// 置管接口方向
Property BPAJoinDirection As %String [ SqlColumnNumber = 54, SqlFieldName = BPA_JoinDirection ];

/// 出口效果
Property BPAOutletEffect As %String [ SqlColumnNumber = 55, SqlFieldName = BPA_OutletStat ];

/// 医生操作状态
Property BPADocOperateStatus As %String(DISPLAYLIST = ",Check,Recheck", MAXLEN = 7, SELECTIVITY = "25%", VALUELIST = ",C,R") [ SqlColumnNumber = 56, SqlFieldName = BPA_DocOperateStatus ];

/// 该病人在血透系统里第几次透析
Property BPABPNum As %Integer [ SqlColumnNumber = 57, SqlFieldName = BPA_BPNum ];

Property BPAURR As %Float [ SqlColumnNumber = 58, SqlFieldName = BPA_URR ];

Property BPAKtV As %String [ SqlColumnNumber = 59, SqlFieldName = BPA_KtV ];

/// 血压测量部位
Property BPABPMeasurePart As %String(DISPLAYLIST = ",Upper,Lower", MAXLEN = 7, SELECTIVITY = "25%", VALUELIST = ",U,L") [ SqlColumnNumber = 60, SqlFieldName = BPA_BPMeasurePart ];

Property BPATemperature As %Float [ SqlColumnNumber = 61, SqlFieldName = BPA_Temperature ];

/// 充水量
Property BPAReplenishWaterAmount As %Float [ SqlColumnNumber = 62, SqlFieldName = BPA_ReplenishWaterAmount ];

/// 透析前舒张压
Property BPAStartDiastolicPressure As %Float [ SqlColumnNumber = 63, SqlFieldName = BPA_StartDiastolicPressure ];

/// 透析后舒张压
Property BPAEndDiastolicPressure As %Float [ SqlColumnNumber = 64, SqlFieldName = BPA_EndDiastolicPressure ];

/// 透析前收缩压
Property BPAStartSystolicPressure As %Float [ SqlColumnNumber = 65, SqlFieldName = BPA_StartSystolicPressure ];

/// 透析后收缩压
Property BPAEndSystolicPressure As %Float [ SqlColumnNumber = 66, SqlFieldName = BPA_EndSystolicPressure ];

/// 透析前心率
Property BPAStartHeartRate As %Float [ SqlColumnNumber = 67, SqlFieldName = BPA_StartHeartRate ];

/// 透析后心率
Property BPAEndHeartRate As %Float [ SqlColumnNumber = 68, SqlFieldName = BPA_EndHeartRate ];

/// 透析前症状
Property BPAStartSymptom As %String [ SqlColumnNumber = 69, SqlFieldName = BPA_StartSymptom ];

/// 透析后症状
Property BPAEndSymptom As %String [ SqlColumnNumber = 70, SqlFieldName = BPA_EndSymptom ];

/// 尿量
Property BPAUrineVolume As %Float [ SqlColumnNumber = 71, SqlFieldName = BPA_UrineVolume ];

/// 临床评估备注
Property BPAClinicalEvaluationNote As %String [ SqlColumnNumber = 72, SqlFieldName = BPA_ClinicalEvaluationNote ];

/// 单纯超滤量
Property BPAIsolatedUltVolume As %Float [ SqlColumnNumber = 73, SqlFieldName = BPA_IsolatedUltVolume ];

/// 血流速
Property BPABFR As %Float [ SqlColumnNumber = 74, SqlFieldName = BPA_BFR ];

/// 血流速备注
Property BPABFRNote As %String [ SqlColumnNumber = 75, SqlFieldName = BPA_BFRNote ];

/// 血管通路码表指针
Property BPABPCVADr As User.DHCBPCVascularAccess [ SqlColumnNumber = 76, SqlFieldName = BPA_BPCVA_Dr ];

/// 血管通路建立部位
Property BPAVABodySiteDr As %String [ SqlColumnNumber = 77, SqlFieldName = BPA_VABodySite_Dr ];

/// 抗凝方式指针
Property BPAAnticoagulantModeDr As User.DHCBPCAnticoagulantMode [ SqlColumnNumber = 78, SqlFieldName = BPA_AnticoagulantMode_Dr ];

/// 回输盐水总量
Property BPAReturnSalineAmount As %Float [ SqlColumnNumber = 79, SqlFieldName = BPA_ReturnSalineAmount ];

/// 透析方案调整备注
Property BPABPSchemeAdjustment As %String(MAXLEN = 800) [ SqlColumnNumber = 80, SqlFieldName = BPA_BPSchemeAdjustment ];

/// 透析计划时间(分钟)
Property BPAPlanTherapyDuration As %Float [ SqlColumnNumber = 81, SqlFieldName = BPA_PlanTherapyTime ];

/// 计划血滤置换液量
Property BPAPlanFilterReplaceAmount As %Float [ SqlColumnNumber = 82, SqlFieldName = BPA_PlanFilterReplaceAmount ];

/// 透析液流速
Property BPADFR As %Float [ SqlColumnNumber = 83, SqlFieldName = BPA_DFR ];

/// 血管通路情况
Property BPAVascularAccessStatus As %String [ SqlColumnNumber = 84, SqlFieldName = BPA_VascularAccessStatus ];

/// 病情处理记录
Property BPADiseaseTreatment As %String(MAXLEN = 800) [ SqlColumnNumber = 85, SqlFieldName = BPA_DiseaseTreatment ];

Property BPANote As %String(MAXLEN = 500) [ SqlColumnNumber = 86, SqlFieldName = BPA_Note ];

Property BPAEndDate As %Date [ SqlColumnNumber = 87, SqlFieldName = BPA_EndDate ];

Property BPAEndTime As %Time [ SqlColumnNumber = 88, SqlFieldName = BPA_EndTime ];

Property BPACreateUserDr As %String [ SqlColumnNumber = 89, SqlFieldName = BPA_CreateUser_Dr ];

Property BPACreateDate As %Date [ SqlColumnNumber = 90, SqlFieldName = BPA_CreateDate ];

Property BPACreateTime As %Time [ SqlColumnNumber = 91, SqlFieldName = BPA_CreateTime ];

/// 核查医生
Property BPACheckDocDr As %String [ SqlColumnNumber = 92, SqlFieldName = BPA_CheckDoc_Dr ];

Property BPACheckDate As %Date [ SqlColumnNumber = 93, SqlFieldName = BPA_CheckDate ];

Property BPACheckTime As %Time [ SqlColumnNumber = 94, SqlFieldName = BPA_CheckTime ];

/// 复核医生
Property BPARecheckDocDr As %String [ SqlColumnNumber = 95, SqlFieldName = BPA_RecheckDoc_Dr ];

Property BPARecheckDate As %Date [ SqlColumnNumber = 96, SqlFieldName = BPA_RecheckDate ];

Property BPARecheckTime As %Time [ SqlColumnNumber = 97, SqlFieldName = BPA_RecheckTime ];

/// 查房医生
Property BPAWardRoundDocDr As %String [ SqlColumnNumber = 98, SqlFieldName = BPA_WardRoundDoc_Dr ];

Property BPAWardRoundDate As %Date [ SqlColumnNumber = 99, SqlFieldName = BPA_WardRoundDate ];

Property BPAWardRoundTime As %Time [ SqlColumnNumber = 100, SqlFieldName = BPA_WardRoundTime ];

/// 透析后更新医生
Property BPAEndUpdateDocDr As %String [ SqlColumnNumber = 101, SqlFieldName = BPA_EndUpdateDoc_Dr ];

Property BPADocEndUpdateDate As %Date [ SqlColumnNumber = 102, SqlFieldName = BPA_DocEndUpdateDate ];

Property BPADocEndUpdateTime As %Time [ SqlColumnNumber = 103, SqlFieldName = BPA_DocEndUpdateTime ];

/// 上机护士
Property BPAStartOperationNurseDr As %String [ SqlColumnNumber = 104, SqlFieldName = BPA_StartOperationNurse_Dr ];

Property BPAStartOperationDate As %Date [ SqlColumnNumber = 105, SqlFieldName = BPA_StartOperationDate ];

Property BPAStartOperationTime As %Time [ SqlColumnNumber = 106, SqlFieldName = BPA_StartOperationTime ];

/// 下机护士
Property BPAEndOperationNurseDr As %String [ SqlColumnNumber = 107, SqlFieldName = BPA_EndOperationNurse_Dr ];

Property BPAEndOperationDate As %Date [ SqlColumnNumber = 108, SqlFieldName = BPA_EndOperationDate ];

Property BPAEndOperationTime As %Time [ SqlColumnNumber = 109, SqlFieldName = BPA_EndOperationTime ];

/// 核查护士
Property BPACheckNurseDr As %String [ SqlColumnNumber = 110, SqlFieldName = BPA_CheckNurse_Dr ];

Property BPANurseCheckDate As %Date [ SqlColumnNumber = 111, SqlFieldName = BPA_NurseCheckDate ];

Property BPANurseCheckTime As %Time [ SqlColumnNumber = 112, SqlFieldName = BPA_NurseCheckTime ];

/// 实验室检查(腹透复诊记录)
Property BPALaboratoryExamination As %String(MAXLEN = 1000) [ SqlColumnNumber = 113, SqlFieldName = BPA_LaboratoryExamination ];

/// 其他症状(腹透复诊记录)
Property BPAOtherSymptoms As %String(MAXLEN = 500) [ SqlColumnNumber = 114, SqlFieldName = BPA_OtherSymptoms ];

/// 治疗备注
Property BPADialysisBeforeNote As %String(MAXLEN = 500) [ SqlColumnNumber = 115, SqlFieldName = BPA_DialysisBeforeNote ];

/// 充分性评估PCR
Property BPAPCR As %String [ SqlColumnNumber = 116, SqlFieldName = BPA_PCR ];

Storage CacheStorage
{
<Data name="DHCBPArrangeClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPArrangeDefaultData">
<Value name="1">
<Value>BPABPPatRegisterDr</Value>
</Value>
<Value name="2">
<Value>BPAAdmDr</Value>
</Value>
<Value name="3">
<Value>BPABPSchemeDr</Value>
</Value>
<Value name="4">
<Value>BPADate</Value>
</Value>
<Value name="5">
<Value>BPATime</Value>
</Value>
<Value name="6">
<Value>BPADaySeqNo</Value>
</Value>
<Value name="7">
<Value>BPABPCBedDr</Value>
</Value>
<Value name="8">
<Value>BPAArrangeType</Value>
</Value>
<Value name="9">
<Value>BPAStatus</Value>
</Value>
<Value name="10">
<Value>BPAStartWeight</Value>
</Value>
<Value name="11">
<Value>BPASubtractiveWeight</Value>
</Value>
<Value name="12">
<Value>BPAIntakeAmount</Value>
</Value>
<Value name="13">
<Value>BPAPlanDewaterAmount</Value>
</Value>
<Value name="14">
<Value>BPAEndWeight</Value>
</Value>
<Value name="15">
<Value>BPADewaterAmount</Value>
</Value>
<Value name="16">
<Value>BPAFoodIntakeAmount</Value>
</Value>
<Value name="17">
<Value>BPAResidualBloodAmount</Value>
</Value>
<Value name="18">
<Value>BPATherapyDuration</Value>
</Value>
<Value name="19">
<Value>BPAFlushPipeNurseCtcpDr</Value>
</Value>
<Value name="20">
<Value>BPAPunctureNurseCtcpDr</Value>
</Value>
<Value name="21">
<Value>BPACirculatingNurseCtcpDr</Value>
</Value>
<Value name="22">
<Value>BPAJoinPipeNurseCtcpDr</Value>
</Value>
<Value name="23">
<Value>BPACloseNurseCtcpDr</Value>
</Value>
<Value name="24">
<Value>BPAVascularAccessDr</Value>
</Value>
<Value name="25">
<Value>BPABPCEquipDr</Value>
</Value>
<Value name="26">
<Value>BPABPCBPModeDr</Value>
</Value>
<Value name="27">
<Value>BPASecondBPCBPModeDr</Value>
</Value>
<Value name="28">
<Value>BPAThirdBPCBPModeDr</Value>
</Value>
<Value name="29">
<Value>BPABPCConsumableDr</Value>
</Value>
<Value name="30">
<Value>BPASecondBPCConsumableDr</Value>
</Value>
<Value name="31">
<Value>BPAThirdBPCConsumableDr</Value>
</Value>
<Value name="32">
<Value>BPABPCEquipRunParaDr</Value>
</Value>
<Value name="33">
<Value>BPAOrdered</Value>
</Value>
<Value name="34">
<Value>BPACt</Value>
</Value>
<Value name="35">
<Value>BPAAct</Value>
</Value>
<Value name="36">
<Value>BPAOralHematin</Value>
</Value>
<Value name="37">
<Value>BPAInjectHematin</Value>
</Value>
<Value name="38">
<Value>BPAHeparin</Value>
</Value>
<Value name="39">
<Value>BPAFirstHeparinAmount</Value>
</Value>
<Value name="40">
<Value>BPAPreDiaUrea</Value>
</Value>
<Value name="41">
<Value>BPAPostDiaUrea</Value>
</Value>
<Value name="42">
<Value>BPANa</Value>
</Value>
<Value name="43">
<Value>BPAK</Value>
</Value>
<Value name="44">
<Value>BPACa2</Value>
</Value>
<Value name="45">
<Value>BPAHCO3</Value>
</Value>
<Value name="46">
<Value>BPAFilterReplaceMode</Value>
</Value>
<Value name="47">
<Value>BPAFilterReplaceAmount</Value>
</Value>
<Value name="48">
<Value>BPAEquipRunEffect</Value>
</Value>
<Value name="49">
<Value>BPAGrume</Value>
</Value>
<Value name="50">
<Value>BPAPipeGrume</Value>
</Value>
<Value name="51">
<Value>BPAAVFEffect</Value>
</Value>
<Value name="52">
<Value>BPADindle</Value>
</Value>
<Value name="53">
<Value>BPAJoinDirection</Value>
</Value>
<Value name="54">
<Value>BPAOutletEffect</Value>
</Value>
<Value name="55">
<Value>BPADocOperateStatus</Value>
</Value>
<Value name="56">
<Value>BPABPNum</Value>
</Value>
<Value name="57">
<Value>BPAURR</Value>
</Value>
<Value name="58">
<Value>BPAKtV</Value>
</Value>
<Value name="59">
<Value>BPABPMeasurePart</Value>
</Value>
<Value name="60">
<Value>BPATemperature</Value>
</Value>
<Value name="61">
<Value>BPAReplenishWaterAmount</Value>
</Value>
<Value name="62">
<Value>BPAStartDiastolicPressure</Value>
</Value>
<Value name="63">
<Value>BPAEndDiastolicPressure</Value>
</Value>
<Value name="64">
<Value>BPAStartSystolicPressure</Value>
</Value>
<Value name="65">
<Value>BPAEndSystolicPressure</Value>
</Value>
<Value name="66">
<Value>BPAStartHeartRate</Value>
</Value>
<Value name="67">
<Value>BPAEndHeartRate</Value>
</Value>
<Value name="68">
<Value>BPAStartSymptom</Value>
</Value>
<Value name="69">
<Value>BPAEndSymptom</Value>
</Value>
<Value name="70">
<Value>BPAUrineVolume</Value>
</Value>
<Value name="71">
<Value>BPAClinicalEvaluationNote</Value>
</Value>
<Value name="72">
<Value>BPAIsolatedUltVolume</Value>
</Value>
<Value name="73">
<Value>BPABFR</Value>
</Value>
<Value name="74">
<Value>BPABFRNote</Value>
</Value>
<Value name="75">
<Value>BPABPCVADr</Value>
</Value>
<Value name="76">
<Value>BPAVABodySiteDr</Value>
</Value>
<Value name="77">
<Value>BPAAnticoagulantModeDr</Value>
</Value>
<Value name="78">
<Value>BPAReturnSalineAmount</Value>
</Value>
<Value name="79">
<Value>BPABPSchemeAdjustment</Value>
</Value>
<Value name="80">
<Value>BPAPlanTherapyDuration</Value>
</Value>
<Value name="81">
<Value>BPAPlanFilterReplaceAmount</Value>
</Value>
<Value name="82">
<Value>BPADFR</Value>
</Value>
<Value name="83">
<Value>BPAVascularAccessStatus</Value>
</Value>
<Value name="84">
<Value>BPADiseaseTreatment</Value>
</Value>
<Value name="85">
<Value>BPANote</Value>
</Value>
<Value name="86">
<Value>BPAEndDate</Value>
</Value>
<Value name="87">
<Value>BPAEndTime</Value>
</Value>
<Value name="88">
<Value>BPACreateUserDr</Value>
</Value>
<Value name="89">
<Value>BPACreateDate</Value>
</Value>
<Value name="90">
<Value>BPACreateTime</Value>
</Value>
<Value name="91">
<Value>BPACheckDocDr</Value>
</Value>
<Value name="92">
<Value>BPACheckDate</Value>
</Value>
<Value name="93">
<Value>BPACheckTime</Value>
</Value>
<Value name="94">
<Value>BPARecheckDocDr</Value>
</Value>
<Value name="95">
<Value>BPARecheckDate</Value>
</Value>
<Value name="96">
<Value>BPARecheckTime</Value>
</Value>
<Value name="97">
<Value>BPAWardRoundDocDr</Value>
</Value>
<Value name="98">
<Value>BPAWardRoundDate</Value>
</Value>
<Value name="99">
<Value>BPAWardRoundTime</Value>
</Value>
<Value name="100">
<Value>BPAEndUpdateDocDr</Value>
</Value>
<Value name="101">
<Value>BPADocEndUpdateDate</Value>
</Value>
<Value name="102">
<Value>BPADocEndUpdateTime</Value>
</Value>
<Value name="103">
<Value>BPAStartOperationNurseDr</Value>
</Value>
<Value name="104">
<Value>BPAStartOperationDate</Value>
</Value>
<Value name="105">
<Value>BPAStartOperationTime</Value>
</Value>
<Value name="106">
<Value>BPAEndOperationNurseDr</Value>
</Value>
<Value name="107">
<Value>BPAEndOperationDate</Value>
</Value>
<Value name="108">
<Value>BPAEndOperationTime</Value>
</Value>
<Value name="109">
<Value>BPACheckNurseDr</Value>
</Value>
<Value name="110">
<Value>BPANurseCheckDate</Value>
</Value>
<Value name="111">
<Value>BPANurseCheckTime</Value>
</Value>
<Value name="112">
<Value>BPALaboratoryExamination</Value>
</Value>
<Value name="113">
<Value>BPAOtherSymptoms</Value>
</Value>
<Value name="114">
<Value>BPADialysisBeforeNote</Value>
</Value>
<Value name="115">
<Value>BPAPCR</Value>
</Value>
</Data>
<DataLocation>^DHCBPArrange</DataLocation>
<DefaultData>DHCBPArrangeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPArrange</IdLocation>
<IndexLocation>^DHCBPArrange(0)</IndexLocation>
<StreamLocation>^User.DHCBPArrangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
