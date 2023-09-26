/// 临床决策支持-患者其他医嘱信息
Class web.CDSSEntity.PatientView.OtherOrderInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.OtherOrderInfo";

Property OrderID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property VisitID As %String;

Property VisitType As %String;

Property GroupFlag As %String;

Property GroupSequence As %String;

Property OrderDesc As %String;

Property ExecuteTime As %String;

Property ExecuteResult As %String;

Property PassFlag As %String;

}
