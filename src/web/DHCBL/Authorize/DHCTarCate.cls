/// Function: 计费-收费项目大类 数据授权类 
/// Creator:  sunfengchao
/// CreateDate:2016-12-2
Class web.DHCBL.Authorize.DHCTarCate Extends web.BDP.sys.ExtPreferences
{

/// 数据授权、
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "DHC_TarCate";

Parameter EntityClassName = "web.Entity.CT.DHCTarCate";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.DHCTarCate).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.DHCTarCate).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
