/// Creator:基础数据平台组 孙凤超
/// CreateDate:2012-08-30
/// Desc:资源组
Class web.Entity.CT.RBCEquipmentGroup Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.RBCEquipmentGroup";

Property GRPRowId As %String;

/// ID
Property GRPCode As %String;

/// 代码
Property GRPDesc As %String;

/// 描述
Property GRPDateFrom As %String;

/// 开始日期
Property GRPDateTo As %String;

///    结束日期

}
