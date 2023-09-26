Class EMRservice.entity.ETemplate Extends (%Library.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Property DocumentType As %String(TRUNCATE = 1);

Property ChartItemType As %String(TRUNCATE = 1);

/// EMRmeta.CTProperty
Property TemplateProperty As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

Property ID As %String(TRUNCATE = 1);

Property LastVersion As %Integer;

Property Name As %String(TRUNCATE = 1);

Property PublishVersion As %Integer;

Property TemplateCategoryID As %String(TRUNCATE = 1);

/// 模板模板标识符Code 遵循电子病历基本架构中业务活动记录EMRxxx
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 类型编码(港大自主编码)
Property TypeCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板描述 DisplayName
Property DisplayName As %String(MAXLEN = 200, TRUNCATE = 1);

}
