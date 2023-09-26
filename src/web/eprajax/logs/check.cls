Class web.eprajax.logs.check Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	set userID = %session.Get("LOGON.USERID")
	if ("" = userID)
	{
		w "sessionTimedOut"
		Quit $$$OK
	}
	
	set action = $Get(%request.Data("action", 1), "")
	if ("qcCheck"=action) {
	
		w ..qcCheck()
		Quit $$$OK		
	}
		
	set userName = $Get(%request.Data("userName", 1), "-1")
	set pwd = $Get(%request.Data("pwd", 1), "-1")
	set userLevel = $Get(%request.Data("userLevel", 1), "-1")

	s UsrCertCode = $Get(%request.Data("UsrCertCode", 1), "")
	k PLIST	
	
	
	
	if (""=UsrCertCode) //传统登录
	{
		set loginValid = ##class(EPRmeta.Privilege.PowerUser).IsLogonValid(userName, pwd)	
	    //验证用户名和密码
	    if (loginValid = 0)
	    {
		    w "LoginValidFail"
		    q $$$OK
	    }
	    set uID = ##class(EPRmeta.Privilege.PowerUser).GetUserId(userName)
	    //if (userLevel '= ##class(EPRmeta.Privilege.PowerUser).GetUserLevel(uID))
	    if ("0"=##class(EPRmeta.Privilege.PowerUser).CheckUserLevel(uID, userLevel))
	    {
		    w "CheckLevelFail"
		    q $$$OK
	    }

	}

	
	set episodeID = $Get(%request.Data("episodeID", 1), "-1")		
	set eprDocID = $Get(%request.Data("EPRDocID", 1), "-1")
	set eprNum = $Get(%request.Data("eprNum", 1), "-1")
	//s printDocID = $Get(%request.Data("printDocID", 1), "")	
	s instanceIDs=$g(%request.Data("instanceIDs", 1), "")
	s signValue=$g(%request.Data("signValue", 1), "")
	s contentHash=$g(%request.Data("contentHash", 1), "")
	s signLog=""	
	// CA验证
	if (UsrCertCode '= "")
	{	
	    if ("-1"=eprDocID)
	    {
		    s eprDocID=$g(%request.Data("printDocID", 1), "-1")  
		}			
		s ret=##Class(EPRservice.BLDigitalSignature).Sign(UsrCertCode, episodeID, eprDocID, eprNum, 
	               instanceIDs, signValue, contentHash)	
        if (ret'="")
        {
	        w ret
	        Quit $$$OK
	    }
 
	    set eprDocID = $Get(%request.Data("printDocID", 1), "-1")
	    set uID = ##class(CA.UsrSignatureInfo).GetUsrIdByKey(UsrCertCode)	
    }
	s userPos=$g(%request.Data("userPos", 1), "") //大同三院增加
	s action=$g(%request.Data("OperAction", 1), "") //大同三院增加	
	w ..UpdateEPRLogs(episodeID, eprDocID, eprNum, userLevel, userPos, action, uID)
	Quit $$$OK
}

ClassMethod qcCheck() As %String
{
	set userName = $Get(%request.Data("userName", 1), "-1")
	set pwd = $Get(%request.Data("pwd", 1), "-1")	
	set loginValid = ##class(EPRmeta.Privilege.PowerUser).IsLogonValid(userName, pwd)	
	//验证用户名和密码
	q:(loginValid = 0) "LoginValidFail"
 
	set uID = ##class(EPRmeta.Privilege.PowerUser).GetUserId(userName)
    s pos=##class(EPRmeta.Privilege.PowerUser).GetUserPos(uID)
    q:(""=pos) "CheckLevelFail"
    
	set episodeID = $Get(%request.Data("episodeID", 1), "-1")		
	set eprDocID = $Get(%request.Data("EPRDocID", 1), "-1")
	//s ^CacheTemp("eprDocID")=eprDocID
	set eprNum = $Get(%request.Data("eprNum", 1), "-1") 
    set logID = ##class(EPRinstance.EPRLogs).GetLogID(episodeID, eprDocID, eprNum)
	q:""=logID "NoLog"
	 
	s id = $O(^DHCEPRM.UserPostI("NameIndex"," "_$zcvt(pos,"U"), "")) 
	s userPos = ##Class(EPRmeta.UserPost).%OpenId(id)
	s action=userPos.OperAction
	s userPos=userPos.Name
	s userLevel=""
	q ..UpdateEPRLogs(episodeID, eprDocID, eprNum, userLevel, userPos, action, uID)
}

ClassMethod UpdateEPRLogs(episodeID As %String, eprDocID As %String, eprNum As %String, userLevel As %String, userPos As %String, action As %String, uID As %String) As %String
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
		q:(""=userPos) "UserPosParametersError"
		q:(""=action) "ActionParametersError"			
	}
	
	set logID = ##class(EPRinstance.EPRLogs).GetLogID(episodeID, eprDocID, eprNum)
	q:""=logID "NoLog"
	 
	//set IP = $ZUtil(67, 15, $Job)
	s IP=%request.GetCgiEnv("REMOTE_ADDR")
	//s ^CacheTemp("action")=action
	set status = ##class(EPRinstance.EPRLogs).UpdateEPRLogByID(logID, action, IP, uID)
	q:"0"=status "Update Log Error"
    
	s currState = ##class(EPRinstance.EPRLogs).GetEPRStatus(episodeID, eprDocID, eprNum)
	s divStateServer = ##class(EPRinstance.EPRLogs).GetLogStatus(episodeID, eprDocID, eprNum)
	s signLog=##Class(EPRservice.BLDigitalSignature).GetSignLog(episodeID, eprDocID, eprNum)
	if (signLog'="") {s divStateServer = divStateServer_signLog }
	q "success^"_divStateServer_"^"_currState
}

}
