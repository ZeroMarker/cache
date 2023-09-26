/// Desc:       签名逻辑
/// Creator:    Candy
/// CreateDate: 2014-7-25
Class EMRservice.BL.BLEMRSign Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       保存签名信息
/// Creator:    Candy
/// CreateDate: 2016-6-21
/// Input:      AEpisodeID 就诊号
///             AInstanceID 实例ID
///             AUserID 签名用户ID
///             ASignID CA 签名ID
///             AAction 签名状态
///             ADigest 摘要
///             AType 类型 
///             APath 签名单元ID
///             AActionType 签名类型
/// 			ADocSignType 文档存储类型(cdaxml 签名域/compressxml 压缩整个原文签名/xml 非压缩整个原文签名/layoutxml 展现部分签名)
ClassMethod SetMERSign(AEpisodeID As %String, AInstanceID As %String, AUserID As %String, ASignID As %String, AAction As %String, ADigest As %String, AType As %String, argInData As %GlobalBinaryStream, APath As %String, AActionType As %String, ALocID As %String, AIsCompressDocument As %String, ADocSignType As %String = "") As %String
{
	s result = 0
	if (AActionType = "Replace")
	{
		TStart
		s result = ..RevokeSign(AEpisodeID,AInstanceID,AUserID,AAction,APath)
		if ($p(result,"^",1) '= 0)
		{
			s result = ..SaveEMRSign(AEpisodeID,AInstanceID,AUserID,ASignID,AAction,ADigest,AType,argInData,APath,1,ALocID,AIsCompressDocument,ADocSignType)
	        if ($p(result,"^",1) '= 0)
	        {
		        TCommit
		    }
		    else
		    {
			    TRollback
			}
		}
	}
	elseif (AActionType = "Append")
	{
		s result = ..SaveEMRSign(AEpisodeID,AInstanceID,AUserID,ASignID,AAction,ADigest,AType,argInData,APath,1,ALocID,AIsCompressDocument,ADocSignType)	
	}
	q result
}

/// Desc:       保存签名信息
/// Creator:    Candy
/// CreateDate: 2014-7-25
/// Input:      AEpisodeID 就诊号
///             AInstanceID 实例ID
///             AUserID 签名用户ID
///             ASignID CA 签名ID
///             AAction 签名状态
///             ADigest 摘要
///             AType 类型 
///             APath 签名单元ID
/// 			ADocSignType 文档存储类型(cdaxml 签名域/compressxml 压缩整个原文签名/xml 非压缩整个原文签名/layoutxml 展现部分签名)
ClassMethod SaveEMRSign(AEpisodeID As %String, AInstanceID As %String, AUserID As %String, ASignID As %String, AAction As %String, ADigest As %String, AType As %String, argInData As %GlobalBinaryStream, APath As %String, ASignValid As %String, ALocID As %String, AIsCompressDocument As %String, ADocSignType As %String = "") As %String
{
	s result = "0"
	q:((AEpisodeID = "")||(AInstanceID = "")||(AUserID = "")||(AAction = "")) result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s EMRNum = objInstance.ListNo
	k objInstance
	s ecrecordId = $p(AInstanceID,"||",1)
	s objEcrecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result 
	s EMRDocID = objEcrecord.RealChartItemID
	s documentType = objEcrecord.DocumentType
	k objEcrecord
	s rowId = $o(^DHCEMRI.EMRSignI("IdxUnique"," "_AEpisodeID," "_EMRDocID," "_EMRNum," "_$zcvt(APath,"U")," "_$Zcvt(AAction,"u"),""))

	if (rowId '= "" )
	{
		s objEMRSign = ##Class(EMRinstance.EMRSign).%OpenId(rowId)
	}
	else
	{
		s objEMRSign = ##Class(EMRinstance.EMRSign).%New()
	}
	
	q:(objEMRSign = "") result	
	s objEMRSign.Action = AAction
	s objEMRSign.EMRDocID = EMRDocID
	s objEMRSign.Code = APath
	s objEMRSign.EMRNum = EMRNum
	s objEMRSign.EpisodeID = AEpisodeID
	s objEMRSign.UsrID = AUserID
	s objEMRSign.InstanceID = AInstanceID
	s objEMRSign.SignDate = $p($h,",",1)
	s objEMRSign.SignTime = $p($h,",",2)
	s objEMRSign.Type = AType
	s objEMRSign.SignID = ASignID
	//摘要信息为文档压缩后，再生成的摘要
	s objEMRSign.Digest = ADigest
	s objEMRSign.isSignValid = ASignValid  //$Case(AActionType,"Append":1,:0)
	s objEMRSign.UsrLoginLocID = ALocID
	s objEMRSign.DocSignType = ADocSignType
	s sc = objEMRSign.%Save()
	if $$$ISOK(sc) 
	{
		//cdaxml 签名域/compressxml 压缩整个原文签名/layoutxml 展现部分签名         此类型作废：xml 非压缩整个原文签名
		s docSignType = $ZCVT(ADocSignType,"U")
		if (docSignType="CDAXML")
		{
			s outStream = ##Class(%GlobalBinaryStream).%New()
			//压缩：实例+打散+cdaxml
			if (AIsCompressDocument="TRUE")
			{
				s lastData = ##Class(EMRservice.Parser.StreamData).GetFirstParserStream(argInData,"-----------------------------7da4a26140fde",outStream)
				s signData = ##Class(EMRservice.Parser.StreamData).GetFirstParserStream(lastData,"-----------------------------7da4a26140fde",outStream)
			}
			else //非压缩：实例+cdaxml
			{
				s signData = ##Class(EMRservice.Parser.StreamData).GetFirstParserStream(argInData,"-----------------------------7da4a26140fde",outStream)
			
			}
		}
		elseif(docSignType="COMPRESSXML")
		{
			//对病历压缩后信息签名，原文为压缩后文档
			s signData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"","-----------------------------7da4a26140fde","")
		}
		elseif(docSignType="LAYOUTXML")
		{
			if (documentType = "DOC")
			{
				s signData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<abiword","</abiword>","10")
			}
			else
			{		
				s signData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<iEditor","</iEditor>","10")
			}
		}
		else
		{
			q "0^未获取到实际的签名类型，请联系系统管理员检查客户端环境是否正常。"
		}
		
		if (AType = "CA")
		{
			s signmd5 = ##class(%SYSTEM.Encryption).MD5HashStream(signData,.sc)
			q:($$$ISERR(sc)) "0^md5失败"
			s signmd5 = ##class(web.Util.Encryption).Byte2Hex(signmd5)
			s signmd5 = $zcvt(signmd5,"L")

			if (signmd5 '= ADigest) 
			{
				q "0^签名原文不一致请检查"
			}
		}
		//后台压缩
		s signCompressData = ##Class(EMRservice.Parser.StreamData).CompressStream(signData)
		TStart
		if (AType = "CA")
		{
			d signData.Rewind()	
			s resultLog = ..SaveEMRSignLog(objEMRSign,signCompressData)	
			if (resultLog = "0")
			{
				TRollback
				q result
			}
		}
        elseif (AType = "AnySign")
		{
			s resultLog = ..SaveEMRAnySignLog(objEMRSign,signCompressData)	
			if (resultLog = "0")
			{
				TRollback
				q result
			}
		}
		else
		{
			s resultLog = ..SaveEMRSignLog(objEMRSign,"")	
			if (resultLog = "0")
			{
				TRollback
				q result
			}
		}
		TCommit	
		s result ="1^"_objEMRSign.%Id()_"^"_$P(resultLog,"^",2)
	}
	else
	{
		Do DecomposeStatus^%apiOBJ(sc,.errors,"d")
		s result =result_"^"_errors
	}
    q result
}

/// Desc: 失效签名
/// Input:
ClassMethod RevokeSign(AEpisodeID As %String, AInstanceID As %String, AUserID As %String, AAction As %String, APath As %String) As %String
{
	s result = "0"
	q:((AEpisodeID = "")||(AInstanceID = "")||(AUserID = "")||(AAction = "")) result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s EMRNum = objInstance.ListNo
	k objInstance
	s ecrecordId = $p(AInstanceID,"||",1)
	s objEcrecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result
	//修复遗漏代码 
	s EMRDocID = objEcrecord.RealChartItemID
	k objEcrecord
	s rowId = ""
	s actionInfo = ##Class(EMRservice.BL.BLEMRSign).GetSameRoleLevelAction(AAction)
	q:(actionInfo = "") result
	s count=$l(actionInfo, "^")
	f i=1:1:count 
	{
		s action = $p(actionInfo, "^", i)
		q:(action = "")
		
		s rowId = $o(^DHCEMRI.EMRSignI("IdxUnique"," "_AEpisodeID," "_EMRDocID," "_EMRNum," "_$zcvt(APath,"U")," "_$Zcvt(action,"u"),""))
		s:(rowId = "") rowId = $o(^DHCEMRI.EMRSignI("IdxUnique"," "_AEpisodeID," "_EMRDocID," "_EMRNum," "," "_$Zcvt(action,"u"),""))
		q:(rowId '= "")
	}
	q:(rowId = "" ) result
	s objEMRSign = ##Class(EMRinstance.EMRSign).%OpenId(rowId)
	s objEMRSign.isSignValid = "0"
	TStart
	s sc = objEMRSign.%Save()
	if $$$ISOK(sc) 
	{
		s resultLog = ..SaveEMRSignLog(objEMRSign,"")	
		if (resultLog = "0")
		{
			TRollback
			q result
		}
		TCommit	
		s result ="1^"_objEMRSign.%Id()
	}
  q result
}

/// Desc:       保存患者签名病历原文xml
/// CreateDate: 
/// Creator:    
/// Input:      AEMRSign 患者签名数据表EMRinstance.Anysignlog表Rowid
///             AargInData 签名xml 
ClassMethod SaveEMRAnySignLog(AEMRSign As EMRinstance.EMRSign, AargInData As %GlobalBinaryStream) As %String
{
	s result = "0"
	q:(AEMRSign = "") result

	s objEMRAnySingLog = ##Class(EMRinstance.AnySignLog).%OpenId(AEMRSign.SignID)
	d objEMRAnySingLog.InstanceData.CopyFrom(AargInData)
	s objEMRAnySingLog.Digest = AEMRSign.Digest
	s objEMRAnySingLog.DocSignType = AEMRSign.DocSignType
	s:($$$ISOK(objEMRAnySingLog.%Save())) result = "1^"_objEMRAnySingLog.%Id()
	q result
}

/// Desc:       保存签名历史
/// CreateDate: 2015-7-29
/// Creator:    Candyxu
/// Input:      AEMRSign 签名数据
///             AargInData 签名xml 
ClassMethod SaveEMRSignLog(AEMRSign As EMRinstance.EMRSign, AargInData As %GlobalBinaryStream) As %String
{
	s result = "0"
	q:(AEMRSign = "") result
	s signlogType = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("SignlogType")	
	if ($zcvt(signlogType,"U") = "LAST")
	{
		q:(AargInData = "")||(AargInData.Size <=0) "1"
		s rowId = "",objEMRSingLog=""
		for
		{
			s rowId = $o(^DHCEMRCA.EMRSignLogI("IdxInstance"," "_AEMRSign.InstanceID,rowId))
			q:(rowId="")
			if (rowId '= "")
			{
				s objSingLog = ##Class(EMRinstance.EMRSignLog).%OpenId(rowId)
				if (objSingLog.Code=AEMRSign.Code)
				{
					s objEMRSingLog = objSingLog
					q
				}
			}
		}
		if (objEMRSingLog="")
		{
			s objEMRSingLog = ##Class(EMRinstance.EMRSignLog).%New()
		}
	}
	else
	{
		s objEMRSingLog = ##Class(EMRinstance.EMRSignLog).%New()
	}
	s objEMRSingLog.EMRSignID = AEMRSign.%Id()
	s objEMRSingLog.Action = AEMRSign.Action
	s objEMRSingLog.Digest = AEMRSign.Digest
	s objEMRSingLog.EMRDocID = AEMRSign.EMRDocID
	s objEMRSingLog.Code = AEMRSign.Code
	s objEMRSingLog.EMRNum = AEMRSign.EMRNum
	s objEMRSingLog.EpisodeID = AEMRSign.EpisodeID
	s objEMRSingLog.InstanceID = AEMRSign.InstanceID
	s objEMRSingLog.isSignValid = AEMRSign.isSignValid
	s objEMRSingLog.SignDate = AEMRSign.SignDate
	s objEMRSingLog.SignTime = AEMRSign.SignTime
	s objEMRSingLog.SignID = AEMRSign.SignID
	s objEMRSingLog.UsrID = AEMRSign.UsrID
	s objEMRSingLog.UsrLoginLocID = AEMRSign.UsrLoginLocID
	s objEMRSingLog.DocSignType = AEMRSign.DocSignType
	d objEMRSingLog.InstanceData.CopyFrom(AargInData)
	s:($$$ISOK(objEMRSingLog.%Save())) result = "1^"_objEMRSingLog.%Id()
	q result
}

/// Desc:       验证系统签名用户,返回用户信息
/// Creator:    Candy
/// CreateDate: 2014-8-20
/// Input:      AUserCode 用户工号
///             APassword 用户密码 
///             ALocID    科室ID
///             APasswordType 密码验证类型 值为INSU时取医保验证
///             AType 住院还是门诊
///             AEpisodeID 就诊号
///             AHospitalID 医院ID
///             AOriSignatureLevel 签名单元code
///             AInstanceID 实例ID
/// Output:     UserID,UserName,level
///             characterCode 最高级别(EMRmeta.SignRole表的RoleLevel最高)签名角色代码（EMRmeta.SignRole表的Name）
///             characterDesc 最高级别签名角色描述（EMRmeta.SignRole表的Description）
///             characterRange 签名角色范围
/// Debug:      w ##Class(EMRservice.BL.BLEMRSign).GetUserInfo("YS02","","132","","inpatient","170","3","Check","")
ClassMethod GetUserInfo(AUserCode As %String, APassword As %String, ALocID As %String, APasswordType As %String = "", AType As %String = "", AEpisodeID As %String = "", AHospitalID As %String = "", AOriSignatureLevel As %String = "", AInstanceID As %String = "") As %String
{
	s $zt = "ErrorHandler"	
	s json = ""
	q:(AUserCode = "") json
	
	k PLIST	
	s userID = ##class(EMRservice.BL.BLPowerUser).GetUserId(AUserCode,AHospitalID)
	q:(userID = "") json
	///验证用户
	if (APassword '= "")
	{
		s loginValid = ##class(EMRservice.BL.BLPowerUser).IsLogonValid(AUserCode,APassword,AHospitalID)	
		q:(loginValid = 0) json
	}
	s userName = ##Class(EMRservice.BL.BLPowerUser).GetUserName(userID)
	s userLevel = ##class(EMRservice.BL.BLSignRole).GetUserLevel(userID,AEpisodeID,ALocID)
	s levelCode = $p(userLevel,"^",1)
	s levelDesc = $p(userLevel,"^",2)
	//职称
	s CTPCPDesc = ##Class(EMRservice.BL.BLSignRole).GetUserCTPCPDesc(userID)
	s userPos = ##Class(EMRservice.BL.BLSignRole).GetUserPosition(userID,ALocID)	
    s posCode = $p(userPos,"^",1)
    s posDesc = $p(userPos,"^",2)
    
    if (AOriSignatureLevel '= "")
    {
    	s signCharacterInfo = ##Class(EMRservice.BL.BLSignRole).GetSignCharacter(AOriSignatureLevel,userID,ALocID,AEpisodeID)
    }
    else
    {
	    s signCharacterInfo = ##Class(EMRservice.BL.BLSignRole).GetInstanceSignCharacter(AInstanceID,userID,ALocID,AEpisodeID)
    }
    s characterCode = $p(signCharacterInfo,"^",1)
	s characterDesc = $p(signCharacterInfo,"^",2)
	s characterRange = $p(signCharacterInfo,"^",3)
    
    if (AType = "inpatient")
    {
	    s signType = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SignTypeInP","")
    }
    else
    {
		s signType = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SignType","Text")
    }
	s image = ""
	if (signType = "Graph")
	{
		s info = ##Class(CA.UsrSignatureInfo).GetInUseInfo(userID)
		if (info '= "") && (info.SignImage '= "") 
		{
			s image = $Replace($ZSTRIP(info.SignImage,"*C")," ","")
		}
		else
		{
			s signType = "Text"
		}
	}
	
    //判断CA是否开启，最新的程序增加产品模块的判断
    s isSignGraphNoCA = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("isSignGraphNoCA","Y")    
    if ($ll((##class(%Dictionary.CompiledMethod).%OpenId("CA.DigitalSignatureService||IsCACTLoc")).DefaultArgs) = "4") {
        s ModelCode = "OPEMR"
        s:(AType = "inpatient") ModelCode = "IPEMR"
        
        s IsCACTLoc=##Class(CA.DigitalSignatureService).IsCACTLoc(ALocID,userID,"",ModelCode)
        if ((isSignGraphNoCA = "N")&&(IsCACTLoc = 0))
        {
            s signType = "Text"
        }
    } else {
        s IsCACTLoc = ##class(CA.DigitalSignatureService).IsCACTLoc(ALocID)
        s IsCAUser = 1
        if (##class(%Dictionary.CompiledMethod).%ExistsId("CA.UsrInUseInfo||GetInUsedByUserID") = 1)
        {
            s InUse = ##class(CA.UsrInUseInfo).GetInUsedByUserID(userID)
            s:(InUse = 1) IsCAUser = 0
        }
        if ((isSignGraphNoCA = "N")&&((IsCACTLoc = 0)||(IsCAUser = 0)))
        {
            s signType = "Text"
        }
    }
	
   	s json = "{'UserID':'"_userID_"','UserName':'"_userName_"','UserLevel':'"_levelCode_"','LevelDesc':'"_levelDesc_"','UserPos':'"_posCode_"','PosDesc':'"_posDesc_"','Type':'"_signType_"','Image':'"_image_"','CTPCPDesc':'"_CTPCPDesc_"','characterCode':'"_characterCode_"','characterDesc':'"_characterDesc_"','characterRange':'"_characterRange_"'}"
   	q json
ErrorHandler 
    q ""
}

/// Desc: 返回数字签名信息
/// debug:w ##Class(EMRservice.BL.BLEMRSign).CALogin("uhwHeWt/hx8e3xMmAEJRXg==","1050","MEUCIClAGN9vfZj6tBqfpdLuzctGjFrsIu85aIjRox0h38H9AiEApy48XLDDoacr/WO9nxb8Ijz+scsoXaG8o1DHaZpxi3I=",105,"999000100007193","MIIDAzCCAqigAwIBAgIKLRAAAAAAAAViMzAKBggqgRzPVQGDdTBEMQswCQYDVQQGDAJDTjENMAsGA1UECgwEQkpDQTENMAsGA1UECwwEQkpDQTEXMBUGA1UEAwwOQmVpamluZyBTTTIgQ0EwHhcNMTUwNzIxMTYwMDAwWhcNMTYxMjIyMTU1OTU5WjAmMQswCQYDVQQGDAJDTjEXMBUGA1UEAwwO5rWL6K+VKOa1i+ivlSkwWTATBgcqhkjOPQIBBggqgRzPVQGCLQNCAAROEOAVfj/98i51wwVkKYhAHgyzrn2Lap5KzEpIwd4tNpCK8ihR2KOL4lYZc0r52HwwMD5BQigtj8uy7v2HEIP+o4IBnjCCAZowHwYDVR0jBBgwFoAUH+bP1I/FIiqXSimKFecWyZI0xLYwHQYDVR0OBBYEFGxp9TRHPNac6fej5BK8f0xPGq/+MAsGA1UdDwQEAwIGwDCBmwYDVR0fBIGTMIGQMF+gXaBbpFkwVzELMAkGA1UEBhMCQ04xDTALBgNVBAoMBEJKQ0ExDTALBgNVBAsMBEJKQ0ExFzAVBgNVBAMMDkJlaWppbmcgU00yIENBMREwDwYDVQQDEwhjYTIxY3JsMjAtoCugKYYnaHR0cDovL2NybC5iamNhLm9yZy5jbi9jcmwvY2EyMWNybDIuY3JsMCQGCiqBHIbvMgIBAQEEFgwUU0Y1MzAxMDMxOTg0MTEyMzAwMjUwIAYIYIZIAYb4RAIEFAwSNTMwMTAzMTk4NDExMjMwMDI1MC0GCiqBHIbvMgIBARcEHwwdMUAyMTUwMDlTRjA1MzAxMDMxOTg0MTEyMzAwMjUwIAYIKoEc0BQEAQEEFAwSNTMwMTAzMTk4NDExMjMwMDI1MBQGCiqBHIbvMgIBAR4EBgwEMTA1MDAKBggqgRzPVQGDdQNJADBGAiEAnTr+aN8ESO+5UVilMyJMqRlkWtAEe/Z+EJsXahMktugCIQCLkG0JomFn4bgc65R1EQwuJOuOKlEsjycWAEWq3aBEdw==")
ClassMethod CALogin(AServerRan As %String, AUsrCertCode As %String, AUserSignedData As %String, ACertificateNo As %String, ACertificate As %String, ALocID As %String, AType As %String = "", AEpisodeID As %String = "", signType As %String = "", venderCode As %String = "", AOriSignatureLevel As %String = "") As %String
{
	// 1.随机数检查       多登陆方式后  出现其他模块手机扫码签时也会初始化随机数导致数据不一致，去掉此判断
	// q:(AServerRan '= %session.Get("ServerRan")) ..OutputErr("证书会话已过期，请重新认证！")
			
	// 2.用户证书检查	
    s UsrCertCode = $ZSTRIP(AUsrCertCode,"*C") 
    q:(UsrCertCode="") ..OutputErr("用户证书编码不能为空！")
    
    if (##Class(EMRservice.SystemParameter).CAVersion() = "2")
    {
	    s CertNo = $ZSTRIP(ACertificateNo,"*C") 
 		q:(CertNo="") ..OutputErr("证书编码不能为空！")
	    d ##Class(CA.DigitalSignatureService).Login("",UsrCertCode,"","",ACertificateNo,ACertificate,signType, venderCode)
	    s info = ##Class(CA.UsrSignatureInfo).GetActiveBindInfoByCert(UsrCertCode,CertNo)
	}
	else
    {
		s info = ##Class(CA.UsrSignatureInfo).GetInUsedInfoByKey(UsrCertCode)
	}   
    q:(info="") ..OutputErr("没关联用户！")
    
    if (##Class(EMRservice.SystemParameter).CAVersion() = "2")
    {
    	s ret = ##Class(CA.DigitalSignatureService).Login(info.UsrID,UsrCertCode,AServerRan,AUserSignedData,ACertificateNo,ACertificate,signType, venderCode)
    }
    else
    {
    	s ret = ##Class(CA.DigitalSignatureService).Login(info.UsrID,UsrCertCode,AServerRan,AUserSignedData,ACertificateNo,ACertificate)
    }
	q:(ret '= "") ..OutputErr(ret)
	
    // 3.成功返回用户名字和签名图片
    s userName = ##Class(EMRservice.BL.BLPowerUser).GetUserName(info.UsrID)
	s userLevel = ##class(EMRservice.BL.BLSignRole).GetUserLevel(info.UsrID,AEpisodeID)
	s levelCode = $p(userLevel,"^",1)
	s levelDesc = $p(userLevel,"^",2)
	//职称
	s CTPCPDesc = ##Class(EMRservice.BL.BLSignRole).GetUserCTPCPDesc(info.UsrID)
	s userPos = ##Class(EMRservice.BL.BLSignRole).GetUserPosition(info.UsrID,ALocID)	
    s posCode = $p(userPos,"^",1)
    s posDesc = $p(userPos,"^",2) 
    
    s signCharacterInfo = ##Class(EMRservice.BL.BLSignRole).GetSignCharacter(AOriSignatureLevel,info.UsrID,ALocID,AEpisodeID)
    s characterCode = $p(signCharacterInfo,"^",1)
	s characterDesc = $p(signCharacterInfo,"^",2)
    
    if (AType = "inpatient")
    {
	    s signType = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SignTypeInP","")
    }
    else
    { 
		s signType = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SignType","Text")
    }
	s ret = "{""UserID"":"""_info.UsrID_""",""Type"":"""_signType_""",""UserName"":"""_userName_""",""Image"":"""_$Replace($ZSTRIP(info.SignImage,"*C")," ","")_""",""UserLevel"":"""_levelCode_""",""LevelDesc"":"""_levelDesc_""",""UserPos"":"""_posCode_""",""PosDesc"":"""_posDesc_""",""CTPCPDesc"":"""_CTPCPDesc_""",""characterCode"":"""_characterCode_""",""characterDesc"":"""_characterDesc_"""}"
	q ret
}

ClassMethod OutputErr(errInfo As %String) As %String
{
	q "{""Err"":"""_errInfo_"""}"
}

/// Desc: 获取初始化参数 服务器端的三个信息和已经保存的key
/// Debug: w ##Class(EMRservice.BL.BLEMRSign).CASessionDataInit()
ClassMethod CASessionDataInit() As %String
{
	s ret = ""
	d ##Class(CA.DigitalSignatureService).CASessionDataInit()
	s ServerRan = %session.Get("ServerRan")
	s ServerSignedData = %session.Get("ServerSignedData")
	s ServerCert = %session.Get("ServerCert")
	s:(ServerCert = "") ServerCert = $G(^CF("CA","ServerCert"))	
	s key = ##Class(CA.DigitalSignatureService).GetKeyInSession()
	s ret = "{"
	s ret = ret_"""ServerRan"":"""_ServerRan_""""
	s ret = ret_",""ServerSignedData"":"""_ServerSignedData_""""
	s ret = ret_",""ServerCert"":"""_ServerCert_""""
	s ret = ret_",""Key"":"""_key_""""
	s ret = ret_"}"
	q ret
}

/// Desc:存储key值
ClassMethod SetKeyInSession(AKey As %String) As %String
{
	s result = "1"
	d ##Class(CA.DigitalSignatureService).SetKeyInSession(AKey)
	q result
}

/// Desc:签名
ClassMethod Sign(AUsrCertCode As %String, ASignValue As %String, AContentHash As %String, ACertNo As %String) As %String
{
	s ret = ""
	//q:(AUsrCertCode = "")||(ASignValue = "")||(AContentHash = "") ret
	q:(AUsrCertCode = "") ..OutputErr("CA用户唯一标识不能为空")
	q:(AContentHash = "") ..OutputErr("签名原文Hash不能为空")
	q:(ASignValue = "") ..OutputErr("签名值不能为空")

	if (##Class(EMRservice.SystemParameter).CAVersion() = "2")
	{
		q:(ACertNo = "") ret
		// 调用公共服务进行签名，成功：1^SignID  失败：0^ErrMsg	
		s ret = ##Class(CA.DigitalSignatureService).Sign(AUsrCertCode, "EMR", AContentHash, ASignValue,ACertNo)
	}
	else
	{
		// 调用公共服务进行签名，成功：1^SignID  失败：0^ErrMsg	
		s ret = ##Class(CA.DigitalSignatureService).Sign(AUsrCertCode, "EMR", AContentHash, ASignValue)
	}
	q:(0=$p(ret,"^",1)) ..OutputErr($p(ret,"^",2))
	s ret = "{""SignID"":"""_$p(ret,"^",2)_"""}"
	q ret
}

/// Desc:      取签名图片
/// Creator:   Candy
/// CreateDate:2016-4-7
/// Input:     AUserID 用户ID
/// Output:    Image:签名图
ClassMethod GetSignImage(AUserID As %String) As %String
{
	s result = ""
	q:(AUserID = "") result
	s info = ##Class(CA.UsrSignatureInfo).GetInUseInfo(AUserID)
	s:(info '= "") result = info.SignImage
	q result
}

/// Desc:       取三级医师
/// Creator:    Candy
/// CreateDate: 2016-12-07
/// Input:      AEpisodeID 就诊号
/// Output:     result 三级医师级其级别
ClassMethod GetThreeLevelDoctor(AEpisodeID As %String) As %String
{
	s result = ""
	q ""
	q:(AEpisodeID = "") result	
	// 一级医生
	s firstDoctorCpId = $P($g(^PAADM(AEpisodeID)),"^",9)
	if (firstDoctorCpId '= "")
	{
		s firstDoctorId = $o(^SSU("SSUSR",0,"CTPCP",firstDoctorCpId,""))
		s result = "{""level"":""Resident"",""desc"":""住院医师"",""Id"":"""_firstDoctorId_"""}"
	}
	s DHCADMRowId = $o(^DHCPAAdm(0,"PAAdm",AEpisodeID,""))
	if (DHCADMRowId = "") 
	{
		s:(result '= "") result = "["_result_"]"
		q result
	}
	
	// 二级医生
	s secondDoctorCpId = $P(^DHCPAAdm(DHCADMRowId),"^",21)
	if (secondDoctorCpId '= "")
	{
		s secondDoctorId = $o(^SSU("SSUSR",0,"CTPCP",secondDoctorCpId,""))
		s result = result_",{""level"":""Attending"",""desc"":""主治医师"",""Id"":"""_secondDoctorId_"""}"
	}
	
	// 三级医生
	s thirdDoctorCpId = $P(^DHCPAAdm(DHCADMRowId),"^",22)
	if (thirdDoctorCpId '= "")
	{
		s thirdDoctorId = $o(^SSU("SSUSR",0,"CTPCP",thirdDoctorCpId,""))
		s result = result_",{""level"":""Chief"",""desc"":""主任医师"",""Id"":"""_thirdDoctorId_"""}"
	}
	s result = "["_result_"]"
	q result
}

/// Desc:       返回最后一次有效签名信息
/// Creator:    candy
/// CreateDate: 2016-12-06
/// Input:      AInstanceID 实例ID
/// Output:     result 数组对象根据key取value 
///            key键值包括：
///               SignDate:签名日期[cache类型]
///               SignTime:签名时间[cache类型]
///               UserID: 签名用户ID  
/// Debug:      w ##Class(EMRservice.BL.BLEMRSign).GetLastSignInfo("2||1")
ClassMethod GetLastSignInfo(AInstanceID As %String) As %String
{
	s result = ##Class(%ArrayOfDataTypes).%New()
	q:(AInstanceID = "") result
	s rowId = $o(^DHCEMRI.EMRSignI("IdxInstance"," "_AInstanceID,""),-1)
	q:(rowId = "") result
	s obj = ##Class(EMRinstance.EMRSign).%OpenId(rowId)
	q:(obj = "")||(obj.isSignValid = "0") result
	d result.SetAt(obj.SignDate,"SignDate")
	d result.SetAt(obj.SignTime,"SignTime")
	d result.SetAt(obj.UsrID,"UserID")
	q result
}

/// Desc:       取病历签名信息
/// Creator:    Candy
/// CreateDate: 2018-2-9
/// Input:      AInstanceID 病历ID
///            ACheckLevel 签名级别 如:viceChiefCheck
/// Output:     签名信息
/// Debug:      w ##Class(EMRservice.BL.BLEMRSign).GetDocumentSign("4||1","participantCheck")
ClassMethod GetDocumentSign(AInstanceID As %String, ACheckLevel As %String) As %String
{
	s result = ""
	q:(AInstanceID = "")||(ACheckLevel = "") result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s result = "["
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRI.EMRSignI("IdxMain"," "_objInstance.RealEpisodeID," "_objInstance.TheECRecord.RealChartItemID," "_objInstance.ListNo," "_$zcvt(ACheckLevel,"U"),rowId))
		q:(rowId = "")
		s objEmrsign = ##Class(EMRinstance.EMRSign).%OpenId(rowId)
		continue:(objEmrsign = "")
		s userId = objEmrsign.UsrID
		s userName = ##Class(EMRservice.BL.BLPowerUser).GetUserName(userId)
		s signLevel = objEmrsign.Action
		s signDesc = ##Class(EMRservice.BL.BLEMRAction).GetActionNameByCode(signLevel)
		s signDateTime = $zd(objEmrsign.SignDate,3)_" "_$zt(objEmrsign.SignTime)
		s:(result >1) result = result_","
		s result = result_"{"
		s result = result_"""UserID"":"""_userId_""""
		s result = result_",""UserName"":"""_userName_""""
		s result = result_",""SignLevel"":"""_signLevel_""""
		s result = result_",""SignDesc"":"""_signDesc_""""
		s result = result_",""signDateTime"":"""_signDateTime_""""
		s result = result_",""Path"":"""_objEmrsign.Code_""""
		s result = result_"}"
	}
	s result = result_"]"
	q result
}

/// Creator:    获取对应医师签名时间列表
/// CreateTime: 2018-10-15
/// Desc:       获取病历作者信息
/// Input：     pInstanceId 实例ID  pUserId 签名用户ID
/// Debug:      w ##Class(EMRservice.BL.BLEMRSign).GetSignMessage("1||8",105)
ClassMethod GetSignMessage(pInstanceId As %String, pUserId As %String) As %ArrayOfDataTypes
{
  	s result = ##Class(%ArrayOfDataTypes).%New()
	q:((pInstanceId = "")||(pUserId = "")) result
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRI.EMRSignI("IdxInstance"," "_pInstanceId,rowId))
		q:(rowId = "")
		s obj = ##Class(EMRinstance.EMRSign).%OpenId(rowId)
		q:(obj = "")
		continue:(obj.isSignValid = "0")||(obj.UsrID '= pUserId)
		s userName = ##Class(EMRservice.BL.BLPowerUser).GetUserName(pUserId)
		s time = $zd(obj.SignDate,3)_" "_$zt(obj.SignTime,1)
		s signAction = $zcvt(obj.Action,"U")
		s roleId = $o(^DHCEMRM.SignRoleI("IdxActionCode"," "_signAction,""))
		continue:(roleId = "")
		s objSignRole = ##Class(EMRmeta.SignRole).%OpenId(roleId)
		s level = objSignRole.Description
		d result.SetAt(obj.SignDate,"SignDate")
		d result.SetAt(obj.SignTime,"SignTime")
		d result.SetAt(obj.UsrID,"UserID")
		d result.SetAt(userName,"UserName")
		d result.SetAt(level,"Level")
		d result.SetAt(time,"Time")
	}
	q result
}

/// Desc:  		取签名图片比例
/// Creator:    董璐璐
/// CreateDate: 2019-7-25
/// Input:      AUserID
/// Output:     图片比例
/// Debug:      w ##Class(EMRservice.BL.BLEMRSign).GetDoctorSignImageRatio("")
ClassMethod GetDoctorSignImageRatio(AUserID As %String) As %String
{
	s ratio = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("SignImage_Zoom")
	s:(ratio = "") ratio = "{""ip"":""1.2"",""op"":""1.2""}"
	q ratio
}

/// Desc:  		签名验证，判断是否在此签名单元上有权限签名，或者是否需要改签
/// Creator:    董璐璐
/// CreateDate: 2020-7-20
/// Input:      AUserID:用户ID
///       		ACharacterCode：用户签名角色
///       		AOriSignatureLevel：签名单元的Code
///       		ASignatureLevel：签名单元上所有签名的角色，以^分隔
///       		AID:签名单元最后的签名userID
///       		ASignedLength:签名单元上签名的个数
/// Output:     "Append" 签名/ "Replace" 改签/无权限或者无需签名的时候返回具体原因
/// Debug:      w ##Class(EMRservice.BL.BLEMRSign).CheckPrivilege("","","","","","")
ClassMethod CheckPrivilege(AUserID As %String, ACharacterCode As %String, AOriSignatureLevel As %String, ASignatureLevel As %String, AID As %String, ASignedLength As %String) As %String
{
	s result = ""
	q:(AUserID = "")||(ACharacterCode = "")||(AOriSignatureLevel = "") result
	
	if (AOriSignatureLevel = "Check")
	{
		s highestSignInfo = ##Class(EMRservice.BL.BLEMRSign).getHighestSignLevel(ASignatureLevel)
		s highestSignLevel = $p(highestSignInfo, "|", 1)
		s highestSignUserID = $p(highestSignInfo, "|", 2)
		
		if (ASignedLength = "0")
		{
			s result = "Append"
		}
		else
		{
			s charactorRoleLevel = ##Class(EMRservice.BL.BLSignRole).GetSignLevel(ACharacterCode)
			s signRoleLevel = ##Class(EMRservice.BL.BLSignRole).GetSignLevel(highestSignLevel)
			if (charactorRoleLevel > signRoleLevel)
			{
				s result = "Append"
			}
			elseif(charactorRoleLevel = signRoleLevel)
			{
				if (AUserID '= highestSignUserID)
				{
					//改签
					s result = "Replace"
				}
				else
				{
					s result = "已签名,不必再签"
				}
			}
			else
			{
				s result = "上级已签名，无权限签名"
			}
		}
	}
	else
	{
		if (ACharacterCode = AOriSignatureLevel)
		{
			if (ASignedLength = 0)
			{
				//签名
				s result = "Append"
			}
			else
			{
				if (AUserID '= AID)
				{
					//改签
					s result = "Replace"
				}
				else
				{
					s result = "已签名,不必再签"
				}
			}
		}
		else
		{
			s result = "签名级别或职务不符，无权限签名"
		}
	}
	q result
}

/// Desc:  		获取EMRmeta.SignRole的RoleLevel相同的action集合，以^分隔
/// Creator:    董璐璐
/// CreateDate: 2020-8-10
/// Input:      AAction:签名动作代码
/// Output:     EMRmeta.SignRole的RoleLevel相同的action集合，以^分隔
/// Debug:      w ##Class(EMRservice.BL.BLEMRSign).GetSameRoleLevelAction("chairmanCheck")
ClassMethod GetSameRoleLevelAction(AAction As %String) As %String
{
	s result = ""
	q:(AAction = "") result
	
	s rowID = $o(^DHCEMRM.SignRoleI("IdxActionCode"," "_$zcvt(AAction,"U"),""))
	q:(rowID = "") result
	s objSignRole = ##Class(EMRmeta.SignRole).%OpenId(rowID)
	q:(objSignRole = "") result
	s level = objSignRole.RoleLevel
	q:(level = "") result
	
	s id = ""
	for
	{
		s id = $o(^DHCEMRM.SignRoleI("IdxRoleLevel",level,id))
		q:(id = "")
		s objSignRole = ##Class(EMRmeta.SignRole).%OpenId(id)
		continue:(objSignRole = "")
		continue:(objSignRole.ActionCode = "")
		s:(result '= "") result = result_"^"
		s result = result_objSignRole.ActionCode
	}
	
	q result
}

/// Desc:		判断签名单元的最高级
/// Creator:	Donglulu
/// CreateDate:	2021-7-27
/// Input:      ASignatureLevels 签名单元上所有签名的角色，以^分隔
/// Output:     签名单元的最高级别
/// Debug:      w ##Class(EMRservice.BL.BLEMRSign).getHighestSignLevel("")
ClassMethod getHighestSignLevel(ASignatureLevels As %String) As %String
{
	s result = ""
	q:(ASignatureLevels = "") result
	
	s count=$l(ASignatureLevels, "^")
	f i=1:1:count 
	{
		s tmpLevelInfo = $p(ASignatureLevels, "^", i)
		q:(tmpLevelInfo = "")
		
		s tmpLevel = $p(tmpLevelInfo, "|", 1)
		continue:(tmpLevel = "")
		
		if (result = "")
		{
			s result = tmpLevelInfo
		}
		else
		{
			s nowLevel = $p(result, "|", 1)
			if (##Class(EMRservice.BL.BLSignRole).IsUserLevelHigher(tmpLevel,nowLevel) = "1")
			{
				s result = tmpLevelInfo
			}
		}
	}
	
	q result
}

/// Desc:		判断上级医师是否签名
/// Creator:	Donglulu
/// CreateDate:	2021-7-23
/// Input:      AUserCharacterCode 签名角色代码
///             AInstanceID 实例ID
/// Output:     1：上级已签名  0：上级未签名       
/// Debug:      w ##Class(EMRservice.BL.BLEMRSign).IsSuperiorSign(230,"")
ClassMethod IsSuperiorSign(AUserCharacterCode As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:(AUserCharacterCode = "")||(AInstanceID = "") result
	
	s characterLevel = ##Class(EMRservice.BL.BLSignRole).GetSignLevel(AUserCharacterCode)
	
	s signID = ""
	for
	{
		s signID = $o(^DHCEMRI.EMRSignI("IdxInstance"," "_$zcvt(AInstanceID,"U"),signID))
		q:(signID = "")
		s signObj = ##Class(EMRinstance.EMRSign).%OpenId(signID)
		q:(signObj = "")
		continue:(signObj.isSignValid '= "1")
		s action = signObj.Action
		continue:(action = "")
		//排除签名域的签名
		continue:(signObj.DocSignType="cdaxml")
		s roleID = $o(^DHCEMRM.SignRoleI("IdxActionCode"," "_$zcvt(action,"U"),""))
		continue:(roleID = "")
		s roleObj = ##Class(EMRmeta.SignRole).%OpenId(roleID)
		continue:(roleObj = "")
		s tmpLevel = roleObj.RoleLevel
		if (tmpLevel > characterLevel)
		{
			s result = "1"
			q
		}
	}
	q result
}

/// Desc:       获取最后一次有效的CA签名信息
/// Creator:    yb
/// CreateDate: 2022-05-30
/// Input:      AInstanceID 实例ID
/// Output:     未查询到返回空 
///             查询到返回SignID->CA.DigitalSignature的rowID^摘要数据
/// Debug:      w ##class(EMRservice.BL.BLEMRSign).GetSignInfoByInsID("13||10")
ClassMethod GetSignInfoByInsID(AInstanceID As %String) As %String
{
	s rowId = $o(^DHCEMRCA.EMRSignLogI("IdxInstance"," "_AInstanceID,""),-1) 
	q:(rowId = "") "-1^未查询到有效的CA签名记录"
	
	s objEMRSingLog = ##Class(EMRinstance.EMRSignLog).%OpenId(rowId,0)
	q:(objEMRSingLog = "") "-1^未查询到有效的CA签名记录"
	
	s isValid = objEMRSingLog.isSignValid
	q:(isValid = 0) "-1^未查询到有效的CA签名记录"
	
	s signID = objEMRSingLog.SignID
	q:(signID = "") "-1^未查询到有效的CA签名记录"
	
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID,0)
	q:(objInstance = "") "-1^病历数据查询异常"
	
	//判断xml是否压缩存储
	s isCompress = 0,isBKCompress =0
	//不存在方法认为不压缩
	if (##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.BL.BLInstanceDataCompressInfo||GetIsCompressByInstanceID") = 1)
	{
		s flag = ##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsCompressByInstanceID(AInstanceID)
		s:($zcvt(flag,"U") = "TRUE") isCompress = 1
	}
	//不存在方法认为不压缩,后台压缩
	if (##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.BL.BLInstanceDataCompressInfo||GetIsBKCompressByInstanceID") = 1)
	{
		s flag = ##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsBKCompressByInstanceID(AInstanceID)
		s:($zcvt(flag,"U") = "1") isBKCompress = 1
	}
	s signData = ##Class(%GlobalBinaryStream).%New()
	//插件压缩
	if (isCompress = 1)
	{
		d signData.CopyFrom(objInstance.InstanceData)
	}
	elseif(isBKCompress=1) // 后台压缩
	{
		s temSignData = ##class(EMRservice.Parser.StreamData).DeCompressStream(objInstance.InstanceData)
		d signData.CopyFrom(temSignData)
	}
	else
	{
		s ecrordID = $p(AInstanceID,"||",1)
		s objEcrecord = ##class(EMRinstance.ECRecord).%OpenId(ecrordID,0)
		q:(objEcrecord = "") "-1^病历数据Ecrecord查询异常"
	
		s documentType = objEcrecord.DocumentType
		if (documentType = "DOC")
		{
			d signData.CopyFrom(##Class(EMRservice.Parser.StreamData).ParserStream(objInstance.InstanceData,"<abiword","</abiword>","10"))
		}
		else
		{		
			d signData.CopyFrom(##Class(EMRservice.Parser.StreamData).ParserStream(objInstance.InstanceData,"<iEditor","</iEditor>","10"))
		}
	}
	d signData.Rewind()	
	q:(signData.Size < 10) "-1^病历签名数据获取异常"
	
	s signmd5 = ##class(%SYSTEM.Encryption).MD5HashStream(signData,.sc)
	q:($$$ISERR(sc)) "-1^对病历数据做摘要失败"
	
	s signmd5 = ##class(web.Util.Encryption).Byte2Hex(signmd5)
	s signmd5 = $zcvt(signmd5,"L")
	q:(signmd5 = "") "-1^病历摘要为空"
	
	s result = signID_"^"_signmd5
	q result
}

/// Desc:       验证CA签名
/// Creator:    yb
/// CreateDate: 2022-05-30
/// Input:      AInstanceID 实例ID
/// Output:     正确返回"1^签名人、日期时间"，错误返回"0^错误信息"          
///             错误返回"0^错误信息"    
/// Debug:      w ##class(EMRservice.BL.BLEMRSign).VerifySignedData("72||16")
ClassMethod VerifySignedData(AInstanceID As %String) As %String
{
	q:(AInstanceID = "") "0^验证签名失败：病历实例ID为空"
	
	s signInfo = ..GetSignInfoByInsID(AInstanceID)
	q:($p(signInfo,"^",1) = "-1") "0^验证签名失败："_$p(signInfo,"^",2)
	
	s signID = $p(signInfo, "^" ,1)
	s digest = $p(signInfo, "^" ,2)
	s ret = ##class(CA.DigitalSignatureService).GetVerifySignResult(signID,digest)
	q ret
}

/// Desc:       获取签名摘要和签名单元路径
/// Creator:    yejian
/// CreateDate: 2022-11-16
/// Input:      AInstanceID 实例ID
/// Output:     未查询到返回空 
///             查询到返回摘要,路径数据 {"InstanceID": "332||1","PathList": [{"Digest": "c9c685bd95e945dfb0f3ddae211e5cb9","Path": "S017_V004_V017_L0015"}]} 
/// Debug:      w ##class(EMRservice.BL.BLEMRSign).GetSignDigestDatas("403||1").Read()
ClassMethod GetSignDigestDatas(AInstanceID As %String) As %GlobalCharacterStream
{
	q:(AInstanceID = "") ""
	
	s signData = ##Class(%GlobalCharacterStream).%New()
	d signData.Write("{")
	d signData.Write("""InstanceID"":"""_AInstanceID_"""")
	d signData.Write(",""PathList"":[")
	s json = ""
	s signID= ""
	for
	{
		s signID = $o(^DHCEMRI.EMRSignI("IdxInstance"," "_$zcvt(AInstanceID,"U"),signID))
		q:(signID = "")
		s signObj = ##Class(EMRinstance.EMRSign).%OpenId(signID)
		q:(signObj = "")
		continue:(signObj.isSignValid '= "1")
		s code = signObj.Code
		s digest = signObj.Digest
		s json=$case(json,"":"{",:json_",{")
		s json = json_"""Path"":"""_code_""",""Digest"":"""_digest_""""
		s json=json_"}"
	}
	d signData.Write(json)
	d signData.Write("]}")
	q signData
}

}
