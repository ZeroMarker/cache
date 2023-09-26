Class CIS.AN.CA.ServiceBase Extends (%RegisteredObject, %XML.Adaptor)
{

/// Description:   CA服务初始化Session                   
/// Table：        ^CF("CA")        
/// Output：       开启：Y;  关闭：N            
/// Debug: d ##Class(CA.BJCAServic).CASessionDataInit() 
ClassMethod CASessionDataInit()
{
	q ""
}

/// s service=##Class(CA.DigitalSignatureService).GetCAService()
/// dhcserviceclient.CA.ServiceSoap
ClassMethod GetCAService() As %SOAP.WebClient
{
   q ""
}

ClassMethod VerifyCertAndSignedData(argbstrCert As %String, argInData As %String, argsignedData As %String) As %String
{
	q ""
}

/// Description:   签名，验证，盖时间戳     
/// Return：       成功：1^signID->CA.DigitalSignature的rowID  
///                失败：0^错误信息
/// Debug:       
ClassMethod Sign(recordSheet As CIS.AN.RecordSheet, signInfo As CIS.AN.CA.UsrSignatureInfo, code As %String, contentHash As %String, signValue As %String) As %String
{
	q ""
}

/// Description:   验证签名数据      
/// Return：       正确返回""，错误返回错误说明
/// Test:          d ##Class(CA.DigitalSignatureService) 
ClassMethod VerifySignedData(certificate As %String, contentHash As %String, signValue As %String, timeStamp As %String) As %String
{
    
    q ""
}

/// Description:   登录，证书验证      
/// Return：       错误说明, 正确返回""
/// Test:          d ##Class(CA.DigitalSignatureService) 
ClassMethod Login(usrID As %String, UsrCertCode As %String, serverRan As %String, userSignedData As %String, certNo As %String, userCert As %String) As %String
{
	
	q ""
}

ClassMethod GenRandom() As %String
{
	q ""
}

ClassMethod OnUsbChanged()
{
}

ClassMethod CheckRandom(cRan As %String, sRan As %String) As %String
{
	q:(cRan'=sRan) "0^"_"证书会话已过期，请重新认证"
	q ""
}

/// Desc:	替换掉字符串中的回车换行符号
ClassMethod FilterIlleaglChar(txt As %String) As %String
{
	s txt = $tr(txt,$c(10),"")
	s txt = $tr(txt,$c(13),"")
	q txt
}

}
