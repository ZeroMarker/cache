Class EMRservice.BOFileStoreAdm Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "FileStoreAdm";

ClassMethod RegFSAdm(AEpisodeID As %String, AOutPutType As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLFileStoreAdm).RegFSAdm(AEpisodeID,AOutPutType)
}

ClassMethod GetFSAdm(AEpisodeID As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLFileStoreAdm).GetFSAdm(AEpisodeID)
}

ClassMethod GetAdmFilePath(AEpisodeID As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLFileStoreAdm).GetAdmFilePath(AEpisodeID)
}

}
