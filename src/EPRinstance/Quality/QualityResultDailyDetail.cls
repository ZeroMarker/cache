Class EPRinstance.Quality.QualityResultDailyDetail Extends %Persistent
{

Index IdxRuleID On RuleDR;

Index IdxExamineDate On ExamineDate;

Index IdxExecuteEpiRuleEntry On (ExamineDate, EpisodeID, RuleDR, EntryDR);

Index IdxEpisodeRuleID On (EpisodeID, RuleDR);

Index IdxEpisodeRuleIDDateEntry On (EpisodeID, RuleDR, ExamineDate, EntryDR);

Index IdxEpisodeRuleIDEntry On (EpisodeID, RuleDR, EntryDR);

Index IdxRuleEpisodeID On (RuleDR, EpisodeID);

Index IdxComposite On (EpisodeID, RuleDR, ExamineDate);

Index IdxEpisodeEntryID On (EpisodeID, EntryDR);

Index IdxEntryID On EntryDR;

/// Represent current visit for one patient
Property EpisodeID As %String(TRUNCATE = 1);

/// Quality rule reference
Property RuleDR As %String(TRUNCATE = 1);

/// 实际得分
Property ActualScore As %String(TRUNCATE = 1);

/// 实际扣分
Property ActualDeScore As %String(TRUNCATE = 1);

/// Represent the grade of current EPR
Property GradeDR As %String(TRUNCATE = 1);

/// User reference, represent who will take responsibility
Property SignUserDR As %String(TRUNCATE = 1);

/// 检查时间 (出院为出院时间加7天)
Property ExamineDate As %String(TRUNCATE = 1);

/// Examine time
Property ExamineTime As %String(TRUNCATE = 1);

/// Execute date, system format
Property ExecuteDate As %String(TRUNCATE = 1);

/// Execute time
Property ExecuteTime As %String(TRUNCATE = 1);

/// Is active for this result
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 实际级别
Property ActualGrade As %String(TRUNCATE = 1);

/// 手工质控操作类型
Property Action As %String(TRUNCATE = 1);

/// Quality entry reference
Property EntryDR As %String(TRUNCATE = 1);

Property ExamCount As %String(TRUNCATE = 1);

/// Current score for <EntryDR>
Property EntryScore As %String(TRUNCATE = 1);

Property EntryGrade As %String(TRUNCATE = 1);

Property InstanceId As %String(TRUNCATE = 1);

Property EmrDocId As %String(TRUNCATE = 1);

/// Trigger date
Property TriggerDate As %String(TRUNCATE = 1);

/// Notes
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0);

Storage Default
{
<Data name="QualityResultDailyDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>RuleDR</Value>
</Value>
<Value name="4">
<Value>ActualScore</Value>
</Value>
<Value name="5">
<Value>ActualDeScore</Value>
</Value>
<Value name="6">
<Value>GradeDR</Value>
</Value>
<Value name="7">
<Value>SignUserDR</Value>
</Value>
<Value name="8">
<Value>ExamineDate</Value>
</Value>
<Value name="9">
<Value>ExamineTime</Value>
</Value>
<Value name="10">
<Value>ExecuteDate</Value>
</Value>
<Value name="11">
<Value>ExecuteTime</Value>
</Value>
<Value name="12">
<Value>IsActive</Value>
</Value>
<Value name="13">
<Value>ActualGrade</Value>
</Value>
<Value name="14">
<Value>Action</Value>
</Value>
<Value name="15">
<Value>EntryDR</Value>
</Value>
<Value name="16">
<Value>ExamCount</Value>
</Value>
<Value name="17">
<Value>EntryScore</Value>
</Value>
<Value name="18">
<Value>EntryGrade</Value>
</Value>
<Value name="19">
<Value>TriggerDate</Value>
</Value>
<Value name="20">
<Value>ResumeText</Value>
</Value>
<Value name="21">
<Value>InstanceId</Value>
</Value>
<Value name="22">
<Value>EmrDocId</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.QualityRetDailyDetD</DataLocation>
<DefaultData>QualityResultDailyDetailDefaultData</DefaultData>
<IdLocation>^DHCEPRQ.QualityRetDailyDetD</IdLocation>
<IndexLocation>^DHCEPRQ.QualityRetDailyDetI</IndexLocation>
<StreamLocation>^DHCEPRQ.QualityRetDailyDetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
