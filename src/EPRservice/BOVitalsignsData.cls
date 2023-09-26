/// 名称：EPRservice.BOVitalsignsData
/// 描述：根据EpisodeID,查询患者指定项目的生命体征信息,并且可以通过时间进行数据的筛选
/// 创建者：Lifengbo
/// 创建时间 2012-05-31
Class EPRservice.BOVitalsignsData Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "VitalsignsDataService";

ClassMethod SelectVitalsignsList(EpisodeID As %String, ArgITMStr As %String, StDate As %String, EndDate As %String, AStartPage As %String, AEndPage As %String) As EPRservice.dataset.EVitalsignslistDataset [ WebMethod ]
{
	//<+> added on 2013-04-12 BY CYY, 处理默认非法默认日期，如 2012/1/1 为2012-1-1
	s StDate = $p(StDate, " ", 1)
	s StDate = $Tr(StDate, "/","-")
	s EndDate = $p(EndDate, " ", 1)
	s EndDate = $Tr(EndDate, "/","-")
	
	s result=##class(EPRservice.dataset.EVitalsignslistDataset).%New()
	d result.SetArgs(EpisodeID,ArgITMStr,StDate,EndDate,AStartPage,AEndPage)
	q result
}

}
