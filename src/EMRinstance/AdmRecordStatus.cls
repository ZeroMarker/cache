/// Desc:       病历全部完成状态表
/// Creator:    DongLuLu
/// CreateDate: 2016-7-18
Class EMRinstance.AdmRecordStatus Extends %Persistent
{

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 病历提交状态（1：提交，0：撤销 -1 退回 -2:召回）
Property CompletedStatus As %String(TRUNCATE = 1);

/// 病历全部完成日期
Property FinishDate As %Date;

/// 病历全部完成时间
Property FinishTime As %Time;

/// 病历提交人
Property UserID As %String;

/// 操作人IP地址
Property IPAddress As %String(TRUNCATE = 1);

/// 操作产品模块来源
Property ProductSource As %String(TRUNCATE = 1);

Index IdxEpisodeID On EpisodeID;

Index IdxDateTimeEpisodeID On (FinishDate, FinishTime, EpisodeID);

Storage Default
{
<Data name="AdmRecordStatusDefaultData">
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
<Value>IPAddress</Value>
</Value>
<Value name="8">
<Value>ProductSource</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.AdmRecordStatusD</DataLocation>
<DefaultData>AdmRecordStatusDefaultData</DefaultData>
<IdLocation>^DHCEMRI.AdmRecordStatusD</IdLocation>
<IndexLocation>^DHCEMRI.AdmRecordStatusI</IndexLocation>
<StreamLocation>^DHCEMRI.AdmRecordStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
