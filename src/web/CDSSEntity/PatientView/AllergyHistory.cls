/// 临床决策支持-过敏史信息
Class web.CDSSEntity.PatientView.AllergyHistory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.AllergyHistory";

Property AllergyID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property AllergySourceName As %String;

Property AllergySourceType As %String;

Property AllergyHistoryNum As %String;

Property StartTime As %String;

Property EndTime As %String;

Property RiskLevel As %String;

Property TreatmentEffect As %String;

Property Remarks As %String;

Property PassFlag As %String;

}
