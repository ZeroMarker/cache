Class CIS.AN.SRV.DirectConn.Client.OPAppConn Extends %RegisteredObject
{

/// Version of the direct connect client.
Parameter Version = "0.1.0";

/// Name of the WebService.
Parameter SERVICENAME = "OPAppAPIForAIS";

Method GetOperAppointmentList(request As CIS.AN.DTO.Abstract.Request) As %RegisteredObject
{
	quit ##class(CIS.OPApp.SRV.DirectConn.Server.ForAIS).GetOperAppointmentList(request)
}

Method OnArrangeSubmit(request As %RegisteredObject) As %RegisteredObject
{
	quit ##class(CIS.OPApp.SRV.DirectConn.Server.ForAIS).OnArrangeSubmit(request)
}

Method OnStatusChange(request As %RegisteredObject) As %RegisteredObject
{
	quit ##class(CIS.OPApp.SRV.DirectConn.Server.ForAIS).OnStatusChange(request)
}

Method Test(request As %RegisteredObject) As %RegisteredObject
{
	quit ##class(CIS.OPApp.SRV.DirectConn.Server.ForAIS).Test(request)
}

}
