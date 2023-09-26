/// Function:  证件类型定义授权类
/// Creator:   sunfengchao
/// CreateDate:2016-6-23
Class web.DHCBL.Authorize.DHCCredType Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "DHC_CredType";

Parameter EntityClassName = "web.Entity.CT.DHCCredType";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
  s strAutJson=##class(web.DHCBL.Authorize.DHCCredType).DHCGetDataByReference(ObjectType,ObjectReference)
  q strAutJson
}

}
