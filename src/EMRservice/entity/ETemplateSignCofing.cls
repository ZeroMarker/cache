/// 名称：		EMRservice.entity.ETemplateSignCofing
/// 描述：		签名配置对象
/// 编写者：	yejian	
/// 编写时间：	2018-12-5
Class EMRservice.entity.ETemplateSignCofing Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 模板ID
Property TemplateID As %String(TRUNCATE = 1);

/// 模板版本ID
Property TemplateVersion As %String;

/// 是否有签名单元（1 有签名单元，0 无签名单元） 
Property HasSign As %String(TRUNCATE = 1);

}
