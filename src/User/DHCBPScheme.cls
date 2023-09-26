Class User.DHCBPScheme Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = BPS_RowId, SqlTableName = DHC_BP_Scheme, StorageStrategy = CacheStorage ]
{

Relationship ChildDHCBPSchemeEquipRunPara As User.DHCBPSchemeEquipRunPara [ Cardinality = children, Inverse = BPSERPParref ];

Index PatRegister On BPSBPPatRegisterDr As Plus;

Index Template On BPSTemplateName As Space;

Property BPSBPPatRegisterDr As User.DHCBPPatRegister [ SqlColumnNumber = 2, SqlFieldName = BPS_BPRegister_Dr ];

/// 方案开始日期
Property BPSStartDate As %Date [ SqlColumnNumber = 3, SqlFieldName = BPS_StartDate ];

/// 方案结束日期
Property BPSEndDate As %Date [ SqlColumnNumber = 4, SqlFieldName = BPS_EndDate ];

/// 每周次数
Property BPSWeekNum As %Integer [ SqlColumnNumber = 5, SqlFieldName = BPS_WeekNum ];

/// 病人干体重
Property BPSPatDryWeight As %Float [ SqlColumnNumber = 6, SqlFieldName = BPS_PatDryWeight ];

/// 最大除水量kg
Property BPSMaxDewaterAmount As %Float [ SqlColumnNumber = 7, SqlFieldName = BPS_MaxDeWaterAmount ];

/// 净除水量
Property BPSNetDewaterAmount As %Float [ SqlColumnNumber = 8, SqlFieldName = BPS_NetDeWaterAmount ];

/// 进食量
Property BPSFoodIntakeAmount As %Float [ SqlColumnNumber = 9, SqlFieldName = BPS_FoodIntakeAmount ];

/// 回血量
Property BPSResidualBloodAmount As %Float [ SqlColumnNumber = 10, SqlFieldName = BPS_ResidualBloodAmount ];

/// 血管通路方案指针
Property BPSVascularAccessDr As User.DHCBPVascularAccess [ SqlColumnNumber = 11, SqlFieldName = BPS_VascularAccess_Dr ];

/// 血透机/血液滤过机型号
Property BPSBPCEquipModelDr As User.DHCBPCEquipModel [ SqlColumnNumber = 12, SqlFieldName = BPS_BPCEquipModel_Dr ];

/// 第一血液净化方式指针
Property BPSBPCBPModeDr As User.DHCBPCBloodPurificationMode [ SqlColumnNumber = 13, SqlFieldName = BPS_BPCBPMode_Dr ];

/// 第二血液净化方式指针
Property BPSSecondBPCBPModeDr As User.DHCBPCBloodPurificationMode [ SqlColumnNumber = 14, SqlFieldName = BPS_SecondBPCBPMode_Dr ];

/// 第三血液净化方式指针
Property BPSThirdBPCBPModeDr As User.DHCBPCBloodPurificationMode [ SqlColumnNumber = 15, SqlFieldName = BPS_ThirdBPCBPMode_Dr ];

/// 透析器/滤过器
Property BPSBPCConsumableDr As User.DHCBPCConsumable [ SqlColumnNumber = 16, SqlFieldName = BPS_BPCConsumable_Dr ];

/// 透析器/滤过器
Property BPSSecondBPCConsumableDr As User.DHCBPCConsumable [ SqlColumnNumber = 17, SqlFieldName = BPS_SecondBPCConsumable_Dr ];

/// 透析器/滤过器
Property BPSThirdBPCConsumableDr As User.DHCBPCConsumable [ SqlColumnNumber = 18, SqlFieldName = BPS_ThirdBPCConsumable_Dr ];

/// 治疗时间(h)
Property BPSTherapyDuration As %Time [ SqlColumnNumber = 19, SqlFieldName = BPS_TherapyDuration ];

/// 抗凝方案指针
Property BPSAnticoagulantModeDr As User.DHCBPCAnticoagulantMode [ SqlColumnNumber = 20, SqlFieldName = BPS_AnticoagulantMode_Dr ];

/// 首推量(肝素mg)
Property BPSFirstHeparinAmount As %Float [ SqlColumnNumber = 21, SqlFieldName = BPS_FirstHeparinAmount ];

/// （血透、血滤）机器运行参数
Property BPSBPCEquipRunParaDr As %String [ SqlColumnNumber = 22, SqlFieldName = BPS_BPCEquipRunPara_Dr ];

/// 血滤置换液输入方式（前稀释，后稀释）(暂停使用)
Property BPSFilterReplaceMode As %String [ SqlColumnNumber = 23, SqlFieldName = BPS_FilterReplaceMode ];

/// 血滤置换量(暂停使用)
Property BPSFilterReplaceAmount As %Float [ SqlColumnNumber = 24, SqlFieldName = BPS_FilterReplaceAmount ];

/// 口服补血剂
Property BPSOralHematin As %String [ SqlColumnNumber = 25, SqlFieldName = BPS_OralHematin ];

/// 注射补血针
Property BPSInjectHematin As %String [ SqlColumnNumber = 26, SqlFieldName = BPS_InjectHematin ];

/// 钠浓度
Property BPSNa As %Float [ SqlColumnNumber = 27, SqlFieldName = BPS_Na ];

/// 钾浓度
Property BPSK As %Float [ SqlColumnNumber = 28, SqlFieldName = BPS_K ];

/// 钙浓度
Property BPSCa2 As %Float [ SqlColumnNumber = 29, SqlFieldName = BPS_Ca2 ];

/// 碳酸氢根浓度
Property BPSHCO3 As %Float [ SqlColumnNumber = 30, SqlFieldName = BPS_HCO3 ];

/// 备注
Property BPSNote As %String [ SqlColumnNumber = 31, SqlFieldName = BPS_Note ];

Property BPSUpdateUserDr As %String [ SqlColumnNumber = 32, SqlFieldName = BPS_UpdateUser_Dr ];

Property BPSUpdateDate As %Date [ SqlColumnNumber = 33, SqlFieldName = BPS_UpdateDate ];

Property BPSUpdateTime As %Time [ SqlColumnNumber = 34, SqlFieldName = BPS_UpdateTime ];

/// 肝素维持剂量
Property BPSHeparinDose As %Float [ SqlColumnNumber = 35, SqlFieldName = BPS_HeparinDose ];

/// 鱼精蛋白量
Property BPSProtamineAmount As %Float [ SqlColumnNumber = 36, SqlFieldName = BPS_ProtamineAmount ];

/// 低分子肝素总量
Property BPSLowMoleHeparinAmount As %Float [ SqlColumnNumber = 37, SqlFieldName = BPS_LowMoleHeparinAmount ];

/// 模板名
Property BPSTemplateName As %String [ SqlColumnNumber = 38, SqlFieldName = BPS_TemplateName ];

/// 血流速
Property BPSBFR As %Float [ SqlColumnNumber = 39, SqlFieldName = BPS_BFR ];

/// 血流速备注
Property BPSBFRNote As %String [ SqlColumnNumber = 40, SqlFieldName = BPS_BFRNote ];

/// 去除体重
Property BPSSubtractiveWeight As %Float [ SqlColumnNumber = 41, SqlFieldName = BPS_SubtractiveWeight ];

/// 盐水用量
Property BPSSalineDose As %Float [ SqlColumnNumber = 42, SqlFieldName = BPS_SalineDose ];

/// PFR
Property BPSPFR As %Float [ SqlColumnNumber = 43, SqlFieldName = BPS_PFR ];

/// DFR
Property BPSDFR As %Float [ SqlColumnNumber = 44, SqlFieldName = BPS_DFR ];

/// 目标清除量
Property BPSObjectiveClearAmount As %Float [ SqlColumnNumber = 45, SqlFieldName = BPS_ObjectiveClearAmount ];

/// 回输血浆量
Property BPSResidualPlasmaAmount As %Float [ SqlColumnNumber = 46, SqlFieldName = BPS_ResidualPlasmaAmount ];

/// 回输盐水葡萄糖量
Property BPSResidualSalineAmount As %Float [ SqlColumnNumber = 47, SqlFieldName = BPS_ResidualSalineAmount ];

/// 回输蛋白量
Property BPSResidualAlbuminAmount As %Float [ SqlColumnNumber = 48, SqlFieldName = BPS_ResidualAlbuminAmount ];

/// 盐水/葡萄糖/盐水葡萄糖药品
Property BPSSalineGlucoseDrug As %String(DISPLAYLIST = ",Saline,Glucos,Glucos10,OSalineGlucos", MAXLEN = 9, SELECTIVITY = "14.2857%", TRUNCATE = 1, VALUELIST = ",S,G,G10,O") [ SqlColumnNumber = 49, SqlFieldName = BPS_SalineGlucoseDrug ];

/// 氯化钾
Property BPSKCL As %Float [ SqlColumnNumber = 50, SqlFieldName = BPS_KCL ];

/// 碳酸氢钠
Property BPSNaHCO3 As %Float [ SqlColumnNumber = 51, SqlFieldName = BPS_NaHCO3 ];

/// RP
Property BPSRP As %Float [ SqlColumnNumber = 52, SqlFieldName = BPS_RP ];

/// 透析液量
Property BPSDialysateAmount As %Float [ SqlColumnNumber = 53, SqlFieldName = BPS_DialysateAmount ];

/// 抗凝禁忌
Property BPSAntContraindication As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 54, SqlFieldName = BPS_AntContraindication ];

