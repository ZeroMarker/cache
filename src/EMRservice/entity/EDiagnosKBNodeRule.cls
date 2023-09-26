/// 名称:	EMRmeta.DiagnosKBNodeRule
/// 描述:	病种知识库关联附加规则
/// 编写者：yejian
/// 编写日期: 2016-7-19
Class EMRservice.entity.EDiagnosKBNodeRule Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// RowID of the table EMRmeta.DiagnosKBNode
Property DiagnosKBNodeID As %String(TRUNCATE = 1);

/// RowID of the table StdDictionary
Property DiagnosRuleID As %String(TRUNCATE = 1);

/// The StdDictionary item code
Property DiagnosRuleCode As %String(TRUNCATE = 1);

/// The StdDictionary item desc
Property DiagnosRuleDesc As %String(TRUNCATE = 1);

}
