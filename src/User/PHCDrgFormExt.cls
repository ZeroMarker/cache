/// PHC_DrgForm Extension For DHCC ,Created By zhouyg 2012.07.11
Class User.PHCDrgFormExt Extends %Persistent [ SqlRowIdName = PHCDF_RowId, SqlTableName = PHC_DrgFormExt, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (PHCDFPHCDParRef, PHCDFChildSub) [ IdKey, PrimaryKey, Unique ];

/// Des Ref to PHC_DrgMast
Property PHCDFPHCDParRef As PHCDrgMast [ Required, SqlFieldName = PHCDF_PHCD_ParRef ];

/// PHCDrgForm Child Sub (New Key)
Property PHCDFChildSub As %Numeric(SCALE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHCDF_ChildSub ];

/// 门诊按总剂量计算整包装 1:是   0:否
Property PHCDFCalcuDose As %String [ SqlColumnNumber = 4, SqlFieldName = PHCDF_CalcuDose ];

/// 门诊皮试用原液 1:是   0:否
Property PHCDFOPSkinTestYY As %String [ SqlColumnNumber = 5, SqlFieldName = PHCDF_OPSkinTestYY ];

/// 住院皮试用原液 1:是   0:否
Property PHCDFIPSkinTestYY As %String [ SqlColumnNumber = 6, SqlFieldName = PHCDF_IPSkinTestYY ];

/// 年龄限制
Property PHCDFAgeLimit As %String [ SqlColumnNumber = 7, SqlFieldName = PHCDF_AgeLimit ];

/// DDD值成人常用剂量,作为参考用 
Property PHCDFDDD As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PHCDF_DDD ];

/// 医保剂量上传为0,仅北京医保用
Property PHCDFInsuDoseZero As %String [ SqlColumnNumber = 9, SqlFieldName = PHCDF_InsuDoseZero ];

/// 草药默认备注
Property PHCDFCHPhSpecInstr As %String [ SqlColumnNumber = 10, SqlFieldName = PHCDF_CHPhSpecInstr ];

/// 抗生素标志 Y-是抗生素,N-非抗生素
Property PHCDFAntibioticFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PHCDF_AntibioticFlag ];

/// 危重药标志 Y-是危重药,N-非危重药
Property PHCDFCriticalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PHCDF_CriticalFlag ];

/// WHONET码
Property PHCDFWHONET As %String [ SqlColumnNumber = 13, SqlFieldName = PHCDF_WHONET ];

/// WHO定义的原始DDD值
Property PHCDFWHODDD As %String [ SqlColumnNumber = 14, SqlFieldName = PHCDF_WHODDD ];

/// WHO定义的原始DDD值的单位
Property PHCDFWHODDDUomDr As %String [ SqlColumnNumber = 15, SqlFieldName = PHCDF_WHODDDUom_Dr ];

/// 滴速
Property PHCDFivgttSpeed As %String [ SqlColumnNumber = 16, SqlFieldName = PHCDF_ivgttSpeed ];

/// 颗粒剂与饮片的转换系数(饮片压缩成颗粒之后，1g颗粒转换为饮片的系数(此单位与基本单位一致))
Property PHCDFGranulesFact As %String [ SqlColumnNumber = 17, SqlFieldName = PHCDF_GranulesFact ];

/// 省属常用药物
Property PHCDFProvinceComm As %String [ SqlColumnNumber = 18, SqlFieldName = PHCDF_ProvinceComm ];

/// ATC代码
Property PHCDFATCCode As %String [ SqlColumnNumber = 19, SqlFieldName = PHCDF_ATCCode ];

/// 医保代码,解决异地就医报销使用
Property PHCDFInsuCode As %String [ SqlColumnNumber = 20, SqlFieldName = PHCDF_InsuCode ];

/// 主辅用药,药品在本院是主治还是辅助用药
Property PHCDFSCDIDr As User.DHCStkComDictionary [ SqlColumnNumber = 21, SqlFieldName = PHCDF_SCDI_Dr ];

/// 高危分类，高危-H,特殊高危-S,相当于PHCDF_CriticalFlag的分类
Property PHCDFHighRisk As %String [ SqlColumnNumber = 22, SqlFieldName = PHCDF_HighRisk ];

