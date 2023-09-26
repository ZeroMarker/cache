/// 名称:手术和过程-手术延缓原因实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-12
Class web.Entity.CT.ORCReasonForSuspend Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCReasonForSuspend";

Property SUSPRowId As %String;

//代码

Property SUSPCode As %String;

//手术延缓原因

Property SUSPDesc As %String;

//Default For Automatic

Property SUSPDefaultForAutomatic As %String;

}
