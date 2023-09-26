Class CIS.OPApp.SRV.Event.OnOperRegister Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// 触发登记提交事件
ClassMethod Trigger(args As CIS.OPApp.DTO.Event.Args.OnOperRegister) As %Status
{
	set event=..GenerateEvent(args)
	quit ..Send(event)
}

/// 发送事件
ClassMethod Send(event As CIS.OPApp.DTO.Event.OnOperRegister) As %Status
{
	/// 触发ENS领域事件
	/// set ENSService=##class(CIS.AN.SRV.Factory).GetENSService()
	/// if ENSService.Validate() set response=ENSService.OnOperRegister(event)
	/// 159 上暂时先直接调用DirectConn方法
	if event.Models.Count()>0
	{
		set array=##class(%DynamicArray).%New()
		set models=event.Models
		while(models.GetNext(.key))
		{
			set model=models.GetAt(key)
			do array.%Push(model.ToJSON())
		}
		
		if ..#DEBUG=1 write "OPApp:before send to ENS",!
		if ..#DEBUG=1 write array.%ToJSON(),!
		
		do ##class(CIS.OPApp.SRV.DirectConn.Client.ENSConn).SendSystemStatus(array)
	}
	
	quit $$$OK
}

/// 生成事件实例
ClassMethod GenerateEvent(args As CIS.OPApp.DTO.Event.Args.OnOperRegister) As CIS.OPApp.DTO.Event.OnOperRegister
{
	set queryArgs=##class(CIS.OPApp.DTO.ENS.Request.Arguments).%New()
	set queryArgs.RowId=args.RowId
	
	set event=##class(CIS.OPApp.DTO.Event.OnOperRegister).%New()
	set lastSubmit={}
	set event.ActDateTime=""
	set event.ActUser=""
	set event.ActUserID=""
	
	set models=##class(CIS.OPApp.SRV.Assembler.ENS.SystemStatus).Query(queryArgs)
	
	set event.Models=models
	
	quit event
}

}
