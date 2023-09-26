/// 名称: 系统转移
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-29
Class web.Entity.CT.PACTransType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACTransType";

/// RowId
Property TRANSTYPRowId As %String;

/// 代码
Property TRANSTYPCode As %String;

/// 描述
Property TRANSTYPDesc As %String;

}
