Class CIS.OPApp.SRV.HTTP.Adaptor Extends (%RegisteredObject, CIS.OPApp.SRV.Interface.IAdaptor)
{

Parameter Version = "0.1.0";

/// 包名
Parameter PackageName = "CIS.OPApp.SRV";

/// 连接协议
Parameter ConnectProtocol = "HTTP";

Method Send(request As CIS.OPApp.DTO.Abstract.Request) As CIS.OPApp.DTO.Abstract.Response
{
}

Method Receive(request As CIS.OPApp.DTO.Abstract.Request) As CIS.OPApp.DTO.Abstract.Response
{
}

}
