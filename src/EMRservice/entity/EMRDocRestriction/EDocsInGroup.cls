Class EMRservice.entity.EMRDocRestriction.EDocsInGroup Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

//模板组ID

Property GroupID As %String(TRUNCATE = 1);

//病历结构ID

Property DocID As %String(TRUNCATE = 1);

Property DocName As %String(TRUNCATE = 1);

}
