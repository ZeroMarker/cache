Class EPRservice.entity.EEPRTemplate Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

Property EPRTemplateName As %String(TRUNCATE = 1);

Property EPRCategoryID As %String(TRUNCATE = 1);

Property EPRTemplateSeq As %Integer;

Property BindTemplateID As %String(TRUNCATE = 1);

Property BindTemplateCategoryID As %String(TRUNCATE = 1);

Property NecessaryTemplate As %String(TRUNCATE = 1);

}
