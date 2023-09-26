/// Function: 计费-收费项目大类 
/// Creator:  sunfengchao
/// CreateDate:2016-12-2
Class web.Entity.CT.DHCTarCate Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCTarCate";

/// RowId
Property TARCRowId As %String;

/// 项目代码
Property TARCCode As %String;

/// 项目名称
Property TARCDesc As %String;

}
