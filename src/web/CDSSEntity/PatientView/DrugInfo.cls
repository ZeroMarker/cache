/// 临床决策支持-患者诊断信息
Class web.CDSSEntity.PatientView.DrugInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.DrugInfo";

Property DrugID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property VisitID As %String;

Property VisitType As %String;

Property Type As %String;

Property GroupFlag As %String;

Property GroupSequence As %String;

Property DrugCode As %String;

Property DrugName As %String;

Property Usage As %String;

Property Dose As %String;

Property Frequency As %String;

Property Unit As %String;

Property Specification As %String;

Property StartTime As %String;

Property ExecuteTime As %String;

Property StopTime As %String;

Property Remarks As %String;

Property PassFlag As %String;

}
