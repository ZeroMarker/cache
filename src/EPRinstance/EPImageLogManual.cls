Class EPRinstance.EPImageLogManual Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property CreateDate As %Date;

Property CreateTime As %Time;

Property PatientID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property EPRLogsID As %String(TRUNCATE = 1);

Property PrintType As %String(TRUNCATE = 1);

Property PrintTemplateID As %String(TRUNCATE = 1);

Property PrintDocID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

Property ClientIP As %String(TRUNCATE = 1);

Property ResultFlag As %String(TRUNCATE = 1);

Property UpdateDate As %Date;

Property UpdateTime As %Time;

Property HospitalID As %String;

Index IdxCreateDateTime On (CreateDate, CreateTime, EpisodeID, EPRLogsID, ResultFlag);

Index IdxEpisodeIDAndLogsID On (EpisodeID, EPRLogsID, ClientIP);

Index IdxEpisodeIDAndDocID On (EpisodeID, PrintDocID);

Index IdxOnUpdateDateTime On (UpdateDate, UpdateTime) [ Data = ResultFlag ];

Index IdxOnResultFlag On (ResultFlag, UpdateDate, UpdateTime);

Index IdxOnHospitalID On (HospitalID, UpdateDate, UpdateTime) [ Data = ResultFlag ];

Storage Default
{
<Data name="EPImageLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateDate</Value>
</Value>
<Value name="3">
<Value>CreateTime</Value>
</Value>
<Value name="4">
<Value>PatientID</Value>
</Value>
<Value name="5">
<Value>EpisodeID</Value>
</Value>
<Value name="6">
<Value>EPRLogsID</Value>
</Value>
<Value name="7">
<Value>PrintType</Value>
</Value>
<Value name="8">
<Value>PrintTemplateID</Value>
</Value>
<Value name="9">
<Value>PrintDocID</Value>
</Value>
<Value name="10">
<Value>InstanceDataID</Value>
</Value>
<Value name="11">
<Value>UserID</Value>
</Value>
<Value name="12">
<Value>ClientIP</Value>
</Value>
<Value name="13">
<Value>ResultFlag</Value>
</Value>
<Value name="14">
<Value>UpdateDate</Value>
</Value>
<Value name="15">
<Value>UpdateTime</Value>
</Value>
<Value name="16">
<Value>HospitalID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.EPImageLogManualD</DataLocation>
<DefaultData>EPImageLogDefaultData</DefaultData>
<IdLocation>^DHCEPRI.EPImageLogManualD</IdLocation>
<IndexLocation>^DHCEPRI.EPImageLogManualI</IndexLocation>
<StreamLocation>^DHCEPRI.EPImageLogManualS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
