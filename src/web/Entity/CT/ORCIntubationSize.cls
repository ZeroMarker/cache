/// 名称:手术和过程-插管尺寸实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-4
Class web.Entity.CT.ORCIntubationSize Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCIntubationSize";

Property ORINTRowId As %String;

//代码

Property ORINTCode As %String;

//插管尺寸

Property ORINTDesc As %String;

}
