/// Description：住院Demo-死亡记录
/// Table：User.DHCDSSDEMODeathRec
Class web.CDSSEntity.Demo.DeathRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.DeathRec";

/// RowId
Property RowId As %String;

/************患者表信息********************/
/// 姓名
Property Name As %String;

/// 性别
Property Sex As %String;

/// 年龄
Property Age As %String;

/// 年龄单位
Property AgeUnit As %String;

/// 入院日期
Property AdmisTime As %String;

/// 住院天数
Property HospDays As %String;

/// 死亡时间
Property DeathTime As %String;

/************死亡记录表信息********************/
/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 入院情况
Property AdmisComplexion As %String;

/// 入院诊断
Property AdmisDisease As %String;

/// 治疗经过
Property TreatProcess As %String;

/// 死亡原因
Property DeathCause As %String;

/// 死亡诊断
Property DeathDiag As %String;

/// 抢救经过
Property RescueProcess As %String;

/// 出院情况
Property DischargeSituation As %String;

/// 出院医嘱
Property DischargeOrder As %String;

/// 出院指导
Property DischargeGuide As %String;

/// 是否出院31天再住院计划
Property RehospitalPlan As %String;

/// 医师签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
