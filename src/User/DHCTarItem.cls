/// Tariff Item
Class User.DHCTarItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = TARI_RowId, SqlTableName = DHC_TarItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCTarItemPrice As User.DHCTarItemPrice [ Cardinality = children, Inverse = TPTARIParRef ];

/// 收费项代码
Property TARICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TARI_Code ];

/// 收费项名称
Property TARIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TARI_Desc ];

/// 单位
Property TARIUOM As User.CTUOM [ SqlColumnNumber = 4, SqlFieldName = TARI_UOM ];

/// 收费项目子类
Property TARISubCate As User.DHCTarSubCate [ SqlColumnNumber = 5, SqlFieldName = TARI_SubCate ];

/// 收费会计子类
Property TARIAcctCate As User.DHCTarAcctCate [ SqlColumnNumber = 6, SqlFieldName = TARI_AcctCate ];

/// 门诊费用子类
Property TARIOutpatCate As User.DHCTarOutpatCate [ SqlColumnNumber = 7, SqlFieldName = TARI_OutpatCate ];

/// 经济核算子类
Property TARIEMCCate As User.DHCTarEMCCate [ SqlColumnNumber = 8, SqlFieldName = TARI_EMCCate ];

/// 旧病案首页子类
Property TARIMRCate As User.DHCTarMRCate [ SqlColumnNumber = 9, SqlFieldName = TARI_MRCate ];

/// 特殊项目标识（Y/N)
Property TARISpecialFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 10, SqlFieldName = TARI_SpecialFlag ];

/// 有效标志
Property TARIActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = TARI_ActiveFlag ];

/// 开始日期
Property TARIStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = TARI_StartDate ];

/// 结束日期
Property TARIEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = TARI_EndDate ];

/// Tariff Item Price
Property TARIPrice As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = TARI_Price ];

/// TARI_AlterPrice1
Property TARIAlterPrice1 As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = TARI_AlterPrice1 ];

/// TARI_AlterPrice2
Property TARIAlterPrice2 As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = TARI_AlterPrice2 ];

/// 外部编码(如果收费项已经做过医保对照，外部代码可以填同一类收费项的代码，就不需要再对照这条收费项）
Property TARIExternalCode As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = TARI_ExternalCode ];

/// 住院费用子类
Property TARIInpatCate As User.DHCTarInpatCate [ SqlColumnNumber = 18, SqlFieldName = TARI_InpatCate ];

/// 医保名称
Property TARIInsuName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = TARI_InsuName ];

/// 收费说明
Property TARIEngName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = TARI_EngName ];

/// 收费依据
Property TARIChargeBasis As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = TARI_ChargeBasis ];

/// 新病案首页子类 
Property TARIMCNew As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = TARI_MCNew ];

/// 创建人
Property TARICreateUser As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = TARI_CreateUser ];

/// 创建日期
Property TARICreateDate As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = TARI_CreateDate ];

/// 创建日期
Property TARICreateTime As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = TARI_CreateTime ];

/// 科目类别
Property TARIItemCatDR As User.BDPItemCategory [ SqlColumnNumber = 26, SqlFieldName = TARI_ItemCatDR ];

/// 项目内涵
Property TARIConnote As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = TARI_Connote ];

/// 备注
Property TARIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = TARI_Remark ];

/// 除外内容
Property TARIExclude As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = TARI_Exclude ];

/// 税务编码
Property TARITaxcode As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = TARI_Taxcode ];

/// 税率
Property TARITaxrate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = TARI_Taxrate ];

/// 手术级别 add@2020-04-13
Property TARIOPERCategoryDR As ORCOperationCategory [ SqlColumnNumber = 32, SqlFieldName = TARI_OPERCategory_DR ];

/// 限价耗材标志     
Property TARIFixedPriceFlag As %Library.String [ SqlColumnNumber = 33, SqlFieldName = TARI_FixedPriceFlag ];

/// 医保上限价格  
Property TARIInsuranceMaxPice As %Library.String [ SqlColumnNumber = 34, SqlFieldName = TARI_InsuranceMaxPice ];

/// 北京医疗价格编码 --医价平台编码 
Property TARIPriceCodeBJ As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = TARI_PriceCodeBJ ];

/// MDM对照码
Property TARIMDMCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = TARI_MDMCode ];

/// 外送标志 0 非外送 1外送
Property TARIDelivery As %Library.String(DISPLAYLIST = ",NoDilivery,Dilivery", VALUELIST = ",0,1") [ SqlColumnNumber = 37, SqlFieldName = TARI_Delivery ];

/// 外送医保编码
Property TARIDelivMedInsureCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = TARI_DelivMedInsureCode ];

/// 仪器编码
Property TARIEquipmentCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = TARI_EquipmentCode ];

/// 权重
Property TARIWeight As %Library.String [ SqlColumnNumber = 40, SqlFieldName = TARI_Weight ];

