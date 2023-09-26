Class EMRservice.entity.EEMRTemplate Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

Property TemplateName As %String(TRUNCATE = 1);

Property CategoryID As %String(TRUNCATE = 1);

Property TemplateSeq As %Integer;

Property BindTemplateID As %String(TRUNCATE = 1);

Property BindTemplateCategoryID As %String(TRUNCATE = 1);

Property NecessaryTemplate As %String(TRUNCATE = 1);

/// 内部表示符
Property InternalID As %String(TRUNCATE = 1);

}
