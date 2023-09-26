/// Function: 系统分娩状态
/// CreateDate:2012-8-14
/// Creator:基础数据平台组  孙凤超
Class web.Entity.CT.PACPregStatus Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACPregStatus";

Property PREGSTRowId As %String;

/// ID
Property PREGSTCode As %String;

/// 代码
Property PREGSTDesc As %String;

/// 描述
Property PREGSTDateFrom As %String;

/// 开始日期
Property PREGSTDateTo As %String;

///    结束日期

}
