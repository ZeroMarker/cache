/// Function: 病人管理--职员职位 授权类
/// Creator:  sunfengchao
/// CreateDate: 2015-2-5
Class web.DHCBL.Authorize.CTEmpFunc Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "CT_EmpFunc";

Parameter EntityClassName = "web.Entity.CT.CTEmpFunc";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// Function:获取授权的Data
/// w ##class(web.DHCBL.Authorize.CTEmpFunc).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.CTEmpFunc).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
