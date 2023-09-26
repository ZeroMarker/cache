/// Function:　病人管理-健康医护人员 基础数据授权类
/// Creator:   sunfengchao
/// CreateDate: 2015-3-3
/// Table:     CT_HealthCareProvider
Class web.DHCBL.Authorize.CTHealthCareProvider Extends web.BDP.sys.ExtPreferences
{

/// 数据授权、
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "CT_HealthCareProvider";

Parameter EntityClassName = "web.Entity.CT.CTHealthCareProvider";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.CTHealthCareProvider).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.CTHealthCareProvider).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
