Class CIS.AN.SRV.WebService.Server.ForOPApp Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Version of My Service For ENS.
Parameter Version = "0.1.0";

/// Name of the WebService.
Parameter SERVICENAME = "AISAPIForOPApp";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://111.231.5.101/dthealth/web/";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// 测试时调用
ClassMethod Test(request As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
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
