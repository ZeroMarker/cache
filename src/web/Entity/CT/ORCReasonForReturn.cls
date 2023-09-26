/// 名称:手术和过程-返回原因实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-4
Class web.Entity.CT.ORCReasonForReturn Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCReasonForReturn";

Property RFRRowId As %String;

//代码

Property RFRCode As %String;

//返回原因

Property RFRDesc As %String;

//开始日期

Property RFRDateFrom As %String;

//结束日期

Property RFRDateTo As %String;

}
