/// Function: 国际协定数据授权类
/// Creator:  sunfengchao
/// CreateDate:2015-3-4
Class web.DHCBL.Authorize.CTInternatAgreem Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "CT_InternatAgreem";

Parameter EntityClassName = "web.Entity.CT.CTInternatAgreem";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.CTInternatAgreem).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.CTInternatAgreem).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
