/// 名称:手术项目编辑器 -高危提醒 
/// 描述: 实体类
/// 编写者：基础数据平台组-高姗姗
/// 编写日期: 2017-4-10
Class web.Entity.KB.DHCOPERRemind Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCOPERRemind";

Property PHDDRowId As %String;

// 主索引表指针

Property PHDDInstDr As %String;

// 病症

Property PHDDDiseaDr As %String;

// 年龄

Property PDAAgeDr As %String;

// 年龄最大值

Property PDAMaxVal As %String;

// 年龄最小值

Property PDAMinVal As %String;

// 年龄单位

Property PDAUomDr As %String;

// 说明

Property PHINSTText As %String;

// 主索引表必填项

Property PHINSTTypeDr As %String;

Property PHINSTOrderNum As %String;

Property PHINSTGenDr As %String;

Property PHINSTPointerDr As %String;

Property PHINSTLibDr As %String;

Property PHINSTPointerType As %String;

Property PHINSTActiveFlag As %String;

Property PHINSTSysFlag As %String;

Property PHINSTBMIMin As %String;

Property PHINSTBMIMax As %String;

// 特殊人群

Property SpecialPopu As %String;

/// 病症描述 2018-11-08
Property PHDDDiseaDrs As %String;

/// 特殊人群描述 2018-11-08
Property SPEPISpecDrs As %String;

// 作用模式

Property PHINSTMode As %String;

// 收缩压下限

Property SysPressMinVal As %String;

// 收缩压上限

Property SysPressMaxVal As %String;

// 舒张压下限

Property DiaPressMinVal As %String;

// 舒张压上限

Property DiaPressMaxVal As %String;

}
