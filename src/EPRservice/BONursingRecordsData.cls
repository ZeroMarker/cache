/// 名称：EPRservice.BONursingRecordsData
/// 描述：根据EpisodeID,查询患者指定项目的护理记录单信息,并且可以通过时间进行数据的筛选
/// 创建者：niucaicai
/// 创建时间 2014-8-8
Class EPRservice.BONursingRecordsData Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "NursingRecordsDataService";

ClassMethod SelectNursingRecordsList(EpisodeID As %String, ArgITMStr As %String, StDate As %String, EndDate As %String, AStartPage As %String, AEndPage As %String) As EPRservice.dataset.ENursingRecordslistDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.ENursingRecordslistDataset).%New()
	d result.SetArgs(EpisodeID,ArgITMStr,StDate,EndDate,AStartPage,AEndPage)
	q result
}

}
