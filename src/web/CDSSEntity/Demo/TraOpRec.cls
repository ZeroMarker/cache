/// Description：住院Demo-有创操作记录
/// Table：User.DHCDSSDEMOTraOpRec
Class web.CDSSEntity.Demo.TraOpRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.TraOpRec";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 操作时间	
Property OperationTime As %String;

/// 操作记录
Property OperationHistory As %String;

/// 医生签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
