/// 名称:检验项目编辑器 -相互作用
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-12-3
Class web.Entity.KB.DHCLABDiseaseInteract Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCLABDiseaseInteract";

Property PDINTRowId As %String;

//主索引表指针

Property PDINTInstDr As %String;

//通用名指针

Property PDINTGenDr As %String;

// 管控级别: Warn警示, Control管控, Stat统计

Property PDINTManage As %String;

// 类型：相互作用Interact、配伍禁忌Incompatibility、互斥项目MutualExclusion

Property PDINTType As %String;

//PHINST_Mode级别

Property PHINSTMode As %String;

//主索引表必填项

Property PHINSTTypeDr As %String;

Property PHINSTOrderNum As %String;

Property PHINSTGenDr As %String;

Property PHINSTPointerDr As %String;

Property PHINSTLibDr As %String;

Property PHINSTPointerType As %String;

Property PHINSTActiveFlag As %String;

Property PHINSTSysFlag As %String;

//分类、类型字典表指针

Property PDINTCatDr As %String;

//描述，存进主索引表

Property PHINSTText As %String;

}
