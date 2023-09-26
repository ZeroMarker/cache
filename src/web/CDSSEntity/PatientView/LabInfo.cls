/// 临床决策支持-检验信息
Class web.CDSSEntity.PatientView.LabInfo Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.CDSSEntity.PatientView.LabInfo";

Property LabID As %String;

Property IDNO As %String;

Property PatientDR As %String;

Property VisitID As %String;

Property VisitType As %String;

Property GroupFlag As %String;

Property GroupSequence As %String;

Property InspectionCode As %String;

Property InspectionName As %String;

Property LabItemCode As %String;

Property LabItemName As %String;

Property LabResult As %String;

Property Unit As %String;

Property Reference As %String;

Property Specimen As %String;

Property ExecuteTime As %String;

Property ReportTime As %String;

Property Remarks As %String;

Property PassFlag As %String;

Property LabResultFlag As %String;

}
