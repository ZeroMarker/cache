/// Creator:wangcc
/// Descriptions:实习生培训制度
/// Date:2020-09-01
Class DHCINM.Intern.MgTrainRule Extends %Persistent
{

/// 标题
Property RuleName As %String [ SqlColumnNumber = 2, SqlFieldName = Rule_Name ];

/// 附件
Property RuleRefer As %String [ SqlColumnNumber = 3, SqlFieldName = Rule_Refer ];

/// 上传人
Property RuleUpPer As %String [ SqlColumnNumber = 4, SqlFieldName = Rule_UpPer ];

/// 上传时间
Property RuleUpDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Rule_UpDate ];

Storage Default
{
<Data name="MgTrainRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleName</Value>
</Value>
<Value name="3">
<Value>RuleRefer</Value>
</Value>
<Value name="4">
<Value>RuleUpPer</Value>
</Value>
<Value name="5">
<Value>RuleUpDate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Intern.MgTrainRuleD</DataLocation>
<DefaultData>MgTrainRuleDefaultData</DefaultData>
<IdLocation>^DHCINM.Intern.MgTrainRuleD</IdLocation>
<IndexLocation>^DHCINM.Intern.MgTrainRuleI</IndexLocation>
<StreamLocation>^DHCINM.Intern.MgTrainRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
