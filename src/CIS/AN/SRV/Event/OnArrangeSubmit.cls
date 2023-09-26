Class CIS.AN.SRV.Event.OnArrangeSubmit Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// 触发安排提交事件
/// 为了避免短时间内多次点击安排提交按钮导致频繁触发，采用间隔定时检测是否执行提交
ClassMethod Trigger(args As CIS.AN.DTO.Event.Args.OnArrangeSubmit) As %Status
{
	set event=..GenerateEvent(args)
	quit ..Send(event)
}

/// 发送事件
ClassMethod Send(event As CIS.AN.DTO.Event.OnArrangeSubmit) As %Status
{
	/// 触发ENS领域事件
	set ENSService=##class(CIS.AN.SRV.Factory).GetENSService()
	if ENSService.Validate() set response=ENSService.OnArrangeSubmit(event)
	
	quit $$$OK
}

/// 生成事件实例
ClassMethod GenerateEvent(args As CIS.AN.DTO.Event.Args.OnArrangeSubmit) As CIS.AN.DTO.Event.OnArrangeSubmit
{
	set queryArgs=##class(CIS.AN.DTO.ENS.Request.Arguments).%New()
	set queryArgs.StartDate=args.Date
	set queryArgs.EndDate=args.Date
	set queryArgs.RowId=args.RowId
	set queryArgs.ApplicationID=args.ApplicationID
	
	set event=##class(CIS.AN.DTO.Event.OnArrangeSubmit).%New()
	set lastSubmit={}
	set event.ActDateTime=""
	set event.ActUser=""
	set event.ActUserID=""
	
	set models=##class(CIS.AN.SRV.Assembler.OP.Arrangement).Query(queryArgs)
	
	set event.Models=models
	
	quit event
}

}
