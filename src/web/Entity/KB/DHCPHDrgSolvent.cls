/// 名称:溶媒
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期:  2016-10-11
Class web.Entity.KB.DHCPHDrgSolvent Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHDrgSolvent";

Property PDINTRowId As %String;

// 主索引表指针

Property PDINTInstDr As %String;

// 商品名指针

Property PDINTDrgDr As %String;

// 浓度

Property PDINTDosage As %String;

// 关系 2016-11-24

Property PDINTRelation As %String;

// 单位 2016-11-24

Property PDINTMustUomDr As %String;

/// 浓度上限 2018-01-04
Property PDINTDosageMax As %String;

/// 浓度下限 2018-01-04
Property PDINTDosageMin As %String;

// 管控级别: Warn警示, Control管控, Stat统计

Property PDINTManage As %String;

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

}
