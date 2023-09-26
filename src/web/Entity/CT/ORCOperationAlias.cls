/// 名称:手术和过程-手术别名实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-20
Class web.Entity.CT.ORCOperationAlias Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCOperationAlias";

//Parent RowId

Property ALIASParRef As %String;

Property ALIASChildsub As %String;

Property ALIASRowId As %String;

//手术别名

Property ALIASText As %String;

}
