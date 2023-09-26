Class web.CDSSEntity.Demo.DEMOTasks Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.DEMOTasks";

Property ID As %String;

/// 任务名称
Property TaskName As %String;

/// 任务目的
Property TaskTarget As %String;

/// 文书类型（ALL/入院记录）
Property DocumentType As %String;

/// 选定的患者ID_是否命中（ID_0,...,ID_1）逗号分隔
Property PatientIDs As %String;

/// 创建人员
Property CreateUser As %String;

/// 创建时间
Property CreateTime As %String;

/// 命中率
Property HitRate As %String;

}
