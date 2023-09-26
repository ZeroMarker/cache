Class EMRinstance.AdmMRecordStatus Extends %Persistent
{

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 病历是否全部完成
Property CompletedStatus As %String(TRUNCATE = 1);

/// 病案是否质控确认
Property MCompletedStatus As %String(TRUNCATE = 1);

/// 病历全部完成日期
Property FinishDate As %Date;

/// 病历全部完成时间
Property FinishTime As %Time;

/// 病案确定日期
Property MFinishDate As %Date;

/// 病案确定时间
Property MFinishTime As %Time;

/// 病历提交人
Property UserID As %String;

/// 病案确定人
Property MUserID As %String;

Index IdxEpisodeID On EpisodeID;

Storage Default
{
<Data name="AdmMRecordStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>CompletedStatus</Value>
</Value>
<Value name="4">
<Value>FinishDate</Value>
</Value>
<Value name="5">
<Value>FinishTime</Value>
</Value>
<Value name="6">
<Value>UserID</Value>
</Value>
<Value name="7">
<Value>MCompletedStatus</Value>
</Value>
<Value name="8">
<Value>MFinishDate</Value>
</Value>
<Value name="9">
<Value>MFinishTime</Value>
</Value>
<Value name="10">
<Value>MUserID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.AdmMRecordStatusD</DataLocation>
<DefaultData>AdmMRecordStatusDefaultData</DefaultData>
<IdLocation>^DHCEMRI.AdmMRecordStatusD</IdLocation>
<IndexLocation>^DHCEMRI.AdmMRecordStatusI</IndexLocation>
<StreamLocation>^DHCEMRI.AdmMRecordStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
