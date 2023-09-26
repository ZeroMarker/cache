Class EMRservice.Ajax.caKeySign Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

ClassMethod OnPage() As %Status
{
	s errInfo=""
	s $zt = "ErrorHandler"
	
	s func=$g(%request.Data("func",1),"")
	if (func="") { w "" }
	elseif (func="CASessionDataInit") { 
		w ..CASessionDataInit()
	}
	elseif (func="SetKeyInSession"){
		s key = $g(%request.Data("Key", 1), "")
		d ##Class(CA.DigitalSignatureService).SetKeyInSession(key)
		w ""
	}
	elseif (func="login"){
    	w ..Login()
	}
	elseif (func="sign"){
    	w ..Sign()
	}	
	elseif (func="verify"){
		w ..Verify()
	}	
    elseif (func="GetUserInfo"){
		w ..GetUserInfo()
	}
	elseif (func="GetRecordInfo"){
		w ..GetRecordInfo()
	}
	else
	{
		s name = $Get(%request.Data("name",1),"")
		s password = $Get(%request.Data("password",1),"")
		w "{""name"":"""_name_""",""password"":"""_password_"""}"
	}
 
	Quit $$$OK
ErrorHandler
   w "{""Err"":"""_errInfo_"_"_$zerror_"""}"
   Quit $$$OK
}

/// 获取初始化参数 服务器端的三个信息和已经保存的key
/// w ##Class(EMRservice.Ajax.caKeySign).CASessionDataInit()
ClassMethod CASessionDataInit() As %String
{
	d ##Class(CA.DigitalSignatureService).CASessionDataInit()
	s ServerRan=%session.Get("ServerRan")
	s ServerSignedData=%session.Get("ServerSignedData")
	s ServerCert=$G(^CF("CA","ServerCert"))  //%session.Get("ServerCert")
	s ContainerName=""
  
	s key = ##Class(CA.DigitalSignatureService).GetKeyInSession()
    
	s ret="{""ServerRan"":"""_ServerRan_""",""ServerSignedData"":"""_ServerSignedData
	s ret=ret_""",""ServerCert"":"""_ServerCert_""",""Key"":"""_key_"""}"
	//s ^CacheTemp("ret")=ret
    s ret = $ZSTRIP(ret,"*C")
	q ret
}

ClassMethod Login() As %String
{
	// 1.随机数检查
    s serverRan = $Get(%request.Data("ServerRan",1),"")
	q:(serverRan'=%session.Get("ServerRan")) ..OutputErr("证书会话已过期，请重新认证！")
			
	// 2.用户证书检查	
    s UsrCertCode = ..FilterIlleaglChar($g(%request.Data("UsrCertCode", 1), ""))
    q:(UsrCertCode="") ..OutputErr("用户证书编码不能为空！")

    s userSignedData = $Get(%request.Data("UserSignedData",1),"")
	s usrID = $Get(%request.Data("userID",1),"")
	s certNo = $Get(%request.Data("certificateNo",1),"")
	s userCert = $Get(%request.Data("certificate",1),"")
 
    s info = ##Class(CA.UsrSignatureInfo).GetInUsedInfoByKey(UsrCertCode)
    q:(info="") ..OutputErr("未关联用户！")
    q:(info.UsrID '= usrID) ..OutputErr("Ukey未关联当前用户！")
 
	//s ^CacheTemp("cert")=usrID_", "_UsrCertCode_", "_serverRan_", "_userSignedData_", "_certNo_", "_userCert
    s ret = ##Class(CA.DigitalSignatureService).Login(usrID, UsrCertCode, serverRan, userSignedData, certNo, userCert)
	q:(ret'="") ..OutputErr(ret)
	
    // 3.用户操作权限检查
    s operate=$Get(%request.Data("operate",1),"")
    /*if (operate'="")
    {
	    s:(operate="complete") level="Attending" //完成操作是使用其级别
	}*/
    
    // 成功返回用户名字和签名图片
    s info=##Class(CA.UsrSignatureInfo).GetInUsedInfoByKey(UsrCertCode)    	
	s UsrName=$p(^SSU("SSUSR",info.UsrID), "^", 2) // 用户真实姓名
	s type=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SignType","Text") //"Graph" //
	//s level=##class(EMRservice.BL.BLPowerUser).GetUserLevel(info.UsrID)
	s userlevel=##class(EMRservice.BL.BLSignRole).GetUserLevel(info.UsrID)
	s levelCode = $p(userlevel,"^",1)
	s levelDesc = $p(userlevel,"^",2)
	
	s ret= "{""UserID"":"""_info.UsrID_""",""Type"":"""_type_""",""Name"":"""_UsrName_""",""Image"":"""_$Replace($ZSTRIP(info.SignImage,"*C")," ","")_""",""Level"":"""_levelCode_""",""LevelDesc"":"""_levelDesc_"""}"
	//s ^CacheTemp("Login")=ret
	q ret
}

ClassMethod Sign() As %String
{
	s ret = ""
	s UsrCertCode = $Get(%request.Data("UsrCertCode",1),"")
	s signValue = $Get(%request.Data("signValue",1),"")
	s contentHash = $Get(%request.Data("contentHash",1),"")	
	//s ^CacheTemp("Sign1",1)=UsrCertCode
	//s ^CacheTemp("Sign1",2)=signValue
	//s ^CacheTemp("Sign1",3)=contentHash
	//s ret = ##Class(EMRservice.BL.BLDigitalSignature).Sign(UsrCertCode, signValue, contentHash)
	// 调用公共服务进行签名，成功：1^SignID  失败：0^ErrMsg	
	if (##Class(EMRservice.SystemParameter).CAVersion() = "2")
	{
		s UsrCertNo = $Get(%request.Data("UsrCertNo",1),"")	
		s ret=##Class(CA.DigitalSignatureService).Sign(UsrCertCode, "EMR", contentHash, signValue, UsrCertNo)
	}
	else
	{
		s ret=##Class(CA.DigitalSignatureService).Sign(UsrCertCode, "EMR", contentHash, signValue)
	}
	//q:0=$p(ret,"^",1) $p(ret,"^",2)
	
	q:(0=$p(ret,"^",1)) ..OutputErr($p(ret,"^",2))
	
	s ret = "{""SignID"":"""_$p(ret,"^",2)_"""}"
	//s ^CacheTemp("Sign")=ret
	q ret
}

ClassMethod Verify() As %String
{
	s ret = ""
	s signID = $Get(%request.Data("signID",1),"")
	s contentHash = $Get(%request.Data("contentHash",1),"")
	q:(signID="" || contentHash="") ret

	s ret=##Class(CA.DigitalSignatureService).VerifySign(signID, contentHash)
    s:(ret'="") ret="签名验证失败！"


	s sign=##Class(CA.DigitalSignature).%OpenId(signID)
    s usr=sign.UsrID 
	s usr = $p($g(^SSU("SSUSR",+usr)),"^",2)    
    s date=$zd(sign.CreateDate, 3) 
    s time=$zt(sign.CreateTime, 1)

	s ret = ret_" 最后签名者："_usr_" 签名时间："_date_" "_time
	q "{""Message"":"""_ret_"""}"
}

ClassMethod GetUserInfo() As %String
{
	s userName = $Get(%request.Data("UserName",1),"")
    q:(userName = "") ..OutputErr("未获取到用户工号")
    
    s userCertCode = $Get(%request.Data("UserCertCode",1),"")
	q:(userCertCode = "") ..OutputErr("未获取到用户证书标识")
    
    s certNo = $Get(%request.Data("CertNo",1),"")
    q:(certNo = "") ..OutputErr("未获取到证书编码")
    
    s userID = ##class(EPRmeta.Privilege.PowerUser).GetUserId(userName)
    q:(userID = "") ..OutputErr("根据工号获取UserID失败")
    
    // 用户真实姓名	
	s UsrName=$p(^SSU("SSUSR",userID), "^", 2)
	s type=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SignType","Text")
	//s level=##class(EMRservice.BL.BLPowerUser).GetUserLevel(userID)
    s levelInfo=##class(EMRservice.BL.BLSignRole).GetUserLevel(userID)
    s level=$p(levelInfo,"^",1)
    s levelDesc=$p(levelInfo,"^",2)
	// 用户级别检查
	q:(level = "") ..OutputErr("请配置电子病历系统医师级别!")
	
	s obj = ##Class(CA.UsrSignatureInfo).GetActiveBindInfoByCert(userCertCode,certNo)
	s image = ""
	s:(obj'="") image = $Replace($ZSTRIP(obj.SignImage,"*C")," ","")
	if (type = "Graph")&&(image = "")
	{
		s type = "Text"
	}
	
	// 成功返回用户名字和签名图片
	s ret= "{""UserID"":"""_userID_""",""Type"":"""_type_""",""Name"":"""_UsrName_""",""UserName"":"""_UsrName_""",""Image"":"""_image_""",""UserLevel"":"""_level_""",""LevelDesc"":"""_levelDesc_""",""Level"":"""_level_"""}"
	q ret
}

ClassMethod OutputErr(errInfo As %String) As %String
{
	q "{""Err"":"""_errInfo_"""}"
}

ClassMethod FilterIlleaglChar(txt As %String) As %String
{
	s txt = $tr(txt,$c(10),"")
	s txt = $tr(txt,$c(13),"")
	q txt
}

ClassMethod GetRecordInfo(AInstanceDataID As %String = "") As %String
{
	if (AInstanceDataID = "")
	{
		s AInstanceDataID = $Get(%request.Data("InstanceDataID",1),"")
	}
	q:(AInstanceDataID = "") ..OutputErr("请指定InstanceDataID")
	
	s obj = ##class(EMRinstance.InstanceData).%OpenId(AInstanceDataID)
	s docID = obj.TheECRecord.RealChartItemID
	s type = obj.TheECRecord.ChartItemType
	s objDoc = ##class(EMRmeta.EMRTemplateCategory).%OpenId(docID)
	s objChapter = ##class(EMRmeta.EMRTemplateCategory).%OpenId(objDoc.ParentCategoryID)
	if (type = "Multiple")
	{
		s subject = objChapter.CategoryName_"."_objDoc.CategoryName_"."_obj.Title_" "_$zd(obj.HappenDate,3)_" "_$zt(obj.HappenTime,1)
	}
	else
	{
		s subject = objChapter.CategoryName_"."_objDoc.CategoryName  //_"."_obj.Title_" "_$zd(obj.HappenDate,3)_" "_$zt(obj.HappenTime,1)
	}
    
    s episodeID = obj.EpisodeID
    s patientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
    s name = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(patientID)
    s subject = "姓名："_name_" 病历信息："_subject
    
    q "{""subject"":"""_subject_""",""product"":""EMR""}"
}

}
