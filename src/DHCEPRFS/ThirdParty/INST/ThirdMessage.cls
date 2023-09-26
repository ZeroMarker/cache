Class DHCEPRFS.ThirdParty.INST.ThirdMessage Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property PatientID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property EpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property AdmDateTime As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property DisDateTime As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Property RequestXML As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Property SequeueID As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

Property ActDate As %Date;

Property ActTime As %Time;

Storage Default
{
<Data name="ThirdMessageDefaultData">
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
</Data>
<DataLocation>^DHCEPRFS.INST.ThirdMessageD</DataLocation>
<DefaultData>ThirdMessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.ThirdMessageD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.ThirdMessageI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.ThirdMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
