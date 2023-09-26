/// 事件处理类
Class CIS.OPApp.SRV.Event.Handler.OnStatusChange Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// 捕获到事件
ClassMethod Capture(event As CIS.OPApp.DTO.Event.OnStatusChange) As %Status
{
	while (event.Models.GetNext(.key))
	{
		set model=event.Models.GetAt(key)
		do ..Proceed(model)
	}
	
	quit $$$OK
}

/// 处理
ClassMethod Proceed(model As CIS.OPApp.DTO.OP.StatusChange) As %Status
{
	set instance=##class(CIS.AN.OperSchedule).%OpenId(model.ApplicationID)
	if instance.EpisodeID'=model.EpisodeID quit $$$ERROR("就诊号不匹配")
	
	set instance.Status=##class(CIS.AN.BL.OperStatus).GetInstance(model.CurrentStatusCode)
	
	do instance.%Save()
	
	//手术业务过程，暂时未添加处理
	
	quit $$$OK
}

}
