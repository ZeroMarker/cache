/// Creator:基础数据平台组 孙凤超
/// CreateDate:2012-8-14
/// Function:婴儿先天畸形 实体类
Class web.Entity.CT.PACCongenitalAnomalies Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.PACCongenitalAnomalies";

Property CONGANOMRowId As %String;

/// ID
Property CONGANOMCode As %String;

/// 代码
Property CONGANOMDesc As %String;

/// 描述
Property CONGANOMDateFrom As %String;

/// 开始日期
Property CONGANOMDateTo As %String;

/// 结束日期
Property CONGANOMActive As %String;

}
