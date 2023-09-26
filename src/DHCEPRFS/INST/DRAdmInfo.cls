Class DHCEPRFS.INST.DRAdmInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property RegNo As %String(MAXLEN = 100);

Property AdmNo As %String(MAXLEN = 100);

Property DoctorNo As %String(MAXLEN = 100);

Property DoctorName As %String(MAXLEN = 100);

Property AdmDate As %String(MAXLEN = 100);

Property AdmTime As %String(MAXLEN = 100);

Property AdmLocCode As %String(MAXLEN = 100);

Property AdmLocName As %String(MAXLEN = 100);

Property DisDate As %String(MAXLEN = 100);

Property DisTime As %String(MAXLEN = 100);

Property DisLocCode As %String(MAXLEN = 100);

Property DisLocName As %String(MAXLEN = 100);

Index IdxAdmNo On AdmNo [ Unique ];

Storage Default
{
<Data name="DRAdmInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RegNo</Value>
</Value>
<Value name="3">
<Value>EpisoeNo</Value>
</Value>
<Value name="4">
<Value>DoctorNo</Value>
</Value>
<Value name="5">
<Value>DoctorName</Value>
</Value>
<Value name="6">
<Value>AdmDate</Value>
</Value>
<Value name="7">
<Value>AdmTime</Value>
</Value>
<Value name="8">
<Value>AdmLocCode</Value>
</Value>
<Value name="9">
<Value>AdmLocName</Value>
</Value>
<Value name="10">
<Value>DisDate</Value>
</Value>
<Value name="11">
<Value>DisLocCode</Value>
</Value>
<Value name="12">
<Value>DisLocName</Value>
</Value>
<Value name="13">
<Value>DisTime</Value>
</Value>
<Value name="14">
<Value>AdmNo</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.DRAdmInfoD</DataLocation>
<DefaultData>DRAdmInfoDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.DRAdmInfoD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.DRAdmInfoI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.DRAdmInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
