/// 名称: 病种基础表
/// 描述: 病种基础表
/// 编写者：叶剑
/// 编写日期: 2016-7-19
Class EMRservice.entity.EDiagnos Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 病种代码
Property DiagnosCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 病种名称
Property DiagnosName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 病种分组代码
Property CategoryCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 病种分组名称
Property CategoryName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 创建者UserID
Property UserID As %String(TRUNCATE = 1);

/// 创建时间
Property CreateDate As %String;

/// 顺序(病种目录下顺序)
Property Sequence As %String;

/// 使用状态 0 正常，1 停用
Property Status As %String(TRUNCATE = 1);

}
