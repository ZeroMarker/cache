/// 预约挂号服务
/// 对外部系统提供的预约挂号服务  
Class dhcservice.TeleService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://172.16.1.22/trakcarelive/trak/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
/// Parameter NAMESPACE = "http://hospital.service.com/su";
Parameter NAMESPACE = "http://hospital.service.com/interface";

/// Name of the WebService.
Parameter SERVICENAME = "TeleService";

/// ljq-医院对账
ClassMethod CheckAccountMsg(xmlstr As %String) As %String [ WebMethod ]
{
	s rtn=##class(dhcinterface.TeleReg).CheckAccountMsg(xmlstr)
	Quit rtn
}

/// New对帐明细
ClassMethod CheckInAccountDetailInfo(xmlstr As %String) As %String [ WebMethod ]
{
	s rtn=##class(dhcinterface.TeleReg).CheckInAccountDetailInfo(xmlstr)
	Quit rtn
}

/// New对帐确认
ClassMethod ConfirmCheckInAccountInfo(xmlstr As %String) As %String [ WebMethod ]
{
	s rtn=##class(dhcinterface.TeleReg).ConfirmCheckInAccountInfo(xmlstr)
	Quit rtn
}

/// ljq-预约挂号支付确认
ClassMethod PaymentRegistration(xmlstr As %String) As %String [ WebMethod ]
{
	s rtn=##class(dhcinterface.TeleReg).PaymentRegistration(xmlstr)
	Quit rtn
}

/// New接收差异明细信息
ClassMethod ReceiveErrorCheckDetailInfo(xmlstr As %String) As %String [ WebMethod ]
{
	s rtn=##class(dhcinterface.TeleReg).ReceiveErrorCheckDetailInfo(xmlstr)
	Quit rtn
}

/// ljq-医院退号
ClassMethod RefundRegistration(xmlstr As %String) As %String [ WebMethod ]
{
	s rtn=##class(dhcinterface.TeleReg).RefundRegistration(xmlstr)
	Quit rtn
}

/// ljq-查询医院退号
ClassMethod SearchRefundRegistration(xmlstr As %String) As %String [ WebMethod ]
{
	s rtn=##class(dhcinterface.TeleReg).SearchRefundRegistration(xmlstr)
	Quit rtn
}

/// 自动冲正
ClassMethod autoComplemented(xmlstr As %String) As %String [ WebMethod ]
{
	s rtn=##class(dhcinterface.TeleReg).autoComplemented(xmlstr)
	Quit rtn
}

/// 取消挂号
ClassMethod cancelRegistration(xmlstr As %String) As %String [ WebMethod ]
{
	s rtn=##class(dhcinterface.TeleReg).cancelRegistration(xmlstr)
	Quit rtn
}

/// 验证用户信息
ClassMethod checkUserInfo(xmlstr As %String) As %String [ WebMethod ]
{
	s rtn=##class(dhcinterface.TeleReg).checkUserInfo(xmlstr)
	Quit rtn
}

/// 确认挂号
ClassMethod confirmRegistration(xmlstr As %String) As %String [ WebMethod ]
{
	s rtn=##class(dhcinterface.TeleReg).confirmRegistration(xmlstr)
	Quit rtn
}

/// 根据排班信息获取可挂号数
ClassMethod getAvailableRegCount(xmlstr As %String) As %String [ WebMethod ]
{
	s rtn=##class(dhcinterface.TeleReg).getAvailableRegCount(xmlstr)
	Quit rtn
}

/// 公告信息
ClassMethod getBulletinInfo(xmlstr As %String) As %String [ WebMethod ]
{
	s rtn=##class(dhcinterface.TeleReg).getBulletinInfo(xmlstr)
	Quit rtn
}

/// 根据交易流水号?重发排班信息
ClassMethod reSendWorkInfo(xmlstr As %String) As %String [ WebMethod ]
{
	s rtn=##class(dhcinterface.TeleReg).reSendWorkInfo(xmlstr)
	Quit rtn
}

}
