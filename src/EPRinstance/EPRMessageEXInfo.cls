Class EPRinstance.EPRMessageEXInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property EPRMessageID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Index IdxEPRMessageID On EPRMessageID;

Index IdxEpisodeID On EpisodeID;

Storage Default
{
<Data name="EPRMessageEXInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EPRMessageID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>UserID</Value>
</Value>
</Data>
<DataLocation>^EPRinstance.EPRMessageEXInfoD</DataLocation>
<DefaultData>EPRMessageEXInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRinstance.EPRMessageEXInfoD</IdLocation>
<IndexLocation>^EPRinstance.EPRMessageEXInfoI</IndexLocation>
<StreamLocation>^EPRinstance.EPRMessageEXInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
