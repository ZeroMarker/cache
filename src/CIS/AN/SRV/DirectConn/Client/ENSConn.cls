Class CIS.AN.SRV.DirectConn.Client.ENSConn Extends %RegisteredObject
{

/// Version of the direct connect client.
Parameter Version = "0.1.0";

/// Name of the Service.
Parameter SERVICENAME = "ENSAPIForOPApp";

/// Class Name of the Service.
Parameter SERVICECLASS = "web.DHCENS.XX.cls";

/// 发送消息
Method SendMessage(request As %RegisteredObject) As %RegisteredObject
{
	quit $classmethod(..#SERVICECLASS,"SendMessage",request)
}

/// 获取就诊信息
Method GetAdmission(request As %RegisteredObject) As %RegisteredObject
{
	quit $classmethod(..#SERVICECLASS,"GetAdmission",request)
}

/// 获取用户信息
Method GetUserInfo(request As %RegisteredObject) As %RegisteredObject
{
	quit $classmethod(..#SERVICECLASS,"GetUserInfo",request)
}

/// 获取检验数据
Method GetLabList(request As %RegisteredObject) As %RegisteredObject
{
	quit $classmethod(..#SERVICECLASS,"GetLabList",request)
}

/// 获取体温单数据
Method GetVitalSign(request As %RegisteredObject) As %RegisteredObject
{
	quit $classmethod(..#SERVICECLASS,"GetVitalSign",request)
}

/// 发送手术安排数据
Method SendOperArrangeInfo(request As %RegisteredObject) As %RegisteredObject
{
	quit $classmethod(..#SERVICECLASS,"SendOperArrangeInfo",request)
}

/// 发送手术登记数据
Method SendOperRegisterInfo(request As %RegisteredObject) As %RegisteredObject
{
	quit $classmethod(..#SERVICECLASS,"SendOperRegisterInfo",request)
}

/// 发送手术状态改变数据
Method SendOperStatusChangeInfo(request As %RegisteredObject) As %RegisteredObject
{
	quit $classmethod(..#SERVICECLASS,"SendOperStatusChangeInfo",request)
}

/// 测试时调用
Method Test(request As %RegisteredObject) As %RegisteredObject
{
	quit $classmethod(..#SERVICECLASS,"Test",request)
}

}
