Class EMRinstance.AdmTaskExec Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property EpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property AdmDate As %Date [ SqlColumnNumber = 3 ];

Property Priority As %Integer [ SqlColumnNumber = 4 ];

/// FP 首页质控
Property TaskType As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Property CreateCount As %Integer [ SqlColumnNumber = 6 ];

Property CandidateDate As %Date [ SqlColumnNumber = 7 ];

Property CandidateTime As %Time [ SqlColumnNumber = 8 ];

Property TaskDate As %Date [ SqlColumnNumber = 9 ];

Property TaskTime As %Time [ SqlColumnNumber = 10 ];

Property TaskRemark As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 11 ];

Property RemarkDate As %Date [ SqlColumnNumber = 12 ];

Property RemarkTime As %Time [ SqlColumnNumber = 13 ];

Index IdxEpisode On EpisodeID;

Index IdxPriorityTaskType On (TaskType, Priority);

Index IdxPriorityCreateCount On (CreateCount, Priority);

Index IdxTypeTaskDateTime On (TaskType, TaskDate, TaskTime);

Storage Default
{
<Data name="AdmTaskExecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>AdmDate</Value>
</Value>
<Value name="4">
<Value>Priority</Value>
</Value>
<Value name="5">
<Value>TaskType</Value>
</Value>
<Value name="6">
<Value>CreateCount</Value>
</Value>
<Value name="7">
<Value>CandidateDate</Value>
</Value>
<Value name="8">
<Value>CandidateTime</Value>
</Value>
<Value name="9">
<Value>TaskDate</Value>
</Value>
<Value name="10">
<Value>TaskTime</Value>
</Value>
<Value name="11">
<Value>TaskRemark</Value>
</Value>
<Value name="12">
<Value>RemarkDate</Value>
</Value>
<Value name="13">
<Value>RemarkTime</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.AdmTaskExecD</DataLocation>
<DefaultData>AdmTaskExecDefaultData</DefaultData>
<IdLocation>^DHCEMRI.AdmTaskExecD</IdLocation>
<IndexLocation>^DHCEMRI.AdmTaskExecI</IndexLocation>
<StreamLocation>^DHCEMRI.AdmTaskExecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
