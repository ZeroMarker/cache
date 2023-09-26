/// Desc:       签名逻辑
/// Creator:    Candy
/// CreateDate: 2014-7-25
Class web.DHCCM.EMRservice.BL.BLEMRSign Extends (%RegisteredObject, %XML.Adaptor)
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
ClassMethod SetMERSign(AEpisodeID As %String, AInstanceID As %String, AUserID As %String, ASignID As %String, AAction As %String, ADigest As %String, AType As %String, argInData As %GlobalBinaryStream, APath As %String, AActionType As %String) As %String
{
	s result = 0
	if (AActionType = "Replace")
	{
		TStart
		s result = ..RevokeSign(AEpisodeID,AInstanceID,AUserID,AAction,APath)
		if ($p(result,"^",1) '= 0)
		{
			s result = ..SaveEMRSign(AEpisodeID,AInstanceID,AUserID,ASignID,AAction,ADigest,AType,argInData,APath,1)
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
		s result = ..SaveEMRSign(AEpisodeID,AInstanceID,AUserID,ASignID,AAction,ADigest,AType,argInData,APath,1)	
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
ClassMethod SaveEMRSign(AEpisodeID As %String, AInstanceID As %String, AUserID As %String, ASignID As %String, AAction As %String, ADigest As %String, AType As %String, argInData As %GlobalBinaryStream, APath As %String, ASignValid As %String) As %String
{
	s result = "0"
	q:((AEpisodeID = "")||(AInstanceID = "")||(AUserID = "")||(AAction = "")) result
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s EMRNum = objInstance.ListNo
	k objInstance
	s ecrecordId = $p(AInstanceID,"||",1)
	s objEcrecord = ##Class(User.DHCPHECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result 
	s EMRDocID = objEcrecord.ChartItemID
	k objEcrecord
	s rowId = $o(^DHCPHI.EMRSignI("IdxUnique"," "_AEpisodeID," "_EMRDocID," "_EMRNum," "_$zcvt(APath,"U")," "_$Zcvt(AAction,"u"),""))

	if (rowId '= "" )
	{
		s objEMRSign = ##Class(User.DHCPHEMRSign).%OpenId(rowId)
	}
	else
	{
		s objEMRSign = ##Class(User.DHCPHEMRSign).%New()
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
	s objEMRSign.Digest = ADigest
	s objEMRSign.isSignValid = ASignValid  //$Case(AActionType,"Append":1,:0)
	s sc = objEMRSign.%Save()
	if $$$ISOK(sc) 
	{ 
		TStart
		if (AType = "CA")
		{
			s resultLog = ..SaveEMRSignLog(objEMRSign,argInData)	
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
		s result ="1^"_objEMRSign.%Id()
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
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s EMRNum = objInstance.ListNo
	k objInstance
	s ecrecordId = $p(AInstanceID,"||",1)
	s objEcrecord = ##Class(User.DHCPHECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result 
	s EMRDocID = objEcrecord.ChartItemID
	k objEcrecord
	s rowId = $o(^DHCPHI.EMRSignI("IdxUnique"," "_AEpisodeID," "_EMRDocID," "_EMRNum," "_$zcvt(APath,"U")," "_$Zcvt(AAction,"u"),""))
	q:(rowId = "" ) result
	s objEMRSign = ##Class(User.DHCPHEMRSign).%OpenId(rowId)
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

/// Desc:       保存签名历史
/// CreateDate: 2015-7-29
/// Creator:    Candyxu
/// Input:      AEMRSign 签名数据
///             AargInData 签名xml 
ClassMethod SaveEMRSignLog(AEMRSign As EMRinstance.EMRSign, AargInData As %GlobalBinaryStream) As %String
{
	s result = "0"
	q:(AEMRSign = "") result
	s objEMRSingLog = ##Class(User.DHCPHEMRSignLog).%New()
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
	s objEMRSingLog.InstanceData = AargInData
	s:($$$ISOK(objEMRSingLog.%Save())) result = "1"
	q result
}

/// Desc:       验证系统签名用户,返回用户信息
/// Creator:    Candy
/// CreateDate: 2014-8-20
/// Input:      AUserCode 用户工号
///             APassword 用户密码   
/// Output:     UserID,UserName,level
/// Debug:      w ##Class(web.DHCCM.EMRservice.BL.BLEMRSign).GetUserInfo("inpha","")
ClassMethod GetUserInfo(AUserCode As %String, APassword As %String) As %String
{
	s $zt = "ErrorHandler"	
	s json = ""
	q:(AUserCode = "") json
	
	k PLIST	
	///验证用户
	if (APassword '= "")
	{
		s loginValid = ##class(EMRservice.BL.BLPowerUser).IsLogonValid(AUserCode,APassword)	
	   	q:(loginValid = 0) json
	}
    s userID = ##class(EMRservice.BL.BLPowerUser).GetUserId(AUserCode)
	q:(userID = "") json
	s userName = ##Class(EMRservice.BL.BLPowerUser).GetUserName(userID)
	//s userName=##Class(EMRservice.BL.opInterface).TRNoGB(userName)  qunianpeng 2018/3/14 注释  报错
    s levelCode = ##class(EMRservice.BL.BLPowerUser).GetUserLevel(userID)
    s levelDesc = ##Class(EMRservice.BL.BLUserLevel).GetDesc(levelCode)
    s posCode = ##Class(EMRservice.BL.BLPowerUser).GetUserPos(userID)
    s posDesc = ##Class(EMRservice.BL.BLUserPost).GetDesc(posCode)
	s type = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SignType","Text")
	s image = ""
	if (type = "Graph")
	{
		s info = ##Class(CA.UsrSignatureInfo).GetInUseInfo(userID)
		//s:(info '= "") image = info.SignImage
		if (info '= "") && (info.SignImage'="") 
		{
			s image = info.SignImage
		}
		else
		{
			s type = "Text"
		}
	}
   	s json = "{'UserID':'"_userID_"','UserName':'"_userName_"','UserLevel':'"_levelCode_"','LevelDesc':'"_levelDesc_"','UserPos':'"_posCode_"','PosDesc':'"_posDesc_"','Type':'"_type_"','Image':'"_image_"'}"
   	q json
ErrorHandler 
    q ""
}

/// Desc: 返回数字签名信息
/// debug:w ##Class(EMRservice.BL.BLEMRSign).CALogin("uhwHeWt/hx8e3xMmAEJRXg==","1050","MEUCIClAGN9vfZj6tBqfpdLuzctGjFrsIu85aIjRox0h38H9AiEApy48XLDDoacr/WO9nxb8Ijz+scsoXaG8o1DHaZpxi3I=",105,"999000100007193","MIIDAzCCAqigAwIBAgIKLRAAAAAAAAViMzAKBggqgRzPVQGDdTBEMQswCQYDVQQGDAJDTjENMAsGA1UECgwEQkpDQTENMAsGA1UECwwEQkpDQTEXMBUGA1UEAwwOQmVpamluZyBTTTIgQ0EwHhcNMTUwNzIxMTYwMDAwWhcNMTYxMjIyMTU1OTU5WjAmMQswCQYDVQQGDAJDTjEXMBUGA1UEAwwO5rWL6K+VKOa1i+ivlSkwWTATBgcqhkjOPQIBBggqgRzPVQGCLQNCAAROEOAVfj/98i51wwVkKYhAHgyzrn2Lap5KzEpIwd4tNpCK8ihR2KOL4lYZc0r52HwwMD5BQigtj8uy7v2HEIP+o4IBnjCCAZowHwYDVR0jBBgwFoAUH+bP1I/FIiqXSimKFecWyZI0xLYwHQYDVR0OBBYEFGxp9TRHPNac6fej5BK8f0xPGq/+MAsGA1UdDwQEAwIGwDCBmwYDVR0fBIGTMIGQMF+gXaBbpFkwVzELMAkGA1UEBhMCQ04xDTALBgNVBAoMBEJKQ0ExDTALBgNVBAsMBEJKQ0ExFzAVBgNVBAMMDkJlaWppbmcgU00yIENBMREwDwYDVQQDEwhjYTIxY3JsMjAtoCugKYYnaHR0cDovL2NybC5iamNhLm9yZy5jbi9jcmwvY2EyMWNybDIuY3JsMCQGCiqBHIbvMgIBAQEEFgwUU0Y1MzAxMDMxOTg0MTEyMzAwMjUwIAYIYIZIAYb4RAIEFAwSNTMwMTAzMTk4NDExMjMwMDI1MC0GCiqBHIbvMgIBARcEHwwdMUAyMTUwMDlTRjA1MzAxMDMxOTg0MTEyMzAwMjUwIAYIKoEc0BQEAQEEFAwSNTMwMTAzMTk4NDExMjMwMDI1MBQGCiqBHIbvMgIBAR4EBgwEMTA1MDAKBggqgRzPVQGDdQNJADBGAiEAnTr+aN8ESO+5UVilMyJMqRlkWtAEe/Z+EJsXahMktugCIQCLkG0JomFn4bgc65R1EQwuJOuOKlEsjycWAEWq3aBEdw==")
ClassMethod CALogin(AServerRan As %String, AUsrCertCode As %String, AUserSignedData As %String, AUserID As %String, ACertificateNo As %String, ACertificate As %String) As %String
{
	// 1.随机数检查
	q:(AServerRan '= %session.Get("ServerRan")) ..OutputErr("证书会话已过期，请重新认证！")
			
	// 2.用户证书检查	
    s UsrCertCode = $ZSTRIP(AUsrCertCode,"*C") 
    q:(UsrCertCode="") ..OutputErr("用户证书编码不能为空！")
    s ret = ##Class(CA.DigitalSignatureService).Login(AUserID,UsrCertCode,AServerRan,AUserSignedData,ACertificateNo,ACertificate)
	q:(ret '= "") ..OutputErr(ret)
	
    // 3.成功返回用户名字和签名图片
    s info = ##Class(CA.UsrSignatureInfo).GetInUsedInfoByKey(UsrCertCode)
    s userName = ##Class(EMRservice.BL.BLPowerUser).GetUserName(info.UsrID)
    s levelCode = ##class(EMRservice.BL.BLPowerUser).GetUserLevel(info.UsrID)
    s levelDesc = ##Class(EMRservice.BL.BLUserLevel).GetDesc(levelCode)
    s posCode = ##Class(EMRservice.BL.BLPowerUser).GetUserPos(info.UsrID)
    s posDesc = ##Class(EMRservice.BL.BLUserPost).GetDesc(posCode)    
	s type = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SignType","Text")
	s ret = "{""UserID"":"""_info.UsrID_""",""Type"":"""_type_""",""UserName"":"""_userName_""",""Image"":"""_info.SignImage_""",""UserLevel"":"""_levelCode_""",""LevelDesc"":"""_levelDesc_""",""UserPos"":"""_posCode_""",""PosDesc"":"""_posDesc_"""}"
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
	s ContainerName = ""
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
ClassMethod Sign(AUsrCertCode As %String, ASignValue As %String, AContentHash As %String) As %String
{
	s ret = ""
	q:(AUsrCertCode = "")||(ASignValue = "")||(AContentHash = "") ret
	// 调用公共服务进行签名，成功：1^SignID  失败：0^ErrMsg	
	s ret = ##Class(CA.DigitalSignatureService).Sign(AUsrCertCode, "EMR", AContentHash, ASignValue)
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

}
