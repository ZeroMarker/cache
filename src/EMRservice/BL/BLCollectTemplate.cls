Class EMRservice.BL.BLCollectTemplate Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       判断当前docID是否已被当前用户收藏
/// Creator:    yn
/// CreateDate: 2020-5-10
/// Input:      userID
/// OutPut:     返回字符1或0
/// Debug:      w ##class(EMRservice.BL.BLCollectTemplate).GetIsCollect("18881","TempCate-641")
ClassMethod GetIsCollect(AuserID As %String, AID As %String) As %String
{
	;获取当前template是否被当前userID收藏 collect = 0为未被收藏，1为已被收藏
       	s collect = "0"
       	s isExistNodeID = ""
		for
		{
			s isExistNodeID = $o(^EMRmeta.CollectTemplateI("IdxUserNodeID"," "_AuserID,isExistNodeID),1)
			q:isExistNodeID=""
			if ($zconvert(AID,"U")=$replace(isExistNodeID," ","")){
				s collect = "1"
				q
			}	
		}
		q collect
}

/// Desc:       添加模板docID到常用模板表中
/// Creator:    yn
/// CreateDate: 2020-5-10
/// Input:      userID
/// OutPut:     返回-1或者1,添加成功失败的状态
/// Debug:      w ##class(EMRservice.BL.BLCollectTemplate).GetIsCollect("10209","88")
ClassMethod AddUserCollect(AuserID As %String, AID As %String) As %String
{
	
	s strRes ="-1"
	q:(AuserID = ""||AID = "") strRes
	TSTART
	s strMark = "1"
	s collectObj = ##class(EMRmeta.CollectTemplate).%New()
	s collectObj.nodeID = AID
	s collectObj.userID = AuserID
	s sc = collectObj.%Save()
	if ('$$$ISOK(sc))
	{
		s strMark="-1"
	}
	if (strMark ="-1")
	{
		TROLLBACK
	}
	else
	{
		TCOMMIT
		s strRes = "1"
	}
	q strRes
}

/// Desc:       移除收藏
/// Creator:    yn
/// CreateDate: 2020-5-10
/// Input:      userID
/// OutPut:     返回-1或者1,移除成功失败的状态
/// Debug:     w ##class(EMRservice.BL.BLCollectTemplate).removeUserCollect("18881","TempCate-641")
ClassMethod removeUserCollect(AuserID As %String, AID As %String) As %String
{
	s strRes ="-1"
	;通过AuserID，docID找rowID 
	s rowID=""
	s rowID = $o(^EMRmeta.CollectTemplateI("IdxUserNodeID"," "_AuserID," "_$zconvert(AID,"U"),rowID))
	TSTART
	s strMark = "1"
	s collect = ##class(EMRmeta.CollectTemplate).%OpenId(rowID)
	if (collect="") 
	{
		s strMark="-1"
	}else{
		s sc = collect.%DeleteId(rowID)
		if ('$$$ISOK(sc))
		{
			s strMark="-1"
		}
	}
	if (strMark ="-1")
	{
		TROLLBACK
	}
	else
	{
		TCOMMIT
		s strRes = "1"
	}
	q strRes
}

/// Desc:       获取当前用户所收藏的所有知情同意书[不用]
/// Creator:    yn
/// CreateDate: 2020-5-13
/// Input:      userID
/// OutPut:     返回json
/// Debug:      w ##class(EMRservice.BL.BLCollectTemplate).GetAllOften("6","4","10209","List")
ClassMethod GetAllOften(ACategoryID As %String, AEpisodeID As %String, AuserID As %String, AResultType As %String = "", AEventType As %String = "", AEventID As %String = "", ACTLocId As %String = "") As %GlobalCharacterStream
{
	s stres = "-1"
	q:(ACategoryID=""||AuserID=""||AEpisodeID="") stres
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AuserID)
	s patDept = $p($li(curPatInfo,2),$c(2),2)
	s json = ##Class(%GlobalCharacterStream).%New()
	;获取当前用户所收藏的所有docID
	s tempID = ""
	;获取当前用户所收藏的知情同意书信息
	for
	{
		s tempID = $o(^EMRmeta.CollectTemplateI("IdxUserNodeID"," "_AuserID,tempID))
		q:tempID=""
		s docID = $replace(tempID," ","")
		s objdoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docID)
        continue:(objdoc = "")
		s objchapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objdoc.ParentCategoryID)
		continue:(objchapter = "")
		s objcategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objchapter.ParentCategoryID)
		continue:(objcategory = "")	
		if (objcategory.%Id()=ACategoryID){
				s JaneSpell = objchapter.JaneSpell
	    		s FullFight = objchapter.FullFight
	    		s docCategoryName = objdoc.CategoryName
				s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docID)
				s objEMRTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docID)
		    	s EMRChartItemType = ##class(EMRservice.EMRDoc.DocCategoryFunSet).GetChapterDocType(objEMRTemplateCategoryDoc.ParentCategoryID)
				s childs = ##class(EMRservice.BL.BLClientCategory).GetTitleByDocID(docID,AEpisodeID,AEventType,AEventID,ACTLocId)
				s quotationFlag = ##Class(EMRservice.BL.BLQuotation).GetDocQuationFlag(patDept,docID)
				s curDocGropID = ""
				s curDocGropID = $o(^DHCEMRM.DocRes.DocsInGroupI("DocIDIdx"," "_docID,""))
				continue:(curDocGropID = "")
				s curDocGropID = $ZSTRIP(curDocGropID,"<W")
				s curDocGropObj = ##Class(EMRmeta.EMRDocRestriction.DocGroup).%OpenId(curDocGropID)
				s curDocGropName = ""
				s curDocGropName = curDocGropObj.GroupName
				s curDocGropObj = "" k curDocGropObj
				s curObjDocCategory = "" k curObjDocCategory
				s disCurDocGropName = ""
				s disCurDocGropName = disCurDocGropName_"模板组："
				s disCurDocGropName = disCurDocGropName_curDocGropName

				s nowcurCategoryName =docCategoryName_"（"
				s nowcurCategoryName = nowcurCategoryName_disCurDocGropName
				s nowcurCategoryName = nowcurCategoryName_"）"
				s collect = 1
				if (AResultType = "List")
				{
					d DisplayInList 
				}else
				{
					d DisPlayInTree
				}
				s cjson = $ZSTRIP(cjson,"*C")
				d:(json.Size >0) json.Write(",")
		    	d json.Write(cjson)	
			}
	}
	q json
