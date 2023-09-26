/// 名称: 急诊情况维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-31
Class web.Entity.CT.MRCEmergencyCondition Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.MRCEmergencyCondition";

/// RowId号
Property EMCRowId As %String;

/// 代码
Property EMCCode As %String;

/// 描述
Property EMCDesc As %String;

/// 开始日期
Property EMCDateFrom As %String;

/// 结束日期
Property EMCDateTo As %String;

}
