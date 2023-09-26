/// 名称:药学-药理学小子分类实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期: 2012-8-30
Class web.Entity.CT.PHCMinorSubCat Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PHCMinorSubCat";

Property MINParRef As %String;

//RowId

Property MINRowId As %String;

//Code

Property MINCode As %String;

//Desc

Property MINDesc As %String;

//ChildSub

Property MINChildsub As %String;

}
