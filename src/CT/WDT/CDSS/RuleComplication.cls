/// Creator:丁亚男
/// CreatDate:2020-01-11
/// Description：诊疗节点内容表（预警规则-并发症）
/// Table：CT.WDT.CDSS.RuleComplication
Class CT.WDT.CDSS.RuleComplication Extends (%Persistent, User.Abstract)
{

/// 流程图节点
Property NodeDR As CT.WDT.CDSS.RuleNode [ Required ];

/// 顺序
Property Sequence As %Integer [ Required ];

/// 并发症
Property ComplicationDR As CT.WDT.CDSS.DiseaseDict [ Required ];

/// 要点
Property MainPoints As %String(MAXLEN = "");

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 治疗方案来源（文献或者教程名称）
Property TreatSource As %String;

Property RuleBasisDR As CT.WDT.CDSS.RuleBasis;

Index NodeDRIndex On NodeDR As Exact;

Index ComplicationDRIndex On ComplicationDR;

Index NodeCompDRIndex On (NodeDR, ComplicationDR);

Storage Default
{
<Data name="RuleComplicationDefaultData">
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
<Value>ComplicationDR</Value>
</Value>
<Value name="5">
<Value>MainPoints</Value>
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
<DataLocation>^CT.WDT.CDSS.RuleComplicationD</DataLocation>
<DefaultData>RuleComplicationDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.RuleComplicationD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.RuleComplicationI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.RuleComplicationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
