/// 名称: 用户模板标题关联表
/// 描述: 用户模板标题关联表
/// 编写者：叶剑
/// 编写日期: 2017-11-7
Class EMRservice.entity.EUserTemplateTitle Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 分组代码EMRmeta.UserTemplate的Code
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 标题编码
Property TitleCode As %String;

/// 标题名称
Property TitleName As %String;

}
