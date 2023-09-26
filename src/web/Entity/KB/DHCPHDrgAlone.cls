/// 名称: 单独用药
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-11-3
Class web.Entity.KB.DHCPHDrgAlone Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHDrgAlone";

Property PHDALRowId As %String;

// 主索引表指针

Property PHDALInstDr As %String;

// 商品名指针

Property PHDALDrgDr As %String;

// 管控级别: Warn警示, Control管控, Stat统计

Property PHDALManage As %String;

// 组号 2016-11-24

Property PHDALGrpNo As %String;

// 溶媒分类 2016-11-24

Property PHDALCatDr As %String;

// PHINST_Mode级别

Property PHINSTMode As %String;

// 主索引表必填项

Property PHINSTTypeDr As %String;

Property PHINSTOrderNum As %String;

Property PHINSTGenDr As %String;

Property PHINSTPointerDr As %String;

Property PHINSTLibDr As %String;

Property PHINSTPointerType As %String;

Property PHINSTActiveFlag As %String;

Property PHINSTSysFlag As %String;

// 描述，存进主索引表

Property PHINSTText As %String;

/// 商品名描述 2018-11-07
Property PHDALDrgDrs As %String;

}
