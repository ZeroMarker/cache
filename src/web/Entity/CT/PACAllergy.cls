/// 创建日期：2013-09-03
/// 创建人：基础数据平台组 孙凤超
/// 功能： 电子病历-2 过敏原 实体类
Class web.Entity.CT.PACAllergy Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACAllergy";

Property ALGRowId As %String;

/// 代码
Property ALGCode As %String;

/// 描述
Property ALGDesc As %String;

/// 分类
Property ALGTypeDR As %String;

/// 开始日期 
Property ALGDateFrom As %String;

/// 结束日期
Property ALGDateTo As %String;

/// 备注
Property ALGNoteText As %String;

/// 过敏原指向
Property ALGAllergyDR As %String;

}
