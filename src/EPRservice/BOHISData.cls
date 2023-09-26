Class EPRservice.BOHISData Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// Parameter LOCATION = "http://10.10.141.189/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "HISDataService";

/// Creator：      Candy
/// CreateDate：   2011-05-26
/// Description:： 根据病人PatID,就诊开始日期SPAADMDate，就诊结束日期EPAADMDate 查询患者的就诊信息
/// Table： PA_ADM
/// Input： 病人PatID
/// Return：就诊信息列表
/// "126053","2008-10-10","2009-10-10"  , SPAADMDate As %String, EPAADMDate As %String     
ClassMethod GetEpisodeListByPID(PatID As %String) As EPRservice.dataset.EEpisodeListByPIdDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.EEpisodeListByPIdDataset).%New()
	;d result.SetArgs(PatID,SPAADMDate,EPAADMDate)
	d result.SetArgs(PatID)
	q result
}

}
