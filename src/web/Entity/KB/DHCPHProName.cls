/// 知识库-药品商品名字典表　
/// 2016-09-30
/// 谷雪萍
Class web.Entity.KB.DHCPHProName Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHProName";

Property PHNRowId As %String;

Property PHNCode As %String;

Property PHNDesc As %String;

Property PHNActiveFlag As %String;

Property PHNSysFlag As %String;

// 剂型2017-02-24

Property PHNFormDr As %String;

// 厂家2017-02-24

Property PHNFactory As %String;

// 通用名指针2017-03-20

Property PHNGenericDr As %String;

// 草药毒性字典指针 2017-07-19

Property PHNToxicity As %String;

// 是否整支标识 2017-11-29

Property PHNWholeFlag As %String;

// 厂家字典表 2017-11-29

Property PHNManfDR As %String;

}
