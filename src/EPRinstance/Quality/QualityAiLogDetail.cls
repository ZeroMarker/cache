/// ************************************************************
/// * Class Name:	EPRinstance.Quality.QualityAiLogDetail
/// * Description:	内涵质控触犯日志明细
/// * Author:		QY
/// * Create Date:	2021
/// ************************************************************/
Class EPRinstance.Quality.QualityAiLogDetail Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxEpisode On EpisodeID;

Index IdxAiLog On TheAiLog;

Index IdxEntryDR On EntryDR;

Index IdxTriggerDate On (TriggerDate, EpisodeID);

Index IdxEntryDRStatus On (TheAiLog, EntryDR, Status);

Relationship TheAiLog As EPRinstance.Quality.QualityAiLog [ Cardinality = parent, Inverse = Details ];

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// EntryDR
Property EntryDR As %String(TRUNCATE = 1);

/// 内涵检测错误提示内容
Property Title As %String(MAXLEN = 500, TRUNCATE = 1);

/// 内涵质控运行@后内容备份
Property ResumeText As %String(MAXLEN = 500, TRUNCATE = 1);

/// 状态 E 未修复 R 修复
Property Status As %String(TRUNCATE = 1);

/// 触犯日期
Property TriggerDate As %String(TRUNCATE = 1);

/// 触犯时间
Property TriggerTime As %String(TRUNCATE = 1);

/// 触犯时主管医生
Property TriggerUserDR As %String(TRUNCATE = 1);

/// 触犯时科室
Property TriggerLocDR As %String(TRUNCATE = 1);

/// 修复日期
Property RepairDate As %String(TRUNCATE = 1);

/// 修复时间
Property RepairTime As %String(TRUNCATE = 1);

/// 修复时主管医生
Property RepairUserDR As %String(TRUNCATE = 1);

/// 修复时科室
Property RepairLocDR As %String(TRUNCATE = 1);

Storage Default
{
<Data name="QualityAiLogDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>EntryDR</Value>
</Value>
<Value name="4">
<Value>Title</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>TriggerDate</Value>
</Value>
<Value name="8">
<Value>TriggerTime</Value>
</Value>
<Value name="9">
<Value>TriggerUserDR</Value>
</Value>
<Value name="10">
<Value>RepairDate</Value>
</Value>
<Value name="11">
<Value>RepairTime</Value>
</Value>
<Value name="12">
<Value>RepairUserDR</Value>
</Value>
<Value name="13">
<Value>TriggerLocDR</Value>
</Value>
<Value name="14">
<Value>RepairLocDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Details")</DataLocation>
<DefaultData>QualityAiLogDetailDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Details")</IdLocation>
<IndexLocation>^DHCEPRQ.QualityAiLogDetailI</IndexLocation>
<StreamLocation>^DHCEPRQ.QualityAiLogDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
