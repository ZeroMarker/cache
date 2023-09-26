/// 名称:药学-药理学子分类实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期: 2012-8-30
Class web.Entity.CT.PHCSubCat Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PHCSubCat";

Property PHCSCPHCCParRef As %String;

//RowId

Property PHCSCRowId As %String;

//Code

Property PHCSCCode As %String;

//Desc

Property PHCSCDesc As %String;

//ChildSub

Property PHCSCChildSub As %String;

}
