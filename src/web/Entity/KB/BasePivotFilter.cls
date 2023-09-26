/// 明细主题指标表
Class web.Entity.KB.BasePivotFilter Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.BasePivotFilter";

Property KPIRowId As %String;

Property KPICode As %String;

Property KPIName As %String;

Property SubjectName As %String;

Property PivotFilter As %String;

}
