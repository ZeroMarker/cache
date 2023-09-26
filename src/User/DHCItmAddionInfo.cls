Class User.DHCItmAddionInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INFO_RowId, SqlTableName = DHC_ItmAddionInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 2500;

/// INFO_INCI_DR
Property INFOINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = INFO_INCI_DR ];

/// INFO_ImportFlag
Property INFOImportFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INFO_ImportFlag ];

/// INFO_QualityLevel
Property INFOQualityLevel As User.DHCItmQualityLevel [ SqlColumnNumber = 4, SqlFieldName = INFO_QualityLevel ];

/// INFO_BasicDrug
Property INFOBasicDrug As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = INFO_BasicDrug ];

/// INFO_OTC
Property INFOOTC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INFO_OTC ];

/// INFO_Codex
Property INFOCodex As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = INFO_Codex ];

/// INFO_Test
Property INFOTest As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = INFO_Test ];

/// INFO_REC
Property INFOREC As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = INFO_REC ];

/// INFO_QualityNo
Property INFOQualityNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INFO_QualityNo ];

/// INFO_ComFrom
Property INFOComFrom As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INFO_ComFrom ];

/// INFO_Remark
Property INFORemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INFO_Remark ];

/// INFO_HighPrice
Property INFOHighPrice As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = INFO_HighPrice ];

/// INFO_BackUp
Property INFOBackUp As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = INFO_BackUp ];

/// INFO_UsePatient
Property INFOUsePatient As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = INFO_UsePatient ];

/// INFO_MT_DR
Property INFOMTDR As User.DHCMarkType [ SqlColumnNumber = 16, SqlFieldName = INFO_MT_DR ];

/// INFO_MaxSp
Property INFOMaxSp As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = INFO_MaxSp ];

/// INFO_AckSp_Flag
Property INFOAckSpFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = INFO_AckSp_Flag ];

/// INFO_AckSp_SSUSR_DR
Property INFOAckSpSSUSRDR As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = INFO_AckSp_SSUSR_DR ];

/// INFO_AckSp_Date
Property INFOAckSpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = INFO_AckSp_Date ];

/// INFO_AckSp_Time
Property INFOAckSpTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = INFO_AckSp_Time ];

/// INFO_InHos_Flag
Property INFOInHosFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = INFO_InHos_Flag ];

/// INFO_PbRp
Property INFOPbRp As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = INFO_PbRp ];

/// INFO_PBL_DR
Property INFOPBLDR As User.DHCPublicBiddingList [ SqlColumnNumber = 24, SqlFieldName = INFO_PBL_DR ];

/// INFO_PbVendor_DR
Property INFOPbVendorDR As User.APCVendor [ SqlColumnNumber = 25, SqlFieldName = INFO_PbVendor_DR ];

/// INFO_PbManf_DR
Property INFOPbManfDR As User.PHManufacturer [ SqlColumnNumber = 26, SqlFieldName = INFO_PbManf_DR ];

/// INFO_PbCarrier_DR
Property INFOPbCarrierDR As User.DHCCarrier [ SqlColumnNumber = 27, SqlFieldName = INFO_PbCarrier_DR ];

/// INFO_Spec
Property INFOSpec As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INFO_Spec ];

/// INFO_ISC_DR
Property INFOISCDR As User.DHCItmStoreCond [ SqlColumnNumber = 29, SqlFieldName = INFO_ISC_DR ];

/// INFO_BA_flag
Property INFOBAflag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = INFO_BA_flag ];

/// INFO_PBLevel
Property INFOPBLevel As User.DHCItmPBLevel [ SqlColumnNumber = 31, SqlFieldName = INFO_PBLevel ];

/// INFO_EndDate
Property INFOEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 32, SqlFieldName = INFO_EndDate ];

/// INFO_ExpireLen
Property INFOExpireLen As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = INFO_ExpireLen ];

/// INFO_PrcFile
Property INFOPrcFile As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = INFO_PrcFile ];

/// INFO_PrcFileD
Property INFOPrcFileD As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 35, SqlFieldName = INFO_PrcFileD ];

/// INFO_SkinTest
Property INFOSkinTest As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = INFO_SkinTest ];

/// DHCST_BookCat
Property INFOBCDr As User.DHCSTBookCat [ SqlColumnNumber = 37, SqlFieldName = INFO_BC_Dr ];

/// INFO_OecAct_Dr
Property INFOOecActDr As User.OECAction [ SqlColumnNumber = 38, SqlFieldName = INFO_OecAct_Dr ];

Property INFODrugUse As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = INFO_DrugUse ];

