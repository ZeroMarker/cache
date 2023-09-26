/// 名称: 辅助用药数量
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-11-24
Class web.Entity.KB.DHCPHAssDrugNum Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHAssDrugNum";

Property PHADRowId As %String;

//主索引表指针

Property PHADInstDr As %String;

//辅助药数量

Property PHADNum As %String;

//级别-2017-08-28

Property PHINSTMode As %String;

//主索引表必填项

Property PHINSTTypeDr As %String;

Property PHINSTOrderNum As %String;

Property PHINSTGenDr As %String;

Property PHINSTPointerDr As %String;

Property PHINSTLibDr As %String;

Property PHINSTPointerType As %String;

Property PHINSTActiveFlag As %String;

Property PHINSTSysFlag As %String;

//描述，存进主索引表

Property PHINSTText As %String;

}
