/// 风险评估
Class CIS.AN.DTO.OperRiskAssessment Extends %RegisteredObject
{

/// 手术医生
Property Surgeon As %String;

/// 麻醉医生
Property AnaDoc As %String;

/// 巡回护士
Property OperNurse As %String;

/// 手术医生签字时间
Property SurgeonSignDT As %String;

/// 麻醉医生签字时间
Property AnaDocSignDT As %String;

/// 巡回护士签字时间
Property OperNurseSignDT As %String;

/// 评估分数
Property AssessmentScore As %String;

/// NNIS评分
Property NNIS As %String;

}
