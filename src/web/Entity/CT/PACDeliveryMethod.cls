/// Creator:基础数据平台组  孙凤超
/// CreateDate:2012-8-13
/// Function:分娩方法 实体类
Class web.Entity.CT.PACDeliveryMethod Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACDeliveryMethod";

Property DLMTHRowId As %String;

/// ID
Property DLMTHCode As %String;

/// 代码
Property DLMTHDesc As %String;

/// 描述
Property DLMTHDateFrom As %String;

/// 开始日期
Property DLMTHDateTo As %String;

///     结束日期

}
