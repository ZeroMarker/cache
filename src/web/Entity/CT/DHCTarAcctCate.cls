/// Function: 会计费用子类 实体类
/// Creator:  sunfengchao
/// CreateDate:2016-12-2
Class web.Entity.CT.DHCTarAcctCate Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCTarAcctCate";

/// ID               
Property TARACRowId As %String;

/// 项目代码
Property TARACCode As %String;

/// 项目名称
Property TARACDesc As %String;

/// 会计费用大类
Property TARACTARTACDR As %String;

}