/// INFO_TpnFlag
Property INFOTpnFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = INFO_TpnFlag ];

/// info_drugbase2
Property INFODrugbase2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = INFO_Drugbase2 ];

/// info_pdrugbase1
Property INFOPDrugbase1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = INFO_PDrugbase1 ];

/// INFO_PDrugbase2
Property INFOPDrugbase2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = INFO_PDrugbase2 ];

/// INFO_HOOKNet_
Property INFOHOOKNet As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = INFO_HOOKNet ];

/// INFO_StandardCode
Property INFOStandardCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = INFO_StandardCode ];

/// INFO_InMedBasis
Property INFOInMedBasis As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = INFO_InMedBasis ];

/// INFO_RefRetReason
Property INFORefRetReasonDr As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = INFO_RefRetReason_Dr ];

/// INFO_NotUseReason_Dr
Property INFONotUseReasonDr As User.DHCItmNotUseReason [ SqlColumnNumber = 48, SqlFieldName = INFO_NotUseReason_Dr ];

/// INFO_PHMNF_DR
Property INFOPHMNFDR As User.PHManufacturer [ SqlColumnNumber = 49, SqlFieldName = INFO_PHMNF_DR ];

/// INFO_InsuCat_DR
Property INFOInsuCatDR As User.DHCItmInsuCategory [ SqlColumnNumber = 50, SqlFieldName = INFO_InsuCat_DR ];

/// INFO_HighRiskFlag
Property INFOHighRiskFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 51, SqlFieldName = INFO_HighRiskFlag ];

/// INFO_PackUom
Property INFOPackUom As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = INFO_PackUom ];

/// INFO_PackUomFactor
Property INFOPackUomFactor As %Library.Float [ SqlColumnNumber = 53, SqlFieldName = INFO_PackUomFactor ];

/// INFO_PackPicPath
Property INFOPackPicPath As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = INFO_PackPicPath ];

/// INFO_MaxPurAmt
Property INFOMaxPurAmt As %Library.Float [ SqlColumnNumber = 55, SqlFieldName = INFO_MaxPurAmt ];

/// INFO_DistribFlag
Property INFODistribFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = INFO_DistribFlag ];

/// INFO_PurPlanCode
Property INFOPurPlanCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = INFO_PurPlanCode ];

/// INFO_ChargeFlag
Property INFOChargeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 58, SqlFieldName = INFO_ChargeFlag ];

/// INFO_Brand
Property INFOBrand As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = INFO_Brand ];

/// INFO_Model
Property INFOModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 60, SqlFieldName = INFO_Model ];

/// INFO_Abbrev
Property INFOAbbrev As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 61, SqlFieldName = INFO_Abbrev ];

/// INFO_Supervision
Property INFOSupervision As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 62, SqlFieldName = INFO_Supervision ];

/// INFO_ImplantationMat
Property INFOImplantationMat As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 63, SqlFieldName = INFO_ImplantationMat ];

/// 招标序号
Property INFOPbNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 64, SqlFieldName = INFO_Pbno ];

/// 招标转换比
Property INFOChangeRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 65, SqlFieldName = INFO_ChangeRate ];

/// 医嘱提示是否悬浮
Property INFOOrdPrompt As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 66, SqlFieldName = INFO_OrdPrompt ];

/// 药理码
Property INFOPhcDrugCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 67, SqlFieldName = INFO_PhcDrugCode ];

/// 标准统计数量
Property INFOStatQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 68, SqlFieldName = INFO_StatQty ];

/// 标准统计单位
Property INFOStatUom As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 69, SqlFieldName = INFO_StatUom ];

/// 说明书最新修改日期
Property INFOIntroUpdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 70, SqlFieldName = INFO_IntroUpdDate ];

/// 说明书最新核对日期
Property INFOIntroAffDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 71, SqlFieldName = INFO_IntroAffDate ];

/// 材质
Property INFOMatQuality As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = INFO_MatQuality ];

/// ABC三类分类,中山三院
Property INFOABC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 73, SqlFieldName = INFO_ABC ];

/// INFO_ReqModeLimited - 限制请求方式 ( "O" - 临时请求 "C" - 请领计划 )
Property INFOReqModeLimited As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 74, SqlFieldName = INFO_ReqModeLimited ];

/// INFO_NoLocReq
Property INFONoLocReq As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 75, SqlFieldName = INFO_NoLocReq ];

/// 基准进价(安徽省立)
Property INFOBasicRp As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 76, SqlFieldName = INFO_BasicRp ];

