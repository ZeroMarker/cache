/// dhcservice.DHCEventLog
Class dhcservice.DHCEventLog Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCEventLog";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// TODO: add arguments and implementation.
/// EventLog
Method EventLog(ModelName, Condition, Content, SecretCode, Success As %String = "Y", UserId = "", IP = "", Mac = "", CName = "", LocId = "", GroupId = "") As %String [ WebMethod ]
{
	Quit ##class(web.DHCEventLog).EventLog(ModelName,Condition,Content,SecretCode,Success,UserId,IP,Mac,CName,LocId,GroupId)
}

}
