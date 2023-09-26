/// 封锁病历患者列表
/// yhy
/// 2018-09-03
Class EPRmeta.Quality.LockPatient Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Index EpisodeIDIndex On EpisodeID [ Unique ];

//封锁操作者

Property UserID As %String(TRUNCATE = 1);

//就诊id

Property EpisodeID As %String(TRUNCATE = 1);

//封锁日期

Property StartDate As %String;

//是否对全部医生封锁

Property AllLock As %String(TRUNCATE = 1);

//解除封锁医生

Property IsUnLockUserID As %String(TRUNCATE = 1);

/// 是否封锁
Property IsLock As %String(TRUNCATE = 1);

Storage Default
{
<Data name="LockPatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>SSGroupID</Value>
</Value>
<Value name="4">
<Value>StartDate</Value>
</Value>
<Value name="5">
<Value>StartTime</Value>
</Value>
<Value name="6">
<Value>EndDate</Value>
</Value>
<Value name="7">
<Value>EndTime</Value>
</Value>
<Value name="8">
<Value>Foreverban</Value>
</Value>
<Value name="9">
<Value>IsAllowCopyPaste</Value>
</Value>
<Value name="10">
<Value>EpisodeID</Value>
</Value>
<Value name="11">
<Value>AllLock</Value>
</Value>
<Value name="12">
<Value>IsUnLockUserID</Value>
</Value>
<Value name="13">
<Value>IsLock</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.LockPatientD</DataLocation>
<DefaultData>LockPatientDefaultData</DefaultData>
<IdLocation>^DHCEPRM.LockPatientD</IdLocation>
<IndexLocation>^DHCEPRM.LockPatientI</IndexLocation>
<StreamLocation>^DHCEPRM.LockPatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
