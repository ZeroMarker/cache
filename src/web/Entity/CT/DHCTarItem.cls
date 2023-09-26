/// 名称: 收费项目维护
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2015-07-22
Class web.Entity.CT.DHCTarItem Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCTarItem";

/// RowId
Property TARIRowId As %String;

/// Tariff Item Code
Property TARICode As %String;

/// Tariff Item Desc
Property TARIDesc As %String;

/// TARI_UOM
Property TARIUOM As %String;

/// Tariff Item SubCategory
Property TARISubCate As %String;

/// Tariff Item Account Category
Property TARIAcctCate As %String;

/// Outpatient Tariff Category
Property TARIOutpatCate As %String;

/// TARI_EMCCate
Property TARIEMCCate As %String;

/// Tariff Item MR FirstPage Category
Property TARIMRCate As %String;

/// Specital Item Flag
Property TARISpecialFlag As %String;

/// Tariff Item Actived Flag
Property TARIActiveFlag As %String;

/// TARI_StartDate
Property TARIStartDate As %String;

/// TARI_EndDate
Property TARIEndDate As %String;

/// Tariff Item Price
Property TARIPrice As %String;

/// TARI_AlterPrice1
Property TARIAlterPrice1 As %String;

/// TARI_AlterPrice2
Property TARIAlterPrice2 As %String;

/// Tariff Item External Code
Property TARIExternalCode As %String;

/// Inpatient Tariff Category
Property TARIInpatCate As %String;

/// TARI_InsuName
Property TARIInsuName As %String;

/// TARI_EngName
Property TARIEngName As %String;

/// PLIST(21)
Property TARIChargeBasis As %String;

/// PLIST(22)
Property TARIMCNew As %String;

Property TARIItemCatDR As %String;

/// 项目内涵 2017-11-29
Property TARIConnote As %String;

/// 备注  2017-11-29
Property TARIRemark As %String;

/// 除外内容 2017-11-29
Property TARIExclude As %String;

/// 手术级别 add@2020-04-13
Property TARIOPERCategoryDR As %String;

/// 物价编码 add 2020-11-13
Property TARIPriceCode As %String;

/// 物价名称 add 2020-11-13
Property TARIPriceDesc As %String;

/// 特需项目标识 add 2020-11-13
Property TARISpecialProcurementFlag As %String;

/// 国家医保编码 add 2021-04-06
Property TARIInsuCode As %String;

/// 物价备注 add 2021-07-29
Property TARIPriceRemark As %String;

/// 不允许重复收费 add 2021-07-29
Property TARIRepeatedChargeFlag As %String;

/// 进口标志 add 2021-08-19
Property TARIManufactorType As %String;

}
