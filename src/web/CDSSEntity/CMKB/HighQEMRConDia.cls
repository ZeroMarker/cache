/// 名称:优质病历关联诊断表
/// 描述:实体类
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期:2023-4-14
Class web.CDSSEntity.CMKB.HighQEMRConDia Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.HighQEMRConDia";

/// rowid
Property RowId As %String;

/// 优质病历指针
Property EMRDR As %String;

/// 诊断分类（中医、西医、证型）
Property DiagnosisClass As %String;

/// 中医/西医/证型名称
Property DiagnosisName As %String;

/// 诊断顺序号
Property DiagnosisSequence As %String;

/// 是否主诊断（1-是，0-否）
Property IsMainDiagnosis As %String;

/// 诊断来源（确诊诊断：1，初步诊断：2，修正诊断：3，补充诊断：4）
Property DiagnosisType As %String;

/// 备注
Property Remarks As %String;

}
