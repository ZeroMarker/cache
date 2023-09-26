/// 临床决策支持-患者手术信息
Class web.CDSSEntity.PatientView.OperationInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.OperationInfo";

Property OperID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property VisitID As %String;

Property VisitType As %String;

Property OperNum As %String;

Property OperSequence As %String;

Property MainOperFlag As %String;

Property OperCode As %String;

Property OperName As %String;

Property OperDesc As %String;

Property OperType As %String;

Property OperPosition As %String;

Property IntraoperDiagnosis As %String;

Property OperDuration As %String;

Property OperStartTime As %String;

Property OperEndTime As %String;

Property PassFlag As %String;

}
