/// Creator:丁亚男
/// CreatDate:2020-01-04
/// Description：治疗方案明细表（推荐治疗方案-药品、推荐治疗方案-手术）
/// Table：CT.WDT.CDSS.RuleDetail
Class CT.WDT.CDSS.RuleDetail Extends (%Persistent, User.Abstract)
{

/// 流程图节点
Property NodeDR As CT.WDT.CDSS.RuleNode [ Required ];

/// 顺序
Property Sequence As %Integer [ Required ];

/// 药品名/手术名/治法/方剂/方剂组成/处置 CT.WDT.CDSS.DrugDict或者CT.WDT.CDSS.OperationDict
Property DrugDR As %String [ Required ];

/// 给药途径/手术方式/煎法/处置类型（腧穴、中药、药物）CT.WDT.CDSS.UsageDict
Property DrugUse As %String;

/// 最小剂量
Property DosageMIN As %String(MAXLEN = "");

/// 最小剂量单位
Property DosageMINUnit As CT.WDT.CDSS.UnitDict;

/// 最大剂量
Property DosageMAX As %String(MAXLEN = "");

/// 最大剂量单位
Property DosageMAXUnit As CT.WDT.CDSS.UnitDict;

/// 频率
Property Frequency As CT.WDT.CDSS.FrequencyDict;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 上级节点
Property LastLevel As CT.WDT.CDSS.RuleDetail;

Index NodeDRIndex On NodeDR As Exact;

Index DrugDRIndex On DrugDR;

Index NodeDrugDRIndex On (NodeDR, DrugDR As Exact);

Index LastLevelIndex On LastLevel;

Index NodeLLevelIndex On (NodeDR, LastLevel);

Index NodeLLDrugDRIndex On (NodeDR, LastLevel, DrugDR As Exact);

Storage Default
{
<Data name="RuleDetailDefaultData">
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
<Value>DrugDR</Value>
</Value>
<Value name="5">
<Value>DrugUse</Value>
</Value>
<Value name="6">
<Value>DosageMIN</Value>
</Value>
<Value name="7">
<Value>DosageMINUnit</Value>
</Value>
<Value name="8">
<Value>DosageMAX</Value>
</Value>
<Value name="9">
<Value>DosageMAXUnit</Value>
</Value>
<Value name="10">
<Value>Frequency</Value>
</Value>
<Value name="11">
<Value>Remarks</Value>
</Value>
<Value name="12">
<Value>LastLevel</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.RuleDetailD</DataLocation>
<DefaultData>RuleDetailDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.RuleDetailD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.RuleDetailI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.RuleDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
