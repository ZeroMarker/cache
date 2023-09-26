/// Creator:丁亚男
/// CreatDate:2022-10-08
/// Description：评估表关联结论表
/// Table：CT.WDT.CDSS.AssConResult
Class CT.WDT.CDSS.AssConResult Extends (%Persistent, User.Abstract)
{

/// 评估表指针
Property AssDR As CT.WDT.CDSS.AssBase [ Required ];

/// 评估结果字典表
Property ResultDR As CT.WDT.CDSS.AssessResultDict [ Required ];

Index AssIndex On AssDR;

Index ResultDRIndex On ResultDR;

Index AssResIndex On (AssDR, ResultDR);

Storage Default
{
<Data name="AssConResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AssDR</Value>
</Value>
<Value name="3">
<Value>ResultDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.AssConResultD</DataLocation>
<DefaultData>AssConResultDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.AssConResultD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.AssConResultI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.AssConResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
