Class DHCEPRFS.INST.ImportScan Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property EpisodeID As %String(TRUNCATE = 1);

Property MedRecordNo As %String(TRUNCATE = 1);

Property PatientName As %String(TRUNCATE = 1);

Property AdmDate As %String(TRUNCATE = 1);

Property DisDate As %String(TRUNCATE = 1);

Property ParamXML As %String(MAXLEN = 1000, TRUNCATE = 1);

//Q - 待生成， E - 正在生成， S - 生成完成

Property AdmTaskStatus As %String(TRUNCATE = 1);

Property AdmTaskQueueID As %String(TRUNCATE = 1);

Property AdmTaskQueueDate As %Date;

Property AdmTaskQueueTime As %Time;

Property AdmTaskExecuteID As %String(TRUNCATE = 1);

Property AdmTaskExecuteDate As %Date;

Property AdmTaskExecuteTime As %Time;

Property AdmTaskSucceedID As %String(TRUNCATE = 1);

Property AdmTaskSucceedDate As %Date;

Property AdmTaskSucceedTime As %Time;

Property ActUserID As %String(TRUNCATE = 1);

Property ActDate As %Date;

Property ActTime As %Time;

Index IdxEpisodeID On EpisodeID;

Index IdxMedRecordNo On (MedRecordNo, AdmDate, DisDate);

Index IdxActDateTime On (ActDate, ActTime);

Index IdxAdmTaskQueue On AdmTaskQueueID;

Index IdxAdmTaskExecute On AdmTaskExecuteID;

Index IdxAdmTaskSucceed On AdmTaskSucceedID;

Storage Default
{
<Data name="ImportScanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>RegNo</Value>
</Value>
<Value name="4">
<Value>PatientName</Value>
</Value>
<Value name="5">
<Value>AdmDate</Value>
</Value>
<Value name="6">
<Value>DisDate</Value>
</Value>
<Value name="7">
<Value>ParamXML</Value>
</Value>
<Value name="8">
<Value>ActUserID</Value>
</Value>
<Value name="9">
<Value>ActDate</Value>
</Value>
<Value name="10">
<Value>ActTime</Value>
</Value>
<Value name="11">
<Value>AdmTaskStatus</Value>
</Value>
<Value name="12">
<Value>AdmTaskQueueID</Value>
</Value>
<Value name="13">
<Value>AdmTaskExecuteID</Value>
</Value>
<Value name="14">
<Value>AdmTaskSucceedID</Value>
</Value>
<Value name="15">
<Value>MedRecordNo</Value>
</Value>
<Value name="16">
<Value>AdmTaskQueueDate</Value>
</Value>
<Value name="17">
<Value>AdmTaskQueueTime</Value>
</Value>
<Value name="18">
<Value>AdmTaskExecuteDate</Value>
</Value>
<Value name="19">
<Value>AdmTaskExecuteTime</Value>
</Value>
<Value name="20">
<Value>AdmTaskSucceedDate</Value>
</Value>
<Value name="21">
<Value>AdmTaskSucceedTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.ImportScanD</DataLocation>
<DefaultData>ImportScanDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.ImportScanD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.ImportScanI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.ImportScanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
