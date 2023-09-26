Class DHCEPRFS.ThirdParty.Srv.BJXHCommon Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "BJXHCommon";

/// 查询扫描病案
/// 入参：AStartDate -开始时间段 AEndDate-结束时间段
/// 返回值 结果集
ClassMethod GetScanLog(AStartDate As %String, AEndDate As %String) As %XML.DataSet [ WebMethod ]
{
	s:(AStartDate = $c(0)) AStartDate = ""
	s:(AEndDate = $c(0)) AEndDate = ""
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.ThirdParty.BL.BJXHCommon:GetScanLog")
	d obj.SetArgs(AStartDate,AEndDate)
	q obj
}

/// 查询扫描病案
/// 入参：AStartDate -开始时间段 AEndDate-结束时间段
/// 返回值 结果集
ClassMethod AddCreateLIS(AEpisodeID As %String) As %String [ WebMethod ]
{
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s ret = ##class(DHCEPRFS.ThirdParty.BL.BJXHCommon).AddCreateLIS(AEpisodeID)
	q ret
}

}
