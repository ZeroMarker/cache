Class web.DHCAPPPisReqModel Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Response";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property RegNo As %String(MAXLEN = "");

Property Name As %String(MAXLEN = "");

Property SexCode As %String(MAXLEN = "");

Property Age As %String(MAXLEN = "");

Property PatDeptCode As %String(MAXLEN = "");

Property PatWardCode As %String(MAXLEN = "");

Property PatBedNO As %String(MAXLEN = "");

Property Telephone As %String(MAXLEN = "");

Property BirthDay As %String(MAXLEN = "");

Property Address As %String(MAXLEN = "");

Property OrdDeptCode As %String(MAXLEN = "");

Property FeeType As %String(MAXLEN = "");

Property DocumentID As %String(MAXLEN = "");

Property AppCode As %String(MAXLEN = "");

Property AppName As %String(MAXLEN = "");

Property OrdDoctorCode As %String(MAXLEN = "");

Property OrdDoctorName As %String(MAXLEN = "");

Property OrdDate As %String(MAXLEN = "");

Property OrdTime As %String(MAXLEN = "");

Property AdmRowID As %String(MAXLEN = "");

Property AppID As %String(MAXLEN = "");

Property OperationInfo As %String(MAXLEN = "");

Property TumorInfo As %String(MAXLEN = "");

Property GynecologyInfo As %String(MAXLEN = "");

Property ClinicInfo As %String(MAXLEN = "");

Property IsUrgent As %String(MAXLEN = "");

Property IsFrozen As %String(MAXLEN = "");

Property SpecOffDateTime As %String(MAXLEN = "");

Property SpecFixedDateTime As %String(MAXLEN = "");

Property SamplingDeptCode As %String(MAXLEN = "");

Property SamplingDoctorCode As %String(MAXLEN = "");

Property SamplingDateTime As %String(MAXLEN = "");

Property InfectionInfo As %String(MAXLEN = "");

Property DocumentInfo As %String(MAXLEN = "");

Property HumanPapillomavirusDateTime As %String(MAXLEN = "");

Property TestMethod As %String(MAXLEN = "");

Property ClinicalDiagnosis As %String(MAXLEN = "");

Property Treatment As %String(MAXLEN = "");

Property GeneralSpecExamination As %String(MAXLEN = "");

Property ConsultationRequirements As %String(MAXLEN = "");

Property ConsultationDoctor As %String(MAXLEN = "");

Property SamplingPosition As %String(MAXLEN = "");

Property SamplingType As %String(MAXLEN = "");

Property DOTFOTD As %String(MAXLEN = "");

Property MedicalHistory As %String(MAXLEN = "");

Property ClinicPhysicalExam As %String(MAXLEN = "");

Property AutopsyInfo As %String(MAXLEN = "");

Property SpecInfo As list Of web.DHCAPPPisSpecModel;

Property OrdInfo As list Of web.DHCAPPPisOrderModel;

Property OrdHospital As %String(MAXLEN = "");

Property TraDoctorCode As %String(MAXLEN = "");

Property ExamType As %String(MAXLEN = "");

Property ResultCode As %String(MAXLEN = "");

Property ResultDesc As %String(MAXLEN = "");

Property PisNoStatus As %String(MAXLEN = "");

Property TestContent As %String(MAXLEN = "");

/// 检查目的
Property Purpose As %String(MAXLEN = "");

/// 接收科室
Property AcceptDeptDR As %String(MAXLEN = "");

}
