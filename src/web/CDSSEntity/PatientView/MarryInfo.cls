/// 临床决策支持-婚育史信息
Class web.CDSSEntity.PatientView.MarryInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.MarryInfo";

Property MarryID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property TypeOfMarriage As %String;

Property MarriageOverview As %String;

Property StartTime As %String;

Property EndTime As %String;

Property Duration As %String;

Property Criticality As %String;

Property Remarks As %String;

Property PassFlag As %String;

}
