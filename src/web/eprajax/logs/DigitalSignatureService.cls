Class web.eprajax.logs.DigitalSignatureService Extends %CSP.Page [ Not ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s errInfo=""
	s $zt = "ErrorHandler"
	
	set userID = %session.Get("LOGON.USERID")
	if ("" = userID)
	{
		w "0^sessionTimedOut"
		Quit $$$OK
	}
	s method = $g(%request.Data("method", 1), "")
	
	//	params["method"] = "SaveKeyInSession";
	//params["Key"] = key;
	if ("SaveKeyInSession" = method)
	{
		s Key = $Get(%request.Data("Key", 1), "")
		d ##Class(CA.DigitalSignatureService).SetKeyInSession(Key)
		Quit $$$OK
	}
	
    // 单独CA签名
	if ("sign" = method)
	{	
	    s episodeID = $Get(%request.Data("episodeID", 1), "")		
		s UsrCertCode = ..FilterIlleaglChar($Get(%request.Data("UsrCertCode", 1), ""))
		s eprNum = $Get(%request.Data("eprNum", 1), "")
		s printDocID = $Get(%request.Data("printDocID", 1), "")	
		s instanceIDs=$g(%request.Data("instanceIDs", 1), "")
		s signValue=$g(%request.Data("signValue", 1), "")
		s contentHash=$g(%request.Data("contentHash", 1), "")	
		s errInfo="1"	
		s ret=##Class(EPRservice.BLDigitalSignature).Sign(UsrCertCode, episodeID, printDocID, eprNum, 
	               instanceIDs, signValue, contentHash)	
        s errInfo="11"
        if (ret'="") { w ret }
        else 
        {
	        /*
	        s divStateServer = ##class(EPRinstance.EPRLogs).GetLogStatus(episodeID, printDocID, eprNum)
	        s errInfo="12"
	        s signLog=##Class(EPRservice.BLDigitalSignature).GetSignLog(episodeID, printDocID, eprNum)
	        if (signLog'="") {s divStateServer = divStateServer_signLog }
	        */
	        s divStateServer = ##Class(EPRservice.BOEPRLogs).GetStatusHtml(episodeID, printDocID, eprNum)
	        w "0^"_divStateServer
	    }
        Quit $$$OK	
 	}
 	
	///签名验证		
	if ("VerifySign" = method)
	{	
		s episodeID=$g(%request.Data("episodeID", 1), "")
		s printDocID=$g(%request.Data("printDocID", 1), "")
		s eprNum=$g(%request.Data("eprNum", 1), "")
		s contentHash=$g(%request.Data("contentHash", 1), "")
		s errInfo="2"
		s ret=##Class(EPRservice.BLDigitalSignature).VerifySignature(episodeID, printDocID, eprNum, contentHash)
		w ret
		Quit $$$OK
	}
	
    // 登录验证验证   
    if ("1" = $g(%request.Data("needLogin", 1), "1")) 
    {
	    s errInfo="3"
	    s loginRet = ..Login(.errInfo)
        if ("" '= loginRet)
        {
	        w loginRet
	        Quit $$$OK
        }
    }
    
    // 取病历内容
	if ("GetContent" = method)
	{
		s instanceIDs = $g(%request.Data("instanceIDs", 1), "") 
		if ("" '= instanceIDs)
		{ 
		   s errInfo="4"
		   s ret=##Class(EPRservice.BLDigitalSignature).GetContentByIDs(instanceIDs)
		}
		else
		{
			s usrID=$g(%request.Data("usrID", 1), "") 
			s printDocID=$g(%request.Data("printDocID", 1), "")
			s episodeID=$g(%request.Data("episodeID", 1), "")
			s errInfo="5"
			s instanceIDs=##Class(EPRservice.BLDigitalSignature).GetInstanceIDs(usrID, printDocID, episodeID) 
    	    s errInfo="6"
    	    s ret=##Class(EPRservice.BLDigitalSignature).GetContentByIDs(instanceIDs)			
		}

        do ret.Rewind()
        while ret.AtEnd=0
        {
	        w ret.Read(10000)
        }

	    Quit $$$OK
	}
	
	w ""
	Quit $$$OK
	
ErrorHandler
   w "0^操作失败"_errInfo_"_"_$zerror
   Quit $$$OK
}

ClassMethod IsCAOn() As %String
{
	s CTLocID=%session.Get("LOGON.CTLOCID")
    //开启：Y;  关闭：N 
	s status=##Class(EPRservice.BLDigitalSignature).GetCAServiceStatus(CTLocID) 
	if (status=1)
	{
		q "0^Y"
	}
	else
	{
		q "0^N"
	}
}

ClassMethod Login(errInfo As %String) As %String
{
	// 1.随机数检查
    s serverRan = $Get(%request.Data("ServerRan",1),"")
	q:(%session.Get("ServerRan")'=serverRan) "0^"_"证书会话已过期，请重新认证"
		
	// 2.用户证书检查	
    s UsrCertCode = ..FilterIlleaglChar($g(%request.Data("UsrCertCode", 1), ""))
    q:UsrCertCode="" "0^用户证书编码不能为空"
     
    s userSignedData = $Get(%request.Data("UserSignedData",1),"")
	s usrID = $Get(%request.Data("userID",1),"")
	s certNo = $Get(%request.Data("certificateNo",1),"")
	s userCert = $Get(%request.Data("certificate",1),"")
	s errInfo="31"
    
    s ret = ##Class(CA.DigitalSignatureService).Login(usrID, UsrCertCode, serverRan, userSignedData, certNo, userCert)
	q:ret'="" "0^"_ret 
    
    s usrLvl=$Get(%request.Data("userLevel",1),"") //级别
    s userPos=$g(%request.Data("userPos", 1), "")  //职务
 
	if ("" = usrID) //&& ("" '= usrLvl) // 审核不传入userID
	{  //审核   
	    s errInfo="32"
	    s info = ##Class(CA.UsrSignatureInfo).GetInUsedInfoByKey(UsrCertCode)
		s errInfo="33"
		
		
		if (""=userPos)
		{
		    if ("0"=##class(EPRmeta.Privilege.PowerUser).CheckUserLevel(info.UsrID, usrLvl))
		    {
			    q "0^医师级别与进行的操作不一致!"
		    }		    
		}
		else
		{
			s ret=..CheckUserPos(info.UsrID, userPos)
			q:(""'=ret) "0^"_ret
		}
	}	

	q ""
}

/// 返回错误描述
ClassMethod CheckUserPos(UsrID As %String, userPos As %String)
{
	s err="用户职务与进行的操作不一致!"
	s hisName=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	if ("ZHSRMYY"=hisName)  //珠海需求：只判断科主任
	{
        if (userPos="Chairman")
        {
	        s pos = ##class(EPRmeta.Privilege.PowerUser).GetUserPos(info.UsrID)
	        q:(userPos'=pos) err
        }
	}
	else
	{
		s pos = ##class(EPRmeta.Privilege.PowerUser).GetUserPos(info.UsrID)
	    q:(userPos'=pos) err
	}
	q ""
}

ClassMethod FilterIlleaglChar(txt As %String) As %String
{
	s txt = $tr(txt,$c(10),"")
	s txt = $tr(txt,$c(13),"")
	q txt
}

}
