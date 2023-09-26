/// 临床决策支持-现病史信息
Class web.CDSSEntity.PatientView.CurrentMedHistory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.CurrentMedHistory";

Property CurrentID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property VisitID As %String;

Property VisitType As %String;

Property SymptomNum As %String;

Property Cause As %String;

Property Status As %String;

Property PartDR As %String;

Property Symptom As %String;

Property Duration As %String;

Property AbnormalMax As %String;

Property AbnormalMin As %String;

Property NormalMax As %String;

Property NormalMin As %String;

Property RangeUnit As %String;

Property RangeType As %String;

Property PassFlag As %String;

}
