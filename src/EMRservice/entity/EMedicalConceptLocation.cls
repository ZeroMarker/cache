Class EMRservice.entity.EMedicalConceptLocation Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 数据值域标示符 引用到模板使用的Code [Code n:1 ConceptCode]
Property Code As %String;

/// 医学概念码表Code
Property ConceptCode As %String;

/// 显示名称
Property DisplayName As %String;

/// 概念详细描述说明
Property Description As %String;

/// 章节维护模板编码
Property TemplateCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 章节维护模板名称
Property TemplateName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 章节维护模板章节编码
Property SectionCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 章节维护模板章节名称
Property SectionName As %String(MAXLEN = 100, TRUNCATE = 1);

}
