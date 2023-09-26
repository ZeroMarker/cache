Class DHCEPRFS.DHCC.Srv.SrvST Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "DHCCST";

/// 药房,材料管理
/// debug w ##class(DHCEPRFS.DHCC.Srv.SrvST).GetFTPPathS("1069_2015-08-01^I^2238")
ClassMethod GetFTPPathS(AParam) As %String [ WebMethod ]
{
	s AParam = $p(AParam,"|",2)
	s AParam = $tr(AParam,"_","&")
	s ret = ##Class(web.DHCST.DHCStkMonFD).GetFTPPathS(AParam)
	q ret
}

}
