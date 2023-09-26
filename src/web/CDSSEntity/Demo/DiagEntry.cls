/// Description：住院Demo-诊断系统
/// Table：User.DHCDSSDEMODiagEntry
Class web.CDSSEntity.Demo.DiagEntry Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.DiagEntry";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 诊断代码
Property DiagCode As %String;

/// 诊断描述
Property DiagDesc As %String;

/// ICD代码
Property ICDCode As %String;

/// 主诊断（是/否）
Property MainDiagFlag As %String;

/// 诊断类型（初步诊断、出院诊断、术前诊断、术后诊断、入院诊断、病理诊断）
Property DiagType As %String;

/// 诊断状态（确诊/待诊/疑诊）
Property DiagState As %String;

/// 发病日期
Property OnsetDate As %String;

/// 诊断日期
Property DiagDate As %String;

/// 诊断备注
Property DiagRemark As %String;

/// 录入人员
Property Recorder As %String;

/// 病历原文
Property OriginalContent As %String;

/// 诊断分类（中医、西医、证型）
Property DiagnosisClass As %String;

}
