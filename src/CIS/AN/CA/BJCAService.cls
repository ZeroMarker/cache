Class CIS.AN.CA.BJCAService Extends CIS.AN.CA.ServiceBase
{

/// Description:   CA服务初始化Session                   
/// Table：        ^CF("CA")        
/// Output：       开启：Y;  关闭：N            
/// Debug: d ##Class(CIS.AN.CA.BJCAService).CASessionDataInit() 
ClassMethod CASessionDataInit() As %String
{
	s service=..GetCAService()
	s strServerRan = service.GenRandom()
	s strServerSignedData =service.SignData(strServerRan)
	s strServerCert = service.GetServerCert()
 	b
	//s %session.Data("ServerRan")=strServerRan
	//s %session.Data("ServerSignedData")=strServerSignedData
	//s %session.Data("ServerCert")=strServerCert
	
	s service=""
	
	quit "{""ServerRan"":"""_strServerRan_""",""ServerSignedData"":"""_strServerSignedData_""",""ServerCert"":"""_strServerCert_"""}"
}

/// s service=##Class(CA.DigitalSignatureService).GetCAService()
/// dhcserviceclient.CA.BJCAServiceSoap
ClassMethod GetCAService() As %SOAP.WebClient
{
    // 创建对象
    s service=##Class(dhcserviceclient.CA.BJCAServiceSoap).%New() 
	//通过系统参数找到服务地址
    s service.Location=^CF("CA","CALocation")
	  
    q service
}

ClassMethod VerifyCertAndSignedData(argbstrCert As %String, argInData As %String, argsignedData As %String) As %String
{
	s rtnstr=""
	s service=..GetCAService()
	s rtnstr = service.VerifyCertAndSignedData(argbstrCert,argInData,argsignedData)
	s service=""
	
	q:(rtnstr=-1) "不信任机构"
	q:(rtnstr=-2) "超过有效期"
	q:(rtnstr=-3) "作废证书"
	q:(rtnstr=-4) "已加入黑名单"
	
	q:(($f(rtnstr, "JJ")>0)||($f(rtnstr, "SF")>0)) ""
	
	q "证书错误:"_rtnstr
}

/// Description:   签名，验证，盖时间戳     
/// Return：       成功：1^signID->CA.DigitalSignature的rowID  
///                失败：0^错误信息
/// Debug:       
ClassMethod Sign(recordSheet As CIS.AN.RecordSheet, signInfo As CIS.AN.CA.UsrSignatureInfo, code As %String, contentHash As %String, signValue As %String) As %String
{
	s $zt = "ErrorHandler"

    s service=..GetCAService()
    // 验证签名
    s ret=service.VerifySignedData(signInfo.Certificate, contentHash, signValue)
    q:0'=ret "E^验证签名失败"
       
    // 生成时间戳  原文+签名值
    s timeStampReq=service.CreateTimeStampRequest(contentHash_signValue)
    s signTimeStamp=service.CreateTimeStamp(timeStampReq)
   
    // 存入CIS.AN.Signature
    s signature=##Class(CIS.AN.Signature).%New() 
    s signature.UserCertID=signInfo.UsrCertCode
    s signature.SignCode=code
    s signature.SignData=signValue
    s signature.SignDate=+$h
    s signature.SignTime=$p($h,",",2)
    s signature.SignUser=signInfo.UsrID
    s signature.HashData=contentHash
    s signature.CertID=signInfo.CertificateSN
    s signature.RecordSheet=recordSheet
    s signature.SignTimeStamp=signTimeStamp
    s signature.SignType="C"
        
    s sc=signature.%Save()
    q:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
     
	q "S^"_signature.%Id()
		
ErrorHandler
   q "E^调用数字认证服务错误 "_$ZERROR
}

/// Description:   验证签名数据      
/// Return：       正确返回""，错误返回错误说明
/// Test:          d ##Class(CA.DigitalSignatureService) 
ClassMethod VerifySignedData(certificate As %String, contentHash As %String, signValue As %String, timeStamp As %String) As %String
{
    s service=..GetCAService()
    // 验证签名
    s ret=service.VerifySignedData(certificate, contentHash, signValue)
    q:0'=ret "验证签名错误！"
    // 验证时间戳
    s ret=service.VerifyTimeStamp(timeStamp)
    q:0'=ret "验证时间戳错误！"
    
    q ""
}

/// Description:   登录，证书验证      
/// Return：       错误说明, 正确返回""
/// Test:          d ##Class(CA.DigitalSignatureService) 
ClassMethod Login(usrID As %String, UsrCertCode As %String, serverRan As %String, userSignedData As %String, certNo As %String, userCert As %String) As %String
{
	s ret=""
	// 1.用户证书检查
	s info = ##Class(CIS.AN.CA.UsrSignatureInfo).GetInUsedInfoByKey(UsrCertCode)	
	q:""=info "E^证书:"_UsrCertCode_"未启用！" 
	if (usrID'="")
	{
		q:usrID'=info.UsrID "E^证书未关联当前用户！"
	} 
	//  更新证书
	if (certNo '= info.CertificateNo)
	{
		s ret=##Class(CIS.AN.CA.UsrSignatureInfo).DisUsed(info.UsrID)	
		q:ret'="" ret	
        d ##Class(CIS.AN.CA.UsrSignatureInfo).NewUsrSignatureInfo(info, certNo, userCert)		
	}
	// 2.验证服务器证书
	s ret = ..VerifyCertAndSignedData(userCert,serverRan,userSignedData)
	
	q:ret'="" "E^"_ret
	
	q "S^"
}

ClassMethod GenRandom() As %String
{
	s service=..GetCAService()
	q service.GenRandom()
}

ClassMethod OnUsbChanged()
{
	w " <script for='XTXAPP' event='OnUsbkeyChange' language='javascript'>",!
   	w " function OnUsbkeyChange() ",!
   	w " {",!
	w " 	GetList_pnp();",!
   	w " }",!
	w " ",!
	w " OnUsbkeyChange();",!
    w " </script>",!
}

/// d ##Class(CA.BJCAService).test()
ClassMethod test()
{
    // 创建对象
    s service=##Class(dhcserviceclient.CA.BJCAServiceSoap).%New() 
    w service,!
	//通过系统参数找到服务地址
    s service.Location="http://127.0.0.1/BJCA/Service.asmx" 
	  
    w service.GenRandom()
}

}
