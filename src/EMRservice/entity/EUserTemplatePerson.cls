/// 名称: 用户模板和用户关联表
/// 描述: 用户模板和用户关联表
/// 编写者：叶剑
/// 编写日期: 2017-11-7
Class EMRservice.entity.EUserTemplatePerson Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 分组代码EMRmeta.UserTemplate的Code
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 用户名
Property UserName As %String(TRUNCATE = 1);

}
