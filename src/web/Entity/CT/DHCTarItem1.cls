/// 名称: 收费项目维护
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2015-07-22
Class web.Entity.CT.DHCTarItem1 Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCTarItem1";

Property OLTRowId As %String;

/// 打印名称 同仁医院
Property TariExpPrintName As %String;

/// 招标进价 
Property INFOPbRp As %String;

/// 收费项价格
Property TPPatInsType As %String;

Property TPAlterPrice1 As %String;

Property TPStartDate As %String;

Property TPEndDate As %String;

Property TPAlterPrice2 As %String;

Property TPPrice As %String;

Property TPRowId As %String;

/// 加成率
Property MRMargin As %String;

Property OLTInstDR As %String;

Property OLTPriorityDR As %String;

Property OLTARCIMDR As %String;

Property OLTTariffDR As %String;

Property OLTQty As %String;

Property ARCIMRowId As %String;

Property OLTEndDate As %String;

Property OLTStartDate As %String;

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

}
