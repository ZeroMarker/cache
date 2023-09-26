Class DHCEPRFS.Srv.SrvFileCheck Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvFileCheck";

ClassMethod GetCheckMREpisodeList(AStartDate As %String, AEndDate As %String, ACheckAction As %String) As DHCEPRFS.DataSet.ECheckMREpisodeListDS [ WebMethod ]
{
	s:(ACheckAction=$C(0)) ACheckAction = ""
	
	s result = ##Class(DHCEPRFS.DataSet.ECheckMREpisodeListDS).%New()
	d result.SetArgs(AStartDate,AEndDate,ACheckAction)
	q result
}

ClassMethod GetCheckFileList(AMREpisode As %String) As DHCEPRFS.DataSet.ECheckFileListDS [ WebMethod ]
{
	s result = ##Class(DHCEPRFS.DataSet.ECheckFileListDS).%New()
	d result.SetArgs(AMREpisode)
	q result
}

}
