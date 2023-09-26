/// 名称:		EMRservice.entity.EPrivRuleDetail
/// 描述:		脚本规则表
/// 编写者：	yejian
/// 编写日期: 	2021-11-23
/// 产品组：	电子病历产品组
Class EMRservice.entity.EPrivRuleDetail Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 关联权限规则表 EMRmeta.PrivRule
Property PrivRule As %String;

/// 名称
Property RuleDesc As %String;

/// 脚本
Property RuleCode As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 关联仓库
Property PrivRuleStore As %String;

/// 院区分组ID
Property HospGroupID As %String;

/// 规则类型
Property PrivRuleType As %String;

/// 是否启用 1:启用，0:不启用
Property IsActive As %String;

/// 顺序
Property Sequence As %Integer;

}
