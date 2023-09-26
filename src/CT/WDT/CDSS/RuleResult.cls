/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：诊疗节点内容表V2.0（辅助诊疗-推荐辅助检验检查、推荐评估表、推荐护理措施、推荐治疗方案，预警规则-合理性、并发症）
/// Table：CT.WDT.CDSS.RuleResult
Class CT.WDT.CDSS.RuleResult Extends (%Persistent, User.Abstract)
{

/// 流程图节点
Property NodeDR As CT.WDT.CDSS.RuleNode [ Required ];

/// 顺序
Property Sequence As %Integer [ Required ];

/// 推荐类别（检验/检查/评估表/治疗方案/确诊诊断/辅助计算）
Property RecommendType As %String [ Required ];

/// 检验/检查/评估表/治疗方案（存id）
Property RecommendResult As %String [ Required ];

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 是否基础评估表(1是，0否)
Property BaseTable As %String;

/// 治疗方案来源（文献或者教程名称）
Property TreatSource As %String(MAXLEN = "");

/// 来源截图(弃用)
Property SourceImg As %GlobalCharacterStream;

Property RuleBasisDR As CT.WDT.CDSS.RuleBasis;

Index NodeDRIndex On NodeDR As Exact;

Index TypeResultIndex On (RecommendType As Exact, RecommendResult As Exact);

Index NodeTypeResultIndex On (NodeDR, RecommendType As Exact, RecommendResult As Exact);

Index NodeRecommendIndex On (NodeDR As Exact, RecommendType As Exact);

Index TreatSourceIndex On TreatSource As Exact;

Storage Default
{
<Data name="RuleResultDefaultData">
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
<Value>RecommendType</Value>
</Value>
<Value name="5">
<Value>RecommendResult</Value>
</Value>
<Value name="6">
<Value>Remarks</Value>
</Value>
<Value name="7">
<Value>BaseTable</Value>
</Value>
<Value name="8">
<Value>TreatSource</Value>
</Value>
<Value name="9">
<Value>SourceImg</Value>
</Value>
<Value name="10">
<Value>RuleBasisDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.RuleResultD</DataLocation>
<DefaultData>RuleResultDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.RuleResultD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.RuleResultI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.RuleResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
