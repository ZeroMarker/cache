Class DHCEPRFS.INST.EstimatePagesLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property EstimatePagesDetail As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property MedRecordNo As %String(TRUNCATE = 1);

Property RegNo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

Property ActDate As %Date;

Property ActTime As %Time;

Property TotalPages As %String(TRUNCATE = 1);

Property UnitPrice As %String(TRUNCATE = 1);

Property TotalPrice As %String(TRUNCATE = 1);

Relationship EstimatePagesItem As DHCEPRFS.INST.EstimatePagesItem [ Cardinality = children, Inverse = EstimatePagesLog ];

Index IdxActDate On ActDate;

Storage Default
{
<Data name="EstimatePagesLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EstimatePagesDetail</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>MedRecordNo</Value>
</Value>
<Value name="5">
<Value>RegNo</Value>
</Value>
<Value name="6">
<Value>PatientID</Value>
</Value>
<Value name="7">
<Value>UserID</Value>
</Value>
<Value name="8">
<Value>ActDate</Value>
</Value>
<Value name="9">
<Value>ActTime</Value>
</Value>
<Value name="10">
<Value>TotalPages</Value>
</Value>
<Value name="11">
<Value>UnitPrice</Value>
</Value>
<Value name="12">
<Value>TotalPrice</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.EstimatePag35ECD</DataLocation>
<DefaultData>EstimatePagesLogDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.EstimatePag35ECD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.EstimatePag35ECI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.EstimatePag35ECS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
