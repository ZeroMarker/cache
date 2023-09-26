/// Description：住院Demo-上级医师查房记录
/// Table：User.DHCDSSDEMOSupCheckRec
Class web.CDSSEntity.Demo.SupCheckRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.SupCheckRec";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 查房记录
Property CheckRecord As %String;

/// 医生签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
