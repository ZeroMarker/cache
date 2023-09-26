/// Creator:谷雪萍
/// CreatDate:2021-04-09
/// Description：评估表关键字表
/// Table：CT.WDT.CDSS.AssKeyWords
Class CT.WDT.CDSS.AssKeyWords Extends (%Persistent, User.Abstract)
{

/// 评估表指针
Property AssDR As CT.WDT.CDSS.AssBase [ Required ];

/// 关键字
Property KeyWords As %String;

Index AssIndex On AssDR;

Index WordsIndex On (AssDR, KeyWords);

Storage Default
{
<Data name="AssKeyWordsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AssDR</Value>
</Value>
<Value name="3">
<Value>KeyWords</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.AssKeyWordsD</DataLocation>
<DefaultData>AssKeyWordsDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.AssKeyWordsD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.AssKeyWordsI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.AssKeyWordsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
