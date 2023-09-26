Class EPRservice.entity.EReport Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property Description As %String(TRUNCATE = 1);

Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

Property ID As %String(TRUNCATE = 1);

/// 最后保存版本
Property LastVersion As %Integer;

Property Name As %String(TRUNCATE = 1);

/// 发布版本
Property PublishVersion As %Integer;

Property ReportCategoryID As %String(TRUNCATE = 1);

}
