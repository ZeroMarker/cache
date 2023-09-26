/// Creator:基础数据平台组  孙凤超
/// CreateDate:2012-8-12
/// Function:规定资源维护
Class web.Entity.CT.RBCEquipment Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.RBCEquipment";

Property EQRowId As %String;

/// ID
Property EQCode As %String;

/// 代码
Property EQDesc As %String;

/// 描述
Property EQGroupDR As %String;

/// 资源组指向
Property EQDateFrom As %String;

/// 开始日期
Property EQDateTo As %String;

///   结束日期

}
