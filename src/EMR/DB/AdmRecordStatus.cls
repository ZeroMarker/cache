/// Desc:       病历全部完成状态表
/// Creator:    lifengbo
/// CreateDate: 2023-04-17
Class EMR.DB.AdmRecordStatus Extends %Persistent
{

/// 就诊号
Property EpisodeID As User.PAAdm;

/// 病历提交状态（1：提交，0：撤销 -1 退回 -2:召回）
Property CompletedStatus As %String(TRUNCATE = 1);

/// 病历全部完成日期
Property FinishDate As %Date;

/// 病历全部完成时间
Property FinishTime As %Time;

/// 病历提交人
Property UserID As User.SSUser;

/// 操作人IP地址
Property IPAddress As %String(TRUNCATE = 1);

/// 操作产品模块来源
Property ProductSource As %String(TRUNCATE = 1);

Index IdxEpisodeID On EpisodeID;

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
<DataLocation>^EMR.DB.AdmRecordStatusD</DataLocation>
<DefaultData>AdmRecordStatusDefaultData</DefaultData>
<IdLocation>^EMR.DB.AdmRecordStatusD</IdLocation>
<IndexLocation>^EMR.DB.AdmRecordStatusI</IndexLocation>
<StreamLocation>^EMR.DB.AdmRecordStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
