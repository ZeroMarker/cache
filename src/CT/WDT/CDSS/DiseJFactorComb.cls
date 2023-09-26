/// Creator:丁亚男
/// CreatDate:2020-12-21
/// Description：疾病关联诊断因子组合表V2.0
/// Table：CT.WDT.CDSS.DiseJFactorComb
Class CT.WDT.CDSS.DiseJFactorComb Extends (%Persistent, User.Abstract)
{

/// 疾病表DR
Property DiseaseDR As CT.WDT.CDSS.DiseaseDict [ Required ];

/// 疾病关联诊断因子的id串CT.WDT.CDSS.DiseJFactor
Property DiseJFactorDRs As %String [ Required ];

/// 组合等级（一级~五级（高），1，2，3,4,5）
Property CombGrade As %Integer;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index DiseaseDRIndex On DiseaseDR;

Index DiseJFactorDRsIndex On (DiseaseDR, DiseJFactorDRs);

Storage Default
{
<Data name="DiseJFactorCombDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiseaseDR</Value>
</Value>
<Value name="3">
<Value>DiseJFactorDRs</Value>
</Value>
<Value name="4">
<Value>CombGrade</Value>
</Value>
<Value name="5">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DiseJFactorCombD</DataLocation>
<DefaultData>DiseJFactorCombDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DiseJFactorCombD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DiseJFactorCombI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DiseJFactorCombS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
