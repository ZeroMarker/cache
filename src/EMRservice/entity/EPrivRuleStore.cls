/// 名称:		EMRservice.entity.EPrivRuleStore
/// 描述:		规则脚本仓库表关联对象
/// 编写者：	yejian
/// 编写日期: 	2020-10-12
/// 产品组：	电子病历产品组
Class EMRservice.entity.EPrivRuleStore Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 规则描述
Property RuleDesc As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 规则代码
Property RuleCode As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 排序
Property Sequence As %Integer;

}
