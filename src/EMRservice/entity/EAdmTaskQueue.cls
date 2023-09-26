Class EMRservice.entity.EAdmTaskQueue Extends %RegisteredObject
{

Property ID As %String;

Property EpisodeID As %String(TRUNCATE = 1);

Property AdmDate As %Date;

Property Priority As %Integer;

/// FP 首页质控
Property TaskType As %String(TRUNCATE = 1);

Property CreateCount As %Integer;

Property CandidateDate As %Date;

Property CandidateTime As %Time;

}
