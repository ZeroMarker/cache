/// Creator:基础数据平台组 孙凤超
/// CreateDate:2012-08-31
/// Desc:资源取消原因
Class web.Entity.CT.RBCReasonForCancel Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.RBCReasonForCancel";

Property RFCRowId As %String;

/// ID
Property RFCCode As %String;

/// 代码
Property RFCDesc As %String;

/// 描述
Property RFCInitiator As %String;

/// 取消人
Property RFCDateFrom As %String;

/// 开始日期
Property RFCDateTo As %String;

///    结束日期

}
