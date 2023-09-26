/// 名称: 系统医嘱优先级维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-9-4
Class web.Entity.CT.OECPriority Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.OECPriority";

/// RowId号
Property OECPRRowId As %String;

/// 代码
Property OECPRCode As %String;

/// 描述
Property OECPRDesc As %String;

/// 优先级
Property OECPRPriority As %String;

}
