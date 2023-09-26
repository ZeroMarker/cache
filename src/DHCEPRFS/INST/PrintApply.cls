Class DHCEPRFS.INST.PrintApply Extends %Persistent
{

Property MRPatientID As %String(TRUNCATE = 1);

Property MREpisodeID As %String(TRUNCATE = 1);

Property ApplyDate As %Date;

Property ApplyTime As %Time;

Property Reason As %String(TRUNCATE = 1);

Property Applicant As %String(TRUNCATE = 1);

Property ApplicantIDCard As %String(TRUNCATE = 1);

Property Relation As %String(TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

Property Picture1 As %GlobalBinaryStream(LOCATION = "^DHCEPRFS.INST.PrintApplyS");

Property Picture2 As %GlobalBinaryStream(LOCATION = "^DHCEPRFS.INST.PrintApplyS");

Property Picture3 As %GlobalBinaryStream(LOCATION = "^DHCEPRFS.INST.PrintApplyS");

Property Picture4 As %GlobalBinaryStream(LOCATION = "^DHCEPRFS.INST.PrintApplyS");

Index IdxMREpisodeID On MREpisodeID;

Index IdxMRPatientIDAndApplyDate On (MRPatientID, ApplyDate);

Index IdxMRPatientID On (MRPatientID, MREpisodeID);

Storage Default
{
<Data name="PrintApplyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRPatientID</Value>
</Value>
<Value name="3">
<Value>MREpisodeID</Value>
</Value>
<Value name="4">
<Value>ApplyDate</Value>
</Value>
<Value name="5">
<Value>ApplyTime</Value>
</Value>
<Value name="6">
<Value>Reason</Value>
</Value>
<Value name="7">
<Value>Applicant</Value>
</Value>
<Value name="8">
<Value>ApplicantIDCard</Value>
</Value>
<Value name="9">
<Value>Relation</Value>
</Value>
<Value name="10">
<Value>UserID</Value>
</Value>
<Value name="11">
<Value>Picture1</Value>
</Value>
<Value name="12">
<Value>Picture2</Value>
</Value>
<Value name="13">
<Value>Picture3</Value>
</Value>
<Value name="14">
<Value>Picture4</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.PrintApplyD</DataLocation>
<DefaultData>PrintApplyDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.PrintApplyD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.PrintApplyI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.PrintApplyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
