Class CIS.AN.SRV.DirectConn.Adaptor Extends (%RegisteredObject, CIS.AN.SRV.Interface.IAdaptor)
{

/// 版本号
Parameter Version = "0.1.0";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// 包名
Parameter PackageName = "CIS.AN.SRV";

/// 连接协议
Parameter ConnectProtocol = "DirectConn";

/// 客户端
Property Client As %RegisteredObject;

/// 实例化
ClassMethod Create() As CIS.AN.SRV.DirectConn.Adaptor
{
	quit ##class(CIS.AN.SRV.DirectConn.Adaptor).%New()
}

Method Send(request As CIS.AN.DTO.Abstract.Request) As CIS.AN.DTO.Abstract.Response
{
	if ('$IsObject(##this.Client))||('##this.IsSameClient()) do ##this.CreateClient()
	if ..#DEBUG=1 write "client is ready",!
	if ##this.TargetMethod'=""
	{
		if ..#DEBUG=1 write "sending request...",!
		set responseObj=$method(##this.Client,##this.TargetMethod,request)
		if ..#DEBUG=1 write "received response",!
	}
	set response=##class(CIS.AN.DTO.ENS.Response).CloneFromObject(responseObj,##this.ModelName)
	if ..#DEBUG=1 write "deserialize response complete",!
	quit response
}

Method Receive(request As CIS.AN.DTO.Abstract.Request) As CIS.AN.DTO.Abstract.Response
{
	if ..#DEBUG=1 write "AIS:received request...",!
	set response=##class(CIS.AN.DTO.ENS.Response).Create()
	do response.Header.Default()
	
	TSTART
	try
	{
		if ##this.Purpose="Query"
		{
			if ..#DEBUG=1 write "AIS:start query...:",##this.TargetAddress,".",##this.TargetMethod,!
			set models=$classmethod(##this.TargetAddress,##this.TargetMethod,request.Body.Arguments)
			do response.Succeed()
			do response.Compose(models)
		}
		elseif ##this.Purpose="Sync"
		{
			if ..#DEBUG=1 write "AIS:start sync...:",##this.TargetAddress,".",##this.TargetMethod,!
			set sc=$classmethod(##this.TargetAddress,##this.TargetMethod,request.Body.Struct.Models)
			do response.Succeed()
		}
		elseif ##this.Purpose="Event"
		{
			if ..#DEBUG=1 write "AIS:start event...:",##this.TargetAddress,".",##this.TargetMethod,!
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
			if ..#DEBUG=1 write "AIS: ready to send to handler: ",##this.TargetAddress," method:",##this.TargetMethod,!
			set sc=$classmethod(##this.TargetAddress,##this.TargetMethod)
			if ..#DEBUG=1 write "AIS: handler process complete",!
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
