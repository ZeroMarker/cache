/// 描述: 病症常用名/别名字典表
/// 编写者：谷雪萍
/// 编写日期: 2016-05-23
Class web.Entity.KB.DHCPHDiseaseComList Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHDiseaseComList";

Property PHDCLRowId As %String;

Property PHDCLDisDr As %String;

Property PHDCLCode As %String;

Property PHDCLDesc As %String;

Property PHDCLType As %String;

Property PHDCLActiveFlag As %String;

Property PHDCLSysFlag As %String;

Property PHDCLKey As %String;

}
