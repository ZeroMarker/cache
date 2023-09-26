Class EMRmeta.TemplatePriv.TemplateGroup Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property GroupName As %String(TRUNCATE = 1);

Relationship Rules As EMRmeta.TemplatePriv.TemplatesRule [ Cardinality = children, Inverse = TemplateGroup ];

Relationship Templates As EMRmeta.TemplatePriv.TemplatesInGroup [ Cardinality = children, Inverse = TemplateGroup ];

Query SelectAllGroupName() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,GroupName:%String")
{
		SELECT ID,GroupName
		FROM EMRmeta_TemplatePriv.TemplateGroup
}

/*
Query SelectTemplatesByGroupName(argGroupName As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT  a.ID as TemplateGroupID,b.Template->ChartItemType,b.Template->ID,
 b.Template->Name,b.Template->TemplateCategoryID,
 b.Template->TemplateProperty,c.CategoryProperty,c.CategoryType,c.Name as CategoryName
 FROM TemplateGroup a,TemplatesInGroup b,EMRmeta.TemplateCategory c
 WHERE (a.GroupName = :argGroupName) and b.TemplateGroup->ID=a.ID and c.ID=b.Template->TemplateCategoryID
}
*/
/// select rules by TemplateGroup Name and Action
Query SelectRulesByGroupName(argGroupName As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT  a.ID,b.AllConditionType
 FROM TemplateGroup a,TemplatesRule b
 WHERE (a.GroupName = :argGroupName) and b.TemplateGroup=a.ID
}

Query SelRulesDetailByGrpNameAndAct(argGroupName As %String, argAction As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT  c.ID,c.Type,c.ConditionValue
 FROM TemplateGroup a,TemplatesRule b,RuleDetails c
 WHERE (a.GroupName = :argGroupName) and b.TemplateGroup=a.ID and b.AvailAction=:argAction and b.ID=c.Rules
}

/*
ClassMethod GetGroupNameByTemplateID(parTemplateId As %String) As %String
{
	k SQLCODE
	s name=""
	&sql(select a.GroupName into :name 
			from EMRmeta_TemplatePriv.TemplateGroup a,EMRmeta_TemplatePriv.TemplatesInGroup b
			where b.Template=:parTemplateId)
	q name
}
*/
/// for efficiency. don't get groupname from an instance
/// and one template can be only set to one template group
ClassMethod GetConditionByGrpNameAndAction(argGroupName As %String, argAction As %String) As %String
{
	s result=""
	k SQLCODE
	&sql(SELECT b.AllConditionType into :result
 			FROM TemplateGroup a,TemplatesRule b
 			WHERE (a.GroupName = :argGroupName) and b.TemplateGroup=a.ID and b.AvailAction=:argAction)
 	q rseult
}

Storage Default
{
<Data name="TemplateGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.Priv.TemplateGroupD</DataLocation>
<DefaultData>TemplateGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.Priv.TemplateGroupD</IdLocation>
<IndexLocation>^DHCEMRM.Priv.TemplateGroupI</IndexLocation>
<StreamLocation>^DHCEMRM.Priv.TemplateGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
