/// 名称: 系统医嘱结果状态维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-9-4
Class web.Entity.CT.OECResultStatus Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.OECResultStatus";

/// RowId号
Property RESSTRowId As %String;

/// 代码
Property RESSTCode As %String;

/// 描述
Property RESSTDesc As %String;

}
