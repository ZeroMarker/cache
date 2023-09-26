/// Description：住院Demo-首次病程记录
/// Table：User.DHCDSSDEMOFstCuzRec
Class web.CDSSEntity.Demo.FstCuzRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.FstCuzRec";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 主诉
Property ChiefCompSum As %String;

/// 病历特点
Property CaseCharacter As %String;

/// 初步诊断
Property PreliminaryDiag As %String;

/// 诊断依据
Property DiagnosticBasis As %String;

/// 鉴别诊断
Property DifferentDiagnosis As %String;

/// 诊疗计划
Property TreatmentPlan As %String;

/// 医生签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
