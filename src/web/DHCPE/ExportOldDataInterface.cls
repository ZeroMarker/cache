Class web.DHCPE.ExportOldDataInterface Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCPEExportOldData";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://web.dhcc.com.cn";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter LOCATION = "http://10.160.16.91/dthealth/web";

Method test() As %String [ WebMethod ]
{
	q "123"
}

Method InsertGBaseXH() As %String [ WebMethod ]
{
	q ##class(web.DHCPE.PreGBaseInfo).InsertGBaseXH()
}

Method InsertGADMXH() As %String [ WebMethod ]
{
	q ##class(web.DHCPE.PreGBaseInfo).InsertGADMXH()
}

Method insertIInfo() As %String [ WebMethod ]
{
	q ##class(web.DHCPE.PreGBaseInfo).insertIInfo()
}

}
