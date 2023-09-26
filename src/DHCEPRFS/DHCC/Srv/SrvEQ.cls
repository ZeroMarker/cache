Class DHCEPRFS.DHCC.Srv.SrvEQ Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "DHCCEQ";

/// 设备
/// debug w ##class(DHCEPRFS.DHCC.Srv.SrvEQ).GetFTPPathS("CGF1|170927^2070")
ClassMethod GetFTPPathS(AParam) As %String [ WebMethod ]
{
	s AParam = $p(AParam,"|",2)
	s ret = ##Class(web.DHCEQ.Interface.Inner.DHCEQFinancialReview).GetFTPPathS(AParam)
	q ret
}

}
