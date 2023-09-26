Class DHCEPRFS.INST.ImportMRQLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 操作日期
Property ActiveDate As %Date;

/// 操作时间
Property ActiveTime As %Time;

/// 病案号
Property MedRecordNo As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 病人号
Property PatientID As %String(TRUNCATE = 1);

/// DHCMRQ.MR.DataMaster的ID
Property DataMasterID As %String(TRUNCATE = 1);

Property ErrorFlag As %String(TRUNCATE = 1);

Property ErrorMsg As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ImportMRQLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActiveDate</Value>
</Value>
<Value name="3">
<Value>ActiveTime</Value>
</Value>
<Value name="4">
<Value>MedRecordNo</Value>
</Value>
<Value name="5">
<Value>EpisodeID</Value>
</Value>
<Value name="6">
<Value>PatientID</Value>
</Value>
<Value name="7">
<Value>DataMasterID</Value>
</Value>
<Value name="8">
<Value>ErrorFlag</Value>
</Value>
<Value name="9">
<Value>ErrorMsg</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.ImportMRQLogD</DataLocation>
<DefaultData>ImportMRQLogDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.ImportMRQLogD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.ImportMRQLogI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.ImportMRQLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
