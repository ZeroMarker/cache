/// 名称: 病种分组
/// 描述: 病种分组表
/// 编写者：叶剑
/// 编写日期: 2016-7-19
Class EMRservice.entity.EDiagnosCategory Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 病种分组代码
Property CategoryCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 病种分组名称
Property CategoryName As %String(MAXLEN = 200, TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

/// 标题顺序
Property Sequence As %String;

}
