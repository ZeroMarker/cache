Class EPRservice.BOVersionHistory Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "VersionHistoryInfo";

ClassMethod AddVersionHistory(VersionHistoryInfos As %String) As %String [ WebMethod ]
{
	
	Set result=##class(EPRinstance.VersionHistory).AddVersionHistoryInfos(VersionHistoryInfos)	
	Quit result
}

ClassMethod SelectAllVersionHistory(TemplateDR As %String) As EPRservice.dataset.EVersionHistoryDataset [ WebMethod ]
{
    Set result=##class(EPRservice.dataset.EVersionHistoryDataset).%New()
    do result.SetArgs(TemplateDR)
	Quit result
}

}
