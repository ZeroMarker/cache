Class EMRinstance.AdmTaskQueue Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property EpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property AdmDate As %Date [ SqlColumnNumber = 3 ];

Property Priority As %Integer [ SqlColumnNumber = 4 ];

/// FP 首页质控
Property TaskType As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Property CreateCount As %Integer [ SqlColumnNumber = 6 ];

Property CandidateDate As %Date [ SqlColumnNumber = 7 ];

Property CandidateTime As %Time [ SqlColumnNumber = 8 ];

Index IdxMain On (EpisodeID, TaskType);

Index IdxPriorityTaskType On (TaskType, Priority);

Index IdxCandidateDateTime On (CandidateDate, CandidateTime);

Index IdxTypeCandidateDateTime On (TaskType, CandidateDate, CandidateTime);

Storage Default
{
<Data name="AdmTaskQueueDefaultData">
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
</Data>
<DataLocation>^DHCEMRI.AdmTaskQueueD</DataLocation>
<DefaultData>AdmTaskQueueDefaultData</DefaultData>
<IdLocation>^DHCEMRI.AdmTaskQueueD</IdLocation>
<IndexLocation>^DHCEMRI.AdmTaskQueueI</IndexLocation>
<StreamLocation>^DHCEMRI.AdmTaskQueueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
