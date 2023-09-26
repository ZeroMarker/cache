Class DHCEPRFS.Srv.SrvWorkFlow Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvWorkFlow";

ClassMethod GetPatInfo(AMREpisodeID As %String) As DHCEPRFS.Entity.EWorkFlowPatInfo [ WebMethod ]
{
	s entity = ##Class(DHCEPRFS.BL.BLWorkFlow).GetPatInfo(AMREpisodeID)
	q entity
}

ClassMethod GetOperationList(AMREpisodeID As %String) As DHCEPRFS.DataSet.EWorkFlowOperationList [ WebMethod ]
{
	s ds = ##Class(DHCEPRFS.DataSet.EWorkFlowOperationList).%New()
	d ds.SetArgs(AMREpisodeID)
	q ds
}

ClassMethod DoOperation(AMREpisodeID As %String, ACanelFinalAccount As %String, ACanelMRCompletion As %String, ARemark As %String, AUserID As %String) As %String [ WebMethod ]
{
	s sc = ##Class(DHCEPRFS.BL.BLWorkFlow).DoOperation(AMREpisodeID,ACanelFinalAccount,ACanelMRCompletion,ARemark,AUserID)
	q sc
}

}
