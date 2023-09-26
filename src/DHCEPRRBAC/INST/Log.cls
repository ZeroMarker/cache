Class DHCEPRRBAC.INST.Log Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property UserID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property AuthorizationID As %String(TRUNCATE = 1);

Property AuthorizationGroupID As %String(TRUNCATE = 1);

Property LogType As %String(TRUNCATE = 1);

Property LogDate As %Date;

Property LogTime As %Time;

Index IdxUserID On (UserID, LogType, LogDate, LogTime);

Index IdxEpisodeID On (EpisodeID, LogType, LogDate, LogTime);

Index IdxLogDateTime On (LogType, LogDate, LogTime);

Storage Default
{
<Data name="LogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>LogType</Value>
</Value>
<Value name="5">
<Value>LogDate</Value>
</Value>
<Value name="6">
<Value>LogTime</Value>
</Value>
<Value name="7">
<Value>FSAuthorizationID</Value>
</Value>
<Value name="8">
<Value>FSAuthorizationGroupID</Value>
</Value>
<Value name="9">
<Value>AuthorizationID</Value>
</Value>
<Value name="10">
<Value>AuthorizationGroupID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRRBAC.INST.LogD</DataLocation>
<DefaultData>LogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRRBAC.INST.LogD</IdLocation>
<IndexLocation>^DHCEPRRBAC.INST.LogI</IndexLocation>
<StreamLocation>^DHCEPRRBAC.INST.LogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
