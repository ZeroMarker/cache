/// 名称：		EMRservice.entity.ECTOrganizationSchemeItem
/// 描述：		方案项目Entity
/// 编写者：	yejian
/// 编写时间：	2014-8-28
Class EMRservice.entity.ECTOrganizationSchemeItem Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

Property ItemCode As %String;

Property ItemName As %String;

/// EMRmeta.EMRTemplateCategory
Property EMRTemplateCategoryID As %String;

/// 原EMRmeta.EPRPageURL属性
Property ItemTitle As %String;

/// 原EMRmeta.EPRPageURL属性
Property ItemURL As %String;

/// 原EMRmeta.EPRPageURL属性
Property ItemParas As %String(MAXLEN = 15000, TRUNCATE = 1);

Property ItemType As %String;

Property StartDate As %String;

Property StartTime As %String;

Property EndDate As %String;

Property EndTime As %String;

Property imagePath As %String;

}
