/// Creator:杨继鸿
/// CreatDate:2022-03-17
/// Description：CDSS演示评测系统-识别词触发任务集详情
/// Table：WDT.CDSS.TriggTasksDetail
Class web.CDSSEntity.Demo.TriggTasksDetail Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ SqlRowIdName = "", SqlTableName = "" ]
{

/// RowId
Property RowId As %String;

/// 患者基础信息表ID
Property PatientDR As %String;

/// 任务集ID
Property TaskDR As %String;

/// 状态 0-编辑/1-继续编辑
Property State As %String;

/// 操作人员
Property OperatorUser As %String;

/// 操作时间
Property OperationTime As %String;

Parameter PersistentClassName = "web.CDSSEntity.Demo.TriggTasksDetail";

}
