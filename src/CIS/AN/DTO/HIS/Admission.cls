Class CIS.AN.DTO.HIS.Admission Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Admission";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 患者ID
Property PatientID As %String;

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 病案号
Property MedcareNo As %String(TRUNCATE = 1);

/// 就诊类型：O门诊，E急诊，I住院
Property Type As %String(TRUNCATE = 1);

/// 就诊类型描述：O门诊，E急诊，I住院
Property TypeDesc As %String(TRUNCATE = 1);

/// 就诊科室ID
Property DepartmentID As %String(TRUNCATE = 1);

/// 就诊科室
Property Department As %String(TRUNCATE = 1);

/// 就诊病区ID
Property WardID As %String(TRUNCATE = 1);

/// 就诊病区
Property Ward As %String(TRUNCATE = 1);

/// 就诊床位ID
Property BedID As %String(TRUNCATE = 1);

/// 就诊床位
Property Bed As %String(TRUNCATE = 1);

/// 就诊日期
Property AdmDate As %String(TRUNCATE = 1);

/// 就诊时间
Property AdmTime As %String(TRUNCATE = 1);

/// 在院状态
Property VisitStatus As %String(TRUNCATE = 1);

/// 在院状态描述
Property VisitStatusDesc As %String(TRUNCATE = 1);

/// 出院日期
Property DischargeDate As %String(TRUNCATE = 1);

/// 出院时间
Property DischargeTime As %String(TRUNCATE = 1);

}
