/// Function: 经济核算子类 实体类
/// Creator:  sunfengchao
/// CreateDate:2016-12-2
Class web.Entity.CT.DHCTarEMCCate Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCTarEMCCate";

/// ID      
Property TARECRowId As %String;

/// 项目代码
Property TARECCode As %String;

/// 项目名称
Property TARECDesc As %String;

/// / 经济核算大类
Property TARECTARTECDR As %String;

}
