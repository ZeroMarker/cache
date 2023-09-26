/// 名称: 病种科室关联
/// 描述: 病种科室关联表
/// 编写者：叶剑
/// 编写日期: 2016-7-19
Class EMRservice.entity.EDiagnosCTLoc Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 分组代码EMRmeta.Diagnos的DiagnosCode
Property DiagnosCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 分组名称EMRmeta.Diagnos的DiagnosName
Property DiagnosName As %String(MAXLEN = 200, TRUNCATE = 1);

/// CT_Loc指针
Property CTLocID As %String(TRUNCATE = 1);

/// CT_Loc名称
Property CTLocName As %String(TRUNCATE = 1);

}
