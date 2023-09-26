/// 名称:个人通讯录HIS科室授权HIS科室
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期: 2021-03-16
Class web.Entity.CT.HCCSLocLinkLoc Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HCCSLocLinkLoc";

// LLLRowId

Property LLLRowId As %String;

// 个人通讯录HIS科室代码

Property LLLHISCode As %String;

// 个人通讯录HIS科室名称

Property LLLHISDesc As %String;

// 个人通讯录HIS科室RowID

Property HCCSCLRowId As %String;

// 个人通讯录his科室代码

Property LLLAutHISCode As %String;

// 个人通讯录his科室名称

Property LLLAutHISDesc As %String;

}
