/// 名称:个人通讯录
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期: 2021-02-02
Class web.Entity.CT.HCCSLocationLinkLoc Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HCCSLocationLinkLoc";

// LLLRowId

Property LLLRowId As %String;

// 父表指针

Property LLLParRef As %String;

// Childsub

Property LLLChildsub As %String;

// his科室代码

Property LLLHISCode As %String;

// his科室名称

Property LLLHISDesc As %String;

// his科室RowID

Property CTLOCRowID As %String;

}
