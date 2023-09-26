Class CIS.OPApp.SRV.DirectConn.Server.ForENS Extends %RegisteredObject
{

/// Version of My Service For ENS.
Parameter Version = "0.1.0";

/// Name of the WebService.
Parameter SERVICENAME = "OPAppAPIForENS";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// [查询]获取手术预约
/// w ##class(CIS.OPApp.SRV.DirectConn.Server.ForENS).GetOperAppointment(859).Read()
ClassMethod GetOperAppointment(opaId As %String) As %GlobalCharacterStream
{
	set arguments=##class(CIS.OPApp.DTO.ENS.Request.Arguments).%New()
	
	set arguments.OldID=opaId
	set models=##class(CIS.OPApp.SRV.Assembler.OP.Appointment).Query(arguments)
	
	set request=##class(CIS.OPApp.DTO.ENS.Request).Create()
	do request.Default()
	do request.Compose(models)
	
	Quit request.ToXML()
}

/// [同步]同步手术排班数据
ClassMethod SendOperArrangementList(request As %GlobalCharacterStream) As %GlobalCharacterStream
{
	if ..#DEBUG=1 set ^CIS.AN.DEBUG.DTS("SRV","ForENS","SendOperArrangementList","Args")=request.Read()

	if ..#DEBUG=1 write "OPApp: service received request",!
	set adaptor=##class(CIS.OPApp.SRV.DirectConn.Adaptor).%New()
	
	set options={}
	set options.TargetAddress="CIS.OPApp.SRV.Sync.OP.Arrangement"
	set options.TargetMethod="Store"
	set options.Purpose="Sync"
	set options.ContentNode="Model"
	set options.ModelName="CIS.OPApp.DTO.OP.Arrangement"
	do adaptor.SetOptions(options)
	
	if ..#DEBUG=1 write "OPApp: adaptor is ready",!
	set deserilizedRequest=##class(CIS.OPApp.DTO.ENS.Request).CloneFromXML(request,options.ContentNode,options.ModelName)
	if ..#DEBUG=1 write "OPApp: request is deserilized",!
	if ..#DEBUG=1 write deserilizedRequest.ToXML().Read(),!
	set response=adaptor.Receive(deserilizedRequest)
	if ..#DEBUG=1 write "OPApp: all complete, ready to send back response",!
	Quit response.ToXML()
}

/// [事件]手术状态发生改变时调用
ClassMethod OnOperStatusChange(request As %GlobalCharacterStream) As %GlobalCharacterStream
{
	if ..#DEBUG=1 write "OPApp: service received request",!
	set adaptor=##class(CIS.OPApp.SRV.DirectConn.Adaptor).%New()
	
	set options={}
	set options.TargetAddress="CIS.OPApp.SRV.Event.Handler.OnStatusChange"
	set options.TargetMethod="Capture"
	set options.Purpose="Event"
	set options.ContentNode="Model"
	set options.ModelName="CIS.OPApp.DTO.OP.StatusChange"
	set options.StructName="CIS.OPApp.DTO.Event.OnStatusChange"
	do adaptor.SetOptions(options)
	
	if ..#DEBUG=1 write "OPApp: adaptor is ready",!
	set deserilizedRequest=##class(CIS.OPApp.DTO.ENS.Request).CloneFromXML(request,options.ContentNode,options.ModelName)
	if ..#DEBUG=1 write "OPApp: request is deserilized",!
	set response=adaptor.Receive(deserilizedRequest)
	if ..#DEBUG=1 write "OPApp: all complete, ready to send back response",!
	Quit response.ToXML()
}

/// [同步]同步手术登记数据
ClassMethod SendOperRegistrationList(request As %GlobalCharacterStream) As %GlobalCharacterStream
{
	if ..#DEBUG=1 write "OPApp: service received request",!
	set adaptor=##class(CIS.OPApp.SRV.DirectConn.Adaptor).%New()
	
	set options={}
	set options.TargetAddress="CIS.OPApp.SRV.Sync.OP.Registration"
	set options.TargetMethod="Store"
	set options.Purpose="Sync"
	set options.ContentNode="Model"
	set options.ModelName="CIS.OPApp.DTO.OP.Registration"
	do adaptor.SetOptions(options)
	
	if ..#DEBUG=1 write "OPApp: adaptor is ready",!
	set deserilizedRequest=##class(CIS.OPApp.DTO.ENS.Request).CloneFromXML(request,options.ContentNode,options.ModelName)
	if ..#DEBUG=1 write "OPApp: request is deserilized",!
	set response=adaptor.Receive(deserilizedRequest)
	if ..#DEBUG=1 write "OPApp: all complete, ready to send back response",!
	Quit response.ToXML()
}

/// [测试]测试时调用
ClassMethod Test(request As %RegisteredObject) As %RegisteredObject
{
	if ..#DEBUG=1 write "OPApp: service received request",!
	set adaptor=##class(CIS.OPApp.SRV.DirectConn.Adaptor).%New()
	
	set options={}
	set options.TargetAddress="CIS.OPApp.SRV.Event.Handler.Test"
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
