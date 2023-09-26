/// Function: CTHealthCareArea 实体类
/// Creator:  sunfengchao
/// CreateDate: 2015-3-3
Class web.Entity.CT.CTHealthCareArea Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTHealthCareArea";

Property HCARowId As %String;

/// 代码
Property HCACode As %String;

/// 描述
Property HCADesc As %String;

/// 开始日期
Property HCADateFrom As %String;

/// 结束日期
Property HCADateTo As %String;

/// 健康区域
Property HCAHCRDR As %String;

}