/// 新药学分类
Property PHCDFPHCCDr As User.DHCPHCCat [ SqlColumnNumber = 23, SqlFieldName = PHCDF_PHCC_Dr ];

/// 默认等效单位
Property PHCDFDefaultUomDr As User.CTUOM [ SqlColumnNumber = 24, SqlFieldName = PHCDF_DefaultUomDr ];

/// 单味使用标识
Property PHCDFSingleUseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = PHCDF_SingleUseFlag ];

/// 药品别名
Property PHCDFOtherName As %String [ SqlColumnNumber = 26, SqlFieldName = PHCDF_OtherName ];

/// 药品配液分类
Property PHCDFPivaCatDr As User.DHCPHCPivaCat [ SqlColumnNumber = 27, SqlFieldName = PHCDF_PivaCatDr ];

/// 草药煎药加水系数
Property PHCDFCYAddWaterQTY As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PHCDF_CYAddWaterQTY ];

/// 兴奋剂
Property PHCDFDope As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = PHCDF_Dope ];

/// 易跌倒
Property PHCDFTumble As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = PHCDF_Tumble ];

/// 过敏
Property PHCDFAllergyFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = PHCDF_AllergyFlag ];

/// 饮食禁忌
Property PHCDFDietTaboo As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = PHCDF_DietTaboo ];

/// 急救药品
Property PHCDFFirstAid As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = PHCDF_FirstAid ];

/// 国家基本药物
Property PHCDFBasicDrug As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = PHCDF_BasicDrug ];

/// 省基本药物
Property PHCDFDrugbase2 As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = PHCDF_Drugbase2 ];

/// 市基本药物
Property PHCDFPDrugbase1 As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = PHCDF_PDrugbase1 ];

/// 区(县)基本药物
Property PHCDFPDrugbase2 As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = PHCDF_PDrugbase2 ];

/// 非处方标志
Property PHCDFOTC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = PHCDF_OTC ];

/// 中国药典标志
Property PHCDFCodex As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = PHCDF_Codex ];

/// 临床验证用药
Property PHCDFTest As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = PHCDF_Test ];

/// TPN标志
Property PHCDFTpnFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = PHCDF_TpnFlag ];

/// 重点监控标记
Property PHCDFMonitorFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = PHCDF_MonitorFlag ];

/// 长期默认嘱托 
Property PHCDFCQZTFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 43, SqlFieldName = PHCDF_CQZTFlag ];

/// 临时默认取药
Property PHCDFONEFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 44, SqlFieldName = PHCDF_ONEFlag ];

/// 慢病用药
Property PHCDFChronicMedFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = PHCDF_ChronicMedFlag ];

/// 含量规格
Property PHCDFSpec As %String [ SqlColumnNumber = 46, SqlFieldName = PHCDF_Spec ];

/// 溶媒标志
Property PHCDFMenstruumFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = PHCDF_MenstruumFlag ];

/// 辅助用药类型
Property PHCDFAdjuvDrgDr As User.DHCStkComDictionary [ SqlColumnNumber = 48, SqlFieldName = PHCDF_AdjuvDrg_Dr ];

/// 草药等级
Property PHCDFChphGrade As %String [ SqlColumnNumber = 49, SqlFieldName = PHCDF_ChphGrade ];

/// 院前检查用药
Property PHCDFPreExamFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 50, SqlFieldName = PHCDF_PreExamFlag ];

/// 中药注射剂
Property PHCDFCHNInjectFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 51, SqlFieldName = PHCDF_CHNInjectFlag ];

/// 肠外营养药品
Property PHCDFParenNutriFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 52, SqlFieldName = PHCDF_ParenNutriFlag ];

/// 激素类药品
Property PHCDFHormoneFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 53, SqlFieldName = PHCDF_HormoneFlag ];

/// 血液制品
Property PHCDFBloodFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 54, SqlFieldName = PHCDF_BloodFlag ];

/// 毒麻编号
Property PHCDFNACode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = PHCDF_NACode ];

/// 附加说明默认自备药
Property PHCDFOMFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = PHCDF_OMFlag ];

/// 不可拆分标志
Property PHCDFNoBreakFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = PHCDF_NoBreakFlag ];

