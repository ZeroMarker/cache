Class CIS.AN.SRV.Event.OnOperRegister Extends %RegisteredObject
{

/// 触发登记提交事件
ClassMethod Trigger(args As CIS.AN.DTO.Event.Args.OnOperRegister) As %Status
{
	set event=..GenerateEvent(args)
	quit ..Send(event)
}

/// 发送事件
ClassMethod Send(event As CIS.AN.DTO.Event.OnOperRegister) As %Status
{
	/// 触发ENS领域事件
	set ENSService=##class(CIS.AN.SRV.Factory).GetENSService()
	if ENSService.Validate() set response=ENSService.OnOperRegister(event)
	
	quit $$$OK
}

/// 生成事件实例
ClassMethod GenerateEvent(args As CIS.AN.DTO.Event.Args.OnOperRegister) As CIS.AN.DTO.Event.OnOperRegister
{
	set queryArgs=##class(CIS.AN.DTO.ENS.Request.Arguments).%New()
	set queryArgs.StartDate=args.Date
	set queryArgs.EndDate=args.Date
	set queryArgs.RowId=args.RowId
	set queryArgs.ApplicationID=args.ApplicationID
	
	set event=##class(CIS.AN.DTO.Event.OnOperRegister).%New()
	set lastSubmit={}
	set event.ActDateTime=""
	set event.ActUser=""
	set event.ActUserID=""
	
	set models=##class(CIS.AN.SRV.Assembler.OP.Registration).Query(queryArgs)
	
	set event.Models=models
	
	quit event
}

}
