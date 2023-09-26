Class CIS.AN.SRV.WebService.Client.ENSSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://114.251.235.37/csp/hsb/DHC.Published.PUB0004.BS.PUB0004.CLS";

/// This is the class name of the web service.
Parameter SERVERCLASS = "DHC.Published.PUB0004.BS.PUB0004";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "PUB0004";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// This is the logon user name provided by the service.
Parameter LogonUser = "_system";

/// This is the logon password provided by the service.
Parameter Password = "SYS";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

Method HIPMessageServer() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HIPMessageServer").Invoke($this,"http://www.dhcc.com.cn/DHC.Published.PUB0004.BS.PUB0004.HIPMessageServer")
}

Method HIPMessageServer1(input1 As %String, input2 As %GlobalCharacterStream) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HIPMessageServer1").Invoke($this,"http://www.dhcc.com.cn/DHC.Published.PUB0004.BS.PUB0004.HIPMessageServer1",.input1,.input2)
}

Method HIPMessageServer2(input1 As %String, input2 As %GlobalCharacterStream) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HIPMessageServer2").Invoke($this,"http://www.dhcc.com.cn/DHC.Published.PUB0004.BS.PUB0004.HIPMessageServer2",.input1,.input2)
}

/// 发送消息
Method SendMessage(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	set msgID="MES0090"
 	Quit ..WebMethod("HIPMessageServer2").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"HIPMessageServer2",.msgID,.args)
}

/// 获取就诊信息
Method GetAdmission(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	set msgID="MES0085"
 	Quit ..WebMethod("HIPMessageServer2").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"HIPMessageServer2",.msgID,.args)
}

/// 获取用户信息
Method GetUserInfo(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	set msgID="﻿MES0085"
 	Quit ..WebMethod("HIPMessageServer2").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"HIPMessageServer2",.msgID,.args)
}

/// 获取检验数据
Method GetLabList(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	set msgID="﻿MES0085"
 	Quit ..WebMethod("HIPMessageServer2").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"HIPMessageServer2",.msgID,.args)
}

/// 获取体温单数据
Method GetVitalSign(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	set msgID="MES0085"
 	Quit ..WebMethod("HIPMessageServer2").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"HIPMessageServer2",.msgID,.args)
}

/// 发送手术安排数据
Method SendOperArrangeInfo(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	if ..#DEBUG=1 write "AIS:soap send... SendOperArrangeInfo",!
	set msgID="MES0112"
	if ..#DEBUG=1 write "AIS:soap msgID:",msgID,!
 	Quit ..WebMethod("HIPMessageServer2").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"HIPMessageServer2",.msgID,.args)
}

/// 发送手术登记数据
Method SendOperRegisterInfo(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	if ..#DEBUG=1 write "AIS:soap send... SendOperRegisterInfo",!
	set msgID="MES0113"
	if ..#DEBUG=1 write "AIS:soap msgID:",msgID,!
 	Quit ..WebMethod("HIPMessageServer2").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"HIPMessageServer2",.msgID,.args)
}

/// 发送手术状态改变数据
Method SendOperStatusChangeInfo(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	if ..#DEBUG=1 write "AIS:soap send... SendOperStatusChangeInfo",!
	set msgID="MES0115"
	if ..#DEBUG=1 write "AIS:soap msgID:",msgID,!
 	Quit ..WebMethod("HIPMessageServer2").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"HIPMessageServer2",.msgID,.args)
}

/// 测试时调用
Method Test() As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	set msgID="﻿MES0085"
 	Quit ..WebMethod("HIPMessageServer2").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"HIPMessageServer2",.msgID,.args)
}

}
