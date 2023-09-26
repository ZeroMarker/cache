/// web.DHCPE.Service.GetPEID
Class web.DHCPE.Service.GetPEID Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "GetPEID";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// TODO: add arguments and implementation.
/// GetPEID
Method GetPEID(OEID) As %String [ WebMethod ]
{
	s PAADM=$P(^OEORD(+OEID),"^",1)
	q ##class(web.DHCPE.PreCommon).GetPEID(PAADM,"PAADM")
}

Method SaveResult(ItemInfo As %String, UserInfo As %String, ResultInfo As %String, ReportPath As %String) As %String [ WebMethod ]
{
	q ##class(web.DHCPE.CRM.Gateway).SavePEResult(ItemInfo,UserInfo,ResultInfo,ReportPath)
	q 0
}

Method SaveComData(ComputerName, Data) As %String [ WebMethod ]
{
	q ##class(web.DHCPE.EquipmentData).SaveData(ComputerName,Data)
}

}
