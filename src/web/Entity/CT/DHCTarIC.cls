/// Function: 计费-住院项目大类 
/// Creator:  sunfengchao
/// CreateDate:2016-12-2
Class web.Entity.CT.DHCTarIC Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCTarIC";

/// ID号      
Property TARTICRowId As %String;

/// 代码
Property TARTICCode As %String;

/// 描述
Property TARTICDesc As %String;

}
