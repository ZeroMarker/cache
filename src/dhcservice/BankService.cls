/// 银行卡注册
/// 对外提供的注册建卡服务
Class dhcservice.BankService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter LOCATION = "http://172.16.1.22/trakcarelive/trak/web";

/// Name of the WebService.
Parameter SERVICENAME = "BankService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
/// Parameter NAMESPACE = "http://hospital.service.com/InterFace";
Parameter NAMESPACE = "http://tempuri.org/InterFace";

/// TODO: add arguments and implementation.
/// BankReg
ClassMethod BankReg(Input As %String) As %String [ WebMethod ]
{
	s xmlstr=Input
	s rtn=##class(dhcinterface.BankReg).BankRegister(xmlstr)
	i rtn="" {
		s msgobj=##class(dhcinterface.BankReturnMsg).%New()
		s msgobj.ResultCode="001"
		s msgobj.ErrorMsg="失败:字符串格式不正确"
		s status=msgobj.XMLExportToString(.rtn,"Response")
	}
	q rtn
}

}
