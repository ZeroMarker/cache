/// 名称:	EMR.DOC.DTO.StdDictionary
/// 描述:	字典传输对象
/// 编写者：yejian
/// 编写日期: 2020-11-9
Class EMR.DOC.DTO.StdDictionary Extends %RegisteredObject
{

/// RowID
Property ID As %String(TRUNCATE = 1);

/// 字典编码
Property Code As %String(TRUNCATE = 1);

/// 字典名称
Property Name As %String(TRUNCATE = 1);

/// 字典描述
Property Description As %String(TRUNCATE = 1);

/// 字典别名
Property DicAliasCol As %String(TRUNCATE = 1);

/// 字典代码列名
Property DicCodeCol As %String(TRUNCATE = 1);

/// 字典描述列名
Property DicDescCol As %String(TRUNCATE = 1);

/// 表名
Property TableName As %String(TRUNCATE = 1);

/// 权限规则类别
Property IsRuleType As %String(TRUNCATE = 1);

/// 规则类别标识
Property RuleTypeTag As %String(TRUNCATE = 1);

/// 默认查询条件编码
Property ConditionCode As %String(TRUNCATE = 1);

/// 默认查询条件内容
Property Condition As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 是否病种规则类别
Property IsDiagnosRuleType As %String(TRUNCATE = 1);

/// 顺序号
Property Sequence As %Integer;

}
