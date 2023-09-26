/// 临床决策支持-检查信息
Class web.CDSSEntity.PatientView.ExamInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.ExamInfo";

Property ExamID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property VisitID As %String;

Property VisitType As %String;

Property GroupFlag As %String;

Property GroupSequence As %String;

Property ExamCode As %String;

Property ExamName As %String;

Property ExamResult As %String;

Property PartDR As %String;

Property ExecuteTime As %String;

Property ReportTime As %String;

Property Remarks As %String;

Property PassFlag As %String;

Property ExamResultNum As %String;

Property ExamResultFlag As %String;

Property ExamResultDesc As %String;

}
