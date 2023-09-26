Class EPRservice.entity.EMixInstanceLog Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

Property Action As %String(TRUNCATE = 1);

Property OperateDate As %String(TRUNCATE = 1);

Property FinalStatus As %String(TRUNCATE = 1);

Property InitStatus As %String(TRUNCATE = 1);

Property OperateTime As %String(TRUNCATE = 1);

Property OperateUserID As %String(TRUNCATE = 1);

Property OperateMachineIP As %String(TRUNCATE = 1);

Property RealOperateUserID As %String(TRUNCATE = 1);

Property OperateUserName As %String(TRUNCATE = 1);

/// 新框架日志使用-新框架标志
Property IsNewFramework As %String(TRUNCATE = 1);

/// 新框架日志使用-EpisodeID
Property EpisodeID As %String(TRUNCATE = 1);

/// 新框架日志使用-打印模板DocID
Property PrintTemplateDocID As %String(TRUNCATE = 1);

/// 新框架日志使用-界面模板DocID
Property TemplateDocID As %String(TRUNCATE = 1);

/// 新框架日志使用-状态条信息
Property StateInfo As %String(TRUNCATE = 1);

}
