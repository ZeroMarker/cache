Class DHCEPRFS.INST.AdmTaskCreate Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 病历生成记录
/// 患者号
Property PatientID As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 开始日期
Property CreateDate As %Date;

/// 开始时间
Property CreateTime As %Time;

/// 结束日期
Property EndDate As %Date;

/// 结束时间
Property EndTime As %Time;

Index IdxEpisodeID On EpisodeID;

Storage Default
{
<Data name="AdmTaskCreateDefaultData">
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
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
<Value name="6">
<Value>EndDate</Value>
</Value>
<Value name="7">
<Value>EndTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.AdmTaskCreateD</DataLocation>
<DefaultData>AdmTaskCreateDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.AdmTaskCreateD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.AdmTaskCreateI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.AdmTaskCreateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
