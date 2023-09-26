/// 药品业务表 溶媒量维护 
Class web.Entity.KB.DHCPHMenstruumQty Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHMenstruumQty";

Property PHMQRowId As %String;

Property PHMQInstDr As %String;

Property PHMQCat As %String;

Property PHMQCatDr As %String;

Property PHMQCatQtyMin As %String;

Property PHMQCatQtyMax As %String;

Property PHMQCatQtyUomDr As %String;

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

Property PHINSTMode As %String;

}
