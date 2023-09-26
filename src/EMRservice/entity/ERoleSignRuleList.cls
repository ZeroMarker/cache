/// Desc: 		角色签名规则表
/// Creator:	yejian
/// CreatDate:	2019-3-19
Class EMRservice.entity.ERoleSignRuleList Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 规则编码
Property RoleRuleCode As %String(TRUNCATE = 1);

/// 规则名称
Property RoleRuleName As %String(TRUNCATE = 1);

/// 规则描述
Property RoleRuleDesc As %String(TRUNCATE = 1);

/// 规则值
Property RoleRuleValue As %String(TRUNCATE = 1);

}
