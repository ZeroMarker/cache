/// 名称:用户模板章节关系表表
/// 描述:用户模板章节关系表表
/// 编写者：yejian
/// 编写日期: 2020-3-10
Class EMRservice.entity.EUserTemplateSectionRelation Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 模板ID
Property TemplateID As %String;

/// 分组代码EMRmeta.UserTemplate的Code
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 名称EMRmeta.UserTemplate的Name
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板章节编码
Property SectionCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板章节名称
Property SectionName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 章节继承状态 reference 引用，replace 覆盖
Property Status As %String(TRUNCATE = 1);

}
