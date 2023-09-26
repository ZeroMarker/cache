/// Creater:wangpf
/// Descriptions:科室护管分工制度
/// Date:2020-07-01
Class DHCINM.HB.MgDivisionRule Extends %Persistent
{

/// 病区
Property RuleWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Rule_Ward ];

/// 分工
Property RuleDivision As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 3, SqlFieldName = Rule_Division ];

/// 制度描述
Property RuleDesc As %String [ SqlColumnNumber = 4, SqlFieldName = Rule_Desc ];

/// 制度内容
Property RuleContent As %String(MAXLEN = 10000) [ SqlColumnNumber = 5, SqlFieldName = Rule_Content ];

/// 制度内容
Property RuleContentExt As %Stream.GlobalCharacter [ SqlColumnNumber = 6, SqlFieldName = Rule_ContentExt ];

Index Ward On RuleWard;

Storage Default
{
<Data name="MgDivisionRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleWard</Value>
</Value>
<Value name="3">
<Value>RuleDivision</Value>
</Value>
<Value name="4">
<Value>RuleDesc</Value>
</Value>
<Value name="5">
<Value>RuleContent</Value>
</Value>
<Value name="6">
<Value>RuleContentExt</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgDivisionRuleD</DataLocation>
<DefaultData>MgDivisionRuleDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgDivisionRuleD</IdLocation>
<IndexLocation>^DHCINM.HB.MgDivisionRuleI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgDivisionRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