DisplayInList
    s cjson = "{"
	s cjson = cjson_ """id"":"""_docID_""""
	s cjson = cjson_ ",""emrDocId"":"""_docID_""""
	s cjson = cjson_ ",""text"":"""_docCategoryName_""""
	s cjson = cjson_ ",""type"":""TempCate""" 
	s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""isLeadframe"":"""_objdoc.IsLeadframe_""""
	s cjson = cjson_ ",""isMutex"":"""_objchapter.IsMutex_""""
	s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
	s cjson = cjson_",""categoryId"":"""_ACategoryID_""""
	s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
	s cjson = cjson_ ",""JaneSpell"":"""_JaneSpell_"""" 
	s cjson = cjson_ ",""FullFight"":"""_FullFight_""""
	s cjson = cjson_ ",""isCollect"":"""_collect_""""
	s cjson = cjson_ ",""DocIDText"":"""_nowcurCategoryName_""""
	s cjson = cjson_ "}"
	q
DisPlayInTree  
	s cjson = "{"
	s cjson = cjson_ """id"":"""_docID_""""
	s cjson = cjson_ ",""emrDocId"":"""_docID_""""
	s cjson = cjson_ ",""text"":"""_docCategoryName_""""
	s cjson = cjson_ ",""childs"":["_childs_"]"
	s cjson = cjson_ ",""attributes"":{" 
	s cjson = cjson_ """type"":""TempCate""" 
	s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""isLeadframe"":"""_objdoc.IsLeadframe_""""
	s cjson = cjson_ ",""isMutex"":"""_objchapter.IsMutex_""""
	s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
	s cjson = cjson_",""categoryId"":"""_ACategoryID_""""
	s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
	s cjson = cjson_ ",""JaneSpell"":"""_JaneSpell_"""" 
	s cjson = cjson_ ",""FullFight"":"""_FullFight_"""" 
	s cjson = cjson_ ",""isCollect"":"""_collect_""""
	s cjson = cjson_ ",""DocIDText"":"""_docCategoryName_""""
	s cjson = cjson_",""disCurDocGropName"":"""_disCurDocGropName_""""
	s cjson = cjson_ "}"
	s cjson = cjson_ "}"
	q
}

}
