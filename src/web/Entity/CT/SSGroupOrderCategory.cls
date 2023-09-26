Class web.Entity.CT.SSGroupOrderCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.SSGroupOrderCategory";

Property SSORDRowId As %String;

//SSORDParRef=SSGRPRowId

Property SSORDParRef As %String;

Property SSORDChildsub As %String;

// 医嘱大类

Property SSORDOrdCatDR As %String;

// 医嘱子分类

Property SSORDOrdSubCategory As %String;

//出院未结算

Property SSORDOrderOnDischarge As %String;

//不可见医嘱项

Property SSORDOrderInvisbleItem As %String;

//医嘱套

Property SSORDOrderSets As %String;

//出院结算医嘱

Property SSORDOrderOnFinanceDisch As %String;

//仅限预约

Property SSORDBookingOnly As %String;

//修改医嘱项

Property SSORDRequireAuthorisation As %String;

}
