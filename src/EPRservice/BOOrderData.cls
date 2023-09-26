/// 名称：EPRservice.BOOrderData
/// 描述：获取HIS数据业务类
/// 创建者：Candyxu
/// 创建时间 20110819
Class EPRservice.BOOrderData Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "OrderDataService";

/// Creator：      Candy
/// CreateDate：   2011-08-19
/// Description:： 根据病人EpisodeID,开始日期SPAADMDate，结束日期EPAADMDate 等查询患者的医嘱信息
/// Table： 
/// Input： 
/// Return：医嘱信息列表
/// "126053","2008-10-10","2009-10-10"  , SPAADMDate As %String, EPAADMDate As %String     
ClassMethod SelectOrderList(EpisodeID As %String, SearchStartDate As %String, SearchEndDate As %String, CategoryID As %String, SubsortID As %String, LongOrd As %String, ShortOrd As %String, OrdStat As %String, ordPriority As %String = "") As EPRservice.dataset.OrderListByDataSet [ WebMethod ]
{
	if SearchStartDate = $c(0) s SearchStartDate =""
	if SearchEndDate =$c(0) s SearchEndDate = ""
	if CategoryID =$c(0) s CategoryID = ""
	if SubsortID =$c(0) s SubsortID = ""
	if LongOrd =$c(0) s LongOrd = ""
	if ShortOrd =$c(0) s ShortOrd = ""
	if OrdStat =$c(0) s OrdStat = ""
	if ordPriority =$c(0) s ordPriority = ""
	s result=##class(EPRservice.dataset.OrderListByDataSet).%New()
	d result.SetArgs(EpisodeID,SearchStartDate,SearchEndDate,CategoryID,SubsortID,LongOrd,ShortOrd,OrdStat,ordPriority)
	q result
}

}
