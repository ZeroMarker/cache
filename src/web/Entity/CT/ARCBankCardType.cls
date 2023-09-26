/// Creator:孙凤超
/// CreateDate:2013-05-13
Class web.Entity.CT.ARCBankCardType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ARCBankCardType";

Property CARDRowId As %String;

/// ID号
Property CARDCode As %String;

/// 代码
Property CARDDesc As %String;

/// 描述
Property CARDDateFrom As %String;

/// 开始日期
Property CARDDateTo As %String;

/// 结束日期

}
