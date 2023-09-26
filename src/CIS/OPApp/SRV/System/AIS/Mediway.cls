Class CIS.OPApp.SRV.System.AIS.Mediway Extends (%RegisteredObject, CIS.OPApp.SRV.Interface.IAISService)
{

/// 版本
Parameter Version = "0.1.0";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// 事件-当手术申请时
Method OnOperApply(event As CIS.OPApp.DTO.Event.OnOperApply) As CIS.OPApp.DTO.ENS.Response
{
	set response=##this.SendOperAppointment(event.Models)
	quit response
}

/// 业务数据-发送手术申请数据
Method SendOperAppointment(models As %ListOfObjects) As CIS.OPApp.DTO.ENS.Response
{
	set options={}
	set options.TargetAddress=##this.Client
	set options.TargetMethod="SendOperAppointment"
	set options.Purpose="Sync"
	set options.ContentNode="Model"
	set options.ModelName=""
	do ##this.Adaptor.SetOptions(options)
	
	set request=##class(CIS.OPApp.DTO.ENS.Request).Create()
	do request.Default()
	do request.Compose(models)
	set response=##this.Adaptor.Send(request)
	do ##this.Adaptor.ClearOptions()
	quit response
}

/// 测试连接
Method Test() As CIS.OPApp.DTO.ENS.Response
{
	set options={}
	set options.TargetAddress=##this.Client
	set options.TargetMethod="Test"
	set options.Purpose="Test"
	set options.ContentNode="Arguments"
	set options.ModelName=""
	do ##this.Adaptor.SetOptions(options)
	
	set request=##class(CIS.OPApp.DTO.ENS.Request).Create()
	do request.Header.Default()
	set request.Body.Arguments.StartDate="2021-10-01"
	set request.Body.Arguments.EndDate="2021-10-31"
	
	write "OPApp: ready to send request",!
	set response=##this.Adaptor.Send(request)
	do ##this.Adaptor.ClearOptions()
	quit response
}

}
