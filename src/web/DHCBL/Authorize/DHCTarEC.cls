/// Function:　经济核算大类 基础数据授权类
/// Creator:   sunfengchao
/// CreateDate: 2016-12-3
Class web.DHCBL.Authorize.DHCTarEC Extends web.BDP.sys.ExtPreferences
{

/// 数据授权、
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "DHC_TarEC";

Parameter EntityClassName = "web.Entity.CT.DHCTarEC";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.DHCTarEC).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.DHCTarEC).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
