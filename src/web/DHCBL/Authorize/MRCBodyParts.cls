/// Function: 电子病例- 身体部位 数据授权类
/// Creaotr:  基础数据平台 孙凤超
/// CreateDate: 2014-12-17
Class web.DHCBL.Authorize.MRCBodyParts Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "MRC_BodyParts";

Parameter EntityClassName = "web.Entity.CT.MRCBodyParts";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.MRCBodyParts).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.MRCBodyParts).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
