/// 名称:手术和过程-ASA分级实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-4
Class web.Entity.CT.ORCASAClassPhActiv Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCASAClassPhActiv";

Property ORASARowId As %String;

//代码

Property ORASACode As %String;

//ASA分级

Property ORASADesc As %String;

}
