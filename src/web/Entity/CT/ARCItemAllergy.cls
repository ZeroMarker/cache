/// 名称: 医嘱项维护过敏原菜单
/// 描述: 实体类
/// 编写者：基础数据平台组-孙凤超
/// 编写日期: 2014-10-15
Class web.Entity.CT.ARCItemAllergy Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ARCItemAllergy";

/// 　孩子数
Property ALGChildsub As %String;

/// 医嘱项的rowid
Property ALGParRef As %String;

/// /过敏原关联的rowid
Property ALGRowId As %String;

/// 药学项
Property ALGDrugMastDR As %String;

/// 药品通用名
Property ALGGenericDR As %String;

/// 过敏原
Property ALGAllergyDR As %String;

/// 用于存放 医嘱项关联的  DR
Property Allergy As %String;

}
