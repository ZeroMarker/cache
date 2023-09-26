/// 名称:医呼通科室
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期: 2021-02-02
Class web.Entity.CT.HCCSLocation Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HCCSLocation";

// LOCRowId

Property LOCRowId As %String;

// 医呼通科室代码

Property LOCCode As %String;

// 医呼通科室名称

Property LOCDesc As %String;

// 开始日期

Property LOCDateFrom As %String;

// 结束日期

Property LOCDateTo As %String;

}
