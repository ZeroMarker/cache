/// KPI指标条件维护表
Class web.Entity.KB.KPICondConfig Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.KPICondConfig";

Property KPIRowId As %String;

Property KPICode As %String;

Property KPIDR As %String;

Property KPIName As %String;

Property TableName As %String;

Property TableCode As %String;

Property TypeRowID As %String;

Property TypeName As %String;

Property Flag As %String;

Property GroupTypeName As %String;

Property ADMType As %String;

Property StartDate As %String;

Property EndDate As %String;

Property Condition As %String;

Property SavedFlag As %String;

}
