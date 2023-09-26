Class DHCEPRFS.INST.AdmTaskExec Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property SysCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property PatientID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property EpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property MedRecordNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Property IPRecordNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Property OPRecordNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

Property EPRecordNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

Property Priority As %Integer [ SqlColumnNumber = 9 ];

Property AdmDate As %Date [ SqlColumnNumber = 10 ];

Property CandidateDate As %Date [ SqlColumnNumber = 11 ];

Property CandidateTime As %Time [ SqlColumnNumber = 12 ];

Property TaskDate As %Date [ SqlColumnNumber = 13 ];

Property TaskTime As %Time [ SqlColumnNumber = 14 ];

Property TaskRemark As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 15 ];

Property IP As %String(MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 16 ];

Property UserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 17 ];

Property SchemeType As %String(TRUNCATE = 1) [ SqlColumnNumber = 18 ];

/// 登记号
Property RegNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 19 ];

/// N-正常，G-绿色通道，O-老病历，S-特殊生成
Property TaskType As %String(TRUNCATE = 1) [ SqlColumnNumber = 20 ];

Property CreateCount As %Integer [ SqlColumnNumber = 21 ];

Property RemarkDate As %Date [ SqlColumnNumber = 22 ];

Property RemarkTime As %Time [ SqlColumnNumber = 23 ];

Property VersionTypeCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 24 ];

Property SpecialFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 25 ];

Property SpecialParam As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 26 ];

Property AdmType As %String(TRUNCATE = 1) [ SqlColumnNumber = 27 ];

Index IdxMedRecordNo On MedRecordNo;

Index IdxEpisode On EpisodeID;

Index IdxRegNo On RegNo;

Index IdxPriorityTaskType On (TaskType, Priority);

Index IdxTaskType On (TaskType, SpecialFlag, Priority);

Index IdxPriorityCreateCount On (CreateCount, Priority);

Index IdxTaskDateTime On (TaskDate, TaskTime);

Index IdxTypeTaskDateTime On (TaskType, TaskDate, TaskTime);

Storage Default
{
<Data name="AdmTaskExecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SysCode</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>MedRecordNo</Value>
</Value>
<Value name="6">
<Value>IPRecordNo</Value>
</Value>
<Value name="7">
<Value>OPRecordNo</Value>
</Value>
<Value name="8">
<Value>EPRecordNo</Value>
</Value>
<Value name="9">
<Value>Priority</Value>
</Value>
<Value name="10">
<Value>AdmDate</Value>
</Value>
<Value name="11">
<Value>CandidateDate</Value>
</Value>
<Value name="12">
<Value>CandidateTime</Value>
</Value>
<Value name="13">
<Value>TaskDate</Value>
</Value>
<Value name="14">
<Value>TaskTime</Value>
</Value>
<Value name="15">
<Value>TaskRemark</Value>
</Value>
<Value name="16">
<Value>IP</Value>
</Value>
<Value name="17">
<Value>UserID</Value>
</Value>
<Value name="18">
<Value>SchemeType</Value>
</Value>
<Value name="19">
<Value>RegNo</Value>
</Value>
<Value name="20">
<Value>TaskType</Value>
</Value>
<Value name="21">
<Value>CreateCount</Value>
</Value>
<Value name="22">
<Value>RemarkDate</Value>
</Value>
<Value name="23">
<Value>RemarkTime</Value>
</Value>
<Value name="24">
<Value>VersionTypeCode</Value>
</Value>
<Value name="25">
<Value>SpecialFlag</Value>
</Value>
<Value name="26">
<Value>SpecialParam</Value>
</Value>
<Value name="27">
<Value>AdmType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.AdmTaskExecD</DataLocation>
<DefaultData>AdmTaskExecDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.AdmTaskExecD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.AdmTaskExecI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.AdmTaskExecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
