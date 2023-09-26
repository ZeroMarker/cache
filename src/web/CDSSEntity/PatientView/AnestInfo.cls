/// 临床决策支持-患者麻醉信息
Class web.CDSSEntity.PatientView.AnestInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.AnestInfo";

Property AnestID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property VisitID As %String;

Property VisitType As %String;

Property AnestMedication As %String;

Property Usage As %String;

Property Dose As %String;

Property Anesthesia As %String;

Property AnestSite As %String;

Property AnestDuration As %String;

Property AnestStartTime As %String;

Property PassFlag As %String;

}
