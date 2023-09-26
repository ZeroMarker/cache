/// 名称: 科室模板病种关联
/// 描述: 科室模板病种关联表
/// 编写者：叶剑
/// 编写日期: 2019-7-31
Class EMRservice.entity.EUserTemplateDisease Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 分组代码EMRmeta.UserTemplate的Code
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 病种代码EMRmeta.Diagnos的DiagnosCode
Property DiagnosCode As %String(TRUNCATE = 1);

/// 病种代码EMRmeta.Diagnos的DiagnosName
Property DiagnosName As %String(TRUNCATE = 1);

}
