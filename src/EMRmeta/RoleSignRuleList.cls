/// Desc: 		角色签名规则表
/// Creator:	yejian
/// CreatDate:	2019-3-19
Class EMRmeta.RoleSignRuleList Extends %Persistent
{

/// 规则编码
Property RoleRuleCode As %String(TRUNCATE = 1);

/// 规则名称
Property RoleRuleName As %String(TRUNCATE = 1);

/// 规则描述
Property RoleRuleDesc As %String(TRUNCATE = 1);

/// 规则值
Property RoleRuleValue As %String(TRUNCATE = 1);

Index IdxRoleRuleCode On RoleRuleCode [ Unique ];

Storage Default
{
<Data name="RoleSignRuleListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RoleRuleCode</Value>
</Value>
<Value name="3">
<Value>RoleRuleDesc</Value>
</Value>
<Value name="4">
<Value>RoleRuleValue</Value>
</Value>
<Value name="5">
<Value>RoleRuleName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.RoleSignRuleListD</DataLocation>
<DefaultData>RoleSignRuleListDefaultData</DefaultData>
<IdLocation>^DHCEMRM.RoleSignRuleListD</IdLocation>
<IndexLocation>^DHCEMRM.RoleSignRuleListI</IndexLocation>
<StreamLocation>^DHCEMRM.RoleSignRuleListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
