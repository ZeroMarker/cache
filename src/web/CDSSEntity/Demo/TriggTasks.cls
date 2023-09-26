/// Creator:杨继鸿
/// CreatDate:2022-03-17
/// Description：CDSS演示评测系统-识别词触发任务集 实体类
/// Table：WDT.CDSS.TriggTasks
Class web.CDSSEntity.Demo.TriggTasks Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ SqlRowIdName = "", SqlTableName = "" ]
{

/// RowId
Property RowId As %String;

/// 任务名称
Property TaskName As %String;

/// 任务目的
Property TaskTarget As %String;

/// 创建人员
Property CreateUser As %String;

/// 创建时间
Property CreateTime As %String;

/// 数据类型(病历导入/编辑新增)
Property DocumentType As %String;

Parameter PersistentClassName = "web.CDSSEntity.Demo.TriggTasks";

}
