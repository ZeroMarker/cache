Class DHCEPRFS.INST.MRLogView Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MREpisodeID As %String [ SqlColumnNumber = 2 ];

Property ActUserID As %String [ SqlColumnNumber = 3 ];

Property ActDate As %Date [ SqlColumnNumber = 4 ];

Property ActTime As %Time [ SqlColumnNumber = 5 ];

Property ClientIP As %String [ SqlColumnNumber = 6 ];

Index IdxOnMREpisodeID On MREpisodeID;

Index IdxOnDateTime On (ActDate, ActTime);

Index IdxOnUserID On (ActUserID, ActDate, ActTime);

Storage Default
{
<Data name="MRLogViewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeID</Value>
</Value>
<Value name="3">
<Value>ActUserID</Value>
</Value>
<Value name="4">
<Value>ActDate</Value>
</Value>
<Value name="5">
<Value>ActTime</Value>
</Value>
<Value name="6">
<Value>ClientIP</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRLogViewD</DataLocation>
<DefaultData>MRLogViewDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRLogViewD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRLogViewI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRLogViewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
