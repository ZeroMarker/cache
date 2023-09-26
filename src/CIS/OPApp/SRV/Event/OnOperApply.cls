/// 当手术申请时
Class CIS.OPApp.SRV.Event.OnOperApply Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// 触发手术申请事件
ClassMethod Trigger(args As CIS.OPApp.DTO.Event.Args.OnOperApply) As %Status
{
	set event=..GenerateEvent(args)
	quit ..Send(event)
}

/// 发送事件
ClassMethod Send(event As CIS.OPApp.DTO.Event.OnOperApply) As %Status
{
	/// 触发AIS领域事件
	set AISService=##class(CIS.AN.SRV.Factory).GetAISService()
	if AISService.Validate() set response=AISService.OnOperApply(event)
	
	quit $$$OK
}

/// 生成事件实例
ClassMethod GenerateEvent(args As CIS.OPApp.DTO.Event.Args.OnOperApply) As CIS.OPApp.DTO.Event.OnOperApply
{
	set queryArgs=##class(CIS.OPApp.DTO.ENS.Request.Arguments).%New()
	set queryArgs.StartDate=args.Date
	set queryArgs.EndDate=args.Date
	set queryArgs.RowId=args.RowId
	set queryArgs.ApplicationID=args.ApplicationID
	
	set event=##class(CIS.OPApp.DTO.Event.OnOperApply).%New()
	set lastSubmit={}
	set event.ActDateTime=""
	set event.ActUser=""
	set event.ActUserID=""
	
	set models=##class(CIS.OPApp.SRV.Assembler.OP.Appointment).Query(queryArgs)
	
	set event.Models=models
	
	quit event
}

}
