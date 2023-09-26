/// 名称:手术和过程-麻醉方法类型实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-5
Class web.Entity.CT.ORCAnaestType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCAnaestType";

Property ANTYPERowId As %String;

//代码

Property ANTYPECode As %String;

//麻醉方法类型

Property ANTYPEDesc As %String;

//开始日期

Property ANTYPEDateFrom As %String;

//结束日期

Property ANTYPEDateTo As %String;

}
