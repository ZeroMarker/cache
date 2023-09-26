Class DHCEPRFS.ThirdParty.INST.CheckFinishLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property PatientID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property EpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property InputValue As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property OutputValue As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Property PublishReports As %Integer [ SqlColumnNumber = 6 ];

Property UnPublishReports As %Integer [ SqlColumnNumber = 7 ];

Property AllReports As %Integer [ SqlColumnNumber = 8 ];

Property Comment As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

Property ErrorFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 10 ];

Property CheckTimes As %Integer [ SqlColumnNumber = 11 ];

Property LastCheckDate As %Date [ SqlColumnNumber = 12 ];

Property LastCheckTime As %Time [ SqlColumnNumber = 13 ];

Property CommitFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 14 ];

Property CommitReturn As %String(TRUNCATE = 1) [ SqlColumnNumber = 15 ];

Property CommitDate As %Date [ SqlColumnNumber = 16 ];

Property CommitTime As %Time [ SqlColumnNumber = 17 ];

Index IdxMain On EpisodeID [ Unique ];

Index IdxCommitDateTime On (CommitFlag, CommitDate, CommitTime);

Storage Default
{
<Data name="CheckFinishLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>AdmDateTime</Value>
</Value>
<Value name="5">
<Value>DisDateTime</Value>
</Value>
<Value name="6">
<Value>RequestXML</Value>
</Value>
<Value name="7">
<Value>SequeueID</Value>
</Value>
<Value name="8">
<Value>ActDate</Value>
</Value>
<Value name="9">
<Value>ActTime</Value>
</Value>
<Value name="10">
<Value>InputValue</Value>
</Value>
<Value name="11">
<Value>OutputValue</Value>
</Value>
<Value name="12">
<Value>PublishReports</Value>
</Value>
<Value name="13">
<Value>UnPublishReports</Value>
</Value>
<Value name="14">
<Value>AllReports</Value>
</Value>
<Value name="15">
<Value>Comment</Value>
</Value>
<Value name="16">
<Value>FinishExecute</Value>
</Value>
<Value name="17">
<Value>CheckTimes</Value>
</Value>
<Value name="18">
<Value>LastCheckDate</Value>
</Value>
<Value name="19">
<Value>LastCheckTime</Value>
</Value>
<Value name="20">
<Value>ExecuteDate</Value>
</Value>
<Value name="21">
<Value>ExecuteTime</Value>
</Value>
<Value name="22">
<Value>ErrorFlag</Value>
</Value>
<Value name="23">
<Value>CommitFlag</Value>
</Value>
<Value name="24">
<Value>CommitReturn</Value>
</Value>
<Value name="25">
<Value>CommitDate</Value>
</Value>
<Value name="26">
<Value>CommitTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.ThirdCheckFinishLogD</DataLocation>
<DefaultData>CheckFinishLogDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.ThirdCheckFinishLogD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.ThirdCheckFinishLogI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.ThirdCheckFinishLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
