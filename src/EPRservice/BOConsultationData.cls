/// EPRservice.BOConsultationData
/// 描述：根据EpisodeID或者PatientID查询患者会诊信息
/// 创建者：niucaicai
/// 创建时间 2014-11-24
Class EPRservice.BOConsultationData Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ConsultationDataService";

ClassMethod GetConsultationData(AEpisodeID As %String, APatientID As %String, ArgStartNum As %String, ArgEndNum As %String, ArgQueryType As %String) As EPRservice.dataset.EConsultationDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.EConsultationDataset).%New()
	d result.SetArgs(AEpisodeID,APatientID,ArgStartNum,ArgEndNum,ArgQueryType)
	q result
}

}
