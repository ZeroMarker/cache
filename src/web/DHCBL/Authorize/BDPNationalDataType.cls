Class web.DHCBL.Authorize.BDPNationalDataType Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "BDP_NationalDataType";

Parameter EntityClassName = "web.Entity.CT.BDPNationalDataType";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.BDPBL.Authorize.BDPNationalDataType).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
  s strAutMenu=##class(web.DHCBL.Authorize.BDPNationalDataType).BDPGetDataByReference(ObjectType,ObjectReference)
  q strAutMenu
}

}
