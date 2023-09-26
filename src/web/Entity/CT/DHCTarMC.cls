/// Function: 旧病案首页大类 实体类
/// Creator:  sunfengchao
/// CreateDate:2016-12-2
Class web.Entity.CT.DHCTarMC Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCTarEC";

/// ID号      
Property TARTMCRowId As %String;

/// 项目代码
Property TARTMCCode As %String;

/// 项目名称
Property TARTMCDesc As %String;

}