/// 工作量百分比
Property TARIJobPercent As %Library.String [ SqlColumnNumber = 41, SqlFieldName = TARI_JobPercent ];

/// 住院自付比例  
Property TARIInsuIPProportion As %Library.String [ SqlColumnNumber = 42, SqlFieldName = TARI_InsuIPProportion ];

/// 门诊自付比例 
Property TARIInsuOPProportion As %Library.String [ SqlColumnNumber = 43, SqlFieldName = TARI_InsuOPProportion ];

/// 大检标志    
Property TARIInsuDJSign As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 44, SqlFieldName = TARI_InsuDJSign ];

/// 物价编码
Property TARIPriceCode As %Library.String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = TARI_PriceCode ];

/// 国家监控高值耗材标志
Property TARIStateHVMFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 46, SqlFieldName = TARI_StateHVMFlag ];

/// 省级监控高值耗材标志
Property TARIProvHVMFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = TARI_ProvHVMFlag ];

/// 医嘱累计最高限价
Property TARITotalLimitedPrice As %Float [ SqlColumnNumber = 48, SqlFieldName = TARI_TotalLimitedPrice ];

/// 卫材超标标识（Y：超标）
Property TARIExcessiveType As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = TARI_ExcessiveType ];

/// 物价名称 add 2020-08-21
Property TARIPriceDesc As %Library.String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = TARI_PriceDesc ];

/// 收费性质
Property TARIChargeType As %Library.String [ SqlColumnNumber = 51, SqlFieldName = TARI_ChargeType ];

/// 价改前价格
Property TARIPriceBeforeChange As %Float [ SqlColumnNumber = 52, SqlFieldName = TARI_PriceBeforeChange ];

/// 特需项目标识 add 2020-11-07  ^58
Property TARISpecialProcurementFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 53, SqlFieldName = TARI_SpecialProcurementFlag ];

/// 国家医保编码 add 2021-02-22  ^59
Property TARIInsuCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 54, SqlFieldName = TARI_InsuCode ];

/// 常规项目标识 add 2021-02-26  ^60
Property TARIRoutineProcurementFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 55, SqlFieldName = TARI_RoutineProcurementFlag ];

/// 试行项目标识 add 2021-02-26 ^61
Property TARIPilotProcurementFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = TARI_PilotProcurementFlag ];

/// 市场调节标识 add 2021-02-26 ^62
Property TARIMarketRegulationFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = TARI_MarketRegulationFlag ];

/// 院内监控重点耗材
Property TARIHospHVMFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 58, SqlFieldName = TARI_HospHVMFlag ];

/// 物价备注  64
Property TARIPriceRemark As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = TARI_PriceRemark ];

/// 特需门诊加收编码 65
Property TARIOutpatientExtrasCostsCode As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 60, SqlFieldName = TARI_OutpatientExtrasCostsCode ];

/// 特需住院加收编码 66
Property TARIInpatientExtrasCostsCode As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 61, SqlFieldName = TARI_InpatientExtrasCostsCode ];

/// 儿童加收编码 67
Property TARIKidsExtrasCostsCode As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 62, SqlFieldName = TARI_KidsExtrasCostsCode ];

/// 不允许重复收费标志 68  默认为N，N时允许重复收费
Property TARIRepeatedChargeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 63, SqlFieldName = TARI_RepeatedChargeFlag ];

/// 进口标志(进口IM、国产HM 、合资JM、未分类UM) 69
Property TARIManufactorType As %Library.String(DISPLAYLIST = ",ImportMade,HomeMade,JointMade,UnClassifyMade", MAXLEN = 3, VALUELIST = ",IM,HM,JM,UM") [ SqlColumnNumber = 64, SqlFieldName = TARI_ManufactorType ];

/// 规格 70 
Property TARISpec As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 65, SqlFieldName = TARI_Spec ];

/// 自费标志 71 默认为N
Property TARIAtOwnExpenseFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 66, SqlFieldName = TARI_AtOwnExpenseFlag ];

/// 省编码 72
Property TARIProvCode As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 67, SqlFieldName = TARI_ProvCode ];

/// 省名称 73
Property TARIProvDesc As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 68, SqlFieldName = TARI_ProvDesc ];

/// 市编码 74
Property TARICityCode As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 69, SqlFieldName = TARI_CityCode ];

/// 市名称 75
Property TARICityDesc As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 70, SqlFieldName = TARI_CityDesc ];

/// 院内编码 76
Property TARIHospCode As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 71, SqlFieldName = TARI_HospCode ];

/// 院内名称 77
Property TARIHospDesc As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 72, SqlFieldName = TARI_HospDesc ];

///  注册证号  78
Property TARIRegistrationNo As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 73, SqlFieldName = TARI_RegistrationNo ];

