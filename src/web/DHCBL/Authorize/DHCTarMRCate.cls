/// Function: 病案首页子类 数据授权类
/// Creator:  sunfengchao
/// CreateDate:2016-12-5
Class web.DHCBL.Authorize.DHCTarMRCate Extends web.BDP.sys.ExtPreferences
{

/// 数据授权、
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "DHC_TarMRCate";

Parameter EntityClassName = "web.Entity.CT.DHCTarMRCate";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.DHCTarMRCate).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.DHCTarMRCate).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
