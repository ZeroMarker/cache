/// 名称:手术和过程-麻醉方法实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-7
Class web.Entity.CT.ORCAnaestMethod Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCAnaestMethod";

Property ANMETRowId As %String;

//代码

Property ANMETCode As %String;

//描述

Property ANMETDesc As %String;

//麻醉类型

Property ANMETTypeDR As %String;

//医嘱套

Property ANMETARCOSDR As %String;

//开始日期

Property ANMETDateFrom As %String;

//结束日期

Property ANMETDateTo As %String;

}
