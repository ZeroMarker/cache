Class EPRmeta.TemplatePriv.TemplatesRule Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// data sample: dept^diag^gender
Property AllConditionType As %String(TRUNCATE = 1);

Property AvailAction As %String(TRUNCATE = 1);

Relationship Details As EPRmeta.TemplatePriv.RuleDetails [ Cardinality = children, Inverse = Rules ];

Relationship TemplateGroup As EPRmeta.TemplatePriv.TemplateGroup [ Cardinality = parent, Inverse = Rules ];

//Index PrivGroupIdAction On (TemplateGroup, AvailAction);

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,childsub:%String,AllConditionType:%String,AvailAction:%String,TemplateGroup:%String")
{
		SELECT ID,childsub,AllConditionType,AvailAction,TemplateGroup
		FROM EPRmeta_TemplatePriv.TemplatesRule
}

Query SelectByAllConditionType(parType As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,childsub:%String,AllConditionType:%String,AvailAction:%String,TemplateGroup:%String")
{
		SELECT ID,childsub,AllConditionType,AvailAction,TemplateGroup
		FROM EPRmeta_TemplatePriv.TemplatesRule
		WHERE AllConditionType like :parType
}

Query SelectByAction(parAction As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,childsub:%String,AllConditionType:%String,AvailAction:%String,TemplateGroup:%String")
{
		SELECT ID,childsub,AllConditionType,AvailAction,TemplateGroup
		FROM EPRmeta_TemplatePriv.TemplatesRule
		WHERE AvailAction like :parAction
}

Query GetByGroupAndAction(parGroupId As %String, parAction As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,childsub:%String,AllConditionType:%String,AvailAction:%String,TemplateGroup:%String")
{
		SELECT ID,childsub,AllConditionType,AvailAction,TemplateGroup
		FROM EPRmeta_TemplatePriv.TemplatesRule
		WHERE TemplateGroup = :parGroupId and AvailAction = :parAction
}

Storage Default
{
<Data name="TemplatesRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConditionValue</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>AllConditionType</Value>
</Value>
<Value name="5">
<Value>AvailAction</Value>
</Value>
<Value name="6">
<Value>Details</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.Priv.TemplatesRuleD</DataLocation>
<DefaultData>TemplatesRuleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.Priv.TemplatesRuleD</IdLocation>
<IndexLocation>^DHCEPRM.Priv.TemplatesRuleI</IndexLocation>
<StreamLocation>^DHCEPRM.Priv.TemplatesRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
