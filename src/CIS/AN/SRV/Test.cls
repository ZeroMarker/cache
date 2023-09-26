Class CIS.AN.SRV.Test Extends %RegisteredObject
{

ClassMethod TestENSService() As %String
{
	set service = ##class(CIS.AN.SRV.Factory).GetENSService()
	set response = service.Test()
}

ClassMethod TestHISService() As %String
{
	set service = ##class(CIS.AN.SRV.Factory).GetHISService()
	set response = service.Test()
}

/// w ##class(CIS.AN.SRV.Test).TestOPAppService()
ClassMethod TestOPAppService() As %String
{
	write "Test Start>>>",!
	set service = ##class(CIS.AN.SRV.Factory).GetOPAppService()
	write "ready to connect",!
	set response = service.Test()
	write "response is ready"
	set result = ##class(CIS.AN.SRV.Handler.Test).Test(response)
	write "Test End<<<",!
	quit ""
}

/// w ##class(CIS.AN.SRV.Test).TestJson()
ClassMethod TestJson() As %String
{
	write "Test Start:",!
	set request=##class(CIS.AN.DTO.ENS.Request).Create()
	do request.Header.Default()
	set request.Body.Arguments.StartDate="2021-10-01"
	set request.Body.Arguments.EndDate="2021-10-31"
	
	write "Request Body:",request.Body.ToJSON().%ToJSON(),!
	
	write "Test End:",!
	quit ""
}

/// w ##class(CIS.AN.SRV.Test).GetOperAppointments()
ClassMethod GetOperAppointments() As %String
{
	write "Test Start>>>",!
	set service = ##class(CIS.AN.SRV.Factory).GetOPAppService()
	write "ready to connect",!
	set arguments=##class(CIS.AN.DTO.ENS.Request.Arguments).%New()
	set arguments.StartDate="2021-10-01"
	set arguments.EndDate="2021-10-31"
	set response = service.GetOperAppointmentList(arguments)
	write "response is ready"
	set result = ##class(CIS.AN.SRV.Sync.OP.Appointment).Store(response.Body.RecordStruct)
	write "Test End<<<",!
	quit ""
}

ClassMethod TriggerEvent() As %String
{
	write "Test Start>>>",!
	set service = ##class(CIS.AN.SRV.Factory).GetOPAppService()
	write "ready to connect",!
	set response = service.Test()
	write "response is ready"
	set result = ##class(CIS.AN.SRV.Handler.Test).Test(response)
	write "Test End<<<",!
	quit ""
}

ClassMethod SendMessage() As %String
{
	write "Test Start>>>",!
	set service = ##class(CIS.AN.SRV.Factory).GetOPAppService()
	write "ready to connect",!
	set response = service.Test()
	write "response is ready"
	set result = ##class(CIS.AN.SRV.Handler.Test).Test(response)
	write "Test End<<<",!
	quit ""
}

/// w ##class(CIS.AN.SRV.Test).ReceiveOperAppointment()
ClassMethod ReceiveOperAppointment() As %String
{
	write "Test Start>>>",!
	set request=##class(%GlobalCharacterStream).%New()
	do request.Write(^CIS.AN.DEBUG.DTS("SRV","ForENS","SendOperAppointment","Args"))
	//write request.Read(),!
	
	write "initiating adaptor!",!
	set adaptor=##class(CIS.AN.SRV.WebService.Adaptor).Create()

	set options={}
	set options.TargetAddress="CIS.AN.SRV.Sync.OP.Appointment"
	set options.TargetMethod="Store"
	set options.Purpose="Sync"
	set options.ContentNode="Model"
	set options.ModelName="CIS.AN.DTO.OP.Appointment"
	do adaptor.SetOptions(options)
	write "initiated adaptor successfully!",!
	
	write "deserilizing request!",!
	
	try
	{
		set deserilizedRequest=##class(CIS.AN.DTO.ENS.Request).CloneFromXML(.request,options.ContentNode,options.ModelName)
		write "deserilized request successfully!",!
		//write deserilizedRequest.ToXML().Read(),!
		set response=adaptor.Receive(deserilizedRequest)
		write "response is ready!",!
	}
	catch(e)
	{
		write e.DisplayString()
	}
	
	write "Test End<<<",!
	quit ""
}

}
