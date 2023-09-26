/// Description：住院Demo-出院记录
/// Table：User.DHCDSSDEMODischargeRec
Class web.CDSSEntity.Demo.DischargeRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.DischargeRec";

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

/// 出院日期
Property DischargeTime As %String;

/************出院记录表信息********************/
/// 指向患者
Property PatDR As %String;

/// 入院情况
Property AdmisComplexion As %String;

/// 入院诊断
Property AdmisDisease As %String;

/// 诊疗经过
Property TreateProcess As %String;

/// 手术名称
Property OperaName As %String;

/// 伤口愈合
Property WoundHealing As %String;

/// 出院诊断
Property DischargeDiag As %String;

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
