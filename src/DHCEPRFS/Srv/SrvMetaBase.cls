Class DHCEPRFS.Srv.SrvMetaBase Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvMetaBase";

ClassMethod GetAllProvince() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMetaBase:GetAllProvince")
	q obj
}

ClassMethod GetAllMarriage() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMetaBase:GetAllMarriage")
	q obj
}

}