/// 特殊标志(安徽省立)
Property INFOSpeFlag As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 77, SqlFieldName = INFO_SpeFlag ];

/// 单月费用上限
Property INFOCostlimits As %Library.Float [ SqlColumnNumber = 78, SqlFieldName = INFO_Costlimits ];

/// 程序自动加锁标志
Property INFOAutoLockFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 79, SqlFieldName = INFO_AutoLockFlag ];

/// INFO_SterileDateLen  -灭菌时间长度
Property INFOSterileDateLen As %Library.Float [ SqlColumnNumber = 80, SqlFieldName = INFO_SterileDateLen ];

/// INFO_MedEqptCat_DR  ->DHC_MedEqptCat 医疗器械分类(68)
Property INFOMedEqptCatDR As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 81, SqlFieldName = INFO_MedEqptCat_DR ];

/// INFO_ZeroStk - 零库存标志
Property INFOZeroStk As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 82, SqlFieldName = INFO_ZeroStk ];

/// INFO_ChargeType  ->DHC_ItmChargeType - 收费类型
Property INFOChargeType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 83, SqlFieldName = INFO_ChargeType ];

/// INFO_EasyConfuse - 药品易混标志
Property INFOEasyConfuse As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 84, SqlFieldName = INFO_EasyConfuse ];

/// INFO_PurPlanType - 药品采购计划类型
Property INFOPurPlanType As User.PHAINPurPlanType [ SqlColumnNumber = 85, SqlFieldName = INFO_PurPlanType ];

/// INFO_PackCharge - 打包收费
Property INFOPackCharge As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 86, SqlFieldName = INFO_PackCharge ];

/// INFO_PrevCode - 原系统代码
Property INFOPrevCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 87, SqlFieldName = INFO_PrevCode ];

/// INFO_HosCategory  - 本院分类
Property INFOHosCategory As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 88, SqlFieldName = INFO_HosCategory ];

/// INFO_PackUomM   - 中包装单位
Property INFOPackUomM As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 89, SqlFieldName = INFO_PackUomM ];

/// INFO_PackUomFactorM  - 中包装转换因子
Property INFOPackUomFactorM As %Library.Float [ SqlColumnNumber = 90, SqlFieldName = INFO_PackUomFactorM ];

/// 赠送比例(龙口)
Property INFOGiftRecb As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 91, SqlFieldName = INFO_GiftRecb ];

/// 拒付价格(龙口)
Property INFOUnPayRp As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 92, SqlFieldName = INFO_UnPayRp ];

/// INFO_FractionFlag 打印分数配置
Property INFOFractionFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 93, SqlFieldName = INFO_FractionFlag ];

/// 重点监控标记
Property INFOMonitorFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 94, SqlFieldName = INFO_MonitorFlag ];

/// INFO_CreateDate - 建档日期
Property INFOCreateDate As %Library.Date [ InitialExpression = {+$h}, SqlColumnNumber = 95, SqlFieldName = INFO_CreateDate ];

/// INFO_CreateTime - 建档时间
Property INFOCreateTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 96, SqlFieldName = INFO_CreateTime ];

/// INFO_SpecFlag -具体规格是否可以录入标志 
Property INFOSpecFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 97, SqlFieldName = INFO_SpecFlag ];

/// INFO_TransDate 到货时间  供应商评价用到
Property INFOTransDate As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 98, SqlFieldName = INFO_TransDate ];

/// INFO_BidDate  - 招标日期
Property INFOBidDate As %Library.Date [ SqlColumnNumber = 99, SqlFieldName = INFO_BidDate ];

/// INFO_FirstReqDept - 首请部门
Property INFOFirstReqDept As User.CTLoc [ SqlColumnNumber = 100, SqlFieldName = INFO_FirstReqDept ];

/// INFO_Origin  -原产地
Property INFOOrigin As User.DHCSTOrigin [ SqlColumnNumber = 101, SqlFieldName = INFO_Origin ];

/// INFO_InsuPay - 是否医保支付
Property INFOInsuPay As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 102, SqlFieldName = INFO_InsuPay ];

/// INFO_InsuPrice  - 医保支付价格
Property INFOInsuPrice As %Library.Float [ SqlColumnNumber = 103, SqlFieldName = INFO_InsuPrice ];

/// 试验项目
Property INFOProjectDr As User.DHCDocPilotProject [ SqlColumnNumber = 104, SqlFieldName = INFO_Project_Dr ];

/// 试验项目验证码标志
Property INFOProjectPin As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 105, SqlFieldName = INFO_ProjectPin ];

/// 低价药品标志
Property INFOCheapDrugFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 106, SqlFieldName = INFO_CheapDrugFlag ];

