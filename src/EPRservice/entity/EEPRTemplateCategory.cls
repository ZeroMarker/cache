Class EPRservice.entity.EEPRTemplateCategory Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property CategoryName As %String(TRUNCATE = 1);

Property CategoryType As %String(TRUNCATE = 1);

Property ParentCategoryID As %String(TRUNCATE = 1);

Property CategorySeq As %Integer;

Property BindPrnTemplateID As %String(TRUNCATE = 1);

Property BindPrnTemplateCategoryID As %String(TRUNCATE = 1);

}
