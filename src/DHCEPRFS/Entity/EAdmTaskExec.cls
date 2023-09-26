Class DHCEPRFS.Entity.EAdmTaskExec Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

Property SysCode As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property MedRecordNo As %String(TRUNCATE = 1);

Property RegNo As %String(TRUNCATE = 1);

Property IPRecordNo As %String(TRUNCATE = 1);

Property OPRecordNo As %String(TRUNCATE = 1);

Property EPRecordNo As %String(TRUNCATE = 1);

Property Priority As %Integer;

Property AdmDate As %Date;

Property CandidateDate As %Date;

Property CandidateTime As %Time;

Property TaskDate As %Date;

Property TaskTime As %Time;

Property TaskRemark As %String(MAXLEN = 2000, TRUNCATE = 1);

Property IP As %String(MAXLEN = 20, TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

Property SchemeType As %String(TRUNCATE = 1);

Property TaskType As %String(TRUNCATE = 1);

Property CreateCount As %Integer;

Property RemarkDate As %Date;

Property RemarkTime As %Time;

Property VersionTypeCode As %String(TRUNCATE = 1);

Property SpecialFlag As %String(TRUNCATE = 1);

Property SpecialParam As %String(TRUNCATE = 1);

Property StartDate As %String(TRUNCATE = 1);

Property EndDate As %String(TRUNCATE = 1);

Property PatientName As %String(TRUNCATE = 1);

Property AdmLocID As %String(TRUNCATE = 1);

Property DisLocID As %String(TRUNCATE = 1);

Property ObservedNo As %String(TRUNCATE = 1);

Property AdmType As %String(TRUNCATE = 1);

}
