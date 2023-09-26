Class EPRinstance.Quality.AiResult Extends %Library.Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxEntryID On EntryDR;

Index IdxExamineDate On ExamineDate;

Index IdxTag On Tag;

Index IdxEpisodeEntryID On (EpisodeID, EntryDR);

Index IdxEpisodeAiResultTitle On (EpisodeID, AiResultTitle);

Property EpisodeID As %String(TRUNCATE = 1);

/// 条目id
Property EntryDR As %String(TRUNCATE = 1);

/// 内涵质控反馈内容
Property AiResultTitle As %String(MAXLEN = 500, TRUNCATE = 1);

/// 评价者UserDR
Property SignUserDR As %String(TRUNCATE = 1);

/// 评价日期
Property ExamineDate As %String(TRUNCATE = 1);

/// 评价时间
Property ExamineTime As %String(TRUNCATE = 1);

/// 反馈内容
Property ErrorText As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0);

/// 标签
Property Tag As %String(TRUNCATE = 1);

/// 标记备注
Property Remarks As %String(TRUNCATE = 1);

/// 标记日期
Property RemarksDate As %String(TRUNCATE = 1);

/// 标记时间
Property RemarksTime As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AiResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>EntryDR</Value>
</Value>
<Value name="4">
<Value>StructName</Value>
</Value>
<Value name="5">
<Value>SignUserDR</Value>
</Value>
<Value name="6">
<Value>ExamineDate</Value>
</Value>
<Value name="7">
<Value>ExamineTime</Value>
</Value>
<Value name="8">
<Value>ErrorText</Value>
</Value>
<Value name="9">
<Value>Tag</Value>
</Value>
<Value name="10">
<Value>Remarks</Value>
</Value>
<Value name="11">
<Value>RemarksDate</Value>
</Value>
<Value name="12">
<Value>RemarksTime</Value>
</Value>
<Value name="13">
<Value>AiResultTitle</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.AiResultD</DataLocation>
<DefaultData>AiResultDefaultData</DefaultData>
<IdLocation>^DHCEPRQ.AiResultD</IdLocation>
<IndexLocation>^DHCEPRQ.AiResultI</IndexLocation>
<StreamLocation>^DHCEPRQ.AiResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
