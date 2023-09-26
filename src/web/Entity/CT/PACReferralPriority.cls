/// Function: 入院病情维护
/// Creator:  sunfengchao
/// CreateDate: 2016-1-13
Class web.Entity.CT.PACReferralPriority Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACReferralPriority";

/// ID
Property REFPRIRowId As %String;

/// 代码
Property REFPRICode As %String;

/// 描述
Property REFPRIDesc As %String;

}
