/// CIS.AN.SRV.WebService.Server.ForINSU
Class CIS.AN.SRV.WebService.Server.ForINSU Extends %SOAP.WebService
{

/// Version of My Service For ENS.
Parameter Version = "0.1.0";

/// Name of the WebService.
Parameter SERVICENAME = "ForINSU";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "https://172.18.18.138:1443/imedical/webservice";

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

/// 4401 住院病案首页信息
ClassMethod Get4401OperInfo(msgID As %String, request As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	//1. 反序列化request
	//2. 组装器获取数据列表list of OperInfo (%ListOfObject)
	//3. 组装Response
	set adaptor=##class(CIS.AN.SRV.WebService.Adaptor).Create()
	
	set options={}
	set options.TargetAddress="CIS.AN.SRV.Assembler.INSU.OperInfo"
	set options.TargetMethod="Query"
	set options.Purpose="Query"
	set options.ContentNode="Arguments"
	set options.ModelName="CIS.AN.DTO.INSU.OperScheduleInfo"
	do adaptor.SetOptions(options)
	
	set deserilizedRequest=##class(CIS.AN.DTO.ENS.Request).CloneFromXML(request,"Arguments")
	set response=adaptor.Receive(deserilizedRequest)
	
	Quit response.ToXML()
}

/// 4701 住院病案首页信息
ClassMethod Get4701OperRecord(msgID As %String, request As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	//1. 反序列化request
	//2. 组装器获取数据列表list of OperInfo (%ListOfObject)
	//3. 组装Response
	set adaptor=##class(CIS.AN.SRV.WebService.Adaptor).Create()
	
	set options={}
	set options.TargetAddress="CIS.AN.SRV.Assembler.INSU.OperRecord"
	set options.TargetMethod="Query"
	set options.Purpose="Query"
	set options.ContentNode="Arguments"
	set options.ModelName="CIS.AN.DTO.INSU.OperRecord"
	do adaptor.SetOptions(options)
	
	set deserilizedRequest=##class(CIS.AN.DTO.ENS.Request).CloneFromXML(request,"Arguments")
	set response=adaptor.Receive(deserilizedRequest)
	
	Quit response.ToXML()
}

/// 4302 计费医保组判断是否是急诊留观
ClassMethod Get4302EmergencyOperInfo(msgID As %String, request As %GlobalCharacterStream) As %GlobalCharacterStream [ WebMethod ]
{
	//1. 反序列化request
	//2. 组装器获取数据列表list of OperInfo (%ListOfObject)
	//3. 组装Response
	set adaptor=##class(CIS.AN.SRV.WebService.Adaptor).Create()
	
	set options={}
	set options.TargetAddress="CIS.AN.SRV.Assembler.INSU.EmergencyOperInfo"
	set options.TargetMethod="Query"
	set options.Purpose="Query"
	set options.ContentNode="Arguments"
	set options.ModelName="CIS.AN.DTO.INSU.EmergencyOperInfo"
	do adaptor.SetOptions(options)
	
	set deserilizedRequest=##class(CIS.AN.DTO.ENS.Request).CloneFromXML(request,"Arguments")
	set response=adaptor.Receive(deserilizedRequest)
	
	Quit response.ToXML()
}

}
