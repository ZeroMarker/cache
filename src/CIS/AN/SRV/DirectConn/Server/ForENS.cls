Class CIS.AN.SRV.DirectConn.Server.ForENS Extends %RegisteredObject
{

/// Version of My Service For ENS.
Parameter Version = "0.1.0";

/// Name of the WebService.
Parameter SERVICENAME = "AISAPIForENS";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://127.0.0.1/imedical/web/";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// [查询]获取手术信息
ClassMethod GetOperScheduleInfo(request As %RegisteredObject) As %RegisteredObject
{
	set adaptor=##class(CIS.AN.SRV.DirectConn.Adaptor).Create()
	
	set options={}
	set options.TargetAddress="CIS.AN.SRV.Handler.OP.Registration"
	set options.TargetMethod="Query"
	set options.Purpose="Query"
	set options.ContentNode="Arguments"
	set options.ModelName=""
	do ##this.Adaptor.SetOptions(options)
	
	set deserilizedRequest=##class(CIS.AN.DTO.ENS.Request).CloneFromObject(request,"CIS.AN.DTO.OP.Registration")
	do adaptor.Receive(deserilizedRequest)
	
	Quit ""
}

/// [测试]测试时调用
ClassMethod Test(request As %RegisteredObject) As %RegisteredObject
{
	set adaptor=##class(CIS.AN.SRV.DirectConn.Adaptor).Create()
	
	set options={}
	set options.TargetAddress="CIS.AN.SRV.Event.Handler.Test"
	set options.TargetMethod="Test"
	set options.Purpose="Test"
	set options.ContentNode="Arguments"
	set options.ModelName=""
	do ##this.Adaptor.SetOptions(options)
	
	set deserilizedRequest=##class(CIS.AN.DTO.ENS.Request).CloneFromObject(request,"CIS.AN.DTO.OP.Appointment")
	do adaptor.Receive(deserilizedRequest)
	
	Quit ""
}

}
