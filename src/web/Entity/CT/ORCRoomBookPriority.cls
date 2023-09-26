/// 名称:手术和过程-房间预约优先级体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-5
Class web.Entity.CT.ORCRoomBookPriority Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCRoomBookPriority";

Property RBPRowId As %String;

//代码

Property RBPCode As %String;

//房间预约优先级

Property RBPDesc As %String;

//手术优先级

Property RBPOrder As %String;

}
