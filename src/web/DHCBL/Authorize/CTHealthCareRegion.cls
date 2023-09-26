/// Function: CTHealthCareRegion 基础数据授权类
/// CreateDate: 2015-3-3
/// Creator:　　sunfengchao
Class web.DHCBL.Authorize.CTHealthCareRegion Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "CT_HealthCareRegion";

Parameter EntityClassName = "web.Entity.CT.CTHealthCareRegion";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.CTHealthCareRegion).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.CTHealthCareRegion).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
