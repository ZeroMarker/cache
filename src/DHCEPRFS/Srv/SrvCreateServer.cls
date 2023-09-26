Class DHCEPRFS.Srv.SrvCreateServer Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvCreateServer";

ClassMethod GetAllTaskType() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLCreateServer:GetAllTaskType")
	d obj.SetArgs()
	q obj
}

ClassMethod GetServerInfoByIP(AIP As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLCreateServer:GetServerInfoByIP")
	d obj.SetArgs(AIP)
	q obj
}

}
