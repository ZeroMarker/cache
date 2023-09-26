/// Function: 资源预约 不可用原因 RBC_ReasonNotAvail
/// Creator: 基础数据平台组 孙凤超
/// CreateDate:2012-08-29
Class web.Entity.CT.RBCReasonNotAvail Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.RBCReasonNotAvail";

Property RNAVRowId As %String;

/// ID
Property RNAVCode As %String;

/// 代码
Property RNAVDesc As %String;

/// 描述
Property RNAVType As %String;

Property RNAVDateFrom As %String;

/// 开始日期
Property RNAVDateTo As %String;

///    结束日期

}
