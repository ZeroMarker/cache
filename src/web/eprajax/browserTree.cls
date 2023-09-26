Class web.eprajax.browserTree Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	;w "[{text:'病历首页',id:'CG18',leaf:false,cls:'folder'},{text:'病程记录',id:'CG23',leaf:false,cls:'folder'}]"
	s episodeID = $Get(%request.Data("EpisodeID",1),"-1")
	s parentId = $Get(%request.Data("node",1),"-1")
	s parentType = $e(parentId,1,2)
	s parentId = $e(parentId, 3, $l(parentId))
	s workGroupID = $g(%session.Data("LOGON.GROUPID")) //当前登录医生的安全组
	
	d ..GetTreeNode(episodeID,parentId,parentType,workGroupID)
	
	q $$$OK
}

/// D ##class(web.eprajax.browserTree).GetTreeNode("72359","0","RT","100")
ClassMethod GetTreeNode(episodeID, parentId, parentType, workGroupID)
{
	
	//s ^CacheTempDHCEPRDebug("web.eprajax.borwserTree","input")= episodeID_"^"_parentId_"^"_parentType_"^"_workGroupID
	
	s parentId = " "_parentId
	s json =  "["
	s isFirstNode = 1
	if (parentType = "RT")
	{
		//取出当前节点的下级目录或绑定的打印模板
		s curCategoryId = ""
		for {
			s curCategoryId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", parentId, curCategoryId))
			q:(curCategoryId="")
			
			//s ssGroupRuleRowID = $o(^DHCEPRM.EPRDOC.EPRSSGroupI("IdxCatalogSSGroup"," "_curCategoryId," "_workGroupID, 0))
			//	if (ssGroupRuleRowID = "")
			//	{
			//		s isCategoryIdValid = 0
			//	}
			
			
			/*
			s count = ##class(EPRmeta.EPRDocRestriction.EPRCatalogSSGroup).GetEPRCatalogSSGroupCount(curCategoryId)
			if (count = 0)
			{
				continue
			}
			*/
			
			s curCategoryNote = $g(^DHCEPRM.EPRTemplateCategoryD(curCategoryId))
			s category = ##class(EPRmeta.EPRTemplateCategory).%OpenId(curCategoryId)
			
			//add by zhuj on 2010-1-22	begin	用来判断是否有图片
			s hasImage = ..IsHasImage(episodeID, curCategoryId, "")

			if (hasImage = "0")
			{
				continue
			}
			//end
			
			s json = json_"{"
			s json = json_"text:'"_category.CategoryName_"'" 
			s json = json_",id:'CG"_category.%Id()_"'"
			s json = json_",leaf:false"			
			s json = json_",cls:'folder'}"
			s json = json_","
			s isFirstNode = 0
		}
		if (json '= "[")
		{
			s json = $e(json, 1, $l(json)-1)
		}
		s json = json_"]"
		w json
	}
	elseif (parentType = "CG")
	{
		//取出当前节点的下级目录或绑定的打印模板
		s curCategoryId = ""
		for {
			s curCategoryId = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", parentId, curCategoryId))
			q:(curCategoryId="")
			s curCategoryNote = $g(^DHCEPRM.EPRTemplateCategoryD(curCategoryId))
			s category = ##class(EPRmeta.EPRTemplateCategory).%OpenId(curCategoryId)
			/*
			//add by zhuj on 2010-1-19		//如果是目录,并非打印模板,则不显示
			s priActivity = ##class(EPRservice.DocRestLogic.PrivLogic).CheckTPrivActivity()
			s curPatInfo = ##class(EPRservice.DocRestLogic.PrivLogic).GetPatInfo(episodeID)
			//查找目录下docID
			s docID = ##class(EPRservice.DocRestLogic.PrivLogic).GetDocIDForView(episodeID, "", curCategoryId, priActivity, curPatInfo)
			//若docID为空,直接跳出本次循环
			if (docID = "")
			{
				continue	
			}
			s tc = ##class(EPRmeta.EPRTemplateCategory).%OpenId(docID)			
			if (tc.CategoryType = "TempCate")
			{
				continue	
			}
			//end
			*/
			//add by zhuj on 2010-1-22	begin	用来判断是否有图片
			s hasImage = ..IsHasImage(episodeID, parentId, curCategoryId)
			if (hasImage = "0")
			{
				continue	
			}
			set now = $Horolog
			set endDate = $ZD(now, 3)
			set endTime = $ZT(now, 2)		
			set docIdList = ##class(EPRmeta.EPRTemplateCategory).GetSubPrtTemplateCategory(parentId, curCategoryId)		//若为第二层目录,传入两个参数
			if (docIdList = "")
			{
				continue
			}
			set logIdList = ##class(EPRservice.BOEPRLogs).GetLogIDByDate(episodeID, "1840-12-31", "0:00", endDate, endTime,  docIdList)	
			if (logIdList = "")
			{
				continue
			}
			//返回值格式：totImgaeCount$docID1^logsID1^printType1^imageCount1^hasTitlePage1#docID2^logsID2^printType2^imageCount2^hasTitlePage2
			set imageList = ##class(EPRservice.BOEPImage).GetEPImageCount(episodeID,logIdList)	
			s imageCount = $p(imageList, "$", 1)
			if (imageCount = 0)
			{
				continue	
			}
			//end
			
			
			s json = json_"{"
			s json = json_"text:'"_category.CategoryName_"'" 
			s json = json_",id:'"_category.%Id()_"'"
			s json = json_",leaf:true"
			s json = json_",icon:'../scripts/epr/ExtJS/resources/images/default/tree/folder.gif'"
			s json = json_",cls:'folder'}"			
			s json = json_","
		}
		if (json '= "[")
		{
			s json = $e(json, 1, $l(json)-1)
		}
		s json = json_"]"
		w json
	}
	
	
	///Quit $$$OK
}

/// CreateTime: 2010-1-22
/// Creator: zhuj
/// Desc: 根据目录取判断是否有图片
/// Input：	aEpisodeID：病人就诊rowid
/// 		parentId：病历结构树第一层的id
/// 		curCategoryId: 病历结构树第二层id,若只选中第1层,传入""即可
/// Output: 1:有图片，0：无图片
ClassMethod IsHasImage(episodeID As %String, parentId As %String, curCategoryId As %String) As %String
{
	set now = $Horolog
	set endDate = $ZD(now, 3)
	set endTime = $ZT(now, 2)		
	set docIdList = ##class(EPRmeta.EPRTemplateCategory).GetSubPrtTemplateCategory(parentId, curCategoryId)		//若为第二层目录,传入两个参数
	if (docIdList = "")
	{
		q "0"
	}
	set logIdList = ##class(EPRservice.BOEPRLogs).GetLogIDByDate(episodeID, "1840-12-31", "0:00", endDate, endTime,  docIdList)	
	if (logIdList = "")
	{
		q "0"
	}
	//返回值格式：totImgaeCount$docID1^logsID1^printType1^imageCount1^hasTitlePage1#docID2^logsID2^printType2^imageCount2^hasTitlePage2
	set imageList = ##class(EPRservice.BOEPImage).GetEPImageCount(episodeID,logIdList)	
	s imageCount = $p(imageList, "$", 1)
	if (imageCount = 0)
	{
		q "0"	
	}
	q "1"
}

}
