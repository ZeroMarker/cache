/// 名称:药品业务表 -适应症维护 
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-12-3
Class web.Entity.KB.DHCPHDrugDiseaseI Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHDrugDiseaseI";

Property PHDDRowId As %String;

// 主索引表指针

Property PHINSTRowId As %String;

Property PHDDInstDr As %String;

// 作用模式

Property PHDDMode As %String;

// 病症

Property PHDDDiseaDr As %String;

// 年龄表ID

Property PDARowId As %String;

Property PDAInstDr As %String;

// 年龄

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

// 说明

Property PHINSTText As %String;

// 治疗手术 

Property PDCUKeyWordDr As %String;

// 症状体征

Property PSYMKeyWordDr As %String;

// 检验项目和指标值范围 2017-03-28

Property LABILabDr As %String;

Property LABIMinVal As %String;

Property LABIMaxVal As %String;

Property LABIUomDr As %String;

Property LABIRelation As %String;

// 细菌  2017-04-11

Property PHORGOrgDr As %String;

// 菌属  2017-04-11

Property PHGENGenusDr As %String;

// 主索引表必填项

Property PHINSTTypeDr As %String;

Property PHINSTOrderNum As %String;

Property PHINSTGenDr As %String;

Property PHINSTPointerDr As %String;

Property PHINSTLibDr As %String;

Property PHINSTPointerType As %String;

Property PHINSTActiveFlag As %String;

Property PHINSTSysFlag As %String;

/// 病症描述 
Property PHDDDiseaDrs As %String;

/// 治疗手术
Property PDCUKeyWordDrs As %String;

/// 症状
Property PSYMKeyWordDrs As %String;

/// 细菌
Property PHORGOrgDrs As %String;

/// 菌属
Property PHGENGenusDrs As %String;

}
