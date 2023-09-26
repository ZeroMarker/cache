/// DHCMA.VTE.CAWebService
Class DHCMA.VTE.CAWebService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "CAWebService";

/// TODO:将此更改为实际 SOAP 命名空间.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 命名空间 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:2.1.	获取登录二维码.
/// 
Method GetData1(venderCode As %String, signType As %String, random As %String, guid As %String) As %String [ WebMethod ]
{
	Quit "success"
	Set result = ##Class(CA.Ajax.Webservice).GetData("GetLoginQR",venderCode,signType,random,guid)
	Quit result
}

/// TODO:2.2.	获取登录二维码授权结果.
Method GetData2(venderCode As %String, signType As %String, signGUID As %String) As %String [ WebMethod ]
{
	Set result = ##Class(CA.Ajax.Webservice).GetData("GetLoginQRResult",venderCode,signType,signGUID)
	Quit result
}

/// TODO:2.3.	获取授权静默签名二维码.
Method GetData3(venderCode As %String, signType As %String, certContainer As %String) As %String [ WebMethod ]
{
	Set result = ##Class(CA.Ajax.Webservice).GetData("GetAuthSignQR",venderCode,signType,certContainer)
	Quit result
}

/// TODO:2.4.	获取授权静默签名二维码授权结果
Method GetData4(venderCode As %String, signType As %String, signGUID As %String) As %String [ WebMethod ]
{
	Set result = ##Class(CA.Ajax.Webservice).GetData("GetAuthSignQRResult",venderCode,signType,signGUID)
	Quit result
}

/// TODO:2.5.	静默签名
Method GetData5(venderCode As %String, signType As %String, inData As %String, certContainer As %String, signToken As %String, episodeID As %String) As %String [ WebMethod ]
{
	Set result = ##Class(CA.Ajax.Webservice).GetData("AuthSign",venderCode,signType,inData, certContainer, signToken, episodeID)
	Quit result
}

/// TODO:2.6.	数据Hash
Method GetData6(venderCode As %String, signType As %String, inData As %String) As %String [ WebMethod ]
{
	Set result = ##Class(CA.Ajax.Webservice).GetData("HashData",venderCode,signType,inData)
	Quit result
}

/// TODO:2.7.	获取指定CA用户的静默签名/自动签名状态
Method GetData7(venderCode As %String, signType As %String, userCertCode As %String) As %String [ WebMethod ]
{
	Set result = ##Class(CA.Ajax.Webservice).GetData("GetAuthSignStatus",venderCode,signType,userCertCode)
	Quit result
}

/// TODO:2.8.	根据HIS的UserID获取已绑定CA证书信息
Method GetData8(userID As %String, venderCode As %String, signType As %String) As %String [ WebMethod ]
{
	Set result = ##Class(CA.Ajax.Webservice).GetCertCodeByUserID(userID,venderCode,signType)
	Quit result
}

/// TODO:2.9.	手机证书PIN码登录并授权静默签名
Method GetData9(venderCode As %String, signType As %String, userCertCode As %String, pin As %String) As %String [ WebMethod ]
{
	Set result = ##Class(CA.Ajax.Webservice).GetData("PhonePinLogin",venderCode,signType,userCertCode,pin)
	Quit result
}

/// TODO:2.10 证书登录
Method GetData10(usrID As %String, UsrCertCode As %String, serverRan As %String, userSignedData As %String, certNo As %String, userCert As %String, signType As %String, venderCode As %String) As %String [ WebMethod ]
{
	Set result = ##Class(CA.Ajax.Webservice).Login2(usrID,UsrCertCode,serverRan,userSignedData,certNo,userCert,signType,venderCode)
	Quit result
}

/// TODO:2.11 根据二维码ID获取二维码图象Base64（二维码ID只能使用一次、使用后相应二维码数据将被清空）
Method GetData11(ID As %String) As %String [ WebMethod ]
{
	Set result = ##Class(CA.Ajax.Webservice).GetImage(ID)
	Quit result
}

/// TODO:2.12 判断token是否失效
Method GetData12(venderCode As %String, signType As %String, certContainer As %String, signToken As %String) As %String [ WebMethod ]
{
	Set result = ##Class(CA.Ajax.Webservice).GetData("GetTokenIsValid",venderCode,signType,certContainer,signToken)
	Quit result
}

/// TODO:2.13 验证签名数据，成功后返回时间戳值以及签名数据公共存储表ID
Method GetData13(UsrCertCode As %String, code As %String, contentHash As %String, signValue As %String, certNo As %String) As %String [ WebMethod ]
{
	Set result = ##Class(CA.Ajax.Webservice).Sign(UsrCertCode, code, contentHash, signValue, certNo)
	Quit result
}

/// TODO:2.17 获取CA最新签名图
Method GetData17(venderCode As %String, signType As %String, certContainer As %String) As %String [ WebMethod ]
{
	Set result = ##Class(CA.Ajax.Webservice).GetData("GetSeal",venderCode,signType,certContainer)
	Quit result
}

}
