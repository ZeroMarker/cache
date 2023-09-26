/// Desc: 		模板签名规则表
/// Creator:	yejian
/// CreatDate:	2019-3-19
Class EMRservice.entity.ETemplateSignRuleList Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 模板ID
Property TemplateID As %String(TRUNCATE = 1);

/// 标题编码
Property TitleCode As %String;

/// 规则名称
Property TemRuleCode As %String(TRUNCATE = 1);

/// 规则描述
Property TemRuleDesc As %String(TRUNCATE = 1);

/// 规则值
Property TemRuleValue As %String(TRUNCATE = 1);

}
