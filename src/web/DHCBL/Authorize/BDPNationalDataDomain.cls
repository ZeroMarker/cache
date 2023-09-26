/// Function:国家标准数据源值域授权类
/// Creator: sunfengchao
/// CreateDate: 2016-3-6
Class web.DHCBL.Authorize.BDPNationalDataDomain Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "BDP_NationalDataDomain";

Parameter EntityClassName = "web.Entity.CT.BDPNationalDataDomain";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.BDPNationalDataDomain).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
  s strAutMenu=##class(web.DHCBL.Authorize.BDPNationalDataDomain).DHCGetDataByReference(ObjectType,ObjectReference)
  q strAutMenu
}

}
