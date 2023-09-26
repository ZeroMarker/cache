/// Function: 社区授权类
/// Creator:  sunfengchao
/// CreateDate:2016-5-10
Class web.DHCBL.Authorize.CTCommunity Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "CT_Community";

Parameter EntityClassName = "web.Entity.CT.CTCommunity";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.ARCTariff).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
  s strAutMenu=##class(web.DHCBL.Authorize.CTCommunity).DHCGetDataByReference(ObjectType,ObjectReference)
  q strAutMenu
}

}
