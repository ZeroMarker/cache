Class CIS.OPApp.SRV.DirectConn.Server.ForMR Extends %RegisteredObject
{

/// Version of My Service For ENS.
Parameter Version = "0.1.0";

/// Name of the WebService.
Parameter SERVICENAME = "OPAppAPIForMR";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// [查询]获取手术预约
/// w ##class(CIS.OPApp.SRV.DirectConn.Server.ForMR).GetOperAppointmentList(3834).Read()
ClassMethod GetOperAppointmentList(EpisodeID As %String) As %GlobalCharacterStream
{
	set arguments=##class(CIS.OPApp.DTO.ENS.Request.Arguments).%New()
	
	set arguments.EpisodeID=EpisodeID
	set models=##class(CIS.OPApp.SRV.Assembler.OP.Appointment).Query(arguments)
	
	set request=##class(CIS.OPApp.DTO.ENS.Request).Create()
	do request.Default()
	do request.Compose(models)
	
	Quit request.ToXML()
}

}
