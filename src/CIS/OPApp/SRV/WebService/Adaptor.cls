Class CIS.OPApp.SRV.WebService.Adaptor Extends (%RegisteredObject, CIS.OPApp.SRV.Interface.IAdaptor)
{

Parameter Version = "0.1.0";

/// 包名
Parameter PackageName = "CIS.OPApp.SRV";

/// 连接协议，支持WebService;HTTP;DirectConnect
Parameter ConnectProtocol = "WebService";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

Property Client As %SOAP.WebClient;

/// 实例化
ClassMethod Create() As CIS.OPApp.SRV.WebService.Adaptor
{
	quit ##class(CIS.OPApp.SRV.WebService.Adaptor).%New()
}

Method CreateClient() As %Status
{
	if ##class(%ClassDefinition).%ExistsId(##this.TargetAddress)
	{
		set client=$classmethod(##this.TargetAddress,"%New")
		set ##this.Client=client
		if ..#DEBUG=1 write "client is initiated",!
	}
	else
	{
		if ..#DEBUG=1 write "client can not be found",!
		quit $$$ERROR("client can not be found")
	}
	quit $$$OK
}

/// 发送请求
Method Send(request As CIS.OPApp.DTO.Abstract.Request) As CIS.OPApp.DTO.Abstract.Response
{
	if ('$IsObject(##this.Client))||('##this.IsSameClient()) do ##this.CreateClient()
	if ..#DEBUG=1 write "client is ready",!
	set responseStream=##class(%GlobalCharacterStream).%New()
	if ##this.TargetMethod'=""
	{
		if ..#DEBUG=1 write "sending request...",!
		if ..#DEBUG=1 write "request xml:",request.ToXML().Read(),!
		set responseStream=$method(##this.Client,##this.TargetMethod,request.ToXML())
		if ..#DEBUG=1 write "received response: ",responseStream,!
	}
	set response=##class(CIS.OPApp.DTO.ENS.Response).CloneFromXML(responseStream,##this.ContentNode,##this.ModelName)
	if ..#DEBUG=1 write "deserialize response complete",!
	quit response
}

/// 接收到请求
Method Receive(request As CIS.OPApp.DTO.Abstract.Request) As CIS.OPApp.DTO.Abstract.Response
{
	if ..#DEBUG=1 write "OPApp:received request...",!
	set response=##class(CIS.OPApp.DTO.ENS.Response).Create()
	do response.Header.Default()
	
	TSTART
	try
	{
		if ##this.Purpose="Query"
		{
			if ..#DEBUG=1 write "OPApp:start query...:",##this.TargetAddress,".",##this.TargetMethod,!
			set models=$classmethod(##this.TargetAddress,##this.TargetMethod,request.Body.Arguments)
			do response.Succeed()
			do response.Compose(models)
		}
		elseif ##this.Purpose="Sync"
		{
			if ..#DEBUG=1 write "OPApp:start sync...:",##this.TargetAddress,".",##this.TargetMethod,!
			set sc=$classmethod(##this.TargetAddress,##this.TargetMethod,request.Body.Struct.Models)
			do response.Succeed()
		}
		elseif ##this.Purpose="Event"
		{
			if ..#DEBUG=1 write "OPApp:start event...:",##this.TargetAddress,".",##this.TargetMethod,!
			set struct=request.Body.Struct
			if ##class(%ClassDefinition).%ExistsId(##this.StructName)
			{
				set struct=$classmethod(##this.StructName,"%New")
				set $property(struct,"Models")=request.Body.Struct.Models
			}
			set sc=$classmethod(##this.TargetAddress,##this.TargetMethod,struct)
			do response.Succeed()
		}
		elseif ##this.Purpose="Test"
		{
			if ..#DEBUG=1 write "OPApp: ready to send to handler: ",##this.TargetAddress," method:",##this.TargetMethod,!
			set sc=$classmethod(##this.TargetAddress,##this.TargetMethod)
			if ..#DEBUG=1 write "OPApp: handler process complete",!
			do response.Succeed()
		}
		
		TCOMMIT
	}
	catch(e)
	{
		TROLLBACK
		set reason=e.DisplayString()
		if ..#DEBUG=1 write reason,!
		do response.Fail(reason)
	}
	
	quit response
}

}
