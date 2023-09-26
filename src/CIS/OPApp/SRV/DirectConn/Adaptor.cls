Class CIS.OPApp.SRV.DirectConn.Adaptor Extends (%RegisteredObject, CIS.OPApp.SRV.Interface.IAdaptor)
{

Parameter Version = "0.1.0";

/// 包名
Parameter PackageName = "CIS.OPApp.SRV";

/// 连接协议
Parameter ConnectProtocol = "DirectConn";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// 客户端
Property Client As %RegisteredObject;

/// 实例化
ClassMethod Create() As CIS.OPApp.SRV.DirectConn.Adaptor
{
	quit ##class(CIS.OPApp.SRV.DirectConn.Adaptor).%New()
}

Method Send(request As CIS.OPApp.DTO.Abstract.Request) As CIS.OPApp.DTO.Abstract.Response
{
	if ('$IsObject(##this.Client))||('##this.IsSameClient()) do ##this.CreateClient()
	if ..#DEBUG=1 write "client is ready",!
	if ##this.TargetMethod'=""
	{
		if ..#DEBUG=1 write "sending request...",!
		set responseObj=$method(##this.Client,##this.TargetMethod,request)
		if ..#DEBUG=1 write "received response",!
	}
	set response=##class(CIS.OPApp.DTO.ENS.Response).CloneFromObject(responseObj,##this.ModelName)
	if ..#DEBUG=1 write "deserialize response complete",!
	quit response
}

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
