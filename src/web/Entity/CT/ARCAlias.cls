/// 名称: 医嘱项别名
/// 描述: 实体类，目前只用于保存日志
/// 编写者：基础数据平台组-李森
/// 编写日期: 2014-1-13
Class web.Entity.CT.ARCAlias Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ARCAlias";

/// 医嘱项DR ARCItmMast
Property ALIASARCIMDR As %String;

/// RowId号
Property ALIASRowId As %String;

/// 代码
Property ALIASText As %String;

/// 开始日期
Property ALIASDateFrom As %String;

/// 截止日期
Property ALIASDateTo As %String;

Property ALIASDesc As %String;

Property ALIASOrderSubCatDR As %String;

Property ALIASType As %String;

Property ALIASOrderOnItsOwn As %String;

}
