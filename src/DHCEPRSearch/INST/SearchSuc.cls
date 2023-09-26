Class DHCEPRSearch.INST.SearchSuc Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MREpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property Priority As %Integer [ SqlColumnNumber = 3 ];

Property CandidateDate As %Date [ SqlColumnNumber = 4 ];

Property CandidateTime As %Time [ SqlColumnNumber = 5 ];

Property SucceedDate As %Date [ SqlColumnNumber = 6 ];

Property SucceedTime As %Time [ SqlColumnNumber = 7 ];

Index IdxMREpisodeID On MREpisodeID;

Index IdxCandidateDateTime On (CandidateDate, CandidateTime);

Index IdxSucceedDateTime On (SucceedDate, SucceedTime);

Storage Default
{
<Data name="SearchSucDefaultData">
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
<Value name="6">
<Value>SucceedDate</Value>
</Value>
<Value name="7">
<Value>SucceedTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRSearch.INST.SearchSucD</DataLocation>
<DefaultData>SearchSucDefaultData</DefaultData>
<IdLocation>^DHCEPRSearch.INST.SearchSucD</IdLocation>
<IndexLocation>^DHCEPRSearch.INST.SearchSucI</IndexLocation>
<StreamLocation>^DHCEPRSearch.INST.SearchSucS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
