/// 名称:药学-频次分发时间实体类
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2012-8-30
Class web.Entity.CT.PHCDispensingTime Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PHCDispensingTime";

Property PHCDTPHCFRParRef As %String;

// RowId

Property PHCDTRowId As %String;

// ChildSub

Property PHCDTChildSub As %String;

// 分发时间

Property PHCDTTime As %String;

// 分发时间描述 add 2020-11-04

Property PHCDTTimeDesc As %String;

}
