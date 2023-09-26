/// Function: 新病案首页子类
/// Creator:  sunfengchao
/// CreateDate:2016-12-5
Class web.Entity.CT.DHCNewTarMRCate Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCNewTarMRCate";

/// RowId
Property NTARMCRowId As %String;

/// 项目代码
Property NTARMCCode As %String;

/// 项目名称
Property NTARMCDesc As %String;

/// 新病案首页大类
Property NTARMCDR As %String;

}
