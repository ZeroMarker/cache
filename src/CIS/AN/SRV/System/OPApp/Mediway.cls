Class CIS.AN.SRV.System.OPApp.Mediway Extends (%RegisteredObject, CIS.AN.SRV.Interface.IOPAppService)
{

/// 版本
Parameter Version = "0.1.0";

/// [查询] 获取手术预约
Method GetOperAppointmentList(arguments As CIS.AN.DTO.ENS.Request.Arguments) As CIS.AN.DTO.Abstract.Response
{
	set options={}
	set options.TargetAddress=##this.Client
	set options.TargetMethod="GetOperAppointmentList"
	set options.Purpose="Query"
	set options.ContentNode="Models"
	set options.ModelName="CIS.AN.DTO.OP.Appointment"
	do ##this.Adaptor.SetOptions(options)
	
	set request=##class(CIS.AN.DTO.ENS.Request).Create()
	do request.Header.Default()
	do request.Body.Arguments.CloneInit(arguments)
	
	write "ready to send request",!
	write "Adaptor Is Object?:",$IsObject(##this.Adaptor),!
	set response=##this.Adaptor.Send(request)
	do ##this.Adaptor.ClearOptions()
	quit response
}

/// 测试连接
Method Test() As CIS.AN.DTO.Abstract.Response
{
	set options={}
	set options.TargetAddress=##this.Client
	set options.TargetMethod="Test"
	set options.Purpose="Test"
	set options.ContentNode="Models"
	set options.ModelName=""
	do ##this.Adaptor.SetOptions(options)
	
	set request=##class(CIS.AN.DTO.ENS.Request).Create()
	do request.Header.Default()
	set request.Body.Arguments.StartDate="2021-10-01"
	set request.Body.Arguments.EndDate="2021-10-31"
	
	write "ready to send request",!
	write "Adaptor Is Object?:",$IsObject(##this.Adaptor),!
	set response=##this.Adaptor.Send(request)
	do ##this.Adaptor.ClearOptions()
	
	quit response
}

}
