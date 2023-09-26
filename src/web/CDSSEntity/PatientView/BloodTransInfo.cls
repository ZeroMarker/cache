/// 临床决策支持-患者输血信息
Class web.CDSSEntity.PatientView.BloodTransInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.BloodTransInfo";

Property BloodID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property VisitID As %String;

Property VisitType As %String;

Property BloodTransStartTime As %String;

Property BloodTransEndTime As %String;

Property BloodTransDuration As %String;

Property BloodTransVolume As %String;

Property BloodTransSite As %String;

Property BloodTransType As %String;

Property BloodTransDurationU As %String;

Property BloodTransVolumeU As %String;

Property BloodTransClass As %String;

Property PassFlag As %String;

}
