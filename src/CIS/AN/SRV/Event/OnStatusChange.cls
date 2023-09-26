Class CIS.AN.SRV.Event.OnStatusChange Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// 触发状态改变事件
ClassMethod Trigger(args As CIS.AN.DTO.Event.Args.OnStatusChange) As %Status
{
	set event=..GenerateEvent(args)
	quit ..Send(event)
}

/// 发送事件
ClassMethod Send(event As CIS.AN.DTO.Event.OnStatusChange) As %Status
{
	/// 触发ENS领域事件
	set ENSService=##class(CIS.AN.SRV.Factory).GetENSService()
	if ENSService.Validate() set response=ENSService.OnStatusChange(event)
	
	quit $$$OK
}

/// 生成事件实例
ClassMethod GenerateEvent(args As CIS.AN.DTO.Event.Args.OnStatusChange) As CIS.AN.DTO.Event.OnStatusChange
{
	set queryArgs=##class(CIS.AN.DTO.ENS.Request.Arguments).%New()
	set queryArgs.StartDate=args.Date
	set queryArgs.EndDate=args.Date
	set queryArgs.RowId=args.RowId
	set queryArgs.ApplicationID=args.ApplicationID
	
	set event=##class(CIS.AN.DTO.Event.OnStatusChange).%New()
	set lastSubmit={}
	set event.ActDateTime=""
	set event.ActUser=""
	set event.ActUserID=""
	
	set models=##class(%ListOfObjects).%New()
	
	set opsId=args.RowId
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set model=##class(CIS.AN.DTO.OP.StatusChange).%New()
	set model.RowId=args.RowId
	set model.ExternalID=##class(CIS.AN.BL.DataMapping).GetExternalID("CIS.AN.OperSchedule",opsId,"OPApp")
    set model.ApplicationID=model.ExternalID

	set model.EpisodeID=operSchedule.EpisodeID
	set model.Patient=operSchedule.PatName
	set model.OriginalStatusCode=args.OriginalStatusCode
	set model.OriginalStatus=""
	set model.CurrentStatusCode=args.CurrentStatusCode
	set model.CurrentStatus=""
	set model.OccurDateTime=##class(CIS.AN.COM.DateTime).ConvertToDateTime(+$h,+$p($h,",",2))
	set model.UpdateDateTime=""
	set model.UpdateUser=""
	set model.UpdateUserID=""
	
	do models.Insert(model)
	
	set event.Models=models
	
	quit event
}

}
