Class DHCEPRFS.Entity.EAdmMRStatus Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

// 系统编码(DHC)

Property SysCode As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

// 最终结算标识

Property FlagFinalAccount As %String;

Property FlagFinalAccountDate As %Date;

Property FlagFinalAccountTime As %Time;

// 病历完成确认标识

Property FlagMRCompletion As %String;

Property FlagMRCompletionDate As %Date;

Property FlagMRCompletionTime As %Time;

Property FlagFinalAccountUserID As %String;

Property FlagMRCompletionUserID As %String;

//必要条件标识

Property NecessaryCondition As %String;

Property NecessaryConditionDate As %Date;

Property NecessaryConditionTime As %Time;

Property NecessaryConditionUserID As %String;

}
