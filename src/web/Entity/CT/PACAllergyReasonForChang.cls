/// Creator:基础数据平台组  孙凤超
/// CreateDate:2013-9-16
/// Function: 过敏改变原因 实体类
Class web.Entity.CT.PACAllergyReasonForChang Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACAllergyReasonForChang";

Property ALRFCRowId As %String;

/// 代码
Property ALRFCCode As %String;

/// 描述
Property ALRFCDesc As %String;

/// 开始日期
Property ALRFCDateFrom As %String;

/// 结束日期
Property ALRFCDateTo As %String;

}
