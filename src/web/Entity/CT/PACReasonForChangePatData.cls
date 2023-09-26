/// 名称: 改变理由维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-31
Class web.Entity.CT.PACReasonForChangePatData Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACReasonForChangePatData";

/// RowId号
Property RCHRowId As %String;

/// 代码
Property RCHCode As %String;

/// 描述
Property RCHDesc As %String;

/// 开始日期
Property RCHDateFrom As %String;

/// 结束日期
Property RCHDateTo As %String;

}