/// 市定价项目  79   
Property TARICityPriceFixFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 74, SqlFieldName = TARI_CityPriceFixFlag ];

/// 自主定价项目  80  
Property TARIPriceDiscretFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 75, SqlFieldName = TARI_PriceDiscretFlag ];

/// 中医诊疗项目 81  
Property TARIChineseTreatFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 76, SqlFieldName = TARI_ChineseTreatFlag ];

/// 付费类型 (公费Free、自费Own、部分自费Partial、条件自费Contional)
Property TARIPayType As %String(DISPLAYLIST = ",Free,Own,Partial,Contional", VALUELIST = ",F,O,P,C") [ SqlColumnNumber = 77, SqlFieldName = TARI_PayType ];

/// 当天只收一次费
Property TARITodayChargeOnce As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 78, SqlFieldName = TARI_TodayChargeOnce ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCTARI(0))</SqlIdExpression>
<SQLMap name="INDEXAccountCate">
<Global>^DHCTARI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TARI_AcctCate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TARI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXChargeBasis">
<Global>^DHCTARI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ChargeBasis"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({TARI_ChargeBasis})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TARI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXCode">
<Global>^DHCTARI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TARI_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TARI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXDesc">
<Global>^DHCTARI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TARI_Desc}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TARI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXEMCCategory">
<Global>^DHCTARI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TARI_EMCCate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TARI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXEngName">
<Global>^DHCTARI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EngName"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TARI_EngName}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TARI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXExternalCode">
<Global>^DHCTARI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ASC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TARI_ExternalCode}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TARI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXIPCate">
<Global>^DHCTARI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"IC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{TARI_InpatCate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{TARI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXInsuName">
<Global>^DHCTARI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"InsuName"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TARI_InsuName}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TARI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXItemCat">
<Global>^DHCTARI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SIC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TARI_ItemCatDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TARI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXMRCate">
<Global>^DHCTARI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TARI_MRCate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TARI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXOPCate">
<Global>^DHCTARI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TARI_OutpatCate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TARI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXSubCate">
<Global>^DHCTARI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TARI_SubCate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{TARI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOPERCate">
<Global>^DHCTARI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OPERCATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TARI_OPERCategory_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TARI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartDate">
<Global>^DHCTARI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StartDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TARI_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TARI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="TariffItemMasterMap">
<Data name="TARI_AcctCate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TARI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TARI_AlterPrice1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TARI_AlterPrice2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TARI_AtOwnExpenseFlag">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="TARI_ChargeBasis">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="TARI_ChargeType">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="TARI_ChineseTreatFlag">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="TARI_CityCode">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="TARI_CityDesc">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="TARI_CityPriceFixFlag">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="TARI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TARI_Connote">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="TARI_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="TARI_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="TARI_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="TARI_DelivMedInsureCode">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="TARI_Delivery">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="TARI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TARI_EMCCate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TARI_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TARI_EngName">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="TARI_EquipmentCode">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="TARI_ExcessiveType">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="TARI_Exclude">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="TARI_ExternalCode">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TARI_FixedPriceFlag">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="TARI_HospCode">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="TARI_HospDesc">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="TARI_HospHVMFlag">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="TARI_InpatCate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TARI_InpatientExtrasCostsCode">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="TARI_InsuCode">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="TARI_InsuDJSign">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="TARI_InsuIPProportion">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="TARI_InsuName">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="TARI_InsuOPProportion">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="TARI_InsuranceMaxPice">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="TARI_ItemCatDR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="TARI_JobPercent">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="TARI_KidsExtrasCostsCode">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="TARI_MCNew">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="TARI_MDMCode">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="TARI_MRCate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TARI_ManufactorType">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="TARI_MarketRegulationFlag">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="TARI_OPERCategory_DR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="TARI_OutpatCate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TARI_OutpatientExtrasCostsCode">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="TARI_PayType">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="TARI_PilotProcurementFlag">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="TARI_Price">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TARI_PriceBeforeChange">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="TARI_PriceCode">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="TARI_PriceCodeBJ">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="TARI_PriceDesc">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="TARI_PriceDiscretFlag">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="TARI_PriceRemark">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="TARI_ProvCode">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="TARI_ProvDesc">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="TARI_ProvHVMFlag">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="TARI_RegistrationNo">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="TARI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="TARI_RepeatedChargeFlag">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="TARI_RoutineProcurementFlag">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="TARI_Spec">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="TARI_SpecialFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="TARI_SpecialProcurementFlag">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="TARI_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TARI_StateHVMFlag">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="TARI_SubCate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TARI_Taxcode">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="TARI_Taxrate">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="TARI_TodayChargeOnce">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="TARI_TotalLimitedPrice">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="TARI_UOM">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TARI_Weight">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Global>^DHCTARI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TARI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{TARI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TARI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCTarItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
