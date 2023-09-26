/// Function: 计费-住院项目子类 
/// Creator:  sunfengchao
/// CreateDate:2016-12-2
Class web.Entity.CT.DHCTarInpatCate Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCTarInpatCate";

///  TARIC_RowId       
Property TARICRowId As %String;

/// 代码
Property TARICCode As %String;

/// 描述
Property TARICDesc As %String;

/// 住院项目大类
Property TARICTARTICDR As %String;

}
