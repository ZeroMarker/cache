Class web.eprajax.logs.updateMultiple Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	set userID = %session.Get("LOGON.USERID")
	if ("" = userID)
	{
		w "sessionTimedOut"
		Quit $$$OK
	}
	set userName = $Get(%request.Data("userName", 1), "-1")
	set pwd = $Get(%request.Data("pwd", 1), "-1")
	set userLevel = $Get(%request.Data("userLevel", 1), "-1")
	set episodeID = $Get(%request.Data("episodeID", 1), "-1")		
	set eprDocIDs = $Get(%request.Data("EPRDocIDs", 1), "-1")
	
	s UsrCertCode = $Get(%request.Data("UsrCertCode", 1), "")
	s signValue=$g(%request.Data("signValue", 1), "")
	//s printDocID = $Get(%request.Data("printDocID", 1), "")	
	s instanceIDs=$g(%request.Data("instanceIDs", 1), "")
	s contentHash=$g(%request.Data("contentHash", 1), "")		
    s eprNum=$g(%request.Data("EPRNum", 1), "")
	k PLIST	
	//	
	if (""=UsrCertCode) //传统登录
	{
		set loginValid = ##class(EPRmeta.Privilege.PowerUser).IsLogonValid(userName, pwd)
		//验证用户名和密码
	    if (loginValid = 0)
	    {
		    w "LoginValidFail"
	    	Quit $$$OK
	    }
	    set userID = ##class(EPRmeta.Privilege.PowerUser).GetUserId(userName)
	    //if (userLevel '= ##class(EPRmeta.Privilege.PowerUser).GetUserLevel(userID))
	    if ("0"=##class(EPRmeta.Privilege.PowerUser).CheckUserLevel(userID, userLevel))
	    {
		    w "CheckLevelFail"
		    Quit $$$OK
	    } 
	}
 	 
	/// CA验证
	if (UsrCertCode '= "")
	{	    
		s ret=##Class(EPRservice.BLDigitalSignature).Sign(UsrCertCode, episodeID, $p(eprDocIDs,"^",1), $p(eprDocIDs,"^",2), 
	               instanceIDs, signValue, contentHash)	
        if (ret'="")
        {
	        w ret
	        Quit $$$OK
	    }	
	    set userID = ##class(CA.UsrSignatureInfo).GetUsrIdByKey(UsrCertCode)
 	}
		
	w ..UpdateEPRLogs(episodeID, eprDocIDs, eprNum, userLevel, userID)	
	Quit $$$OK
}

ClassMethod UpdateEPRLogs(episodeID As %String, eprDocIDs As %String, eprNum As %String = "", userLevel As %String, userID As %String) As %String
{
	if (userLevel = "Chief")
	{
		set action = "chiefCheck"
	}
	elseif (userLevel = "Attending")
	{
		set action = "attendingCheck"
	}
	else 
	{
		q "ParametersError"			
	}
		
	//s IP=$ZUtil(67, 15, $Job) //操作机器的ip地址		
	s IP=%request.GetCgiEnv("REMOTE_ADDR")
	s status = ##class(EPRinstance.EPRLogs).UpdateEPRLogs(episodeID, eprDocIDs, action, IP, userID)	
	q:"0"=status "Update Log Error"
	
	//q "success"
	if ($L(eprDocIDs,"#")=1) {
		s eprDocID = $p(eprDocIDs,"^",1)
		s currState = ##class(EPRinstance.EPRLogs).GetEPRStatus(episodeID, eprDocID, eprNum)
		s divStateServer = ##class(EPRinstance.EPRLogs).GetLogStatus(episodeID, eprDocID, eprNum)
		s signLog=##Class(EPRservice.BLDigitalSignature).GetSignLog(episodeID, eprDocID, eprNum)
		s logID = ##class(EPRinstance.EPRLogs).GetLogID(episodeID, eprDocID, eprNum)
		if (signLog'="") {
			s divStateServer = divStateServer_signLog
		}
		q "success^"_divStateServer_"^"_currState_"^"_logID
	}
	else {
		q "success"
	}
}

}
