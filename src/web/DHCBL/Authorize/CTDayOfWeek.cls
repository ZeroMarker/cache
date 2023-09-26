/// Function: 资源预约-星期 数据授权类
/// Creator: sunfengchao
/// CreateDate: 2015-5-28 
Class web.DHCBL.Authorize.CTDayOfWeek Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "CT_DayOfWeek";

Parameter EntityClassName = "web.Entity.CT.CTDayOfWeek";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.CTDayOfWeek).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.CTDayOfWeek).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
