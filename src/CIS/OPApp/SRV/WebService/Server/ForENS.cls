Class CIS.OPApp.SRV.WebService.Server.ForENS Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Version of My Service For ENS.
Parameter Version = "0.1.0";

/// Name of the WebService.
Parameter SERVICENAME = "OPAppAPIForENS";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://127.0.0.1/imedical/web/";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// [查询]手术预约数据
ClassMethod GetOperAppointmentList(request As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	//set result=##class(%GlobalCharacterStream).%New()
	//do result.Write("<Response><Header><SourceSystem>Mediway.AIS</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></Body></Response>")
	//quit result
	
	write "OPApp: service received request",!
	set adaptor=##class(CIS.OPApp.SRV.WebService.Adaptor).%New()
	do adaptor.Init()
	
	set options={}
	set options.TargetAddress="CIS.OPApp.SRV.Assembler.Appointment"
	set options.TargetMethod="Query"
	set options.Purpose="Query"
	set options.ContentNode="Arguments"
	set options.ModelName=""
	do adaptor.SetOptions(options)
	
	write "OPApp: adaptor is ready",!
	set deserilizedRequest=##class(CIS.OPApp.DTO.ENS.Request).CloneFromXML(request,options.ContentNode,options.ModelName)
	write "OPApp: request is deserilized",!
	set response=adaptor.Receive(deserilizedRequest)
	write "OPApp: all complete, ready to send back response",!
	//write "OPApp: Response JSON:",response.ToJSON().%ToJSON(),!
	Quit response.ToXML()
}

/// 测试时调用
ClassMethod Test(request As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	//set result=##class(%GlobalCharacterStream).%New()
	//do result.Write("<Response><Header><SourceSystem>Mediway.AIS</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></Body></Response>")
	//quit result
	
	write "OPApp: service received request",!
	set adaptor=##class(CIS.OPApp.SRV.WebService.Adaptor).%New()
	do adaptor.Init()
	
	set options={}
	set options.TargetAddress="CIS.OPApp.SRV.Handler.Test"
	set options.TargetMethod="Test"
	set options.Purpose="Test"
	set options.ContentNode="Arguments"
	set options.ModelName=""
	do adaptor.SetOptions(options)
	
	write "OPApp: adaptor is ready",!
	set deserilizedRequest=##class(CIS.OPApp.DTO.ENS.Request).CloneFromXML(request,options.ContentNode,options.ModelName)
	write "OPApp: request is deserilized",!
	set response=adaptor.Receive(deserilizedRequest)
	write "OPApp: all complete, ready to send back response",!
	write "OPApp: Response JSON:",response.ToJSON().%ToJSON(),!
	Quit response.ToXML()
}

}
