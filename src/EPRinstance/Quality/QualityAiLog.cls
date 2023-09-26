/// ************************************************************
/// * Class Name:	EPRinstance.Quality.QualityAiLog
/// * Description:	内涵质控触犯日志汇总
/// * Author:		QY
/// * Create Date:	2021
/// ************************************************************/
Class EPRinstance.Quality.QualityAiLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxEpisode On EpisodeID;

Index IdxActionEpisode On (Action, EpisodeID);

Index IdxEpisodeAction On (EpisodeID, Action) [ Unique ];

Relationship Details As EPRinstance.Quality.QualityAiLogDetail [ Cardinality = children, Inverse = TheAiLog ];

/// 患者阶段 A 在院
Property Action As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 触犯条目总数量
Property Num As %String(TRUNCATE = 1);

/// 修复数量
Property RepairNum As %String(TRUNCATE = 1);

/// 错误数量（未修复）
Property ErrorNum As %String(TRUNCATE = 1);

Storage Default
{
<Data name="QualityAiLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Action</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>Num</Value>
</Value>
<Value name="5">
<Value>RepairNum</Value>
</Value>
<Value name="6">
<Value>ErrorNum</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.QualityAiLogD</DataLocation>
<DefaultData>QualityAiLogDefaultData</DefaultData>
<IdLocation>^DHCEPRQ.QualityAiLogD</IdLocation>
<IndexLocation>^DHCEPRQ.QualityAiLogI</IndexLocation>
<StreamLocation>^DHCEPRQ.QualityAiLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
