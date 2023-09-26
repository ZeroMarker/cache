/// 名称:手术和过程-手术位置实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-6
Class web.Entity.CT.ORCOperPosition Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ORCOperPosition";

Property OPPOSRowId As %String;

//代码

Property OPPOSCode As %String;

//手术位置

Property OPPOSDesc As %String;

}
