Class EPRservice.BOPreviewChecker Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "PreviewCheckerInfo";

ClassMethod GetLogInfoByCreateDate(ACreateDate As %String) As EPRservice.dataset.EEPRLogsByCreateDateDataset [ WebMethod ]
{
	s ACreateDate=$tr(ACreateDate,"/","-")
	Set result=##class(EPRservice.dataset.EEPRLogsByCreateDateDataset).%New()
	do result.SetArgs(ACreateDate)
	Quit result
}

ClassMethod GetLogInfoByPat(AEpisodeNo As %String, APatientNo As %String) As EPRservice.dataset.EEPRLogsByPatDataset [ WebMethod ]
{
	Set result=##class(EPRservice.dataset.EEPRLogsByPatDataset).%New()
	do result.SetArgs(AEpisodeNo, APatientNo)
	Quit result
}

ClassMethod GetLogInfoByEPImageLog(ATimeSlice As %String, FlagClass As %String = "", AHospitalID As %String = "") As EPRservice.dataset.EEPRLogsByEPImageLogDataset [ WebMethod ]
{
	s AHospitalID = $g(AHospitalID)
	s:(AHospitalID = $C(0)) AHospitalID = ""
	
	set result = ##Class(EPRservice.dataset.EEPRLogsByEPImageLogDataset).%New()
	do result.SetArgs(ATimeSlice,FlagClass,AHospitalID)
	quit result
}

ClassMethod GetLogInfoByLogAndPat(AEpisodeNo As %String, APatientNo As %String) As EPRservice.dataset.EEPRLogsByLogAndPatDataset [ WebMethod ]
{
	set result = ##Class(EPRservice.dataset.EEPRLogsByLogAndPatDataset).%New()
	do result.SetArgs(AEpisodeNo, APatientNo)
	quit result
}

}
