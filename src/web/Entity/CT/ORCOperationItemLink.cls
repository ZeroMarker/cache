/// 名称:手术和过程-手术关联医嘱项实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-20
Class web.Entity.CT.ORCOperationItemLink Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCOperationItemLink";

//Parent RowId

Property LINKParRef As %String;

Property LINKChildsub As %String;

Property LINKRowId As %String;

//关联医嘱项

Property LINKARCIMDR As %String;

}
