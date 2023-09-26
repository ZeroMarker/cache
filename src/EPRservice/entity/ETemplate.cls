Class EPRservice.entity.ETemplate Extends (%Library.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Property BindPrintName As %String(TRUNCATE = 1);

Property BindPrintTemplateID As %String(TRUNCATE = 1);

Property ChartItemType As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

Property ID As %String(TRUNCATE = 1);

Property LastVersion As %Integer;

Property Name As %String(TRUNCATE = 1);

Property PublishVersion As %Integer;

Property TemplateCategoryID As %String(TRUNCATE = 1);

Property TemplateProperty As %String(TRUNCATE = 1);

}
