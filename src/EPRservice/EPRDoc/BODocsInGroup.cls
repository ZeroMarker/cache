Class EPRservice.EPRDoc.BODocsInGroup Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EPRDocRes.DocsInGroup";

ClassMethod Add(argDoc As EPRservice.entity.EPRDocRestriction.EDocsInGroup) As %String [ WebMethod ]
{
	q:($d(argDoc)=0)||(argDoc="") 0
	s objDoc=""
	s objDoc=##class(EPRmeta.EPRDocRestriction.DocsInGroup).%New()
	q:(objDoc="") 0
	
	s objDoc.GroupID=argDoc.GroupID
	s objDoc.DocID=argDoc.DocID
	
	s result=""
	s result=objDoc.%Save()
	q objDoc.%Id()
}

ClassMethod Delete(argDocID As %String) As %String [ WebMethod ]
{
	q:($d(argDocID)=0)||(argDocID="") 0
	s objDoc="",result=""
	s objDoc=##class(EPRmeta.EPRDocRestriction.DocsInGroup).%OpenId(argDocID)
	q:(objDoc="") 0
	d objDoc.%Close()
	s objDoc=""
	s result=##class(EPRmeta.EPRDocRestriction.DocsInGroup).%DeleteId(argDocID)
	q result
}

ClassMethod GetById(argDocID As %String) As EPRservice.entity.EPRDocRestriction.EDocsInGroup [ WebMethod ]
{
	s result="",id="",tmpResult="" 
	s result=##class(EPRservice.entity.EPRDocRestriction.EDocsInGroup).%New()
	
	s tmpResult=##class(EPRmeta.EPRDocRestriction.DocsInGroup).%OpenId(argDocID)
	q:(tmpResult="") result
	
	s result.ID = argDocID
	s result.GroupID=tmpResult.GroupID
	s result.DocID=tmpResult.DocID
		
	q result
}

/// Debug: w ##class(EPRservice.EPRDoc.BODocsInGroup).GetAllDoc("2")
ClassMethod GetAllDoc(argGroupID As %String) As EPRservice.dataset.EPRDocRestriction.AllDocDs [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EPRDocRestriction.AllDocDs).%New()
 d result.SetArgs(argGroupID)
 Quit result
}

ClassMethod GetGroupNameByDocId(argDocID As %String) As %String [ WebMethod ]
{
	q:(($d(argDocID)=0) || (argDocID = "")) ""
	set argDocID = " "_argDocID
	set groupID = $o(^DHCEPRM.EPRDoc.DocsInGroupI("DocIDIdx",argDocID,""))
	q:(groupID="") ""
	set docInGroupID = $o(^DHCEPRM.EPRDoc.DocsInGroupI("DocIDIdx", groupID,""))
	
	s groupID = $extract(groupID,2,$l(groupID))
	s objGroup = ##class(EPRmeta.EPRDocRestriction.DocGroup).%OpenId(groupID)
	q:(objGroup = "") ""
	
	s groupName = objGroup.GroupName
	d objGroup.%Close()
	
	q docInGroupID_"^"_groupID_"^"_groupName
}

//取出某一个chapterID下，属于groupID的打印模板DocID及Name

