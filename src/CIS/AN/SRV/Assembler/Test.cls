Class CIS.AN.SRV.Assembler.Test Extends %RegisteredObject
{

/// w ##class(CIS.AN.SRV.Assembler.Test).GetOperAppointments()
ClassMethod GetOperAppointments() As %String
{
	write "Test Start>>>",!

	set instance=##class(CIS.AN.SRV.Assembler.OP.Appointment).GetInstance(19)
	write instance.ToXML().Read(),!
	
	write "Test End<<<",!
	quit ""
}

/// w ##class(CIS.AN.SRV.Assembler.Test).GetOperArrangements()
ClassMethod GetOperArrangements() As %String
{
	write "Test Start>>>",!
	
	try
	{
		set args=##class(CIS.AN.DTO.ENS.Request.Arguments).%New()
		set args.StartDate="2021-12-27"
		set args.EndDate="2021-12-27"
		set models=##class(CIS.AN.SRV.Assembler.OP.Arrangement).Query(args)
		
		set request=##class(CIS.AN.DTO.ENS.Request).Create()
		do request.Default()
		do request.Compose(models)
		
		write request.ToXML().Read(),!
	}
	catch(e){
		write e.DisplayString()
	}
	
	write "Test End<<<",!
	quit ""
}

}
