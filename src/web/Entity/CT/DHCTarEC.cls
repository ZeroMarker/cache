/// Function: 经济核算大类 实体类
/// Creator:  sunfengchao
/// CreateDate:2016-12-2
Class web.Entity.CT.DHCTarEC Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCTarEC";

/// ID号
Property TARTECRowId As %String;

/// 项目代码
Property TARTECCode As %String;

/// 项目名称
Property TARTECDesc As %String;

}
