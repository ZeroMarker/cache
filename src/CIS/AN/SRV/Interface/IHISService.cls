Class CIS.AN.SRV.Interface.IHISService Extends CIS.AN.SRV.Interface.IService [ Abstract ]
{

/// 版本
Parameter Version = "0.1.0";

/// 基础数据-院区
Method ImportHospital() As CIS.AN.DTO.Abstract.Response
{
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

}
