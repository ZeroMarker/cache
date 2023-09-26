Class CIS.OPApp.SRV.Assembler.Test Extends %RegisteredObject
{

/// w ##class(CIS.OPApp.SRV.Assembler.Test).QueryAppointment()
ClassMethod QueryAppointment() As %String
{
	set params = ##class(CIS.OPApp.DTO.ENS.Request.Arguments).Create()
	set params.StartDate="2021-12-01"
	set params.EndDate="2021-12-15"
	
	set appointments=##class(CIS.OPApp.SRV.Assembler.OP.Appointment).Query(params)
	while(appointments.GetNext(.key))
	{
		set appointment=appointments.GetAt(key)
		write appointment.ToJSON().%ToJSON(),!
	}
	
	quit ""
}

/// w ##class(CIS.OPApp.SRV.Assembler.Test).GetAppointment()
ClassMethod GetAppointment() As %String
{
	
	set appointment=##class(CIS.OPApp.SRV.Assembler.OP.Appointment).GetInstance(165)
	//write appointment.ToJSON().%ToJSON(),!
	write appointment.ToXML().Read(),!
	
	quit ""
}

/// w ##class(CIS.OPApp.SRV.Assembler.Test).GetAppointmentFromOldID()
ClassMethod GetAppointmentFromOldID() As %String
{
	
	set appointment=##class(CIS.OPApp.SRV.Assembler.OP.Appointment).GetInstanceFromOPA(866)
	//write appointment.ToJSON().%ToJSON(),!
	write appointment.Read(),!
	
	quit ""
}

/// w ##class(CIS.OPApp.SRV.Assembler.Test).GetAppointmentRequest()
ClassMethod GetAppointmentRequest() As %String
{
	//set request=##class(CIS.OPApp.SRV.Assembler.ENS.Appointment).GetInstance(859)
	//write request.ToXML().Read()
	
	set request=##class(CIS.OPApp.SRV.Assembler.ENS.Appointment).GetInstanceStream(859)
	write request.Read()
	
	quit ""
}

}
