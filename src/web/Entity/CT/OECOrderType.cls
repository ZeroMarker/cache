/// 名称: 系统医嘱类型维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-9-4
Class web.Entity.CT.OECOrderType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.OECOrderType";

/// RowId号
Property TYPRowId As %String;

/// 代码
Property TYPCode As %String;

/// 描述
Property TYPDesc As %String;

}
