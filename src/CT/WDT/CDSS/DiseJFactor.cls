/// Creator:丁亚男
/// CreatDate:2020-12-21
/// Description：疾病关联诊断因子表V2.0
/// Table：CT.WDT.CDSS.DiseJFactor
Class CT.WDT.CDSS.DiseJFactor Extends (%Persistent, User.Abstract)
{

/// 疾病表DR
Property DiseaseDR As CT.WDT.CDSS.DiseaseDict [ Required ];

/// 诊断因子
Property FactorDR As CT.WDT.CDSS.DiagFactorBase [ Required ];

/// 诊断因子类型
Property FactorType As %String;

/// 诊断因子等级（一级~五级（高），1，2，3,4,5）
Property FactorGrade As %Integer;

/// 是否否定条件（0否，1是）
Property IsNegatCondi As %Integer;

/// 是否充要条件（0否，1是）
Property IsNecessAndSuffiCondi As %Integer;

/// 是否必要条件（0否，1是）
Property IsNecessCondi As %Integer;

/// 是否住院召回（0否，1是）(暂时不用)
Property IsHospRecall As %Integer;

/// 是否门诊召回（0否，1是）(暂时不用)
Property IsOutpatientRecall As %Integer;

/// 是否展示（0否，1是）
Property IsShow As %Integer;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index DiseaseDRIndex On DiseaseDR;

Index FactorIndex On FactorDR;

Index FactorDRIndex On (DiseaseDR, FactorDR);

Storage Default
{
<Data name="DiseJFactorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiseaseDR</Value>
</Value>
<Value name="3">
<Value>FactorDR</Value>
</Value>
<Value name="4">
<Value>FactorType</Value>
</Value>
<Value name="5">
<Value>FactorGrade</Value>
</Value>
<Value name="6">
<Value>IsNegatCondi</Value>
</Value>
<Value name="7">
<Value>IsNecessAndSuffiCondi</Value>
</Value>
<Value name="8">
<Value>IsNecessCondi</Value>
</Value>
<Value name="9">
<Value>IsHospRecall</Value>
</Value>
<Value name="10">
<Value>IsOutpatientRecall</Value>
</Value>
<Value name="11">
<Value>IsShow</Value>
</Value>
<Value name="12">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DiseJFactorD</DataLocation>
<DefaultData>DiseJFactorDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DiseJFactorD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DiseJFactorI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DiseJFactorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
