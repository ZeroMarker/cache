Class DHCEPRFS.Srv.SrvPageManagement Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvPageManagement";

/// Desc:	获取页码
/// Input：	
/// Output: 页码
ClassMethod GetPageNumber(APageInfoID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLPageManagement).GetPageNumber(APageInfoID)
}

/// Desc:	设置页码
/// Input：	页码
/// Output: 1
ClassMethod SetPageNumber(APageNumber As %String, APageInfoID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLPageManagement).SetPageNumber(APageNumber, APageInfoID)
}

}