/// INFO_PackWeight   - 大包装净重
Property INFOPackWeight As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 107, SqlFieldName = INFO_PackWeight ];

/// INFO_MatCatOfficial_DR  ->DHC_MatCatOfficial - 官方分类
Property INFOMatCatOfficialDR As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 108, SqlFieldName = INFO_MatCatOfficial_DR ];

/// INFO_MatCatClinical_DR  ->DHC_MatCatClinical - 临床分类
Property INFOMatCatClinicalDR As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 109, SqlFieldName = INFO_MatCatClinical_DR ];

/// INFO_MatCatSpecial_DR  ->DHC_MatCatSpecial - 特殊分类
Property INFOMatCatSpecialDR As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 110, SqlFieldName = INFO_MatCatSpecial_DR ];

/// 全院库存上限
Property INFOMaxQty As %Library.Float [ SqlColumnNumber = 111, SqlFieldName = INFO_MaxQty ];

/// 全院库存下限
Property INFOMinQty As %Library.Float [ SqlColumnNumber = 112, SqlFieldName = INFO_MinQty ];

/// INFO_CreateUser
Property INFOCreateUser As User.SSUser [ SqlColumnNumber = 113, SqlFieldName = INFO_CreateUser ];

/// INFO_OrdEndDate
Property INFOOrdEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 114, SqlFieldName = INFO_OrdEndDate ];

/// 配液滴注时间
Property INFOPivaExedt As %Library.Float [ SqlColumnNumber = 115, SqlFieldName = INFO_PivaExedt ];

/// 配液有效时间
Property INFOPivaExpdet As %Library.Float [ SqlColumnNumber = 116, SqlFieldName = INFO_PivaExpdet ];

/// 配液特殊备注
Property INFOPivaBack As %Library.String [ SqlColumnNumber = 117, SqlFieldName = INFO_PivaBack ];

/// 两票制标志
Property INFOTwoTicketFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 118, SqlFieldName = INFO_TwoTicketFlag ];

/// 谈判药标志
Property INFONegotiateFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 119, SqlFieldName = INFO_NegotiateFlag ];

/// 通用名
Property INFOGeneralDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 120, SqlFieldName = INFO_GeneralDesc ];

/// 单采标志
Property INFOSeparateBuyFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 121, SqlFieldName = INFO_SeparateBuyFlag ];

/// 入库上限
Property INFORecMaxQty As %Library.Float [ SqlColumnNumber = 122, SqlFieldName = INFO_RecMaxQty ];

/// 一致性评价
Property INFOFitEvaluateFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 123, SqlFieldName = INFO_FitEvaluateFlag ];

/// 执行标准
Property INFOOperatNorm As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 124, SqlFieldName = INFO_OperatNorm ];

/// 是否医保
Property INFOMedicFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 125, SqlFieldName = INFO_MedicFlag ];

/// 议价
Property INFOBargaining As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 126, SqlFieldName = INFO_Bargaining ];

/// 备案品种
Property INFOPriceRecord As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 127, SqlFieldName = INFO_PriceRecord ];

/// 转换药品项
Property INFOPreparationDr As User.INCItm [ SqlColumnNumber = 128, SqlFieldName = INFO_Preparation_Dr ];

/// 存储条件备注
Property INFOISCRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 129, SqlFieldName = INFO_ISCRemarks ];

/// 标签药品标志
Property INFOLableFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 130, SqlFieldName = INFO_LableFlag ];

/// 是否占药占比标识
Property INFODrugRatioFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 131, SqlFieldName = INFO_DrugRatioFlag ];

/// 国家带量集中采购
Property INFOCentralPurFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 132, SqlFieldName = INFO_CentralPurFlag ];

/// 招标标志 INFO_PbFlag
Property INFOPbFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 133, SqlFieldName = INFO_PbFlag ];

/// 计划年采购量/使用量  INFO_Purplanqty
Property INFOPurplanqty As %Library.Float [ SqlColumnNumber = 134, SqlFieldName = INFO_Purplanqty ];

/// 标准名称 INFO_StandardName 指向DHC_StandardName
Property INFOStandardName As %Library.String [ SqlColumnNumber = 135, SqlFieldName = INFO_StandardName ];

/// 发药不可跨批次标志
Property INFONoCrossBatch As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 136, SqlFieldName = INFO_NoCrossBatch ];

/// 一级生产企业
Property INFOPriManfDr As User.PHManufacturer [ SqlColumnNumber = 137, SqlFieldName = INFO_PriManf_Dr ];

