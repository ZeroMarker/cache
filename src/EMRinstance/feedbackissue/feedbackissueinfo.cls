Class EMRinstance.feedbackissue.feedbackissueinfo Extends %Persistent
{

//反馈内容，患者信息ID，医生信息ID，发送时间

Property FeedBackMessage As %String;

Property FeedBackDate As %String;

Property FeedBackTime As %String;

Property EpisodeID As %String;

Property DoctorID As %String;

Index idxFeedPDT On (EpisodeID, FeedBackDate, FeedBackTime);

Index idxDoc On DoctorID;

/// d ##class(%ResultSet).RunQuery("EMRinstance.feedbackissue.feedbackissueinfo","GetAllFeedBack")
Query GetAllFeedBack() As %SQLQuery(CONTAINID = 1, ROWSPEC = "MessageID,DoctorID,EpisodeID,FeedBackDate,FeedBackTime,FeedBackMessage")
{
SELECT %ID,DoctorID,EpisodeID,FeedBackDate,FeedBackTime,FeedBackMessage FROM feedbackissueinfo ORDER BY FeedBackDate,FeedBackTime
}

Storage Default
{
<Data name="feedbackissueinfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FeedBackMessage</Value>
</Value>
<Value name="3">
<Value>FeedBackDate</Value>
</Value>
<Value name="4">
<Value>FeedBackTime</Value>
</Value>
<Value name="5">
<Value>EpisodeID</Value>
</Value>
<Value name="6">
<Value>DoctorID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.FeedBackIssueInfoD</DataLocation>
<DefaultData>FeedBackIssueInfooDefaultData</DefaultData>
<IdLocation>^DHCEMRI.FeedBackIssueInfoD</IdLocation>
<IndexLocation>^DHCEMRI.FeedBackIssueInfoI</IndexLocation>
<StreamLocation>^DHCEMRI.FeedBackIssueInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
