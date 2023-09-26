/// Creator:丁亚男
/// CreatDate:2021-03-22
/// Description：疾病关联评估量表
/// Table：CT.WDT.CDSS.DiseJoinAssess
Class CT.WDT.CDSS.DiseJoinAssess Extends (%Persistent, User.Abstract)
{

/// 疾病表DR
Property DiseaseDR As CT.WDT.CDSS.DiseaseDict [ Required ];

/// 评估量表
Property RatingScaleDR As CT.WDT.CDSS.AssBase [ Required ];

/// 备注
Property Remarks As %String(MAXLEN = "");

Index DiseaseDRIndex On DiseaseDR;

Index RatingScaleDRIndex On (DiseaseDR, RatingScaleDR);

Index AssIndex On RatingScaleDR;

Storage Default
{
<Data name="DiseJoinAssessDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiseaseDR</Value>
</Value>
<Value name="3">
<Value>RatingScaleDR</Value>
</Value>
<Value name="4">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DiseJoinAssessD</DataLocation>
<DefaultData>DiseJoinAssessDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DiseJoinAssessD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DiseJoinAssessI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DiseJoinAssessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