/// 抗凝禁忌备注
Property BPSAntContraindicationNote As %String [ SqlColumnNumber = 55, SqlFieldName = BPS_AntContraindicationNote ];

Storage CacheStorage
{
<Data name="BPSBPSchemeClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCBPSchemeDefaultData">
<Value name="1">
<Value>BPSBPPatRegisterDr</Value>
</Value>
<Value name="2">
<Value>BPSStartDate</Value>
</Value>
<Value name="3">
<Value>BPSEndDate</Value>
</Value>
<Value name="4">
<Value>BPSWeekNum</Value>
</Value>
<Value name="5">
<Value>BPSPatDryWeight</Value>
</Value>
<Value name="6">
<Value>BPSMaxDewaterAmount</Value>
</Value>
<Value name="7">
<Value>BPSNetDewaterAmount</Value>
</Value>
<Value name="8">
<Value>BPSFoodIntakeAmount</Value>
</Value>
<Value name="9">
<Value>BPSResidualBloodAmount</Value>
</Value>
<Value name="10">
<Value>BPSVascularAccessDr</Value>
</Value>
<Value name="11">
<Value>BPSBPCEquipModelDr</Value>
</Value>
<Value name="12">
<Value>BPSBPCBPModeDr</Value>
</Value>
<Value name="13">
<Value>BPSSecondBPCBPModeDr</Value>
</Value>
<Value name="14">
<Value>BPSThirdBPCBPModeDr</Value>
</Value>
<Value name="15">
<Value>BPSBPCConsumableDr</Value>
</Value>
<Value name="16">
<Value>BPSSecondBPCConsumableDr</Value>
</Value>
<Value name="17">
<Value>BPSThirdBPCConsumableDr</Value>
</Value>
<Value name="18">
<Value>BPSTherapyDuration</Value>
</Value>
<Value name="19">
<Value>BPSAnticoagulantModeDr</Value>
</Value>
<Value name="20">
<Value>BPSFirstHeparinAmount</Value>
</Value>
<Value name="21">
<Value>BPSBPCEquipRunParaDr</Value>
</Value>
<Value name="22">
<Value>BPSFilterReplaceMode</Value>
</Value>
<Value name="23">
<Value>BPSFilterReplaceAmount</Value>
</Value>
<Value name="24">
<Value>BPSOralHematin</Value>
</Value>
<Value name="25">
<Value>BPSInjectHematin</Value>
</Value>
<Value name="26">
<Value>BPSNa</Value>
</Value>
<Value name="27">
<Value>BPSK</Value>
</Value>
<Value name="28">
<Value>BPSCa2</Value>
</Value>
<Value name="29">
<Value>BPSHCO3</Value>
</Value>
<Value name="30">
<Value>BPSNote</Value>
</Value>
<Value name="31">
<Value>BPSUpdateUserDr</Value>
</Value>
<Value name="32">
<Value>BPSUpdateDate</Value>
</Value>
<Value name="33">
<Value>BPSUpdateTime</Value>
</Value>
<Value name="34">
<Value>BPSHeparinDose</Value>
</Value>
<Value name="35">
<Value>BPSProtamineAmount</Value>
</Value>
<Value name="36">
<Value>BPSLowMoleHeparinAmount</Value>
</Value>
<Value name="37">
<Value>BPSTemplateName</Value>
</Value>
<Value name="38">
<Value>BPSBFR</Value>
</Value>
<Value name="39">
<Value>BPSBFRNote</Value>
</Value>
<Value name="40">
<Value>BPSSubtractiveWeight</Value>
</Value>
<Value name="41">
<Value>BPSSalineDose</Value>
</Value>
<Value name="42">
<Value>BPSPFR</Value>
</Value>
<Value name="43">
<Value>BPSDFR</Value>
</Value>
<Value name="44">
<Value>BPSObjectiveClearAmount</Value>
</Value>
<Value name="45">
<Value>BPSResidualPlasmaAmount</Value>
</Value>
<Value name="46">
<Value>BPSResidualSalineAmount</Value>
</Value>
<Value name="47">
<Value>BPSResidualAlbuminAmount</Value>
</Value>
<Value name="48">
<Value>BPSSalineGlucoseDrug</Value>
</Value>
<Value name="49">
<Value>BPSKCL</Value>
</Value>
<Value name="50">
<Value>BPSNaHCO3</Value>
</Value>
<Value name="51">
<Value>BPSRP</Value>
</Value>
<Value name="52">
<Value>BPSDialysateAmount</Value>
</Value>
<Value name="53">
<Value>BPSAntContraindication</Value>
</Value>
<Value name="54">
<Value>BPSAntContraindicationNote</Value>
</Value>
</Data>
<DataLocation>^DHCBPScheme</DataLocation>
<DefaultData>DHCBPSchemeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCBPScheme</IdLocation>
<IndexLocation>^DHCBPScheme(0)</IndexLocation>
<StreamLocation>^User.DHCBPSchemeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
