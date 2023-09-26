/// Function: 国际协定实体类
/// Creator:  sunfengchao
/// CreateDate:2015-3-4
/// Others:   INAGRowId INAGCode INAGDesc INAGCountryDR
Class web.Entity.CT.CTInternatAgreem Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTInternatAgreem";

Property INAGRowId As %String;

/// 代码
Property INAGCode As %String;

/// 描述
Property INAGDesc As %String;

/// 国家
Property INAGCountryDR As %String;

}
