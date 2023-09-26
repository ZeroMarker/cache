/// 名称:药品业务表 -禁忌症维护 
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-12-3
Class web.Entity.KB.DHCPHDrugDiseaseC Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHDrugDiseaseC";

Property PHDDRowId As %String;

// 主索引表指针

Property PHDDInstDr As %String;

// 作用模式

Property PHDDMode As %String;

// 病症

Property PHDDDiseaDr As %String;

// 年龄

Property PDARowId As %String;

Property PDAInstDr As %String;

Property PDAAgeDr As %String;

// 年龄最大值

Property PDAMaxVal As %String;

// 年龄最小值

Property PDAMinVal As %String;

// 年龄单位

Property PDAUomDr As %String;

// PHINST_Mode级别

Property PHINSTMode As %String;

// PHINST_Sex性别

Property PHINSTSex As %Library.String;

// PHINST_DocUseTips用药提示（用于医生）

Property PHINSTDocUseTips As %String;

// PHINST_Note备注说明

Property PHINSTNote As %String;

// 主索引表必填项

Property PHINSTTypeDr As %String;

Property PHINSTOrderNum As %String;

Property PHINSTGenDr As %String;

Property PHINSTPointerDr As %String;

Property PHINSTLibDr As %String;

Property PHINSTPointerType As %String;

Property PHINSTActiveFlag As %String;

Property PHINSTSysFlag As %String;

// 过敏史指针

Property LALCAllergyDr As %String;

// 特殊人群

Property SpecialPopu As %String;

Property PHINSTText As %String;

// 成分

Property PHINIIngrDr As %String;

// 生理参数

Property PHYVFeildDr As %String;

// 既往史

Property LDHDhDr As %String;

// 类型

Property PHDDType As %String;

// 生理参数下限

Property PHYVMinVal As %String;

// 生理参数上限

Property PHYVMaxVal As %String;

// 检验项目和指标值范围 2017-03-17

Property LABILabDr As %String;

Property LABIMinVal As %String;

Property LABIMaxVal As %String;

Property LABIUomDr As %String;

Property LABIRelation As %String;

// 治疗手术 

Property PDCUKeyWordDr As %String;

// 症状体征

Property PSYMKeyWordDr As %String;

/// 病症描述 
Property PHDDDiseaDrs As %String;

/// 治疗手术
Property PDCUKeyWordDrs As %String;

/// 症状
Property PSYMKeyWordDrs As %String;

/// 特殊人群
Property SPEPISpecDrs As %String;

/// 既往史
Property LDHDhDrs As %String;

}
