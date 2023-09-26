Class CIS.OPApp.SRV.WebService.Client.ENSSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://127.0.0.1/imedical/web//CIS.OPApp.SRV.WebService.Server.ForENS.cls";

/// This is the class name of the web service.
Parameter SERVERCLASS = "CIS.AN.SRV.WebService.Server.ForENS";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "OPApp";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// This is the logon user name provided by the service.
Parameter LogonUser = "_system";

/// This is the logon password provided by the service.
Parameter Password = "SYS";

/// 发送消息
Method SendMessage(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	do ..WSSecurityLogin(..#LogonUser,..#Password)
 	Quit ..WebMethod("GetOperAppointmentList").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"SendMessage",.args)
}

/// 获取就诊信息
Method GetAdmission(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	do ..WSSecurityLogin(..#LogonUser,..#Password)
 	Quit ..WebMethod("GetAdmission").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"GetAdmission",.args)
}

/// 获取用户信息
Method GetUserInfo(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	do ..WSSecurityLogin(..#LogonUser,..#Password)
 	Quit ..WebMethod("GetUserInfo").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"GetUserInfo",.args)
}

/// 获取检验数据
Method GetLabList(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	do ..WSSecurityLogin(..#LogonUser,..#Password)
 	Quit ..WebMethod("GetLabList").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"GetLabList",.args)
}

/// 获取体温单数据
Method GetVitalSign(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	do ..WSSecurityLogin(..#LogonUser,..#Password)
 	Quit ..WebMethod("GetVitalSign").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"GetVitalSign",.args)
}

/// 发送手术安排数据
Method SendOperArrangeInfo(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	do ..WSSecurityLogin(..#LogonUser,..#Password)
 	Quit ..WebMethod("SendOperArrangeInfo").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"SendOperArrangeInfo",.args)
}

/// 发送手术登记数据
Method SendOperRegisterInfo(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	do ..WSSecurityLogin(..#LogonUser,..#Password)
 	Quit ..WebMethod("SendOperRegisterInfo").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"SendOperRegisterInfo",.args)
}

/// 发送手术状态改变数据
Method SendOperStatusChangeInfo(args As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	do ..WSSecurityLogin(..#LogonUser,..#Password)
 	Quit ..WebMethod("SendOperStatusChangeInfo").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"SendOperStatusChangeInfo",.args)
}

/// 测试时调用
Method Test() As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	do ..WSSecurityLogin(..#LogonUser,..#Password)
 	Quit ..WebMethod("Test").Invoke($this,..#NAMESPACE_"/"_..#SERVERCLASS_"."_"Test")
}

}
