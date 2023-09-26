/// Description：住院Demo-日常病程
/// Table：User.DHCDSSDEMODailyCuzRec
Class web.CDSSEntity.Demo.DailyCuzRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.DailyCuzRec";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 病程记录
Property CourseRecord As %String;

/// 医生签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
