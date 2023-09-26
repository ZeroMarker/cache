Class EPRinstance.Quality.RecordQCLogDetail Extends %Persistent
{

Relationship TheRecordQCLog As EPRinstance.Quality.RecordQCLog [ Cardinality = parent, Inverse = TheRecordQCLogDetail ];

Property EpisodeID As %String [ SqlColumnNumber = 2 ];

Property ActionCode As %String [ SqlColumnNumber = 3 ];

Property ActUserID As %String [ SqlColumnNumber = 4 ];

Property ActDate As %Date [ SqlColumnNumber = 5 ];

Property ActTime As %Time [ SqlColumnNumber = 6 ];

Property ActStatus As %String [ SqlColumnNumber = 7 ];

Index IdxOnRecordQCLog On TheRecordQCLog;

Storage Default
{
<Data name="RecordQCLogDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>ActionCode</Value>
</Value>
<Value name="4">
<Value>ActUserID</Value>
</Value>
<Value name="5">
<Value>ActDate</Value>
</Value>
<Value name="6">
<Value>ActTime</Value>
</Value>
<Value name="7">
<Value>ActStatus</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("TheRecordQCLogDetail")</DataLocation>
<DefaultData>RecordQCLogDetailDefaultData</DefaultData>
<IdLocation>{%%PARENT}("TheRecordQCLogDetail")</IdLocation>
<IndexLocation>^DHCEPRQ.RecordQCLogDetailI</IndexLocation>
<StreamLocation>^DHCEPRQ.RecordQCLogDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
