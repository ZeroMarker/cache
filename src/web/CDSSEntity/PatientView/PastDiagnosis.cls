/// 临床决策支持-既往史信息
Class web.CDSSEntity.PatientView.PastDiagnosis Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.PastDiagnosis";

Property PastID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property VisitID As %String;

Property VisitType As %String;

Property PastHistoryNum As %String;

Property PastDiagnosisName As %String;

Property DiagnosisType As %String;

Property StartTime As %String;

Property EndTime As %String;

Property Duration As %String;

Property Criticality As %String;

Property TreatmentEffect As %String;

Property Remarks As %String;

Property PassFlag As %String;

}