/// 仅可开临时医嘱
Property PHCDFOnlyShort As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 58, SqlFieldName = PHCDF_OnlyShort ];

/// 稀缺药标志
Property PHCDFRareDrug As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 59, SqlFieldName = PHCDF_RareDrug ];

/// 终止妊娠
Property PHCDFTermPreg As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 60, SqlFieldName = PHCDF_TermPreg ];

/// 血友病用药
Property PHCDFHemophiliaFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 61, SqlFieldName = PHCDF_HemophiliaFlag ];

/// 抗肿瘤标记
Property PHCDFAntiTumor As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 62, SqlFieldName = PHCDF_AntiTumor ];

/// 时效性药品
Property PHCDFTimeRemind As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 63, SqlFieldName = PHCDF_TimeRemind ];

/// 化疗药
Property PHCDFChemotherapeutic As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 64, SqlFieldName = PHCDF_Chemotherapeutic ];

/// 抗结核药
Property PHCDFAntiTB As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 65, SqlFieldName = PHCDF_AntiTB ];

/// 诊断用药
Property PHCDFDiagnosticFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 66, SqlFieldName = PHCDF_DiagnosticFlag ];

/// 规格含量
Property PHCDFSpecDose As %Library.Float [ SqlColumnNumber = 67, SqlFieldName = PHCDF_SpecDose ];

/// 皮试阳性不产生过敏记录
Property PHCDFNoAllergy As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 68, SqlFieldName = PHCDF_NoAllergy ];

/// 妊娠分级	妊娠分为A、B、C、D、X
Property PHCDFPregClass As %String(DISPLAYLIST = ",A,B,C,D,X", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",A,B,C,D,X") [ SqlColumnNumber = 69, SqlFieldName = PHCDF_PregClass ];

/// 哺乳分级	哺乳分为L1、L2、L3、L4、L5
Property PHCDFLactationClass As %String(DISPLAYLIST = ",L1,L2,L3,L4,L5", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",L1,L2,L3,L4,L5") [ SqlColumnNumber = 70, SqlFieldName = PHCDF_LactationClass ];

/// 抗肿瘤药物级别
Property PHCDFAntiLevSCDIDr As User.DHCStkComDictionary [ SqlColumnNumber = 71, SqlFieldName = PHCDF_AntiLev_SCDI_Dr ];

/// 西药医嘱备注
Property PHCDFWestRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = PHCDF_WestRemark ];

/// 用药级别
Property PHCDFUseDrugLevDr As User.DHCStkComDictionary [ SqlColumnNumber = 73, SqlFieldName = PHCDF_UseDrugLev_Dr ];

