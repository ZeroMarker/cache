Class EPRinstance.Quality.RecordModifyLog Extends %Persistent [ ProcedureBlock ]
{

Property EpisodeID As %String [ SqlColumnNumber = 2 ];

Property EMRVersion As %String [ SqlColumnNumber = 3 ];

Property EPRDocID As %String [ SqlColumnNumber = 4 ];

Property EPRNum As %String [ SqlColumnNumber = 5 ];

Property ActionCode As %String [ SqlColumnNumber = 6 ];

Property ActUserID As %String [ SqlColumnNumber = 7 ];

Property ActDate As %Date [ SqlColumnNumber = 8 ];

Property ActTime As %Time [ SqlColumnNumber = 9 ];

Index IdxMain On (EpisodeID, EMRVersion, EPRDocID, EPRNum, ActionCode) [ Unique ];

Index IdxOnActDateTime On (EpisodeID, ActDate, ActTime, ActionCode);

Storage Default
{
<Data name="RecordModifyLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>EMRVersion</Value>
</Value>
<Value name="4">
<Value>EPRDocID</Value>
</Value>
<Value name="5">
<Value>EPRNum</Value>
</Value>
<Value name="6">
<Value>ActionCode</Value>
</Value>
<Value name="7">
<Value>ActUserID</Value>
</Value>
<Value name="8">
<Value>ActDate</Value>
</Value>
<Value name="9">
<Value>ActTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.RecordModifyLogD</DataLocation>
<DefaultData>RecordModifyLogDefaultData</DefaultData>
<IdLocation>^DHCEPRQ.RecordModifyLogD</IdLocation>
<IndexLocation>^DHCEPRQ.RecordModifyLogI</IndexLocation>
<StreamLocation>^DHCEPRQ.RecordModifyLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
