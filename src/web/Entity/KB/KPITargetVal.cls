/// KPI目标值维护
Class web.Entity.KB.KPITargetVal Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.KPITargetVal";

Property KPIRowId As %String;

Property KPIDR As %String;

Property ElementName As %String;

Property TargetVal As %String;

Property Period As %String;

Property TargetDate As %String;

}
