Class web.eprajax.ajaxGetPower Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	//权限
	s userid = %session.Get("LOGON.USERID")
	s EpisodeID = $Get(%request.Data("episodeID",1),"-1")
	s PatientID = $Get(%request.Data("patientID",1),"-1")
	s ctlocid=%session.Get("LOGON.CTLOCID")
	s docID = $Get(%request.Data("printTemplateDocId",1),"-1")
	s ssgroupid = %session.Get("LOGON.GROUPID")
	s EPRNum = $Get(%request.Data("EPRNum",1),"-1")
	
	s templateDocID = $Get(%request.Data("templateDocId",1),"")
	s bindTemplateCategoryID = ""
	s bindTemplateID = ""
	if (templateDocID '= "")
	{
		s category = ##class(EPRmeta.EPRTemplate).%OpenId(templateDocID)	
		s bindTemplateCategoryID = category.BindTemplateCategoryID	
		s bindTemplateID = category.BindTemplateID
		d category.%Close()
		s category = ""
	}
	s arr = ..GetPowerArray(userid, EpisodeID, PatientID, ctlocid, bindTemplateID, ssgroupid, bindTemplateCategoryID, docID, EPRNum)
	s json = ""
	s json = json_"canView:'"_arr.GetAt("canView")_"',canSave:'"_arr.GetAt("canSave")_"',canPrint:'"_arr.GetAt("canPrint")_"',canCommit:'"_arr.GetAt("canCommit")_"',canSwitch:'"_arr.GetAt("canSwitch")_"',canSwitchTemplate:'"_arr.GetAt("canSwitchTemplate")_"',canChiefCheck:'"_arr.GetAt("canChiefCheck")_"',canAttendingCheck:'"_arr.GetAt("canAttendingCheck")_"',printAfterCommit:'"_arr.GetAt("canPrintAfterCommit")_"',canReference:'"_arr.GetAt("canReference")_"',canExport:'"_arr.GetAt("canExport")_"',canDelete:'"_arr.GetAt("canDelete")_"',canRestore:'"_arr.GetAt("canDelete")_"'"
	w json
	Quit $$$OK
}

//add by zhuj on 2009-12-08

ClassMethod GetPowerArray(userid As %String, episodeID As %String, patientID As %String, ctlocid As %String, templateid As %String, ssgroupid As %String, categoryid As %String, docid As %String, EPRNum As %String) As %ArrayOfDataTypes
{
	 s privString = "userid^"_userid_"!admid^"_episodeID_"!patientid^"_patientID_"!userloc^"_ctlocid_"!templateid^"_templateid_"!ssgroupid^"_ssgroupid_"!categoryid^"_categoryid_"!docid^"_docid_"!isnewframework^1!eprnum^"_EPRNum
	 
	 //s ^CacheTempDHCEPRDebug("web.eprajax.ajaxGetPower")=privString
	 
	 s arr = ##class(%ArrayOfDataTypes).%New()
	 s privRule = ##class(EPRservice.Privilege.BOPrivRule).ParsePrivRule(privString)
	 d arr.SetAt($p($p(privRule, "!", 1), "^", 2), "canView")
	 d arr.SetAt($p($p(privRule, "!", 2), "^", 2), "canSave")
	 d arr.SetAt($p($p(privRule, "!", 3), "^", 2), "canPrint")
	 d arr.SetAt($p($p(privRule, "!", 4), "^", 2), "canCommit")
	 d arr.SetAt($p($p(privRule, "!", 5), "^", 2), "canSwitch")
	 d arr.SetAt($p($p(privRule, "!", 6), "^", 2), "canSwitchTemplate")
	 d arr.SetAt($p($p(privRule, "!", 7), "^", 2), "canChiefCheck")
	 d arr.SetAt($p($p(privRule, "!", 8), "^", 2), "canAttendingCheck")
	 d arr.SetAt($p($p(privRule, "!", 9), "^", 2), "canBrowser")
	 d arr.SetAt($p($p(privRule, "!", 10), "^", 2), "canPrintAfterCommit")
	 d arr.SetAt($p($p(privRule, "!", 13), "^", 2), "canReference")
	 d arr.SetAt($p($p(privRule, "!", 14), "^", 2), "canExport")
	 d arr.SetAt($p($p(privRule, "!", 15), "^", 2), "canNew")
	 //Add by YaoLin
	 d arr.SetAt($p($p(privRule, "!", 17), "^", 2), "canDelete")
	 d arr.SetAt($p($p(privRule, "!", 18), "^", 2), "canRestore")
	 
	 d arr.SetAt($p($p(privRule, "!", 19), "^", 2), "canCASign")
	 d arr.SetAt($p($p(privRule, "!", 20), "^", 2), "canHandSign")	 
	 q arr
}

/// Debug:	w ##class(web.eprajax.ajaxGetPower).Test()
ClassMethod Test() As %String
{
	b "s"
	s privString = ^CacheTempDHCEPRDebug("web.eprajax.ajaxGetPower")
	s privRule = ##class(EPRservice.Privilege.BOPrivRule).ParsePrivRule(privString)
	w privRule
}

}
