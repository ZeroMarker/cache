/// KPI指标条件定义表
Class web.Entity.KB.BaseKPIDefine Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.BaseKPIDefine";

Property KPIRowId As %String;

Property KPICode As %String;

Property KPIName As %String;

Property KPIType As %String;

Property DivCode As %String;

Property DivendCode As %String;

Property KPIAlias As %String;

Property TableName As %String;

Property DecDigits As %String;

Property ConvFactor As %String;

Property ShowFormat As %String;

}