/// 税率
Property INFOTaxRate As %Library.Float [ SqlColumnNumber = 138, SqlFieldName = INFO_TaxRate ];

/// 计量标志
Property INFOMetring As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 139, SqlFieldName = INFO_Metring ];

/// 临时采购标志(哈医大)
Property INFOTemPurchase As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 140, SqlFieldName = INFO_TemPurchase ];

/// INFO_MatRegCert_DR  ->DHC_MatRegCert - 注册证信息
Property INFOMatRegCertDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 141, SqlFieldName = INFO_MatRegCert_DR ];

/// INFO_RiskCategory - 风险类别
Property INFORiskCategory As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 142, SqlFieldName = INFO_RiskCategory ];

/// INFO_ConsumableLevel - 耗材级别
Property INFOConsumableLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 143, SqlFieldName = INFO_ConsumableLevel ];

/// INFO_Application - 用途
Property INFOApplication As %Library.String(COLLATION = "Exact", MAXLEN = 600, TRUNCATE = 0) [ SqlColumnNumber = 144, SqlFieldName = INFO_Application ];

/// INFO_Function - 功能
Property INFOFunction As %Library.String(COLLATION = "Exact", MAXLEN = 600, TRUNCATE = 0) [ SqlColumnNumber = 145, SqlFieldName = INFO_Function ];

/// 高值批次码管理标志
Property INFOBatchCodeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 146, SqlFieldName = INFO_BatchCodeFlag ];

/// 药品养护类型
Property INFOCuringType As %Library.String [ SqlColumnNumber = 147, SqlFieldName = INFO_CuringType ];

/// 省谈判药标志
Property INFOProNegotiateFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 148, SqlFieldName = INFO_ProNegotiateFlag ];

///  库存警示级别大类
Property INFOWarnLevelDr As User.PHAINWarnLevel [ SqlColumnNumber = 149, SqlFieldName = INFO_WarnLevel_Dr ];

///  库存警示级别小类
Property INFOWarnLevelItmDr As User.PHAINWarnLevelItm [ SqlColumnNumber = 150, SqlFieldName = INFO_WarnLevelItm_Dr ];

/// 药食同源标志
Property INFOEdibleFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 151, SqlFieldName = INFO_EdibleFlag ];

/// 非药品
Property INFONonDrugFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 152, SqlFieldName = INFO_NonDrugFlag ];

/// 非中标项对应的集中采购的中标项目
Property INFOConEvalInciDR As User.INCItm [ SqlColumnNumber = 153, SqlFieldName = INFO_ConEvalInci_DR ];

/// 关联可代替的省谈判药品 INFO_ProNInciDR
Property INFOProNInciDR As User.INCItm [ SqlColumnNumber = 154, SqlFieldName = INFO_ProNInci_DR ];

/// 商品名
Property INFOTradeName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 155, SqlFieldName = INFO_TradeName ];

/// 防护标志(天津中医)
Property INFOProtectionFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 156, SqlFieldName = INFO_ProtectionFlag ];

/// 防疫非防护标志(天津中医)
Property INFOEpidemicProtectionFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 157, SqlFieldName = INFO_EpidemicProtectionFlag ];

/// UDI编码
Property INFOUDICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 158, SqlFieldName = INFO_UDICode ];

/// 装备协会分类编码
Property INFOEquAssCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 159, SqlFieldName = INFO_EquAssCode ];

/// 采购来源
Property INFOPurSourceDr As User.DHCStkComDictionary [ SqlColumnNumber = 160, SqlFieldName = INFO_PurSource_Dr ];

/// 国家耗材代码
Property INFOInsuMatCode As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 161, SqlFieldName = INFO_InsuMatCode ];

/// 合同到期日期
Property INFOContractExpiresDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 162, SqlFieldName = INFO_ContractExpiresDate ];

/// 是否为无菌(天津中医)
Property INFOSterileFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 163, SqlFieldName = INFO_SterileFlag ];

/// 使用前是否需要灭菌(天津中医)
Property INFOSterilizationFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 164, SqlFieldName = INFO_SterilizationFlag ];

/// 省集中采购
Property INFOProvCentralPurFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 165, SqlFieldName = INFO_ProvCentralPurFlag ];

/// 市集中采购
Property INFOCityCentralPurFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 166, SqlFieldName = INFO_CityCentralPurFlag ];

/// INFO_ExpireCheckLen
Property INFOExpireCheckLen As %Library.Float [ SqlColumnNumber = 167, SqlFieldName = INFO_ExpireCheckLen ];

/// 申请人员
Property INFOApplicant As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 168, SqlFieldName = INFO_Applicant ];

