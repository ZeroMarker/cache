/// 名称：病人管理--病人位置分组
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2016-8-4
Class web.Entity.CT.PACBroadPatientGroup Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACBroadPatientGroup";

Property BPGRowId As %String;

//代码

Property BPGCode As %String;

//描述

Property BPGDesc As %String;

//开始日期

Property BPGDateFrom As %String;

//结束日期

Property BPGDateTo As %String;

}
