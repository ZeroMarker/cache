/// Function: 授权类
/// Creator:  sunfengchao
/// CreateDate: 2015-1-4
Class web.DHCBL.Authorize.CTHealthCareArea Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "CT_HealthCareArea";

Parameter EntityClassName = "web.Entity.CT.CTHealthCareArea";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.CTHealthCareArea).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.CTHealthCareArea).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
