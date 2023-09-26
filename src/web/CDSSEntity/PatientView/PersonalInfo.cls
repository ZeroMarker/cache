/// 临床决策支持-个人史信息
Class web.CDSSEntity.PatientView.PersonalInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.PersonalInfo";

Property PersonalID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property PersonalHistoryOverview As %String;

Property StartTime As %String;

Property EndTime As %String;

Property Duration As %String;

Property Criticality As %String;

Property Remarks As %String;

Property PassFlag As %String;

}
