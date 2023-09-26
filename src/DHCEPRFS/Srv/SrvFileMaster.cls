Class DHCEPRFS.Srv.SrvFileMaster Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvFileMaster";

ClassMethod GetFileMasterID(AFullFileName As %String) As %String [ WebMethod ]
{
}

}
