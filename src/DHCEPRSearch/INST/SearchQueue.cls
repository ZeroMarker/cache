Class DHCEPRSearch.INST.SearchQueue Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MREpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property Priority As %Integer [ SqlColumnNumber = 3 ];

Property CandidateDate As %Date [ SqlColumnNumber = 4 ];

Property CandidateTime As %Time [ SqlColumnNumber = 5 ];

Index IdxMREpisodeID On MREpisodeID;

Index IdxCandidateDateTime On (CandidateDate, CandidateTime);

Index IdxPriorityAndDateTime On (Priority, CandidateDate, CandidateTime);

Storage Default
{
<Data name="SearchQueueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeID</Value>
</Value>
<Value name="3">
<Value>Priority</Value>
</Value>
<Value name="4">
<Value>CandidateDate</Value>
</Value>
<Value name="5">
<Value>CandidateTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRSearch.INST.SearchQueueD</DataLocation>
<DefaultData>SearchQueueDefaultData</DefaultData>
<IdLocation>^DHCEPRSearch.INST.SearchQueueD</IdLocation>
<IndexLocation>^DHCEPRSearch.INST.SearchQueueI</IndexLocation>
<StreamLocation>^DHCEPRSearch.INST.SearchQueueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
