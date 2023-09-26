/// Desc: 完整性校验规则列表
Class DHCEPRFS.INST.CheckRuleList Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 规则编码
Property RuleCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 规则名称
Property RuleName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 规则描述
Property RuleDesc As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 生效日期
Property StartDate As %Date [ SqlColumnNumber = 5 ];

/// 截止日期
Property EndDate As %Date [ SqlColumnNumber = 6 ];

/// 是否有效
Property IsValid As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

Index IdxMain On RuleCode;

Storage Default
{
<Data name="CheckRuleListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleCode</Value>
</Value>
<Value name="3">
<Value>RuleName</Value>
</Value>
<Value name="4">
<Value>RuleDesc</Value>
</Value>
<Value name="5">
<Value>IsValid</Value>
</Value>
<Value name="6">
<Value>StartDate</Value>
</Value>
<Value name="7">
<Value>EndDate</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.CheckRuleListD</DataLocation>
<DefaultData>CheckRuleListDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.CheckRuleListD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.CheckRuleListI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.CheckRuleListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
