/// Creator:丁亚男
/// CreatDate:2021-09-23
/// Description：疾病关联识别词表V2.0
/// Table：CT.WDT.CDSS.DiseJIWords
Class CT.WDT.CDSS.DiseJIWords Extends (%Persistent, User.Abstract)
{

/// 疾病表DR
Property DiseaseDR As CT.WDT.CDSS.DiseaseDict [ Required ];

/// 识别词
Property WordDR As CT.WDT.CDSS.IdentifyWords [ Required ];

/// 识别词类型
Property WordType As %String;

/// 识别词等级（一级~五级（高），1，2，3,4,5）
Property WordGrade As %Integer;

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

Index WordIndex On WordDR;

Index WordDRIndex On (DiseaseDR, WordDR);

Storage Default
{
<Data name="DiseJIWordsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiseaseDR</Value>
</Value>
<Value name="3">
<Value>WordDR</Value>
</Value>
<Value name="4">
<Value>WordType</Value>
</Value>
<Value name="5">
<Value>WordGrade</Value>
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
<DataLocation>^CT.WDT.CDSS.DiseJIWordsD</DataLocation>
<DefaultData>DiseJIWordsDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DiseJIWordsD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DiseJIWordsI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DiseJIWordsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
