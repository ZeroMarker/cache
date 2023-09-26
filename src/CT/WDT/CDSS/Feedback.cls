/// Creator:谷雪萍
/// CreatDate:2021-03-04
/// Description：CDSS反馈意见表
/// Table：CT.WDT.CDSS.Feedback
Class CT.WDT.CDSS.Feedback Extends (%Persistent, User.Abstract)
{

/// 意见入口
Property OpinionPortal As %String(MAXLEN = "");

/// 反馈意见
Property Feedback As %String(MAXLEN = "");

/// 创建科室
Property CreateLoc As %String;

/// 创建人员
Property CreateUser As %String;

/// 创建时间
Property CreateTime As %TimeStamp;

/// 意见入口分类：评估表、文献
Property OpinionPortalType As %String;

Storage Default
{
<Data name="FeedbackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OpinionPortal</Value>
</Value>
<Value name="3">
<Value>Feedback</Value>
</Value>
<Value name="4">
<Value>CreateLoc</Value>
</Value>
<Value name="5">
<Value>CreateUser</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>OpinionPortalType</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.FeedbackD</DataLocation>
<DefaultData>FeedbackDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.FeedbackD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.FeedbackI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.FeedbackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
