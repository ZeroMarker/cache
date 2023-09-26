/// 名称: 联合用药
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-11-24
Class web.Entity.KB.DHCPHMustDrug Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHMustDrug";

Property PHMDRowId As %String;

//主索引表指针

Property PHMDInstDr As %String;

//关联药

Property PHMDAssDrugDr As %String;

// 必用药品

Property PHMDMustDrugDr As %String;

// 数量

Property PHMDMustQty As %String;

// 关系

Property PHMDRelation As %String;

// 单位 

Property PHMDMustUomDr As %String;

//主索引表必填项

Property PHINSTTypeDr As %String;

Property PHINSTOrderNum As %String;

Property PHINSTGenDr As %String;

Property PHINSTPointerDr As %String;

Property PHINSTLibDr As %String;

Property PHINSTPointerType As %String;

Property PHINSTActiveFlag As %String;

Property PHINSTSysFlag As %String;

//描述，存进主索引表

Property PHINSTText As %String;

}
