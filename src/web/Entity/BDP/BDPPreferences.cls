/// 名称:系统配置 - 6 授权浏览实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2014-1-25
Class web.Entity.BDP.BDPPreferences Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.BDP.BDPPreferences";

Property ID As %String;

Property AppKey As %String;

Property AppSubKey As %String;

Property ObjectType As %String;

Property ObjectReference As %String;

Property DataSplitString As %String;

Property CorrespondingClass As %String;

Property DataMapMode As %String;

Property Data As %String;

}
