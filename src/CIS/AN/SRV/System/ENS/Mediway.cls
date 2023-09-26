Class CIS.AN.SRV.System.ENS.Mediway Extends (%RegisteredObject, CIS.AN.SRV.Interface.IENSService)
{

/// 版本
Parameter Version = "0.1.0";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// 基础数据-院区
Method ImportHospital() As CIS.AN.DTO.Abstract.Response
{
	set options={}
	set options.TargetAddress=##this.Client
	set options.TargetMethod="ImportHospital"
	set options.ContentNode="Models"
	set options.ModelName="CIS.AN.DTO.Base.Hospital"
	do ##this.Adaptor.SetOptions(options)
	
	set request=##class(CIS.AN.DTO.ENS.Request).%New()
	set response=##this.Adaptor.Send(request)
	do ##this.Adaptor.ClearOptions()
	quit response
}

/// 基础数据-科室
Method ImportDepartment() As CIS.AN.DTO.Abstract.Response
{
}

/// 基础数据-病区
Method ImportWard() As CIS.AN.DTO.Abstract.Response
{
}

/// 基础数据-床位
Method ImportBed() As CIS.AN.DTO.Abstract.Response
{
}

/// 基础数据-手术字典
Method ImportOperName() As CIS.AN.DTO.Abstract.Response
{
}

/// 基础数据-麻醉方法类型
Method ImportANAType() As CIS.AN.DTO.Abstract.Response
{
}

/// 基础数据-麻醉方法
Method ImportANAMethod() As CIS.AN.DTO.Abstract.Response
{
}

/// 基础数据-用户
Method ImportUser() As CIS.AN.DTO.Abstract.Response
{
}

/// 基础数据-医护人员类型
Method ImportCareProvType() As CIS.AN.DTO.Abstract.Response
{
}

/// 基础数据-医护人员
Method ImportCareProv() As CIS.AN.DTO.Abstract.Response
{
}

/// 基础数据-CA签名信息
Method ImportCASignature() As CIS.AN.DTO.Abstract.Response
{
}

/// 基础数据-手术医生资质
Method ImportOperPermission() As CIS.AN.DTO.Abstract.Response
{
}

/// 业务数据-预约手术
Method BookOperation() As CIS.AN.DTO.Abstract.Response
{
}

/// 业务数据-获取手术计划表
Method GetOperSchedule() As CIS.AN.DTO.Abstract.Response
{
}

/// 业务数据-发送消息
Method SendMessage(message As CIS.AN.DTO.ENS.Message) As CIS.AN.DTO.Abstract.Response
{
	set options={}
	set options.TargetAddress=##this.Client
	set options.TargetMethod="SendMessage"
	set options.ContentNode="Models"
	set options.ModelName=""
	do ##this.Adaptor.SetOptions(options)
	
	set response=##this.Adaptor.Send(message)
	do ##this.Adaptor.ClearOptions()
	quit response
}

/// 事件-当取消手术时
Method OnCancelOperation() As CIS.AN.DTO.Abstract.Response
{
}

/// 业务数据-获取术前体征信息
Method GetVitalsign(args As CIS.AN.DTO.ENS.Request.Arguments) As CIS.AN.DTO.ENS.Response
{
	set options={}
	set options.TargetAddress=##this.Client
	set options.TargetMethod="GetVitalSign"
	set options.Purpose="Query"
	set options.ContentNode="Models"
	set options.ModelName="CIS.AN.DTO.HIS.VitalSign"
	do ##this.Adaptor.SetOptions(options)
	
	set request=##class(CIS.AN.DTO.ENS.Request).Create()
	do request.Default()
	do request.MatchArgs(args)
	set response=##this.Adaptor.Send(request)
	do ##this.Adaptor.ClearOptions()
	quit response
}

/// 事件-当手术排班提交时
Method OnArrangeSubmit(event As CIS.AN.DTO.Event.OnArrangeSubmit) As CIS.AN.DTO.ENS.Response
{
	set response=##this.SendArrangementList(event.Models)
	
	while (event.Models.GetNext(.key))
	{
		set model=event.Models.GetAt(key)
		set messageList=##class(CIS.AN.SRV.Assembler.MS.Message).GetMessagesOnArrange(model.RowId)
		if ..#DEBUG=1 write "AIS:OPS ",model.RowId," generated ",messageList.Count()," messages",!
		while (messageList.GetNext(.ind))
		{
			set message=messageList.GetAt(ind)
			do ##this.SendMessage(message)
		}
	}
	quit response
}

/// 业务数据-发生手术排班数据
Method SendArrangementList(models As %ListOfObjects) As CIS.AN.DTO.ENS.Response
{
	set options={}
	set options.TargetAddress=##this.Client
	set options.TargetMethod="SendOperArrangeInfo"
	set options.ContentNode="Model"
	set options.ModelName=""
	do ##this.Adaptor.SetOptions(options)
	
	set request=##class(CIS.AN.DTO.ENS.Request).Create()
	do request.Default()
	do request.Compose(models)
	set response=##this.Adaptor.Send(request)
	do ##this.Adaptor.ClearOptions()
	quit response
}

/// 事件-当手术状态改变时
Method OnStatusChange(event As CIS.AN.DTO.Event.OnStatusChange) As CIS.AN.DTO.ENS.Response
{
	set options={}
	set options.TargetAddress=##this.Client
	set options.TargetMethod="SendOperStatusChangeInfo"
	set options.ContentNode="Model"
	set options.ModelName=""
	do ##this.Adaptor.SetOptions(options)
	
	set request=##class(CIS.AN.DTO.ENS.Request).Create()
	do request.Default()
	do request.Compose(event.Models)
	set response=##this.Adaptor.Send(request)
	do ##this.Adaptor.ClearOptions()
	quit response
}

/// 事件-当手术登记时
Method OnOperRegister(event As CIS.AN.DTO.Event.OnOperRegister) As CIS.AN.DTO.Abstract.Response
{
	set response=##this.SendOperRegistrationList(event.Models)
	
	quit response
}

/// 业务数据-发生手术排班数据
Method SendOperRegistrationList(models As %ListOfObjects) As CIS.AN.DTO.ENS.Response
{
	set options={}
	set options.TargetAddress=##this.Client
	set options.TargetMethod="SendOperRegisterInfo"
	set options.ContentNode="Model"
	set options.ModelName=""
	do ##this.Adaptor.SetOptions(options)
	
	set request=##class(CIS.AN.DTO.ENS.Request).Create()
	do request.Default()
	do request.Compose(models)
	set response=##this.Adaptor.Send(request)
	do ##this.Adaptor.ClearOptions()
	quit response
}

}
