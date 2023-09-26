/// Creator:基础数据平台组 孙凤超
/// CreateDate:2012-08-31
/// Desc:挂号职称 
Class web.Entity.CT.RBCSessionType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.RBCSessionType";

Property SESSRowId As %String;

/// 代码
Property SESSCode As %String;

/// 描述
Property SESSDesc As %String;

/// 挂号职称指向
Property SESSSessionTypeDR As %String;

/// 天数
Property SESSNumberOfDays As %String;

/// 挂号职称默认
Property SESSEnableByDefault As %String;

/// 开始日期
Property SESSDateFrom As %String;

/// 结束日期
Property SESSDateTo As %String;

Property SESSCategory As %String;

}
