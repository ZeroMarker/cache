/// 名称: 门诊费用大类 数据授权类
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2016-12-2
Class web.DHCBL.Authorize.DHCTarOutpatCate Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "DHC_TarOutpatCate";

Parameter EntityClassName = "web.Entity.CT.DHCTarOutpatCate";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.DHCTarOutpatCate).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.DHCTarOutpatCate).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
