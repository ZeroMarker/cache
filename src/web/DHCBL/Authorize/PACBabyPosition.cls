/// 胎位授权类
/// 基础数据平台 孙凤超
Class web.DHCBL.Authorize.PACBabyPosition Extends web.BDP.sys.ExtPreferences
{

/// w ##class(web.DHCBL.Authorize.CTSex).SaveAuthorizeData("G","1","[{ID:1},{ID:2}]")
/// w ##class(web.DHCBL.Authorize.CTSex).GetTreeJson("menuTreeRoot","G","1")
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "PAC_BabyPosition";

Parameter EntityClassName = "web.Entity.CT.PACBabyPosition";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAut=##class(web.DHCBL.Authorize.PACBabyPosition).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAut
}

}
