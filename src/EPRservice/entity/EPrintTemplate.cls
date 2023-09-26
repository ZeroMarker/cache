Class EPRservice.entity.EPrintTemplate Extends (%Library.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Property BindTemplateID As %String(TRUNCATE = 1);

Property BindTemplateName As %String(TRUNCATE = 1);

Property ChartItemType As %String(TRUNCATE = 1);

Property ContinuePrint As %Boolean;

Property Description As %String(TRUNCATE = 1);

Property GUID As %String(MAXLEN = 32, TRUNCATE = 1);

Property ID As %String(TRUNCATE = 1);

/// 最后保存版本
Property LastVersion As %Integer;

Property Name As %String(TRUNCATE = 1);

Property NewPage As %Boolean;

Property PrintTemplateCategoryID As %String(TRUNCATE = 1);

Property PrintTemplateFormat As %String(TRUNCATE = 1);

/// 发布版本
Property PublishVersion As %Integer;

/// 唯一模板中是否在后面的空白部分打印格线
Property UnderLine As %Boolean;

/// 添加空白行时是否复制文本行格式
Property BlankRowWithBorder As %Boolean;

}
