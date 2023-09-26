/// Function: 国际编码 对照 北京编码 entity 
/// CreateDate: 2016-12-20
/// Creator:  sunfengchao
Class web.Entity.CT.DKBICDContrast Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DKBICDContrast";

/// DKBCTRowId           
Property DKBCTRowId As %String;

/// 北京版代码
Property DBKCTPekCode As %String;

/// 北京版名称
Property DBKCTPekDesc As %String;

/// 国际版代码
Property DKBCTIntCode As %String;

/// 国际版英文名称
Property DKBCTIntDesc As %String;

/// 国际版中文名称
Property DBKCTIntLongDesc As %String;

}
