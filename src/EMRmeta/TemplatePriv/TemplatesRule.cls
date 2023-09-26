Class EMRmeta.TemplatePriv.TemplatesRule Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// data sample: dept^diag^gender
Property AllConditionType As %String(TRUNCATE = 1);

Property AvailAction As %String(TRUNCATE = 1);

Relationship Details As EMRmeta.TemplatePriv.RuleDetails [ Cardinality = children, Inverse = Rules ];

Relationship TemplateGroup As EMRmeta.TemplatePriv.TemplateGroup [ Cardinality = parent, Inverse = Rules ];

//Index PrivGroupIdAction On (TemplateGroup, AvailAction);

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,childsub:%String,AllConditionType:%String,AvailAction:%String,TemplateGroup:%String")
{
		SELECT ID,childsub,AllConditionType,AvailAction,TemplateGroup
		FROM EMRmeta_TemplatePriv.TemplatesRule
}

Query SelectByAllConditionType(parType As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,childsub:%String,AllConditionType:%String,AvailAction:%String,TemplateGroup:%String")
{
		SELECT ID,childsub,AllConditionType,AvailAction,TemplateGroup
		FROM EMRmeta_TemplatePriv.TemplatesRule
		WHERE AllConditionType like :parType
}

Query SelectByAction(parAction As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,childsub:%String,AllConditionType:%String,AvailAction:%String,TemplateGroup:%String")
{
		SELECT ID,childsub,AllConditionType,AvailAction,TemplateGroup
		FROM EMRmeta_TemplatePriv.TemplatesRule
		WHERE AvailAction like :parAction
}

Query GetByGroupAndAction(parGroupId As %String, parAction As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,childsub:%String,AllConditionType:%String,AvailAction:%String,TemplateGroup:%String")
{
		SELECT ID,childsub,AllConditionType,AvailAction,TemplateGroup
		FROM EMRmeta_TemplatePriv.TemplatesRule
		WHERE TemplateGroup = :parGroupId and AvailAction = :parAction
}

Storage Default
{
<Data name="TemplatesRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AllConditionType</Value>
</Value>
<Value name="3">
<Value>AvailAction</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.Priv.TemplatesRuleD</DataLocation>
<DefaultData>TemplatesRuleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.Priv.TemplatesRuleD</IdLocation>
<IndexLocation>^DHCEMRM.Priv.TemplatesRuleI</IndexLocation>
<StreamLocation>^DHCEMRM.Priv.TemplatesRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
