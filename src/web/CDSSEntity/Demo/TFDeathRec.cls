/// Description：住院Demo-24小时内入院死亡记录
/// Table：User.DHCDSSDEMOTFDeathRec
Class web.CDSSEntity.Demo.TFDeathRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.TFDeathRec";

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

/// 死亡时间
Property DeathTime As %String;

/************24小时内入院死亡记录表信息********************/
/// 指向患者
Property PatDR As %String;

/// 主诉
Property ChiefCompSum As %String;

/// 入院情况
Property AdmisComplexion As %String;

/// 入院诊断
Property AdmisDisease As %String;

/// 治疗经过
Property TreatProcess As %String;

/// 死亡诊断
Property DeathDiag As %String;

/// 死亡原因
Property DeathCause As %String;

/// 医师签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
