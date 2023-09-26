/// 名称: 系统医嘱状态维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-9-4
Class web.Entity.CT.OECOrderStatus Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.OECOrderStatus";

/// RowId号
Property OSTATRowId As %String;

/// 代码
Property OSTATCode As %String;

/// 描述
Property OSTATDesc As %String;

/// 是否激活
Property OSTATActivate As %String;

}
