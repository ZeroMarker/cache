/// Function: 计费-收费项目子类  实体类 
/// Creator:  sunfengchao
/// CreateDate:2016-12-2
Class web.Entity.CT.DHCTarSubCate Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCTarSubCate";

/// RowId     
Property TARSCRowId As %String;

/// 项目代码
Property TARSCCode As %String;

/// 项目名称
Property TARSCDesc As %String;

/// 收费项目大类
Property TARSCTARCDR As %String;

/// 项目类型  add @2023-04-20
Property TARSCType As %Library.String;

}
