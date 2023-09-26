/// Function:资源定义 数据授权
/// CreateDate:2014-12-15
/// Creator:基础数据平台公共产品组 孙凤超
/// Table:  RB_Resource
Class web.DHCBL.Authorize.RBResource Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "RB_Resource";

Parameter EntityClassName = "web.Entity.CT.RBResource";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.RBResource).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.RBResource).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
