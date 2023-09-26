/// 名称:手术和过程-手术室不可用原因实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-6
Class web.Entity.CT.ORCReasonOTNotAvail Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCReasonOTNotAvail";

Property RNAVRowId As %String;

//代码

Property RNAVCode As %String;

//手术室不可用原因

Property RNAVDesc As %String;

}
