Class DHCEPRFS.Entity.EWorkFlowPatInfo Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 电子病案状态标识	
Property MRStatus As %String;

/// 纸质病案状态标识
Property PageStatus As %String;

/// 归档就诊ID
Property MREpisodeID As %String;

/// 归档患者ID
Property MRPatientID As %String;

/// 病人ID
Property PatientID As %String;

/// 就诊ID
Property EpisodeID As %String;

/// 病案号
Property MedRecordNo As %String;

/// 登记号
Property RegNo As %String;

/// 姓名
Property Name As %String;

/// 入院日期
Property AdmDate As %String;

/// 出院日期
Property DisDate As %String;

/// 入院科室
Property AdmLoc As %String;

/// 出院科室
Property DisLoc As %String;

/// 入院病区
Property AdmWard As %String;

/// 出院病区
Property DisWard As %String;

}
