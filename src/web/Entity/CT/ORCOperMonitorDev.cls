/// 名称:手术和过程-手术监控设备实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-6
Class web.Entity.CT.ORCOperMonitorDev Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCOperMonitorDev";

Property OPMONRowId As %String;

//代码

Property OPMONCode As %String;

//手术监控设备

Property OPMONDesc As %String;

}
