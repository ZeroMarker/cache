/// Function: 皮试备注
/// CreateDate: 2017-2-18
/// Creator:  sunfengchao
Class web.DHCBL.Authorize.OECAction Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "OEC_Action";

Parameter EntityClassName = "web.Entity.CT.OECAction";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.OECAction).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.OECAction).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
