/// Description：住院Demo-输血申请表
/// Table：User.DHCDSSDEMOBloodTrans
Class web.CDSSEntity.Demo.BloodTrans Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.BloodTrans";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 输血血型（ABO血型系统）
Property BloodTransType As %String;

/// 输血血型（Rh血型系统）
Property BloodTransTypeRh As %String;

/// 输血品名称
Property BloodTransClass As %String;

/// 输血量
Property BloodTransVolume As %String;

/// 输血量单位
Property BloodTransVolumeU As %String;

/// 输血部位
Property BloodTransSite As %String;

/// 输血指征
Property BTIndication As %String;

/// 指征值
Property BTIndicationValue As %String;

/// 指征值单位
Property BTIndicationValueUnit As %String;

/// 输血目的
Property BloodTransPurpose As %String;

/// 用血时间
Property BloodTransTime As %String;

/// 录入人员
Property Recorder As %String;

/// 病历原文
Property OriginalContent As %String;

}
