Class CIS.AN.BL.CASignature Extends %RegisteredObject
{

/// 北京CA
Parameter BJCA = "BJCA";

/// 辽宁CA
Parameter LNCA = "LNCA";

/// 吉林安信
Parameter JLAX = "JLAX";

/// 网证通
Parameter NETCA = "NETCA";

/// 初始化参数
/// d ##Class(CA.DigitalSignatureService).InitParameter()
ClassMethod InitParameter()
{
  
	s ^CF("CA")="Y"
	s ^CF("CA","CACTLocIDs")=""
	s ^CF("CA","CACompany")=..#BJCA
	s ^CF("CA","CALocation")="http://172.21.21.31:8004/Service.asmx"
	s ^CF("CA","TSLocation")=""
}

/// Creator：      guozongtao
/// CreatDate：    2011-08-22
/// Description:   设置CA服务为开启状态
/// Table：        ^CF("CA")
/// Debug:         d ##Class(websys.CAConfigurationService).PowerOn()        
ClassMethod PowerOn()
{
	s ^CF("CA")="Y"
}

/// Creator：      guozongtao
/// CreatDate：    2011-08-22
/// Description:   设置CA服务为开启状态
/// Table：        ^CF("CA")
ClassMethod PowerOff()
{
	s ^CF("CA")="N"
}

ClassMethod IsCAON()
{
	q ^CF("CA")
}

ClassMethod GetCACompany() As %String
{
	q ^CF("CA","CACompany")
}

ClassMethod GetCACTLocIDs() As %String
{
	q ^CF("CA","CACTLocIDs")
}

ClassMethod SetCACTLocIDs(ids As %String) As %String
{
	s ^CF("CA","CACTLocIDs")=ids
}

ClassMethod GetCALocation() As %String
{
	q ^CF("CA","CALocation")
}

ClassMethod SetCALocation(locaction As %String) As %String
{
	s ^CF("CA","CALocation")=locaction
}

ClassMethod GetService() As CA.ServiceBase
{
	if (..#BJCA=..GetCACompany())
	{
		q ##Class(CA.BJCAService).%New()
	}
	elseif (..#LNCA=..GetCACompany())
	{
		q ##Class(CA.LNCAService).%New()
	} 
	elseif (..#JLAX=..GetCACompany())
	{
		q ##Class(CA.JLAXService).%New()
	}
	elseif (..#NETCA=..GetCACompany())
	{
		q ##Class(CA.NETCAService).%New()
	}
			
	q ""
}

/// Description:   登录，证书验证      
/// Return：       错误说明, 正确d返回""
/// Test:          d ##Class(CA.DigitalSignatureService) 
ClassMethod Login(usrID As %String, UsrCertCode As %String, serverRan As %String, userSignedData As %String, certNo As %String, userCert As %String) As %String
{
	//s ^CacheTemp("Login")=usrID_"|"_UsrCertCode_"|"_serverRan_"|"_userSignedData_"|"_certNo_"|"_userCert
	s service=..GetService()
	s result=service.Login(usrID, UsrCertCode, serverRan, userSignedData, certNo, userCert)
	s service=""
	q result
}

ClassMethod CheckRandom(cRan As %String, sRan As %String) As %String
{
	s service=..GetService()
	q service.CheckRandom(cRan, sRan)
}

/// w ##Class(CA.DigitalSignatureService).GetRandom()
ClassMethod GetRandom() As %String
{
    s service=..GetService()
	s result=service.GenRandom()
	s service=""
	q result
}

/// Description:   签名，验证，盖时间戳，保存至CA.DigitalSignature      
/// Return：       成功：1^signID->CA.DigitalSignature的rowID  
///                失败：0^错误信息
/// Debug:         w ##Class(CA.DigitalSignatureService).Sign 
ClassMethod Sign(UsrCertCode As %String, code As %String, contentHash As %String, signValue As %String) As %String
{
	q:(""=contentHash) "0^签名原文不能为空"
	q:(""=signValue) "0^签名值不能为空"
	
	s signInfo=##Class(CA.UsrSignatureInfo).GetInUsedInfoByKey(UsrCertCode)
	q:(""=signInfo) "0^未找到["_UsrCertCode_"]证书信息"
	
    s service=..GetService()
	s result=service.Sign(.signInfo, code, contentHash, signValue)
	s service=""
	q result
}

/// w ##Class(CA.DigitalSignatureService).CASessionDataInit()
ClassMethod CASessionDataInit()
{
	s service=..GetService()
	d service.CASessionDataInit()
	s service=""
}

ClassMethod VerifyCertAndSignedData(userCert As %String, serverRan As %String, userSignedData As %String) As %String
{
	s service=..GetService()
	s result=service.VerifyCertAndSignedData(userCert,serverRan,userSignedData)
	s service=""
	q result
}

/// Description:   CA服务初始化Session                   
/// Table：        ^CF("CA")        
/// Description:   完成登录验证。通过该方法，可以实现验证用户证书，验证签名，然后获取用户证书的唯一标识。     
/// Input：        string bstrCert客户端证书, 隐含元素
///                string InData  服务器端随机数 session, 
///                string signedData 客户端签名,隐含元素
/// Output：       正确返回""，错误返回相关信息          
/// 验证签名数据
ClassMethod VerifySign(signID As %String, contentHash As %String)
{
    s sign=##Class(CA.DigitalSignature).%OpenId(signID)
	s info=##Class(CA.UsrSignatureInfo).%OpenId(sign.UsrSignInfoID)		
	s service=..GetService()
	s result=service.VerifySignedData(info.Certificate, contentHash, sign.SignValue, sign.SignTimeStamp)
    q result
    s service=""
}

/// d ##Class(CA.DigitalSignatureService).OnUsbChanged()
ClassMethod OnUsbChanged()
{
	s service=..GetService()
	d service.OnUsbChanged()
	s service=""
}

ClassMethod IsCACTLoc(CTLocID As %String) As %String
{
	    s ctloc=..GetCACTLocIDs()
	    //s ^CacheTemp("IsCACTLoc")=ctloc
	    if ($C(0)=ctloc) || ("NULL"=ctloc) // 未配置，不开启
	    {
		    q "0"
		}
		elseif ("ALL"=ctloc) // 全院使用
		{
			q "1"
		}
	    else  //部分科室使用
	    {
		    //w !,"ctloc"_ctloc
		    s is=0
		    s count=$Length(ctloc, "^")
		    f i=1:1:count
		    {
			    if ($p(ctloc, "^", i)=CTLocID)
			    {
				    s is=1
				    q
				}
			}
	 
			if (1=is)
			{
				q "1"
		    }
		    else
		    {
			    q "0"
			}
		}
 
        q "1"
}

/// Description:   获取服务状态
/// w ##Class(CA.DigitalSignatureService).GetCAServiceStatus("1")
ClassMethod GetCAServiceStatus(CTLocID As %String) As %String
{
    // 检查CA开关,服务出了问题
    s rtnstr=$g(^CF("CA"))
    q:(""=rtnstr)||("N"=rtnstr) "0"
    
    q ..IsCACTLoc(CTLocID)
}

/// 返回错误信息
ClassMethod DisUsed(usrID As %String) As %String
{
	q ##Class(CA.UsrSignatureInfo).DisUsed(usrID)
}

ClassMethod NewUsrSignatureInfo(info As CA.UsrSignatureInfo, certNo As %String, userCert As %String)
{
	d ##Class(CA.UsrSignatureInfo).NewUsrSignatureInfo(info, certNo, userCert)
}

ClassMethod OutPutSecXKeyExist()
{
	s caCompany=##Class(CA.DigitalSignatureService).GetCACompany()
    if (..#NETCA=caCompany)
	{
		w "<script type='text/javascript' src='../scripts/epr/js/netcapki.js'>",!
        w "</script>",!
	}	
	w "<script type='text/javascript' src='../scripts/epr/js/SecX_KeyExist_"_caCompany_".js'>",!
    w "</script>",!
}

ClassMethod OutPutSecXCommon()
{
	s caCompany=##Class(CA.DigitalSignatureService).GetCACompany()
	if (..#BJCA=caCompany)
	{
		w "<script type='text/javascript' src='../scripts/epr/js/date.js'>",!
        w "</script>",!
	}
	elseif (..#NETCA=caCompany)
	{
		w "<script type='text/javascript' src='../scripts/epr/js/netcapki.js'>",!
        w "</script>",!
	}	
	
	w "<script type='text/javascript' src='../scripts/epr/js/SecX_Common_"_caCompany_".js'>",!
    w "</script>",!
}

/// 之前的配置数据是保存在电子病历的系统参数表内
/// d ##Class(CA.DigitalSignatureService).SysOptionMigration()
ClassMethod SysOptionMigration()
{
	s CACTLocIDs=##class(EPRmeta.SysOption).GetOptionValueByName("CACTLocIDs")
	s ^CF("CA","CACTLocIDs")=CACTLocIDs
	w "开放数字签名的科室："_CACTLocIDs,!
	s CALocation=##class(EPRmeta.SysOption).GetOptionValueByName("CALocation")
    s ^CF("CA","CALocation")=CALocation
    w "数字签名的服务地址："_CALocation,!
}

/// w ##Class(CA.DigitalSignatureService).test()
ClassMethod test() As %String
{
    s service=..GetService()
}

}