ClassMethod GetDocNameByChapter(chapterID As %String, groupID As %String) As %String [ WebMethod ]
{
	q:(($d(groupID)=0) || (groupID = "")) ""
	q:(($d(chapterID)=0) || (chapterID = "")) ""
	
	s reuslt = ""
	s resultDocID = ""
	s chapterID = " "_chapterID
	s curDocId = ""
	s curDocId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", chapterID, curDocId))
	WHILE (curDocId '= "") 
	{
		s curExist = $d(^DHCEPRM.EPRDoc.DocsInGroupI("DocIDIdx"," "_curDocId," "_groupID))
		if (curExist '= 0)
		{
			s resultDocID = curDocId
			q	
		}
		
		s curDocId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", chapterID, curDocId))
	}
	
	if (resultDocID '= "")
	{
		s curDocNote = $g(^DHCEPRM.EPRTemplateCategoryD(resultDocID))
		s curDocName = $lg(curDocNote,8)
		s reuslt = resultDocID_"^"_curDocName
	}
	
	q reuslt
}

/// Creator: 陈文俊
/// CreatDate: 2009-08-13
/// Description：判断指定的episodeID及打印模板docID下的必填界面模板是否均已保存
/// Table:
/// Input: episodeID--病人就诊号; docID--打印模板docID
/// Output:
/// Return: 如果必填的都保存了，返回 Y；
/// 		如果存在必填的没保存的界面模板，则返回其DocID，格式为 docID1^docID2^docID3
ClassMethod CheckAllNecessaryDocReady(episodeID As %String, docID As %String) As %String
{
	q:(($d(docID)=0) || (docID = "")) "0"
	
	s result = "Y"
	s unSaveDocIDs = ""
	
	s curTemplateDocId = ""
	s curTemplateDocId = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID", " "_docID, curTemplateDocId))
	WHILE (curTemplateDocId '= "") 
	{		
		s curTemplateNote = $g(^DHCEPRM.EPRTemplateD(curTemplateDocId))
		s curTemplateID = $lg(curTemplateNote, 12)
		s isNecessaryTemplate = $lg(curTemplateNote, 4)
		if (isNecessaryTemplate = "1")
		{
			//判断界面模板是否已保存
			s isSaved = "0"
			s curChartItemID = "CG"_curTemplateID
			s ecRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", " "_episodeID, " "_curChartItemID, 0))
			if (ecRecordID '= "")
			{
				s objInstance = ##class(EPRinstance.InstanceData).%OpenId(ecRecordID_"||1")
				if (objInstance '= "")
				{
					s:((objInstance.Status'="")&&(objInstance.Status'="UnSave")) isSaved="1"
				}
			}
			
			//界面模板未保存，记录对应的DocID
			if (isSaved = "0")
			{
				s result = "N"
				if (unSaveDocIDs="") 
				{	s unSaveDocIDs = curTemplateDocId}
				else
				{	s unSaveDocIDs = unSaveDocIDs_"^"_curTemplateDocId}	
			}	
		}
		
		s curTemplateDocId = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID", " "_docID, curTemplateDocId))
	}
	
	if (result = "N")
	{
		s result = unSaveDocIDs	
	}

	q result
}

/// Desc:	要显示的必填模板是否已全部保存
/// Input:	
/// Return:	1 必填界面模板已全部保存
/// 		0 必填界面模板未全部保存
/// 		-1 所有界面模板都未保存
/// Debug:	w ##Class(EPRservice.EPRDoc.BODocsInGroup).IsAllNecessaryDocReady("201764","556")
ClassMethod IsAllNecessaryDocReady(AEpisodeID As %String, APrintTemplateDocID As %String) As %Integer
{
	s $zt = "OnErrorHandler"
	
	q:(($d(APrintTemplateDocID)=0)||(APrintTemplateDocID = "")) "0"
	
	s result = "0"
	s hasAtLeastOneSaved = "0", unsavedNecessaryCount = "0"
	
	s blankPTDocID = " "_APrintTemplateDocID
	s curTemplateDocId = ""
	for {
		//b "s"
		s curTemplateDocId = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID", blankPTDocID, curTemplateDocId))
		q:(curTemplateDocId = "")
		
		s objEPRTemplate = ##Class(EPRmeta.EPRTemplate).%OpenId(curTemplateDocId)
		continue:(objEPRTemplate = "")
		
		//是否必填模板(如果已经有至少一个模板保存了,则只需要判断必填模板状态即可)
		if (hasAtLeastOneSaved="1")&&(objEPRTemplate.NecessaryTemplate '= "1") continue
		
		s curTemplateID = objEPRTemplate.BindTemplateID
		s privRuleID = objEPRTemplate.PrivRuleDR
		
		//是否加载该模板
		s needLoad = ..IsTemplateNeedLoad(AEpisodeID, privRuleID, curTemplateID, APrintTemplateDocID)
		if (needLoad = "0") continue
		
		//判断界面模板是否已保存
		s isSaved = "0"
		s curChartItemID = "CG"_curTemplateID
		s ecRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", " "_AEpisodeID, " "_curChartItemID, 0))
		
		//if (ecRecordID="") continue	//20131101 wangwentao comment
		//20131101 wangwentao update
		if (ecRecordID="")
		{
			if (objEPRTemplate.NecessaryTemplate = "1")
			{
				s unsavedNecessaryCount = unsavedNecessaryCount + 1
			}
			continue
		}
		
		s childSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID," 1",""))
		if (childSub="") 
		{
			if (objEPRTemplate.NecessaryTemplate = "1")
			{
				s unsavedNecessaryCount = unsavedNecessaryCount + 1
			}
			continue
		}
		s instanceID = ecRecordID_"||"_childSub
		s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceID)
		if ((objInstance '= "")&&(objInstance.Status'="")&&(objInstance.Status'="UnSave"))
		{
			s isSaved="1"
		}
		else
		{
			if (objEPRTemplate.NecessaryTemplate = "1")
			{
				s unsavedNecessaryCount = unsavedNecessaryCount + 1
			}
		}
		
		if (isSaved = "1")
		{
			s hasAtLeastOneSaved = "1"
		}
		else
		{
			if (objEPRTemplate.NecessaryTemplate = "1")
			{
				s unsavedNecessaryCount = unsavedNecessaryCount + 1
			}
		}
		
		q:(hasAtLeastOneSaved="1")&&(unsavedNecessaryCount>0)
	}
	
	
	if (hasAtLeastOneSaved = "0")
	{
		s result = "-1" //所有模板都未保存
	}
	else
	{
		if (unsavedNecessaryCount>"0")
		{
			s result = "0" //有个别必填模板未保存
		}
		else
		{
			s result = "1" //所有必填模板都已保存
		}
	}
	
	q result
	
OnErrorHandler
	q "0"
}

/// Desc:	模板是否需要加载
ClassMethod IsTemplateNeedLoad(AEpisodeID As %String, APrivRuleID As %String, ATemplateID As %String, APrintDocID As %String) As %Boolean
{
	q:(APrivRuleID = "")||(APrivRuleID = $C(0)) "1"
	
	s empty = ""
	s categoryID = ""
	s patientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s privString = "userid^"_empty_"!admid^"_AEpisodeID_"!patientid^"_patientID_"!userloc^"_empty_"!templateid^"_ATemplateID_"!ssgroupid^"_empty_"!categoryid^"_categoryID_"!docid^"_APrintDocID_"!isnewframework^1!eprnum^"_1
	s privRule = ##Class(EPRservice.Privilege.BOPrivRule).ParsePrivRuleByID(APrivRuleID,privString)
	
	q:(privRule.GetAt("load") = "1") "1"
	q "0"
}

}
