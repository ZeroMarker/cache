Class web.DHCBL.Authorize.MRCDiagnosType Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "MRC_DiagnosType";

Parameter EntityClassName = "web.Entity.CT.MRCDiagnosType";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.MRCDiagnosType).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.MRCDiagnosType).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
