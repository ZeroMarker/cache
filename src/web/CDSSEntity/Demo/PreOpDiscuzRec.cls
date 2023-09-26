/// Description：住院Demo-术前讨论记录
/// Table：User.DHCDSSDEMOPreOpDiscuzRec
Class web.CDSSEntity.Demo.PreOpDiscuzRec Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.PreOpDiscuzRec";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 讨论日期
Property DiscussTime As %String;

/// 讨论地点
Property DiscussAddress As %String;

/// 主持人
Property Host As %String;

/// 参加人员
Property Participant As %String;

/// 术前准备
Property PrepareOper As %String;

/// 手术指征及方式
Property OperaIndiMethod As %String;

/// 手术体位
Property OperaPosition As %String;

/// 手术步骤
Property OperaSteps As %String;

/// 术中注意事项
Property OperaAttentions As %String;

/// 可能出现的意外及防范措施
Property PreventiveMeasure As %String;

/// 讨论意见
Property DiscussionOpinions As %String;

/// 主持人小结
Property HostSummary As %String;

/// 医生签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
