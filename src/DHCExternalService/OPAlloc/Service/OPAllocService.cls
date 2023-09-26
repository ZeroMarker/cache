Class DHCExternalService.OPAlloc.Service.OPAllocService Extends %SOAP.WebService
{

// http://10.72.16.31/DTHealth/web/DHCExternalService.OPAlloc.Service.OPAllocService.cls

/// Name of the WebService.
Parameter SERVICENAME = "OPAllocService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

Method TestNet() As %String [ WebMethod ]
{
	q "OK"
}

/// Todo:查询患者基本信息
Method GetPatInfo(Input As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	q ##class(DHCExternalService.OPAlloc.Methods).GetPatInfo(Input)
}

/// Todo:查询需报到的记录（1300）
Method GetOPAllocReport(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	s rtn=##class(DHCExternalService.OPAlloc.Methods).GetOPAllocReport(XMLRequest)
	d rtn.XMLExportToStream(.OutputStream,"Response")
	Q OutputStream
}

/// Todo:门诊分诊自助报到（1301）
Method OPAllocAutoReport(XMLRequest As %String) As %Stream.GlobalCharacter [ WebMethod ]
{
	s rtn=##class(DHCExternalService.OPAlloc.Methods).OPAllocAutoReport(XMLRequest)
	do rtn.XMLExportToStream(.OutputStream,"Response")
	quit OutputStream
}

}
