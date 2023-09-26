/// Function:服务组维护数据交互类
/// Creator:基础数据平台组 孙凤超
/// CreateDate:2012-09-29
Class web.Entity.CT.RBCServiceGroup Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.RBCServiceGroup";

Property SGRowId As %String;

/// ID
Property SGCode As %String;

/// 代码
Property SGDesc As %String;

/// 描述
Property SGPreadmissionCheck As %String;

Property SGBypassDateCheck As %String;

Property SGAllowBookAfterDischarge As %String;

Property SGDateFrom As %String;

/// 开始日期
Property SGDateTo As %String;

///    结束日期

}
