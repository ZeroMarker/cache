Class EMRmeta.TemplatePriv.RuleDetails Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Type As %String(TRUNCATE = 1);

Property ConditionValue As %String(TRUNCATE = 1);

Property ConditionDesc As %String(TRUNCATE = 1);

Relationship Rules As EMRmeta.TemplatePriv.TemplatesRule [ Cardinality = parent, Inverse = Details ];

//Index PrivRuleIdTypeValue On (Rules, Type, ConditionValue);

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Type:%String,Value:%String")
{
		SELECT ID,Type,ConditionValue
		FROM EMRmeta_TemplatePriv.RuleDetails
		ORDER BY ID
}

Query SelectByType(parType As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Type:%String,Value:%String")
{
		SELECT ID,Type,ConditionValue
		FROM EMRmeta_TemplatePriv.RuleDetails
		WHERE Type like :parName
		ORDER BY ID
}

Query SelectByTemplateID(parType As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Type:%String,Value:%String")
{
		SELECT ID,Type,ConditionValue
		FROM EMRmeta_TemplatePriv.RuleDetails
		WHERE Type like :parName
		ORDER BY ID
}

Query SelectAllByRuleId(parRuleId As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Type:%String,Value:%String,Desc:%String")
{
		SELECT ID,Type,ConditionValue,ConditionDesc
		FROM EMRmeta_TemplatePriv.RuleDetails
		where Rules = :parRuleId
		ORDER BY Type,ID
}

Storage Default
{
<Data name="RuleDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>ConditionValue</Value>
</Value>
<Value name="4">
<Value>ConditionDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.Priv.RuleDetailsD</DataLocation>
<DefaultData>RuleDetailsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.Priv.RuleDetailsD</IdLocation>
<IndexLocation>^DHCEMRM.Priv.RuleDetailsI</IndexLocation>
<StreamLocation>^DHCEMRM.Priv.RuleDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
