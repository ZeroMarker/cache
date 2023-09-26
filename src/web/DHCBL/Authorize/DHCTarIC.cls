/// Function: 计费-住院项目大类 授权类 
/// Creator:  sunfengchao
/// CreateDate:2016-12-2
Class web.DHCBL.Authorize.DHCTarIC Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "DHC_TarIC";

Parameter EntityClassName = "web.Entity.CT.DHCTarIC";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.DHCTarIC).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.DHCTarIC).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
