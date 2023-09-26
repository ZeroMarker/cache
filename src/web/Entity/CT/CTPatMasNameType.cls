/// Function: 病人姓名类型
/// CreateDate:2022-07-14
/// Creator:sunfengchao
Class web.Entity.CT.CTPatMasNameType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTPatMasNameType";

Property ID As %String;

/// 代码 
Property CTPMNTCode As %String;

/// 描述
Property CTPMNTDesc As %String;

/// 开始日期
Property CTPMNTDateFrom As %String;

/// 结束日期
Property CTPMNTDateTo As %String;

}
