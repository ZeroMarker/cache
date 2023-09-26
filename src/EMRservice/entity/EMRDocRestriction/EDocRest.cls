Class EMRservice.entity.EMRDocRestriction.EDocRest Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

//模板组ID

Property GroupID As %String(TRUNCATE = 1);

//规则条件的项目ID组成的串(如 DEPT:10^PATTYPE:21^SEX:1)

Property RuleItemIDs As %String(TRUNCATE = 1);

Property RuleItemDesc As %String(TRUNCATE = 1);

}
