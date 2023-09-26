/// Description：住院Demo-术前小结
/// Table：User.DHCDSSDEMOPreSum
Class web.CDSSEntity.Demo.PreSum Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.PreSum";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 创建时间
Property CreateTime As %String;

/// 讨论日期
Property DiscussTime As %String;

/// 参加人员
Property Participant As %String;

/// 简要病情
Property PatientCondition As %String;

/// 术前诊断
Property PreDiag As %String;

/// 手术指征
Property OperaIndications As %String;

/// 拟施手术名称和方式
Property PerOperMethod As %String;

/// 拟施麻醉方式
Property AnesthesiaMethod As %String;

/// 注意事项
Property Attentions As %String;

/// 术前查看患者相关情况
Property PrepareOper As %String;

/// 医师签名
Property DoctorSign As %String;

/// 记录日期
Property RecordTime As %String;

}
