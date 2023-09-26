Class CIS.AN.SRV.WebService.Server.ForENS Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Version of My Service For ENS.
Parameter Version = "0.1.0";

/// This is the name of the Service
Parameter SERVICENAME = "ForENS";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "https://172.18.18.142:1443/imedical/webservice";

/// TODO: change this to actual SOAP namespace.
/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// 保存手术申请信息
ClassMethod SendOperAppointment(msgID As %String, request As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set ^CIS.AN.DEBUG.DTS("SRV","ForENS","SendOperAppointment","Args")=request.Read()
	//set response=##class(CIS.AN.DTO.ENS.Response).Create()
	//do response.Default()
	//do response.Succeed()
	//Quit response.ToXML()
	
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
	set response=##class(CIS.AN.DTO.ENS.Response).Create()
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
		set error = e.DisplayString()
		do response.Fail(error)
	}
	
	Quit response.ToXML()
}

/// 获取手术信息
ClassMethod GetOperScheduleInfo(msgID As %String, request As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	set adaptor=##class(CIS.AN.SRV.WebService.Adaptor).Create()
	
	set options={}
	set options.TargetAddress="CIS.AN.SRV.Assembler.OP.Registration"
	set options.TargetMethod="Query"
	set options.Purpose="Query"
	set options.ContentNode="Arguments"
	set options.ModelName=""
	do adaptor.SetOptions(options)
	
	set deserilizedRequest=##class(CIS.AN.DTO.ENS.Request).CloneFromXML(request,"Arguments")
	set response=adaptor.Receive(deserilizedRequest)
	
	Quit response.ToXML()
}

/// 测试时调用
ClassMethod Test(msgID As %String, request As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	write "AIS: service received request",!
	set adaptor=##class(CIS.AN.SRV.WebService.Adaptor).Create()
	
	set options={}
	set options.TargetAddress="CIS.AN.SRV.Event.Handler.Test"
	set options.TargetMethod="Test"
	set options.Purpose="Test"
	set options.ContentNode="Arguments"
	set options.ModelName=""
	do adaptor.SetOptions(options)
	
	write "AIS: adaptor is ready",!
	write "AIS: Request JSON:",request.ToJSON().%ToJSON(),!
	set deserilizedRequest=##class(CIS.AN.DTO.ENS.Request).CloneFromXML(request,"Arguments")
	write "AIS: request is deserilized",!
	set response=adaptor.Receive(deserilizedRequest)
	write "AIS: all complete, ready to send back response",!
	Quit response
}

}
