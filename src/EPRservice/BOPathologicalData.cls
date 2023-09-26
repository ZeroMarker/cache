/// EPRservice.BOPathologicalData
/// 描述：根据EpisodeID或者PatientID查询患者病理报告信息
/// 创建者：niucaicai
/// 创建时间 2014-8-12
Class EPRservice.BOPathologicalData Extends %SOAP.WebService
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "PathologicalDataService";

ClassMethod SelectPathologicalOrderList(AEpisodeID As %String, APatientID As %String, ArgStartNum As %String, ArgEndNum As %String, ArgQueryType As %String) As EPRservice.dataset.EPathologicalListDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.EPathologicalListDataset).%New()
	d result.SetArgs(AEpisodeID,APatientID,ArgStartNum,ArgEndNum,ArgQueryType)
	q result
}

ClassMethod SelectPathologicalReportList(AOrderRowID As %String, AReportID As %String) As EPRservice.dataset.EPathologicalReportDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.EPathologicalReportDataset).%New()
	d result.SetArgs(AOrderRowID,AReportID)
	q result
}

}
