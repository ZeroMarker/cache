/// Creator:丁亚男
/// CreatDate:2020-01-11
/// Description：诊疗节点内容表（预警规则-合理性）
/// Table：CT.WDT.CDSS.RuleRationality
Class CT.WDT.CDSS.RuleRationality Extends (%Persistent, User.Abstract)
{

/// 流程图节点
Property NodeDR As CT.WDT.CDSS.RuleNode [ Required ];

/// 顺序
Property Sequence As %Integer [ Required ];

/// 提醒内容
Property WarningContent As %String(MAXLEN = "") [ Required ];

/// 禁忌级别（A-绝对、R-相对、M-注意事项）
Property TabooLevel As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 治疗方案来源（文献或者教程名称）
Property TreatSource As %String;

Property RuleBasisDR As CT.WDT.CDSS.RuleBasis;

Index NodeDRIndex On NodeDR As Exact;

Storage Default
{
<Data name="RuleRationalityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NodeDR</Value>
</Value>
<Value name="3">
<Value>Sequence</Value>
</Value>
<Value name="4">
<Value>WarningContent</Value>
</Value>
<Value name="5">
<Value>TabooLevel</Value>
</Value>
<Value name="6">
<Value>Remarks</Value>
</Value>
<Value name="7">
<Value>TreatSource</Value>
</Value>
<Value name="8">
<Value>RuleBasisDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.RuleRationalityD</DataLocation>
<DefaultData>RuleRationalityDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.RuleRationalityD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.RuleRationalityI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.RuleRationalityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
