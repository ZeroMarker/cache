/// Description：住院Demo-死亡讨论记录
/// Table：User.DHCDSSDEMODthDiscuzRec
Class web.CDSSEntity.Demo.DthDiscuzRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.DthDiscuzRec";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 讨论日期
Property DiscussTime As %String;

/// 主持人
Property Host As %String;

/// 参加人员
Property Participant As %String;

/// 死亡时间
Property DeathTime As %String;

/// 死亡原因
Property DeathCause As %String;

/// 死亡诊断
Property DeathDiag As %String;

/// 病历摘要
Property RecordSummary As %String;

/// 治疗及抢救经过
Property FirstAidAndTreat As %String;

/// 讨论结果
Property DiscussResult As %String;

/// 主持人小结
Property HostSummary As %String;

/// 医师签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