/// 浓度
Property PHCDFStrength As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 74, SqlFieldName = PHCDF_Strength ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterPHCDF">
<Data name="PHCDF_ATCCode">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>16</Piece>
</Data>
<Data name="PHCDF_AdjuvDrg_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>45</Piece>
</Data>
<Data name="PHCDF_AgeLimit">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>4</Piece>
</Data>
<Data name="PHCDF_AllergyFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>28</Piece>
</Data>
<Data name="PHCDF_AntiLev_SCDI_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>17</Piece>
</Data>
<Data name="PHCDF_AntiTB">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>11</Piece>
</Data>
<Data name="PHCDF_AntiTumor">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>8</Piece>
</Data>
<Data name="PHCDF_AntibioticFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>8</Piece>
</Data>
<Data name="PHCDF_BasicDrug">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>31</Piece>
</Data>
<Data name="PHCDF_BloodFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>51</Piece>
</Data>
<Data name="PHCDF_CHNInjectFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>48</Piece>
</Data>
<Data name="PHCDF_CHPhSpecInstr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>7</Piece>
</Data>
<Data name="PHCDF_CQZTFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>40</Piece>
</Data>
<Data name="PHCDF_CYAddWaterQTY">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>25</Piece>
</Data>
<Data name="PHCDF_CalcuDose">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Data name="PHCDF_Chemotherapeutic">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>10</Piece>
</Data>
<Data name="PHCDF_ChphGrade">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>46</Piece>
</Data>
<Data name="PHCDF_ChronicMedFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>42</Piece>
</Data>
<Data name="PHCDF_Codex">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>36</Piece>
</Data>
<Data name="PHCDF_CriticalFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>9</Piece>
</Data>
<Data name="PHCDF_DDD">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>5</Piece>
</Data>
<Data name="PHCDF_DefaultUomDr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>21</Piece>
</Data>
<Data name="PHCDF_DiagnosticFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>12</Piece>
</Data>
<Data name="PHCDF_DietTaboo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>29</Piece>
</Data>
<Data name="PHCDF_Dope">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>27</Piece>
</Data>
<Data name="PHCDF_Drugbase2">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>32</Piece>
</Data>
<Data name="PHCDF_FirstAid">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>30</Piece>
</Data>
<Data name="PHCDF_GranulesFact">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>14</Piece>
</Data>
<Data name="PHCDF_HemophiliaFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>7</Piece>
</Data>
<Data name="PHCDF_HighRisk">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>19</Piece>
</Data>
<Data name="PHCDF_HormoneFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>50</Piece>
</Data>
<Data name="PHCDF_IPSkinTestYY">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Data name="PHCDF_InsuCode">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>17</Piece>
</Data>
<Data name="PHCDF_InsuDoseZero">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>6</Piece>
</Data>
<Data name="PHCDF_LactationClass">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>16</Piece>
</Data>
<Data name="PHCDF_MenstruumFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>44</Piece>
</Data>
<Data name="PHCDF_MonitorFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>39</Piece>
</Data>
<Data name="PHCDF_NACode">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>1</Piece>
</Data>
<Data name="PHCDF_NoAllergy">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>14</Piece>
</Data>
<Data name="PHCDF_NoBreakFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>3</Piece>
</Data>
<Data name="PHCDF_OMFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>2</Piece>
</Data>
<Data name="PHCDF_ONEFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>41</Piece>
</Data>
<Data name="PHCDF_OPSkinTestYY">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="PHCDF_OTC">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>35</Piece>
</Data>
<Data name="PHCDF_OnlyShort">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>4</Piece>
</Data>
<Data name="PHCDF_OtherName">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>23</Piece>
</Data>
<Data name="PHCDF_PDrugbase1">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>33</Piece>
</Data>
<Data name="PHCDF_PDrugbase2">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>34</Piece>
</Data>
<Data name="PHCDF_PHCC_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>20</Piece>
</Data>
<Data name="PHCDF_ParenNutriFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>49</Piece>
</Data>
<Data name="PHCDF_PivaCatDr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>24</Piece>
</Data>
<Data name="PHCDF_PreExamFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>47</Piece>
</Data>
<Data name="PHCDF_PregClass">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>15</Piece>
</Data>
<Data name="PHCDF_ProvinceComm">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>15</Piece>
</Data>
<Data name="PHCDF_RareDrug">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>5</Piece>
</Data>
<Data name="PHCDF_SCDI_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>18</Piece>
</Data>
<Data name="PHCDF_SingleUseFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>22</Piece>
</Data>
<Data name="PHCDF_Spec">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>43</Piece>
</Data>
<Data name="PHCDF_SpecDose">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>13</Piece>
</Data>
<Data name="PHCDF_Strength">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>20</Piece>
</Data>
<Data name="PHCDF_TermPreg">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>6</Piece>
</Data>
<Data name="PHCDF_Test">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>37</Piece>
</Data>
<Data name="PHCDF_TimeRemind">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>9</Piece>
</Data>
<Data name="PHCDF_TpnFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>38</Piece>
</Data>
<Data name="PHCDF_Tumble">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>26</Piece>
</Data>
<Data name="PHCDF_UseDrugLev_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>19</Piece>
</Data>
<Data name="PHCDF_WHODDD">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>11</Piece>
</Data>
<Data name="PHCDF_WHODDDUom_Dr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>12</Piece>
</Data>
<Data name="PHCDF_WHONET">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>10</Piece>
</Data>
<Data name="PHCDF_WestRemark">
<Delimiter>"^"</Delimiter>
<Node>"DHC",2</Node>
<Piece>18</Piece>
</Data>
<Data name="PHCDF_ivgttSpeed">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>13</Piece>
</Data>
<Global>^PHCD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCDF_PHCD_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHCDF_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHCDF_PHCD_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DF"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PHCDF_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHCDF_RowId</SqlRowIdName>
<StreamLocation>User.PHCDrgFormExtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
