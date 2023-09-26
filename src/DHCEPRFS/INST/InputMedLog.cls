Class DHCEPRFS.INST.InputMedLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 操作人员
Property UserID As %String(TRUNCATE = 1);

/// 操作日期
Property ActiveDate As %Date;

/// 操作时间
Property ActiveTime As %Time;

/// 操作类型 MODIFY,CREATE,DELETE
Property ActiveType As %String(TRUNCATE = 1);

/// 类型 MEDRECORD,EPISODE,DIAGNOSIS,OPERATION
Property AType As %String(TRUNCATE = 1);

/// 病案号
Property MedRecordNo As %String(TRUNCATE = 1);

/// 归档病案号
Property MRMedRecordNo As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 归档就诊号
Property MREpisodeID As %String(TRUNCATE = 1);

/// 更新标志
Property Flag As %String(TRUNCATE = 1);

Index IdxUserID On (UserID, ActiveDate, ActiveTime);

Index IdxMedRecordNo On (MedRecordNo, ActiveDate, ActiveTime);

Index IdxEpisodeID On (EpisodeID, ActiveDate, ActiveTime);

Index IdxDateTime On (ActiveDate, ActiveTime);

Index IdxMREpisodeID On MREpisodeID;

Index IdxMRMedRecordNo On MRMedRecordNo;

Storage Default
{
<Data name="InputMedLogDefaultData">
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
<Value>ActiveType</Value>
</Value>
<Value name="5">
<Value>UserID</Value>
</Value>
<Value name="6">
<Value>AType</Value>
</Value>
<Value name="7">
<Value>EpisodeID</Value>
</Value>
<Value name="8">
<Value>MREpisodeID</Value>
</Value>
<Value name="9">
<Value>MRMedRecordNo</Value>
</Value>
<Value name="10">
<Value>MedRecordNo</Value>
</Value>
<Value name="11">
<Value>Flag</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.InputMedLogD</DataLocation>
<DefaultData>InputMedLogDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.InputMedLogD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.InputMedLogI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.InputMedLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
