/// 包装EPRservice.BLDigitalSignature，对外提供服务
Class EPRservice.BODigitalSignature Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "BODigitalSignature";

ClassMethod GetContent(usrID As %String, printDocID As %String, insID As %String, episodeID As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##Class(EPRservice.BLDigitalSignature).GetContent(usrID, printDocID, insID, episodeID)
}

ClassMethod GetContentByIDs(IDs As %String) As %GlobalCharacterStream [ WebMethod ]
{
	q ##Class(EPRservice.BLDigitalSignature).GetContentByIDs(IDs)
}

/// 唯一模板 获取instanceIDs  id^id^id
ClassMethod GetInstanceIDs(usrID As %String, printDocID As %String, episodeID As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLDigitalSignature).GetInstanceIDs(usrID, printDocID, episodeID)
}

ClassMethod Sign(UsrCertCode As %String, episodeID As %String, printDocID As %String, eprNum As %String, insIDs As %String, signValue As %String, contentHash As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLDigitalSignature).Sign(UsrCertCode, episodeID, 
	printDocID, eprNum, insIDs, signValue, contentHash)
}

ClassMethod GetCAServiceStatus(CTLocID As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLDigitalSignature).GetCAServiceStatus(CTLocID)
}

// printType: Single 唯一； Multiple：可重复

// 取病历对应的最后一次签名者的图片

ClassMethod GetSignImage(episodeID As %String, printDocID As %String, instanceID As %String, printType As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLDigitalSignature).GetSignImage(episodeID, printDocID, instanceID, printType)
}

ClassMethod GetUserSignImage(usrID As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLDigitalSignature).GetUserSignImage(usrID)
}

/// 是否有有效的签名，如果有返回，没有返回""
ClassMethod HasValidSign(episodeID As %String, printDocID As %String, eprNum As %String) As %String [ WebMethod ]
{
	
	q ##Class(EPRinstance.DigitalSignLog).GetValidSign(episodeID, printDocID, eprNum)
}

/// d ##Class(EPRservice.BODigitalSignature).SetSignUnvalid(20)
/// 将所有相关的签名日志记录都设置为失效状态
ClassMethod SetSignUnvalid(signLogID As %String) [ WebMethod ]
{
	d ##Class(EPRinstance.DigitalSignLog).SetSignUnvalid(signLogID)
}

/// Desc: 		获取上级医师签名图
ClassMethod GetSuperiorImage(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLDigitalSignature).GetSuperiorImage(argEpisodeID, argPrintDocID, argEPRNum)
}

/// Desc: 		获取创建者签名图
ClassMethod GetCreaterImage(argEpisodeID As %String, argPrintDocID As %String, argEPRNum As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLDigitalSignature).GetCreaterImage(argEpisodeID, argPrintDocID, argEPRNum)
}

/// Desc: 		导入签名图
/// 错误返回问题
ClassMethod ImportImage(usrCode As %String, img As %String) As %String [ WebMethod ]
{
	s usrID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(usrCode,"U"),"")) 
    q:(usrID="") "未找到用户："_usrCode
	s info = ##Class(CA.UsrSignatureInfo).GetInUseInfo(usrID)
	q:(info="") usrID_" 未绑定证书！"
    
    s info.SignImage=img
    d info.%Save()
    
    q ""
}

// Desc: 		导入签名图

/// 错误返回问题
ClassMethod ImportNewImage(usrCode As %String, img As %String) As %String [ WebMethod ]
{
	s usrID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(usrCode,"U"),"")) 
    q:(usrID="") "未找到用户："_usrCode

	s info = ##Class(CA.UsrSignatureInfo).GetInUseInfo(usrID)
	if (info="")
	{
		s info = ##Class(CA.UsrSignatureInfo).%New()
		s info.UsrCertCode=usrCode
		s info.InUse=1
		s info.UsrID=usrID
		s info.SignImage=img
    	d info.%Save()
	}
	else
	{
		s info.SignImage=img
    	d info.%Save()
	}
    q ""
}

/// Desc: 	get签名图
/// 错误返回问题
ClassMethod GetImage(usrCode As %String) As %String [ WebMethod ]
{
	s usrID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(usrCode,"U"),"")) 
    q:(usrID="") "未找到用户："_usrCode	
	s info = ##Class(CA.UsrSignatureInfo).GetInUseInfo(usrID)
	q:(info="") usrID_" 未绑定证书！"
     
    q info.SignImage
}

/// Desc: 	get签名图
/// 错误返回问题
ClassMethod GetImageByUsrID(usrID As %String) As %String [ WebMethod ]
{
	//s info = ##Class(CA.UsrSignatureInfo).%OpenId(7)
	s info = ##Class(CA.UsrSignatureInfo).GetInUseInfo(usrID)
	q:(info="") usrID_" 未绑定证书！"
     
    q info.SignImage
}

/// w ##Class(EPRservice.BODigitalSignature).GetInuseID()
ClassMethod GetInuseID() As %XML.DataSet [ WebMethod ]
{
 
    //%XML.DataSet
 	s qry = ##Class(%XML.DataSet).%New("%DynamicQuery:SQL")
	s sql = "SELECT ID, SignImage FROM CA.UsrSignatureInfo WHERE InUse =1"
	d qry.Prepare(sql)
	d qry.SetArgs()
    q qry
}

/// usrID As %String, img As %String
/// w ##Class(EPRservice.BODigitalSignature).ChangeImgColor()
ClassMethod ChangeImgColor(usrID As %String, img As %String) As %String [ WebMethod ]
{
	s info = ##Class(CA.UsrSignatureInfo).GetInUseInfo(usrID)
	q:(info="") usrID_" 未绑定证书！"
    
    s info.SignImage=img
    d info.%Save()
    

    q ""
}

}
