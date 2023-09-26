Class EMRservice.entity.EAdmTaskExec Extends %RegisteredObject
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

Property TaskDate As %Date;

Property TaskTime As %Time;

Property TaskRemark As %String(MAXLEN = 2000, TRUNCATE = 1);

Property RemarkDate As %Date;

Property RemarkTime As %Time;

}
