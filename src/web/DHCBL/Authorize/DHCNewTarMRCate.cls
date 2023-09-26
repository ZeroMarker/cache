/// Function: 新病案首页子类 数据授权类
/// Creator:  sunfengchao
/// CreateDate:2016-12-5
Class web.DHCBL.Authorize.DHCNewTarMRCate Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "DHC_NewTarMRCate";

Parameter EntityClassName = "web.Entity.CT.DHCNewTarMRCate";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
    s strAut=##class(web.DHCBL.Authorize.DHCNewTarMRCate).DHCGetDataByReference(ObjectType,ObjectReference)
    q strAut
}

}
