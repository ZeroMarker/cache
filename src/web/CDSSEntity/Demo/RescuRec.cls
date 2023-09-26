/// Description：住院Demo-抢救记录
/// Table：User.DHCDSSDEMORescuRec
Class web.CDSSEntity.Demo.RescuRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.RescuRec";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 入院情况
Property AdmisComplexion As %String;

/// 抢救时间
Property RescueTime As %String;

/// 参加人员
Property Participant As %String;

/// 抢救经过
Property RescueProcess As %String;

/// 医生签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
