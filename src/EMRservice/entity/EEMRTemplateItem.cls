/// 名称：		EMRservice.entity.EEMRTemplateItem
/// 描述：		病历分组子项
/// 编写者：	yejian
/// 编写时间：	2017-5-6
Class EMRservice.entity.EEMRTemplateItem Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// EMRmeta.EMRTemplateGroup 表的TemplateGroupCode字段
Property TemplateGroupCode As %String(TRUNCATE = 1);

/// EMRmeta.EMRTemplate表的ID
Property EMRTemplateID As %String(TRUNCATE = 1);

/// EMRmeta.EMRTemplate表的TemplateName字段
Property EMRTemplateName As %String(TRUNCATE = 1);

/// 类型(基础模板 BASETEM/空,科室模板 USERTEM)
Property TemplateType As %String(TRUNCATE = 1);

/// 科室模板编码(科室模板 EMRmeta.UserTemplate表的Code,基础模板 空值)
Property UserTemplateCode As %String(TRUNCATE = 1);

/// 标题编码
Property TitleCode As %String(TRUNCATE = 1);

/// 排序
Property TemplateSeq As %String;

}
