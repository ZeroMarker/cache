/// 职称维护 实体类  孙凤超  
/// 2013-7-4
Class web.Entity.CT.CTTitle Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTTitle";

///  TTL_RowId	TTL_Code	TTL_Desc	TTL_DateFrom	TTL_DateTo
Property TTLRowId As %String;

Property TTLCode As %String;

/// 代码
Property TTLDesc As %String;

/// 描述
Property TTLDateFrom As %String;

/// 开始日期
Property TTLDateTo As %String;

/// 结束日期

}
