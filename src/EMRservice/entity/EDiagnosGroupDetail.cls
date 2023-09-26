/// 名称: 病种分组关联表
/// 描述: 病种分组关联表
/// 编写者：叶剑
/// 编写日期: 2016-7-19
Class EMRservice.entity.EDiagnosGroupDetail Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 病种分组代码
Property GroupID As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 病种代码
Property DiagnosCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 顺序(病种分组下顺序)
Property Sequence As %String;

}
