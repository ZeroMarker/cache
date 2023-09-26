/// 临床决策支持-护理信息
Class web.CDSSEntity.PatientView.NursingInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.NursingInfo";

Property NursID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property VisitID As %String;

Property VisitType As %String;

Property NursingItemNum As %String;

Property NursingItemCode As %String;

Property NursingItemName As %String;

Property ChildItemNum As %String;

Property ChildItemCode As %String;

Property ChildItemName As %String;

Property NursingEffect As %String;

Property PassFlag As %String;

}
