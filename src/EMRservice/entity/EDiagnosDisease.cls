/// 名称: 病种诊断关联
/// 描述: 病种诊断关联表
/// 编写者：叶剑
/// 编写日期: 2016-7-19
Class EMRservice.entity.EDiagnosDisease Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 病种代码EMRmeta.Diagnos的Code
Property DiagnosCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 病种名称EMRmeta.Diagnos的Name
Property DiagnosName As %String(MAXLEN = 200, TRUNCATE = 1);

/// ICD10 ID
Property ICDID As %String;

/// ICD10编码
Property ICDCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// ICD10名称
Property ICDName As %String(MAXLEN = 200, TRUNCATE = 1);

}
