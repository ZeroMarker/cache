/// 名称:心电业务表 -适应症维护 
/// 描述: 实体类
/// 编写者：基础数据平台组-高姗姗
/// 编写日期: 2015-1-6
Class web.Entity.KB.DHCECGDiseaseI Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCECGDiseaseI";

Property PHDDRowId As %String;

// 主索引表指针

Property PHDDInstDr As %String;

// 病症

Property PHDDDiseaDr As %String;

// 检查结果

Property PHDDExamDr As %String;

// 级别

Property PHINSTMode As %String;

// 描述

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

/// 病症描述 2018-11-12
Property PHDDDiseaDrs As %String;

/// 检查结果描述 2018-11-12
Property PHDDExamDrs As %String;

Property PHDDMode As %String;

}
