/// Description：住院Demo-入院记录
/// Table：User.DHCDSSDEMOAdmRec
Class web.CDSSEntity.Demo.AdmRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.AdmRec";

/// RowId
Property RowId As %String;

/************患者表信息********************/
/// 姓名
Property Name As %String;

/// 性别
Property Sex As %String;

/// 出生地
Property BirthPlace As %String;

/// 婚姻
Property Marriage As %String;

/// 联系地址
Property Address As %String;

/// 工作单位
Property WorkUnitName As %String;

/// 入院日期
Property AdmisTime As %String;

/// 陈述人
Property Representor As %String;

/// 记录日期
Property PatRecordTime As %String;

/************入院记录表信息********************/
/// 指向患者
Property PatDR As %String;

/// 主诉概述
Property ChiefCompSum As %String;

/// 现病史概述
Property CurrentMedHisSum As %String;

/// 既往史概述
Property PastDiagnosisSum As %String;

/// 过敏史概述
Property AllergyHisSum As %String;

/// 个人史概述
Property PersonalHisSum As %String;

/// 婚育史概述
Property MarryHisSum As %String;

/// 月经史概述
Property MenstrualHisSum As %String;

/// 家族史概述
Property FamilyHisSum As %String;

/// 体格检查概述
Property PhysicalExamSum As %String;

/// 专科检查概述
Property SpecExamSum As %String;

/// 辅助检查
Property AssisExam As %String;

/// 当前治疗疾病及用药情况
Property CurrentTreatMedication As %String;

/// 初步诊断
Property PreliminaryDiag As %String;

/// 确诊诊断
Property ConfirmDiag As %String;

/// 补充诊断
Property ComplementaryDiag As %String;

/// 修正诊断
Property DiagnosisCorrecting As %String;

/// 医师签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
