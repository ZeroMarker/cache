/// 临床决策支持-体征信息
Class web.CDSSEntity.PatientView.SignInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.SignInfo";

Property SignID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property VisitID As %String;

Property VisitType As %String;

Property BodyTemperature As %String;

Property BloodPressure As %String;

Property Pulse As %String;

Property BreathFeature As %String;

Property HeartRate As %String;

Property OxygenSaturation As %String;

Property Pupil As %String;

Property CornealReflex As %String;

Property Height As %String;

Property Weight As %String;

Property MeasureDate As %String;

Property PassFlag As %String;

Property DiastolicBlood As %String;

Property SystolicBlood As %String;

}
