/// 名称:结算菜单-出院条件
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-6-24
Class web.Entity.CT.PACDischCondit Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACDischCondit";

Property DISCONRowId As %String;

//代码

Property DISCONCode As %String;

//描述

Property DISCONDesc As %String;

//开始日期

Property DISCONDateFrom As %String;

//结束日期

Property DISCONDateTo As %String;

Property DISCONDeadFlag As %String;

Property DISCONEpisodeType As %String;

Property DISCONNationalCode As %String;

}
