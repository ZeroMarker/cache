Class CIS.OPApp.SRV.DirectConn.Server.ForAIS Extends %RegisteredObject
{

/// Version of the direct connect client.
Parameter Version = "0.1.0";

/// Name of the WebService.
Parameter SERVICENAME = "OPAppAPIForAIS";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// [查询]获取手术预约
ClassMethod GetOperAppointmentList(request As %RegisteredObject) As %RegisteredObject
{
	if ..#DEBUG=1 write "OPApp: service received request",!
	set adaptor=##class(CIS.OPApp.SRV.DirectConn.Adaptor).%New()
	do adaptor.Init()
	
	set options={}
	set options.TargetAddress="CIS.OPApp.SRV.Assembler.Appointment"
	set options.TargetMethod="Query"
	set options.Purpose="Query"
	set options.ContentNode="Arguments"
	set options.ModelName=""
	do adaptor.SetOptions(options)
	
	if ..#DEBUG=1 write "OPApp: adaptor is ready",!
	if ..#DEBUG=1 write "OPApp: Request JSON:",request.ToJSON().%ToJSON(),!
	set deserilizedRequest=##class(CIS.OPApp.DTO.ENS.Request).CloneFromObject(request)
	if ..#DEBUG=1 write "OPApp: request is deserilized",!
	set response=adaptor.Receive(deserilizedRequest)
	if ..#DEBUG=1 write "OPApp: all complete, ready to send back response",!
	if ..#DEBUG=1 write "OPApp: Response JSON:",response.ToJSON().%ToJSON(),!
	Quit response
}

/// 测试时调用
ClassMethod Test(request As %RegisteredObject) As %RegisteredObject
{
	if ..#DEBUG=1 write "OPApp: service received request",!
	set adaptor=##class(CIS.OPApp.SRV.DirectConn.Adaptor).%New()
	do adaptor.Init()
	
	set options={}
	set options.TargetAddress="CIS.OPApp.SRV.Handler.Test"
	set options.TargetMethod="Test"
	set options.Purpose="Test"
	set options.ContentNode="Arguments"
	set options.ModelName=""
	do adaptor.SetOptions(options)
	
	if ..#DEBUG=1 write "OPApp: adaptor is ready",!
	if ..#DEBUG=1 write "OPApp: Request JSON:",request.ToJSON().%ToJSON(),!
	set deserilizedRequest=##class(CIS.OPApp.DTO.ENS.Request).CloneFromObject(request)
	if ..#DEBUG=1 write "OPApp: request is deserilized",!
	set response=adaptor.Receive(deserilizedRequest)
	if ..#DEBUG=1 write "OPApp: all complete, ready to send back response",!
	if ..#DEBUG=1 write "OPApp: Response JSON:",response.ToJSON().%ToJSON(),!
	Quit response
}

}
