/// 临床决策支持-患者诊断信息
Class web.CDSSEntity.PatientView.OtherDisOrderInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.OtherDisOrderInfo";

Property OtherDisOrderID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property VisitID As %String;

Property GroupFlag As %String;

Property GroupSequence As %String;

Property OrderDesc As %String;

Property ExecuteMethod As %String;

Property PlanStartTime As %String;

Property PlanStopTime As %String;

Property ExecuteDesc As %String;

Property PassFlag As %String;

}
