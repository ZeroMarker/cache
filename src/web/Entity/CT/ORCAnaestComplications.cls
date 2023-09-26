/// 名称:手术和过程-麻醉剂并发症实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-7
Class web.Entity.CT.ORCAnaestComplications Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCAnaestComplications";

Property ANACOMRowId As %String;

//代码

Property ANACOMCode As %String;

//麻醉剂并发症

Property ANACOMDesc As %String;

//医嘱套

Property ANACOMARCOSDR As %String;

}
