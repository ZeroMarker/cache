Class web.eprajax.eprBorwser.printTemplateId Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s categoryChapterId = $Get(%request.Data("categoryChapterId",1),"-1")
	s parentId = $Get(%request.Data("parentId",1),"-1")
	s startDate = $ZDH($Get(%request.Data("startDate",1),"-1"), 3)
	s endDate =  $ZDH($Get(%request.Data("endDate",1),"-1"),3)
	s episodeID = $Get(%request.Data("episodeID",1),"-1")
	
	s EPRNum = $Get(%request.Data("EPRNum",1),"-1")
	
	s startTime = $ZTH($Get(%request.Data("startTime",1),"-1"), 2)
	s endTime =  $ZTH($Get(%request.Data("endTime",1),"-1"),2)
	
	q:(parentId = -1 || startDate = -1 || endDate = -1 || episodeID = -1) $$$OK	
	s docId = ""
	s docIdList = ""
	
	//权限
  	s userid = %session.Get("LOGON.USERID")  	
  	s patientID = $Get(%request.Data("patientID",1),"-1")
  	s episodeID = $Get(%request.Data("episodeID",1),"-1")
  	s ctlocid=%session.Get("LOGON.CTLOCID")  
  	s ssgroupid = %session.Get("LOGON.GROUPID")  	
	s bindTemplateCategoryID = "-1"
	s bindTemplateID = "-1"
	
	/*
	if (categoryChapterId = "")
	{
		;s privString = "userid^"_userid_"!admid^"_episodeID_"!patientid^"_patientID_"!userloc^"_ctlocid_"!templateid^"_bindTemplateID_"!ssgroupid^"_ssgroupid_"!categoryid^"_bindTemplateCategoryID_"!docid^"_parentId_"!isnewframework^1"
		s arr = ##class(web.eprajax.ajaxGetPower).GetPowerArray(userid, episodeID, patientID, ctlocid, bindTemplateID, ssgroupid, bindTemplateCategoryID, parentId, EPRNum)
	}
	else
	{
		;s privString = "userid^"_userid_"!admid^"_episodeID_"!patientid^"_patientID_"!userloc^"_ctlocid_"!templateid^"_bindTemplateID_"!ssgroupid^"_ssgroupid_"!categoryid^"_bindTemplateCategoryID_"!docid^"_categoryChapterId_"!isnewframework^1"
		s arr = ##class(web.eprajax.ajaxGetPower).GetPowerArray(userid, episodeID, patientID, ctlocid, bindTemplateID, ssgroupid, bindTemplateCategoryID, categoryChapterId, EPRNum)

	}
	//s privRule = ##class(EPRservice.Privilege.BOPrivRule).ParsePrivRule(privString)
	
	s browse = arr.GetAt("canBrowser")
	if (browse = "0")
	{
		w "NoPower"	
		Quit $$$OK
	}
	*/
	
	set docIdList = ##class(EPRmeta.EPRTemplateCategory).GetSubPrtTemplateCategory(parentId, categoryChapterId)
	if (docIdList = "")
	{
		w "docIdListnull"
		Quit $$$OK
	}
	
	s ruleID = ""
	&sql(SELECT top 1 ID into:ruleID FROM  EPRmeta_Privilege.PrivRule 
		WHERE Valid='1' AND PrivRuleTypeDR in
		(SELECT ID FROM  EPRmeta_Privilege.PrivRuleType WHERE NAME='ViewPrivilege'))
	set ruleDocIdList = ..GetRuleDocList(ruleID, userid, episodeID, patientID, ctlocid, docIdList, ssgroupid)
	if (ruleDocIdList = "")
	{
		w "NoPower"
		q $$$OK
	}
	
	set logIdList = ##class(EPRservice.BOEPRLogs).GetLogIDByDate(episodeID, startDate, startTime, endDate, endTime,  ruleDocIdList)
	if (logIdList = "")
	{
		w "logIdListnull"
		Quit $$$OK
	}
	
	//返回值格式：totImgaeCount$docID1^logsID1^printType1^imageCount1^hasTitlePage1#docID2^logsID2^printType2^imageCount2^hasTitlePage2
	set imageList = ##class(EPRservice.BOEPImage).GetEPImageCount(episodeID,logIdList)	
	
	w imageList
	
	Quit $$$OK
}

ClassMethod GetRuleDocList(argRuleID As %String, AUserID As %String, AEpisodeID As %String, APatientID As %String, AUserLoc As %String, ADocList As %String, AssGroupID As %String) As %String
{
	q:(argRuleID="") ADocList
	
	s RuleDocList = ""
	for i = 1:1:$l(ADocList, "^")
	{
		s ADocID = $p(ADocList, "^", i)
		
		//拼环境变量,跑脚本
		s argEnviromentInfo = "userid^"_AUserID_"!admid^"_AEpisodeID_"!patientid^"_APatientID_"!userloc^"_AUserLoc_"!templateid^"_0_"!ssgroupid^"_AssGroupID_"!categoryid^"_0_"!docid^"_ADocID_"!isnewframework^1!eprnum^1"
		s arr = ##class(EPRservice.Privilege.BOPrivRule).ParsePrivRuleByID(argRuleID,argEnviromentInfo)
		
		continue:(arr.GetAt("browse")=0)
		
		//符合权限脚本
		if (RuleDocList="")
		{
			s RuleDocList = ADocID
		}
		else
		{
			s RuleDocList = RuleDocList_"^"_ADocID
		}
		
	}
	
	q RuleDocList
}

}
