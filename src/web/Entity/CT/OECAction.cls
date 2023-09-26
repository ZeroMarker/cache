/// Creator:   sunfengchao
/// CreateDate:2017-2-28
/// Function:  皮试备注
Class web.Entity.CT.OECAction Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.OECAction";

Property ACTRowId As %String;

/// ID号
Property ACTCode As %String;

/// 代码
Property ACTDesc As %String;

/// 描述
Property ACTDateFrom As %String;

/// 开始日期
Property ACTDateTo As %String;

///  结束日期

}
