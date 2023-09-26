/// 名称:手术和过程-麻醉方法关联的麻醉剂实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-7
Class web.Entity.CT.ORCANAMethodAgentAlloc Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCANAMethodAgentAlloc";

Property METAGRowId As %String;

//麻醉方法

Property METAGMethodDR As %String;

//麻醉剂

Property METAGAgentDR As %String;

}
