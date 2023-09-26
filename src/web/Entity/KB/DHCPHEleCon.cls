/// 药品业务表 成分浓度维护 
Class web.Entity.KB.DHCPHEleCon Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHEleCon";

Property PHECRowId As %String;

Property PHECInstDr As %String;

Property PHECPHExtIngr As %String;

Property PHECIngrQty As %String;

Property PHECUomDr As %String;

Property PHECRelation As %String;

Property PHECTotalQty As %String;

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
