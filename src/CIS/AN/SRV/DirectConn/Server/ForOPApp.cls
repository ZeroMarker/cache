Class CIS.AN.SRV.DirectConn.Server.ForOPApp Extends %RegisteredObject
{

/// Version of My Service For ENS.
Parameter Version = "0.1.0";

/// Name of the WebService.
Parameter SERVICENAME = "AISAPIForOPApp";

/// [事件]测试时调用
ClassMethod SendOperAppointment(request As %RegisteredObject) As %RegisteredObject
{
	write "AIS: service received request",!
	set options={}
	set options.TargetAddress="CIS.AN.SRV.Sync.OP.Appointment"
	set options.TargetMethod="Store"
	set options.Purpose="Sync"
	set options.ContentNode="Model"
	set options.ModelName="CIS.AN.DTO.OP.Appointment"
	do adaptor.SetOptions(options)
	
	write "AIS: adaptor is ready",!
	set deserilizedRequest=##class(CIS.AN.DTO.ENS.Request).CloneFromObject(request)
	write "AIS: request is deserilized",!
	set response=adaptor.Receive(deserilizedRequest)
	write "AIS: all complete, ready to send back response",!
	Quit response
}

/// [事件]测试时调用
ClassMethod Test(request As %RegisteredObject) As %RegisteredObject
{
	write "AIS: service received request",!
	set adaptor=##class(CIS.AN.SRV.DirectConn.Adaptor).%New()
	do adaptor.Init()
	
	set options={}
	set options.TargetAddress="CIS.AN.SRV.Handler.Test"
	set options.TargetMethod="Test"
	set options.Purpose="Test"
	set options.ContentNode="Arguments"
	set options.ModelName=""
	do adaptor.SetOptions(options)
	
	write "AIS: adaptor is ready",!
	write "AIS: Request JSON:",request.ToJSON().%ToJSON(),!
	set deserilizedRequest=##class(CIS.AN.DTO.ENS.Request).CloneFromObject(request)
	write "AIS: request is deserilized",!
	set response=adaptor.Receive(deserilizedRequest)
	write "AIS: all complete, ready to send back response",!
	write "AIS: Response JSON:",response.ToJSON().%ToJSON(),!
	Quit response
}

}
