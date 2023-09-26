/// Function: 地理信息-地址维护 授权类 
/// Creator:  sunfengchao
/// CreateDate: 2015-11-12
Class web.DHCBL.Authorize.CTAddress Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "CT_Address";

Parameter EntityClassName = "web.Entity.CT.CTAddress";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.CTAddress).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
  s strAutMenu=##class(web.DHCBL.Authorize.CTAddress).DHCGetDataByReference(ObjectType,ObjectReference)
  q strAutMenu
}

}
