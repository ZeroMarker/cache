/// Function:　征收代码授权类
/// Creator:   sunfengchao
/// CreateDate: 2015-10-29
Class web.DHCBL.Authorize.ARCTariff Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "ARC_Tariff";

Parameter EntityClassName = "web.Entity.CT.ARCTariff";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.ARCTariff).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
  s strAutMenu=##class(web.DHCBL.Authorize.ARCTariff).DHCGetDataByReference(ObjectType,ObjectReference)
  q strAutMenu
}

}
