Class CIS.OPApp.SRV.Interface.IAISService Extends CIS.OPApp.SRV.Interface.IService [ Abstract ]
{

Parameter Version = "0.1.0";

/// 事件-当手术申请时
Method OnOperApply(event As CIS.OPApp.DTO.Abstract.Event) As CIS.OPApp.DTO.Abstract.Response
{
}

/// 业务数据-发送手术申请数据
Method SendOperAppointment(models As %ListOfObjects) As CIS.OPApp.DTO.Abstract.Response
{
}

/// 测试
Method Test() As CIS.OPApp.DTO.Abstract.Response
{
}

}
