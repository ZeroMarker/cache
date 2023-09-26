/// Creator:基础数据平台组 孙凤超
/// CreateDate:2012-8-13
/// Function:分娩类型维护
Class web.Entity.CT.PACPlacDelivType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACPlacDelivType";

Property PLDTRowId As %String;

/// ID
Property PLDTCode As %String;

/// 代码
Property PLDTDesc As %String;

/// 描述
Property PLDTDateFrom As %String;

/// 开始日期
Property PLDTDateTo As %String;

}
