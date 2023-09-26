/// Creator:zrf
/// CreatDate:2022-9-5
/// Description：出院方式
Class web.Entity.CT.DischargeMethod Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DischargeMethod";

Property ID As %String;

/// 代码
Property CTDMCode As %String;

/// 描述
Property CTDMDesc As %String;

/// 开始日期
Property CTDMDateFrom As %String;

/// 结束日期
Property CTDMDateTo As %String;

}