/// 申请日期
Property INFOAppliDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 169, SqlFieldName = INFO_AppliDate ];

/// INFO_Uom_Insu_DR
Property INFOUomInsuDR As User.CTUOM [ SqlColumnNumber = 170, SqlFieldName = INFO_Uom_Insu_DR ];

/// 带量采购类型(国家组织集中采购、河南省集中采购、四省市联合集中采购、广东等联盟地区集中采购)
Property INFOPurWithQtyType As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 171, SqlFieldName = INFO_PurWithQtyType ];

/// 折扣率
Property INFODiscRate As %Float [ SqlColumnNumber = 172, SqlFieldName = INFO_DiscRate ];

/// 折扣金额
Property INFODiscountPrice As %Float [ SqlColumnNumber = 173, SqlFieldName = INFO_DiscountPrice ];

/// 国家耗材代码流水号
Property INFOInsuMatSerialNo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 174, SqlFieldName = INFO_InsuMatSerialNo ];

/// 国家耗材goodsid
Property INFOInsuGoodsId As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 175, SqlFieldName = INFO_InsuGoodsId ];

Property INFOMAHIDR As CT.PHA.IN.MAHInfo [ SqlColumnNumber = 176, SqlFieldName = INFO_MAHI_DR ];

Property INFOPayModeDr As User.DHCStkComDictionary [ SqlColumnNumber = 177, SqlFieldName = INFO_PayMode_Dr ];

/// 国家医保名称
Property INFOInsuMatDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 178, SqlFieldName = INFO_InsuMatDesc ];

Property INFOSpecCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 179, SqlFieldName = INFO_SpecCode ];

/// 危险物品标记(危化品等)
Property INFODangerFlag As %Library.String [ SqlColumnNumber = 180, SqlFieldName = INFO_DangerFlag ];

/// 满整支发药
Property INFOWholeDispFlag As %Library.String(SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 181, SqlFieldName = INFO_WholeDispFlag ];

