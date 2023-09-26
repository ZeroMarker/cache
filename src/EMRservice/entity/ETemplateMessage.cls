/// 名称：EMRservice.entity.ETemplateMessage
/// 描述:模板消息提示维护
/// 编写者：yejian
/// 编写日期: 2019-9-9
Class EMRservice.entity.ETemplateMessage Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 模板ID
Property TemplateID As %String(TRUNCATE = 1);

/// 模板名称
Property TemplateName As %String(TRUNCATE = 1);

/// 模板提示信息
Property TemMessage As %String(TRUNCATE = 1);

}
