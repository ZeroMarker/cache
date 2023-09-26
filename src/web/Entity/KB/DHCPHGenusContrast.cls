/// 名称：菌属对照表
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-10 
Class web.Entity.KB.DHCPHGenusContrast Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHGenusContrast";

Property PHGRowId As %String;

Property PHGGenusCode As %String;

Property PHGGenusDesc As %String;

Property PHGHisGenusCode As %String;

Property PHGHisGenusDesc As %String;

Property PHGHospDr As %String;

Property PHGSysFlag As %String;

}
