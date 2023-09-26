/// Function: 入院病情维护 数据授权类
/// Creator:  sunfengchao
/// CreateDate: 2016-1-13
Class web.DHCBL.Authorize.PACReferralPriority Extends web.BDP.sys.ExtPreferences
{

/// w ##class(web.DHCBL.Authorize.PACReferralPriority).GetTreeJson("menuTreeRoot","G","1")
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "PAC_ReferralPriority";

Parameter EntityClassName = "web.Entity.CT.PACReferralPriority";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
  s strAutJson=##class(web.DHCBL.Authorize.PACReferralPriority).DHCGetDataByReference(ObjectType,ObjectReference)
  q strAutJson
}

}
