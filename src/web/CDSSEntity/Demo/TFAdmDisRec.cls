/// Description：住院Demo-24小时入出院记录
/// Table：User.DHCDSSDEMOTFAdmDisRec
Class web.CDSSEntity.Demo.TFAdmDisRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.TFAdmDisRec";

/// RowId
Property RowId As %String;

/************患者表信息********************/
/// 姓名
Property Name As %String;

/// 职业
Property Profession As %String;

/// 性别
Property Sex As %String;

/// 入院时间
Property AdmisTime As %String;

/// 年龄
Property Age As %String;

/// 年龄单位
Property AgeUnit As %String;

/// 出院时间
Property DischargeTime As %String;

/************24小时入出院记录信息********************/
/// 指向患者
Property PatDR As %String;

/// 主诉
Property ChiefCompSum As %String;

/// 入院情况
Property AdmissSituation As %String;

/// 入院诊断
Property AdmissDiag As %String;

/// 诊疗经过
Property TreateProcess As %String;

/// 出院情况
Property DischargeSituation As %String;

/// 出院诊断
Property DischargeDiag As %String;

/// 出院医嘱
Property DischargeOrder As %String;

/// 医师签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
