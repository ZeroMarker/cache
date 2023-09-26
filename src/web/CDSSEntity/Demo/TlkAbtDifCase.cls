/// Description：住院Demo-疑难病例讨论记录
/// Table：User.DHCDSSDEMOTlkAbtDifCase
Class web.CDSSEntity.Demo.TlkAbtDifCase Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.TlkAbtDifCase";

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

/// 讨论意见
Property DiscussionOpinions As %String;

/// 主持人小结
Property HostSummary As %String;

/// 医生签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
