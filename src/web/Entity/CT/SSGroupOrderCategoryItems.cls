Class web.Entity.CT.SSGroupOrderCategoryItems Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.SSGroupOrderCategoryItems";

Property ITMRowId As %String;

//ITMParRef=SSORDRowId

Property ITMParRef As %String;

Property ITMChildsub As %String;

// 医嘱项

Property ITMARCIMDR As %String;

//是否可授权

Property ITMUnverifOrder As %String;

Property ITMIncludeExclude As %String;

}
