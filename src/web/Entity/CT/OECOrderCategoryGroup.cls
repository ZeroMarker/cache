/// 名称: 医嘱类组
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-31
Class web.Entity.CT.OECOrderCategoryGroup Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.OECOrderCategoryGroup";

/// RowId号
Property OCGRPRowId As %String;

/// 代码
Property OCGRPCode As %String;

/// 描述
Property OCGRPDesc As %String;

/// 开始日期
Property OCGRPDateFrom As %String;

/// 结束日期
Property OCGRPDateTo As %String;

}
