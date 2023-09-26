/// 名称: 伤害原因维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-31
Class web.Entity.CT.PACCauseOfInjury Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACCauseOfInjury";

/// RowId号
Property INJURowId As %String;

/// 代码
Property INJUCode As %String;

/// 描述
Property INJUDesc As %String;

/// 开始日期
Property INJUDateFrom As %String;

/// 结束日期
Property INJUDateTo As %String;

}
