/// Function: 地理信息- 街道/乡镇  
/// Creator:  sunfengchao
/// CreateDate: 2015-11-12
Class web.Entity.CT.CTLocalityType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTLocalityType";

/// ID号
Property LOCTYPERowId As %String;

/// 代码
Property LOCTYPECode As %String;

/// 描述
Property LOCTYPEDesc As %String;

/// 所属城市区域代码
Property LOCTYPENationalCode As %String;

/// 类型
Property LOCTYPEType As %String;

/// 是否激活
Property LOCTYPEActiveFlag As %String;

/// 所属城市区域描述
Property LOCTYPENationalDesc As %String;

}
