/// Creator:李得原
/// CreatDate:2020-11-04
/// Description：推荐疑似疾病中单一规则
/// Table：CT.WDT.CDSS.SingleSymptomRule
Class CT.WDT.CDSS.SingleSymptomRule Extends (%Persistent, User.Abstract)
{

/// 规则编码
Property RuleCode As %String [ Required ];

/// 一条规则共几行
Property RuleTotal As %String [ Required ];

/// 症状名称
Property RuleSymptom As %ListOfDataTypes;

/// 年龄最小值
Property MinAge As %String;

/// 最小值操作符
Property MinAgeOpera As %String;

/// 年龄最大值
Property MaxAge As %String;

/// 最大值操作符
Property MaxAgeOpera As %String;

/// 性别
Property Gender As %String;

/// 疾病列表
Property RuleDiseases As %ListOfDataTypes;

/// 年龄最小值单位
Property MinAgeUnit As %String;

/// 年龄最大值单位
Property MaxAgeUnit As %String;

Index CodeIndex On (RuleCode As Exact, RuleTotal As Exact);

Index TotalIndex On (RuleTotal As Exact, RuleCode As Exact);

Storage Default
{
<Data name="SingleSymptomRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleCode</Value>
</Value>
<Value name="3">
<Value>RuleTotal</Value>
</Value>
<Value name="4">
<Value>RuleSymptom</Value>
</Value>
<Value name="5">
<Value>MinAge</Value>
</Value>
<Value name="6">
<Value>MinAgeOpera</Value>
</Value>
<Value name="7">
<Value>MaxAge</Value>
</Value>
<Value name="8">
<Value>MaxAgeOpera</Value>
</Value>
<Value name="9">
<Value>Gender</Value>
</Value>
<Value name="10">
<Value>RuleDiseases</Value>
</Value>
<Value name="11">
<Value>MinAgeUnit</Value>
</Value>
<Value name="12">
<Value>MaxAgeUnit</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.SingleSymptomRuleD</DataLocation>
<DefaultData>SingleSymptomRuleDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.SingleSymptomRuleD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.SingleSymptomRuleI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.SingleSymptomRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
