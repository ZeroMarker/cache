Class web.DHCEQ.Interface.Outer.DHCEQWarningInfo Extends %RegisteredObject
{

/// 描述:南方大学南方医院维修提醒信息
/// 入参:vStartDate:开始日期(YYYY-MM-DD) vEndDate:结束日期(YYYY-MM-DD)
/// 返回值:入库单号^入库年月^库房DR^供应商DR^单据日期^制单人
/// w ##Class(web.DHCEQ.Interface.Outer.DHCEQWarningInfo).WarningInfo()
ClassMethod WarningInfo(vStartDate As %String = "", vEndDate As %String = "")
{
	Set Info="南方大学南方医院维修提醒信息   "_##Class(web.DHCEQCommon).TransValueToPage(+$H,"date")
	
	Quit Info
}

}
