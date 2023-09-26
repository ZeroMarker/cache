/// 名称:结算菜单-来院途径
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-6-25
Class web.Entity.CT.PACTransferMeans Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACTransferMeans";

Property TRANSMRowId As %String;

//代码

Property TRANSMCode As %String;

//描述

Property TRANSMDesc As %String;

//开始日期

Property TRANSMDateFrom As %String;

//结束日期

Property TRANSMDateTo As %String;

}
