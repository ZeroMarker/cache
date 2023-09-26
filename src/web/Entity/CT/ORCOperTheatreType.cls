/// 名称:手术和过程-手术室类型实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-6
Class web.Entity.CT.ORCOperTheatreType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCOperTheatreType";

Property OTTYPERowId As %String;

//代码

Property OTTYPECode As %String;

//手术室类型

Property OTTYPEDesc As %String;

//开始日期

Property OTTYPEDateFrom As %String;

//结束日期

Property OTTYPEDateTo As %String;

}
