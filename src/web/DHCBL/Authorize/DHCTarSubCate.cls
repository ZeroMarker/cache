/// Function: 计费-收费项目子类 数据授权类 
/// Creator:  sunfengchao
/// CreateDate:2016-12-2
Class web.DHCBL.Authorize.DHCTarSubCate Extends web.BDP.sys.ExtPreferences
{

/// 数据授权、
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "DHC_TarSubCate";

Parameter EntityClassName = "web.Entity.CT.DHCTarSubCate";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.DHCTarSubCate).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.DHCTarSubCate).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
