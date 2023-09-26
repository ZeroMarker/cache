/// web.DHCSTPHCMWebService
Class web.DHCSTPHCMWebService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "PHCMPubService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhccmedical.com.cn";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// dthealth数据库地址
Parameter LOCATION = "http://192.168.102.235/dthealth/web";

/// TODO: add arguments and implementation.
/// Descript: 公共服务接口
/// InvCmPubService
Method InvCmPubService(action As %String, Params As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	D ##Class(web.DHCSTPHCMActionFactory).AcitonProxy(action, Params, OutBinStream)
	Q OutBinStream
}

/// Descript: 获取病人的基本信息
/// GetPatEssInfo
Method GetPatEssInfo(PatientID As %String, EpisodeID As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	d OutBinStream.Write(##Class(web.DHCAPPExaReportQuery).GetPatEssInfo(PatientID,EpisodeID))
	Q OutBinStream
}

}
