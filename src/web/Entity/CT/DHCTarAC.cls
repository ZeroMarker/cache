/// Function: 会计费用大类  实体类
/// Creator:  sunfengchao
/// CreateDate:2016-12-2
Class web.Entity.CT.DHCTarAC Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCTarAC";

/// ID号          
Property TARTACRowId As %String;

/// 项目代码
Property TARTACCode As %String;

/// 项目名称
Property TARTACDesc As %String;

}
