/// 临床决策支持-患者诊断信息
Class web.CDSSEntity.PatientView.DiagnosisInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.DiagnosisInfo";

Property DiagnosisID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property VisitID As %String;

Property VisitType As %String;

Property DiagnosisType As %String;

Property DiagnosisSequence As %String;

Property DiagnosisCode As %String;

Property DiagnosisName As %String;

Property DiagnosisDesc As %String;

Property DiagnosisTime As %String;

Property DiagnosisStatus As %String;

Property ChildDiagnosisFlag As %String;

Property PassFlag As %String;

}
