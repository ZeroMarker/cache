Class CIS.OPApp.SRV.DirectConn.Client.AISConn Extends %RegisteredObject
{

/// Version of the direct connect client.
Parameter Version = "0.1.0";

/// Name of the WebService.
Parameter SERVICENAME = "AISAPIForOPApp";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

Method SendOperAppointment(request As %RegisteredObject) As %RegisteredObject
{
	quit ##class(CIS.AN.SRV.DirectConn.Server.ForOPApp).SendOperAppointment(request)
}

Method Test(request As %RegisteredObject) As %RegisteredObject
{
	quit ##class(CIS.AN.SRV.DirectConn.Server.ForOPApp).Test(request)
}

}
