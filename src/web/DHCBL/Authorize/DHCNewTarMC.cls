/// Function: 新病案首页大类 数据授权类
/// Creator:  sunfengchao
/// CreateDate:2016-12-5
Class web.DHCBL.Authorize.DHCNewTarMC Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "DHC_NewTarMC";

Parameter EntityClassName = "web.Entity.CT.DHCNewTarMC";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.DHCNewTarMC).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
    s strAutMenu=##class(web.DHCBL.Authorize.DHCNewTarMC).DHCGetDataByReference(ObjectType,ObjectReference)
    q strAutMenu
}

}
