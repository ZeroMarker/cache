/// Function:　计费组 住院费用子类 基础数据授权类
/// Creator:   sunfengchao
/// CreateDate: 2016-12-3
/// Table:     DHC_TarInpatCate
Class web.DHCBL.Authorize.DHCTarInpatCate Extends web.BDP.sys.ExtPreferences
{

/// 数据授权、
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "DHC_TarInpatCate";

Parameter EntityClassName = "web.Entity.CT.DHCTarInpatCate";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.DHCTarInpatCate).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.DHCTarInpatCate).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

}
