Class DHCEPRFS.DHCC.Srv.SrvFEE Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "DHCCFEE";

ClassMethod GetFTPPathS(AParam) As %String [ WebMethod ]
{
	s ret = ""
	for index=1:1:$l(AParam,"#")
	{
		s oneParam = $p(AParam,"#",index)
		s ATypeCode = $p(oneParam,"|",1)
		s ASpecialParam = $p(oneParam,"|",2)
		
		s module = ""
		if (ATypeCode = "CGF1")
		{
			s module = "BuildOPDailyPDF"
		}
		elseif (ATypeCode = "CGF2")
		{
			s module = "BuildOPDailyHZPDF"
		}
		elseif (ATypeCode = "CGF3")
		{
			s module = "BuildIPDailyPDF"
		}
		elseif (ATypeCode = "CGF4")
		{
			s module = "BuildIPDailyHZPDF"
		}
	
		s param1 = $p(ASpecialParam,"^",1)
		s param2 = $p(ASpecialParam,"^",2)
		s param3 = $p(ASpecialParam,"^",3)
		s param4 = $p(ASpecialParam,"^",4)
	
		if (ret = "")
		{
			s ret = ##class(web.DHCBillForFinanceProManager).GetPDFUrl(module,param1,param2,param3,param4)
		}
		else
		{
			s ret = ret_"|"_##class(web.DHCBillForFinanceProManager).GetPDFUrl(module,param1,param2,param3,param4)
		}
	}

	q "/"_ret
}

}
