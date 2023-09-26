Class web.DHCPE.CallVoice.Entity.WaitingPatient Extends (%Persistent, web.DHCPE.CallVoice.Entity.Patient) [ ClassType = persistent, Inheritance = right ]
{

Storage Default
{
<Data name="WaitingPatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Department</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Priority</Value>
</Value>
<Value name="5">
<Value>QueueNo</Value>
</Value>
<Value name="6">
<Value>RegisterNo</Value>
</Value>
<Value name="7">
<Value>Sex</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.Ca91B.WaitingPatientD</DataLocation>
<DefaultData>WaitingPatientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.Ca91B.WaitingPatientD</IdLocation>
<IndexLocation>^web.DHCPE.Ca91B.WaitingPatientI</IndexLocation>
<StreamLocation>^web.DHCPE.Ca91B.WaitingPatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
