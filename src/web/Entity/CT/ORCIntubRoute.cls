/// 名称:手术和过程-插管通道实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-5
Class web.Entity.CT.ORCIntubRoute Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCIntubRoute";

Property INROURowId As %String;

//代码

Property INROUCode As %String;

//插管通道

Property INROUDesc As %String;

}
