/// 名称: 急诊优先级
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-30
Class web.Entity.CT.CTAcuity Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTAcuity";

/// RowId号
Property CTACURowId As %String;

/// 代码
Property CTACUCode As %String;

/// 描述
Property CTACUDesc As %String;

/// 等待时间
Property CTACUWaitTime As %String;

/// 开始日期
Property CTACUDateFrom As %String;

/// 结束日期
Property CTACUDateTo As %String;

/// 颜色 add by sunfengchao 2017-03-17
Property CTACUColour As %String;

}
