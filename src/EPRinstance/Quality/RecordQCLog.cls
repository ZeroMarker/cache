Class EPRinstance.Quality.RecordQCLog Extends %Persistent [ ProcedureBlock ]
{

Relationship TheRecordQCLogDetail As EPRinstance.Quality.RecordQCLogDetail [ Cardinality = children, Inverse = TheRecordQCLog ];

Property EpisodeID As %String [ SqlColumnNumber = 2 ];

Property ActionCode As %String [ SqlColumnNumber = 3 ];

Property ActUserID As %String [ SqlColumnNumber = 4 ];

Property ActDate As %Date [ SqlColumnNumber = 5 ];

Property ActTime As %Time [ SqlColumnNumber = 6 ];

Property ActStatus As %String [ SqlColumnNumber = 7 ];

Index IdxOnMain On (EpisodeID, ActionCode) [ Unique ];

Index IdxOnActDateTime On (EpisodeID, ActDate, ActTime);

Storage Default
{
<Data name="RecordQCLogDefaultData">
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
<DataLocation>^DHCEPRQ.RecordQCLogD</DataLocation>
<DefaultData>RecordQCLogDefaultData</DefaultData>
<IdLocation>^DHCEPRQ.RecordQCLogD</IdLocation>
<IndexLocation>^DHCEPRQ.RecordQCLogI</IndexLocation>
<StreamLocation>^DHCEPRQ.RecordQCLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
