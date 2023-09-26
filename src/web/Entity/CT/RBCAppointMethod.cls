/// 资源预约 预约方法
/// Creator:基础数据平台 孙凤超
/// CreateDate:2012-08-31
Class web.Entity.CT.RBCAppointMethod Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.RBCAppointMethod";

Property APTMRowId As %String;

/// ID
Property APTMCode As %String;

/// 代码
Property APTMDesc As %String;

/// 描述
Property APTMCollectMoney As %String;

/// 开始日期
Property APTMDateFrom As %String;

///  结束日期 
Property APTMDateTo As %String;

///  是否启用占号模式  
Property APTMAppropriateRegist As %String;

///  是否当日挂号受保留号限制
Property APTMRegistRestrict As %String;

}
