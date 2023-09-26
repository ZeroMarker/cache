/// 名称:手术和过程-插管分级实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-4
Class web.Entity.CT.ORCIntubGrade Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCIntubGrade";

Property INGRARowId As %String;

//代码

Property INGRACode As %String;

//插管分级

Property INGRADesc As %String;

}
