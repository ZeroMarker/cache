Class web.DHCPE.CallVoice.Entity.SkipPatient Extends (%Persistent, web.DHCPE.CallVoice.Entity.Patient) [ ClassType = persistent, Inheritance = right ]
{

Storage Default
{
<Data name="SkipPatientDefaultData">
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
<DataLocation>^web.DHCPE.CallV91B.SkipPatientD</DataLocation>
<DefaultData>SkipPatientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.CallV91B.SkipPatientD</IdLocation>
<IndexLocation>^web.DHCPE.CallV91B.SkipPatientI</IndexLocation>
<StreamLocation>^web.DHCPE.CallV91B.SkipPatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
