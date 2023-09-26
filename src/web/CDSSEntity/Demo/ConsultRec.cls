/// Description：住院Demo-会诊记录
/// Table：User.DHCDSSDEMOConsultRec
Class web.CDSSEntity.Demo.ConsultRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.ConsultRec";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 申请日期
Property ApplicationDate As %String;

/// 会诊时间
Property ConsultTime As %String;

/// 诊断名称
Property DiagName As %String;

/// 患者病情
Property PatientCondition As %String;

/// 诊疗情况
Property TreatSituation As %String;

/// 会诊原因及目的
Property ConsultCause As %String;

/// 邀请科室
Property InviteLoc As %String;

/// 邀请医生
Property InviteUser As %String;

/// 申请科室
Property ApplicationLoc As %String;

/// 申请医生
Property ApplicationUser As %String;

/// 会诊意见
Property ConsultAdvice As %String;

/// 医师签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
