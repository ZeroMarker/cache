Class web.eprajax.ajaxCreateEprList Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	if (%session.Get("LOGON.USERID") = "")
  	{
		w "sessionTimedOut"
		q $$$OK
	}
	
	s objTAndCNotes = ##class(EPRservice.BOInstanceData).GetTAndCFromEPRTemplate($Get(%request.Data("episodeID",1),"-1"), $Get(%request.Data("templateDocId",1),"-1"), "2")  		
 	//权限
  	s userid = %session.Get("LOGON.USERID")
  	s EpisodeID = $Get(%request.Data("episodeID",1),"-1")
  	s PatientID = $Get(%request.Data("patientID",1),"-1")
  	s ctlocid=%session.Get("LOGON.CTLOCID")
  	s docID = $Get(%request.Data("printTemplateDocId",1),"-1")
  	s ssgroupid = %session.Get("LOGON.GROUPID")  	
  	s templateDocID = $Get(%request.Data("templateDocId",1),"-1")
  	s category = ##class(EPRmeta.EPRTemplate).%OpenId(templateDocID)	
	s bindTemplateCategoryID = category.BindTemplateCategoryID	
	s bindTemplateID = category.BindTemplateID
	d category.%Close()
	s category = ""
	s eprnum=$Get(%request.Data("EPRNum",1),"")
	
	s arr = ##class(web.eprajax.ajaxGetPower).GetPowerArray(userid, EpisodeID, PatientID, ctlocid, bindTemplateID, ssgroupid, bindTemplateCategoryID, docID, eprnum)

	/*
	s privString = "userid^"_userid_"!admid^"_EpisodeID_"!patientid^"_PatientID_"!userloc^"_ctlocid_"!templateid^"_bindTemplateID_"!ssgroupid^"_ssgroupid_"!categoryid^"_bindTemplateCategoryID_"!docid^"_docID_"!isnewframework^1!eprnum^"_eprnum
	s privRule = ##class(EPRservice.Privilege.BOPrivRule).ParsePrivRule(privString)	
	s canView = $p($p(privRule, "!", 1), "^", 2)
	s canSave = $p($p(privRule, "!", 2), "^", 2)
	s canPrint = $p($p(privRule, "!", 3), "^", 2)
	s canCommit = $p($p(privRule, "!", 4), "^", 2)
	s canSwitch = $p($p(privRule, "!", 5), "^", 2)	
	s canSwitchTemplate = $p($p(privRule, "!", 6), "^", 2)
	s canChiefCheck = $p($p(privRule, "!", 7), "^", 2)
	s canAttendingCheck = $p($p(privRule, "!", 8), "^", 2)
	
	s printAfterCommit = $p($p(privRule, "!", 10), "^", 2)		//add by zhuj on 2009-11-17
	*/
	s ProfileID = objTAndCNotes.ChartItemID
	s CategoryID = objTAndCNotes.CategoryID	
	s PageTitle = objTAndCNotes.EPRCategoryName
	
	s CategoryType = objTAndCNotes.CategoryType
	s TemplateID = objTAndCNotes.TemplateID
	s TemplateName = objTAndCNotes.TemplateName
	//[{text:'住院病历',id:'CG1',leaf:false,cls:'folder'},{text:'测试目录',id:'CG4',leaf:false,cls:'folder'}]
	s json = "["
	s json = json_"{canView:'"_arr.GetAt("canView")_"',canSave:'"_arr.GetAt("canSave")_"',canPrint:'"_arr.GetAt("canPrint")_"',canCommit:'"_arr.GetAt("canCommit")_"',canSwitch:'"_arr.GetAt("canSwitch")_"',canSwitchTemplate:'"_arr.GetAt("canSwitchTemplate")_"',canChiefCheck:'"_arr.GetAt("canChiefCheck")_"',canAttendingCheck:'"_arr.GetAt("canAttendingCheck")_"',printAfterCommit:'"_arr.GetAt("canPrintAfterCommit")
	s json = json_"',ProfileID:'"_ProfileID_"',CategoryID:'"_CategoryID_"',PageTitle:'"_PageTitle_"',CategoryType:'"_CategoryType_"',TemplateID:'"_TemplateID_"',TemplateName:'"_TemplateName_"'}"
	s json = json_"]"
	w json
	q $$$OK
}

}