/// DHC_StkComDictionary的ID串
Property INFOCustomLabel As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 182, SqlFieldName = INFO_CustomLabel ];

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCITMINFO)
	s oldI = +$g(^mdata("DHCITMADDIONINFO"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCITMINFO = maxI
	s ^mdata("DHCITMADDIONINFO") = maxI
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCITMINFO)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INFO_ABC">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="INFO_Abbrev">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="INFO_AckSp_Date">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INFO_AckSp_Flag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INFO_AckSp_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INFO_AckSp_Time">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INFO_AppliDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>47</Piece>
</Data>
<Data name="INFO_Applicant">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>46</Piece>
</Data>
<Data name="INFO_Application">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>21</Piece>
</Data>
<Data name="INFO_AutoLockFlag">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="INFO_BA_flag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INFO_BC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INFO_BackUp">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INFO_Bargaining">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="INFO_BasicDrug">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INFO_BasicRp">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="INFO_BatchCodeFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>23</Piece>
</Data>
<Data name="INFO_BidDate">
<Delimiter>"^"</Delimiter>
<Piece>98</Piece>
</Data>
<Data name="INFO_Brand">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="INFO_CentralPurFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="INFO_ChangeRate">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="INFO_ChargeFlag">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="INFO_ChargeType">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="INFO_CheapDrugFlag">
<Delimiter>"^"</Delimiter>
<Piece>105</Piece>
</Data>
<Data name="INFO_CityCentralPurFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>44</Piece>
</Data>
<Data name="INFO_Codex">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INFO_ComFrom">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INFO_ConEvalInci_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>31</Piece>
</Data>
<Data name="INFO_ConsumableLevel">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>20</Piece>
</Data>
<Data name="INFO_ContractExpiresDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>40</Piece>
</Data>
<Data name="INFO_Costlimits">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="INFO_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>94</Piece>
</Data>
<Data name="INFO_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>95</Piece>
</Data>
<Data name="INFO_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>112</Piece>
</Data>
<Data name="INFO_CuringType">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>24</Piece>
</Data>
<Data name="INFO_CustomLabel">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>6</Piece>
</Data>
<Data name="INFO_DangerFlag">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>4</Piece>
</Data>
<Data name="INFO_DiscRate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>50</Piece>
</Data>
<Data name="INFO_DiscountPrice">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>51</Piece>
</Data>
<Data name="INFO_DistribFlag">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="INFO_DrugRatioFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="INFO_DrugUse">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INFO_Drugbase2">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INFO_EasyConfuse">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="INFO_EdibleFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>28</Piece>
</Data>
<Data name="INFO_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INFO_EpidemicProtectionFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>35</Piece>
</Data>
<Data name="INFO_EquAssCode">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>37</Piece>
</Data>
<Data name="INFO_ExpireCheckLen">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>45</Piece>
</Data>
<Data name="INFO_ExpireLen">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INFO_FirstReqDept">
<Delimiter>"^"</Delimiter>
<Piece>99</Piece>
</Data>
<Data name="INFO_FitEvaluateFlag">
<Delimiter>"^"</Delimiter>
<Piece>122</Piece>
</Data>
<Data name="INFO_FractionFlag">
<Delimiter>"^"</Delimiter>
<Piece>92</Piece>
</Data>
<Data name="INFO_Function">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>22</Piece>
</Data>
<Data name="INFO_GeneralDesc">
<Delimiter>"^"</Delimiter>
<Piece>119</Piece>
</Data>
<Data name="INFO_GiftRecb">
<Delimiter>"^"</Delimiter>
<Piece>90</Piece>
</Data>
<Data name="INFO_HOOKNet">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="INFO_HighPrice">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INFO_HighRiskFlag">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="INFO_HosCategory">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="INFO_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INFO_ISCRemarks">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="INFO_ISC_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INFO_ImplantationMat">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="INFO_ImportFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INFO_InHos_Flag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INFO_InMedBasis">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="INFO_InsuCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="INFO_InsuGoodsId">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>53</Piece>
</Data>
<Data name="INFO_InsuMatCode">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>39</Piece>
</Data>
<Data name="INFO_InsuMatDesc">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>54</Piece>
</Data>
<Data name="INFO_InsuMatSerialNo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>52</Piece>
</Data>
<Data name="INFO_InsuPay">
<Delimiter>"^"</Delimiter>
<Piece>101</Piece>
</Data>
<Data name="INFO_InsuPrice">
<Delimiter>"^"</Delimiter>
<Piece>102</Piece>
</Data>
<Data name="INFO_IntroAffDate">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="INFO_IntroUpdDate">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="INFO_LableFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="INFO_MAHI_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>1</Piece>
</Data>
<Data name="INFO_MT_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INFO_MatCatClinical_DR">
<Delimiter>"^"</Delimiter>
<Piece>108</Piece>
</Data>
<Data name="INFO_MatCatOfficial_DR">
<Delimiter>"^"</Delimiter>
<Piece>107</Piece>
</Data>
<Data name="INFO_MatCatSpecial_DR">
<Delimiter>"^"</Delimiter>
<Piece>109</Piece>
</Data>
<Data name="INFO_MatQuality">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="INFO_MatRegCert_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>18</Piece>
</Data>
<Data name="INFO_MaxPurAmt">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="INFO_MaxQty">
<Delimiter>"^"</Delimiter>
<Piece>110</Piece>
</Data>
<Data name="INFO_MaxSp">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INFO_MedEqptCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="INFO_MedicFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="INFO_Metring">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>16</Piece>
</Data>
<Data name="INFO_MinQty">
<Delimiter>"^"</Delimiter>
<Piece>111</Piece>
</Data>
<Data name="INFO_Model">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="INFO_MonitorFlag">
<Delimiter>"^"</Delimiter>
<Piece>93</Piece>
</Data>
<Data name="INFO_NegotiateFlag">
<Delimiter>"^"</Delimiter>
<Piece>118</Piece>
</Data>
<Data name="INFO_NoCrossBatch">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="INFO_NoLocReq">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="INFO_NonDrugFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>30</Piece>
</Data>
<Data name="INFO_NotUseReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="INFO_OTC">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INFO_OecAct_Dr">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INFO_OperatNorm">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="INFO_OrdEndDate">
<Delimiter>"^"</Delimiter>
<Piece>113</Piece>
</Data>
<Data name="INFO_OrdPrompt">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="INFO_Origin">
<Delimiter>"^"</Delimiter>
<Piece>100</Piece>
</Data>
<Data name="INFO_PBL_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INFO_PBLevel">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INFO_PDrugbase1">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="INFO_PDrugbase2">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="INFO_PHMNF_DR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="INFO_PackCharge">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="INFO_PackPicPath">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="INFO_PackUom">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="INFO_PackUomFactor">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="INFO_PackUomFactorM">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="INFO_PackUomM">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="INFO_PackWeight">
<Delimiter>"^"</Delimiter>
<Piece>106</Piece>
</Data>
<Data name="INFO_PayMode_Dr">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>2</Piece>
</Data>
<Data name="INFO_PbCarrier_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INFO_PbFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="INFO_PbManf_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INFO_PbRp">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INFO_PbVendor_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INFO_Pbno">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="INFO_PhcDrugCode">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="INFO_PivaBack">
<Delimiter>"^"</Delimiter>
<Piece>116</Piece>
</Data>
<Data name="INFO_PivaExedt">
<Delimiter>"^"</Delimiter>
<Piece>114</Piece>
</Data>
<Data name="INFO_PivaExpdet">
<Delimiter>"^"</Delimiter>
<Piece>115</Piece>
</Data>
<Data name="INFO_PrcFile">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INFO_PrcFileD">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INFO_Preparation_Dr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="INFO_PrevCode">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="INFO_PriManf_Dr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>14</Piece>
</Data>
<Data name="INFO_PriceRecord">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="INFO_ProNInci_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>32</Piece>
</Data>
<Data name="INFO_ProNegotiateFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>25</Piece>
</Data>
<Data name="INFO_ProjectPin">
<Delimiter>"^"</Delimiter>
<Piece>104</Piece>
</Data>
<Data name="INFO_Project_Dr">
<Delimiter>"^"</Delimiter>
<Piece>103</Piece>
</Data>
<Data name="INFO_ProtectionFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>34</Piece>
</Data>
<Data name="INFO_ProvCentralPurFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>43</Piece>
</Data>
<Data name="INFO_PurPlanCode">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="INFO_PurPlanType">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="INFO_PurSource_Dr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>38</Piece>
</Data>
<Data name="INFO_PurWithQtyType">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>49</Piece>
</Data>
<Data name="INFO_Purplanqty">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="INFO_QualityLevel">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INFO_QualityNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INFO_REC">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INFO_RecMaxQty">
<Delimiter>"^"</Delimiter>
<Piece>121</Piece>
</Data>
<Data name="INFO_RefRetReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="INFO_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INFO_ReqModeLimited">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="INFO_RiskCategory">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>19</Piece>
</Data>
<Data name="INFO_SeparateBuyFlag">
<Delimiter>"^"</Delimiter>
<Piece>120</Piece>
</Data>
<Data name="INFO_SkinTest">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INFO_SpeFlag">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="INFO_Spec">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INFO_SpecCode">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>3</Piece>
</Data>
<Data name="INFO_SpecFlag">
<Delimiter>"^"</Delimiter>
<Piece>96</Piece>
</Data>
<Data name="INFO_StandardCode">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="INFO_StandardName">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="INFO_StatQty">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="INFO_StatUom">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="INFO_SterileDateLen">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="INFO_SterileFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>41</Piece>
</Data>
<Data name="INFO_SterilizationFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>42</Piece>
</Data>
<Data name="INFO_Supervision">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="INFO_TaxRate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>15</Piece>
</Data>
<Data name="INFO_TemPurchase">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>17</Piece>
</Data>
<Data name="INFO_Test">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INFO_TpnFlag">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INFO_TradeName">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>33</Piece>
</Data>
<Data name="INFO_TransDate">
<Delimiter>"^"</Delimiter>
<Piece>97</Piece>
</Data>
<Data name="INFO_TwoTicketFlag">
<Delimiter>"^"</Delimiter>
<Piece>117</Piece>
</Data>
<Data name="INFO_UDICode">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>36</Piece>
</Data>
<Data name="INFO_UnPayRp">
<Delimiter>"^"</Delimiter>
<Piece>91</Piece>
</Data>
<Data name="INFO_Uom_Insu_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>48</Piece>
</Data>
<Data name="INFO_UsePatient">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INFO_WarnLevelItm_Dr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>27</Piece>
</Data>
<Data name="INFO_WarnLevel_Dr">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>26</Piece>
</Data>
<Data name="INFO_WholeDispFlag">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>5</Piece>
</Data>
<Data name="INFO_ZeroStk">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Global>^DHCITMINFO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INFO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INFO_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBrand">
<Global>^DHCITMINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INFO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"BRAND"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INFO_Brand}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INFO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDate">
<Global>^DHCITMINFO</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"CRDA"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INFO_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INFO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCITMINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INFO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INFO_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INFO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsuCode">
<Global>^DHCITMINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INFO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsuCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INFO_InsuMatCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INFO_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INFO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexManf">
<Global>^DHCITMINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INFO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"MANF"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INFO_PHMNF_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INFO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPbVendor">
<Global>^DHCITMINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INFO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"VEN"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INFO_PbVendor_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INFO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStandardCode">
<Global>^DHCITMINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INFO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STANDCODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({INFO_StandardCode})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INFO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCItmAddionInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
