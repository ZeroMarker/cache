Class CIS.AN.SRV.Interface.IOPAppService Extends CIS.AN.SRV.Interface.IService [ Abstract ]
{

/// 版本
Parameter Version = "0.1.0";

/// 业务数据-预约手术
Method BookOperation() As CIS.AN.DTO.Abstract.Response
{
}

/// [查询] 获取手术预约
Method GetOperAppointmentList(arguments As CIS.AN.DTO.Abstract.Arguments) As CIS.AN.DTO.Abstract.Response
{
}

/// 业务数据-获取术前体征信息
Method GetVitalsign() As CIS.AN.DTO.Abstract.Response
{
}

/// 业务数据-发送消息
Method SendMessage() As CIS.AN.DTO.Abstract.Response
{
}

/// 业务数据-当取消手术时
Method OnCancelOperation() As CIS.AN.DTO.Abstract.Response
{
}

/// 业务数据-当手术状态变更时
Method OnStatusChange() As CIS.AN.DTO.Abstract.Response
{
}

/// 业务数据-当手术排班提交时
Method OnArrangeSubmit() As CIS.AN.DTO.Abstract.Response
{
}

/// 业务数据-当手术登记时
Method OnRegister() As CIS.AN.DTO.Abstract.Response
{
}

/// 测试连接
Method Test() As CIS.AN.DTO.Abstract.Response
{
}

}
