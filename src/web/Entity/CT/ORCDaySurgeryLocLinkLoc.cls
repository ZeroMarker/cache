/// 日间手术科室关联科室表
/// 基础数据平台-李可凡
/// 2021-05-08
Class web.Entity.CT.ORCDaySurgeryLocLinkLoc Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.CT.ORCDaySurgeryLocLinkLoc";

/// 日间手术科室关联科室RowId
Property DSLLLRowId As %String;

/// 日间手术科室DR
Property DSLLLParRef As %String;

/// 日间手术科室关联科室DR
Property DSLLLLinkLocDR As %String;

}
