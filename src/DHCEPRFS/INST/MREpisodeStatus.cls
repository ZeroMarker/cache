Class DHCEPRFS.INST.MREpisodeStatus Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MREpisodeID As %String(TRUNCATE = 1);

Property ArchiveStage As %Integer;

Storage Default
{
<Data name="MREpisodeStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeID</Value>
</Value>
<Value name="3">
<Value>ArchiveStage</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MREpisodeStatusD</DataLocation>
<DefaultData>MREpisodeStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MREpisodeStatusD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MREpisodeStatusI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MREpisodeStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
