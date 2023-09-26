Class CKB.PDSS.RuleCopyLog Extends (%Persistent, User.Abstract) [ SqlRowIdName = DRCL_RowID, SqlTableName = RuleCopyLog ]
{

/// D ##class(CKB.PDSS.RuleCopyLog).%BuildIndices()
/// 来源规则ID
Property DRCLRuleSource As %String [ SqlColumnNumber = 2, SqlFieldName = DRCL_RuleSource ];

/// 目标规则ID
Property DRCLRulePurpose As %String [ SqlColumnNumber = 3, SqlFieldName = DRCL_RulePurpose ];

/// 唯一标识
Property DRCLRuleTag As %String [ SqlColumnNumber = 4, SqlFieldName = DRCL_RuleTag ];

Index RulePurpose On (DRCLRulePurpose As Exact, DRCLRuleSource As Exact);

Storage Default
{
<Data name="RuleCopyLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DRCLRuleSource</Value>
</Value>
<Value name="3">
<Value>DRCLRulePurpose</Value>
</Value>
<Value name="4">
<Value>DRCLRuleTag</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.RuleCopyLogD</DataLocation>
<DefaultData>RuleCopyLogDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.RuleCopyLogD</IdLocation>
<IndexLocation>^CKB.PDSS.RuleCopyLogI</IndexLocation>
<StreamLocation>^CKB.PDSS.RuleCopyLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
