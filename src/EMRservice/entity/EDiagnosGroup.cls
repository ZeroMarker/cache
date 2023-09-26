/// 名称: 病种分组
/// 描述: 病种分组表
/// 编写者：叶剑
/// 编写日期: 2016-7-19
Class EMRservice.entity.EDiagnosGroup Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 病种分组代码
Property GroupCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// 病种分组名称
Property GroupName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// CT_Loc指针
Property CTLocID As %String(TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %String;

}
