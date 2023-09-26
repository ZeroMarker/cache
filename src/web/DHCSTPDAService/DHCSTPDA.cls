/// creator:yunhaibao
/// createdate:2016-08-09
/// description:静配pdawebservice方式调数据库,避免占用licence
/// web.DHCSTPDAService.DHCSTPDA
Class web.DHCSTPDAService.DHCSTPDA Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "ExecutePiva";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhccdhcst.com.cn";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

Parameter LOCATION = "http://172.16.10.120/dthealth/web";

/// TODO: add arguments and implementation.
/// ExecutePiva
Method ExePdaStatus(params = "") As %String [ WebMethod ]
{
	s Code=$p(params,"^",1)
	s Userid=$p(params,"^",2)
	s Num=$p(params,"^",3)
	s ret=##class(web.DHCSTPIVAPDA).ExePdaStatus(Code,Userid,Num)
	Quit ret
}

/// TODO: add arguments and implementation.
/// ExecutePiva
Method GetBarcodeInfo(params = "") As %String [ WebMethod ]
{
	s barcode=$p(params,"^",1)
	s ret=##Class(web.DHCSTPIVAPDA).GetBarcodeInfo(barcode)
	Quit ret
}

/// TODO: add arguments and implementation.
/// ExecutePiva
Method logon(params = "") As %String [ WebMethod ]
{
	s username=$p(params,"^",1)
	s password=$p(params,"^",2)
	s ret=##class(web.DHCSTIPCOMMON).logon(username,password)
	Quit ret
}

/// TODO: add arguments and implementation.
/// ExecutePiva
Method GetUserPwd(params = "") As %String [ WebMethod ]
{
	s username=$p(params,"^",1)
	s ret=##class(web.DHCSTIPCOMMON).logon(username)
	Quit ret
}

}
