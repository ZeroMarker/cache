/// Creator:	Jiangew
/// CreatDate:	2013.02.22
/// Desc: 		权限规则表(操作和条件规则)
Class EMRmeta.PrivRuleList Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property RuleName As %String(TRUNCATE = 1);

Property RuleDesc As %String(TRUNCATE = 1);

Property RuleType As %String(TRUNCATE = 1);

Index IdxName On RuleName [ Data = RuleName, Unique ];

Storage Default
{
<Data name="PrivRuleListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleName</Value>
</Value>
<Value name="3">
<Value>RuleDesc</Value>
</Value>
<Value name="4">
<Value>RuleType</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.PrivRuleListD</DataLocation>
<DefaultData>PrivRuleListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.PrivRuleListD</IdLocation>
<IndexLocation>^DHCEMRM.PrivRuleListI</IndexLocation>
<StreamLocation>^DHCEMRM.PrivRuleListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
