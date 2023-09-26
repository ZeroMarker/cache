/// 名称:手术和过程-麻醉剂实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-7
Class web.Entity.CT.ORCAnaestAgent Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCAnaestAgent";

Property ANAGNRowId As %String;

//代码

Property ANAGNCode As %String;

//描述

Property ANAGNDesc As %String;

//收费项目

Property ANAGNARCIMDR As %String;

//麻醉方法

Property ANAGNMethodDR As %String;

}
