/// Function:　经济核算大类 基础数据授权类
/// Creator:   sunfengchao
/// CreateDate: 2016-12-3
Class web.DHCBL.Authorize.DHCTarAC Extends web.BDP.sys.ExtPreferences
{

/// 数据授权、
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "DHC_TarAC";

Parameter EntityClassName = "web.Entity.CT.DHCTarAC";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.DHCTarAC).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.DHCTarAC).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
