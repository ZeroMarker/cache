/// DHCOLB.OLBService
Class DHCOLB.OLBService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "OLBService";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://dthealth/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://dthealth/web";

ClassMethod GetAvailableLicense() As %String [ WebMethod ]
{
	Quit ##class(DHCOLB.LicenseManage).GetAvailable()
}

ClassMethod GetMinAvailableLicense() As %String [ WebMethod ]
{
	Quit ##class(DHCOLB.LicenseManage).GetMinAvailable()
}

ClassMethod GetConnection(ClientIP As %String) As %String [ WebMethod ]
{
	i ClientIP="" s ClientIP=$ZUTIL(67,15,$JOB)
	Quit ##class(DHCOLB.LicenseManage).GetConnection(ClientIP)
}

ClassMethod GetServerConnections(ServerIP As %String = "") As %String [ WebMethod ]
{
	Quit ##class(DHCOLB.LicenseManage).GetServerConnections(ServerIP)
}

ClassMethod GetServerInfo(ServerIP As %String = "") As %String [ WebMethod ]
{
	Quit ##class(DHCOLB.LicenseManage).GetServerInfo(ServerIP)
}

ClassMethod UpdateServerActive(ServerIP As %String = "", ActiveFlag As %String = "") As %String [ WebMethod ]
{
	Quit ##class(DHCOLB.Configuration).UpdateServerActive(ServerIP,ActiveFlag)
}

}
