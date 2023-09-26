Class EMRservice.Ajax.ActionsLogs.getTemplateInfo Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s $zt = "ErrorHandler"
	s CTLocID = $Get(%request.Data("CTLocID",1),"")
	s EpisodeID = $Get(%request.Data("EpisodeID",1),"")
	s UserID = $Get(%request.Data("UserID",1),"")
	s ssgroupID =$Get(%request.Data("SSgroupID",1),"")
	
	s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(EpisodeID)
	s schemType = $case(disDateTime,"":"Running",:"Archiving")
	s request = ..getTemplate(CTLocID,schemType,EpisodeID,UserID,ssgroupID)
	w "["_request_"]"
	
	Quit $$$OK
ErrorHandler
	q "[]"
}

/// Desc:		所有模板
/// CreateDate:	2014-8-29
/// Input:		ACTLocId 科室ID
/// 				ASchemType 目录加载方案
/// 				AEpisodeID 就诊号
/// 				AUserID 用户ID
/// Output:     json
/// Debug: w ##Class(EMRservice.Ajax.ActionsLogs.getTemplateInfo).getTemplate(6,"Running",1043,662)
ClassMethod getTemplate(ACTLocId As %String, ASchemType As %String, AEpisodeID As %String, AUserID As %String, AssgroupID As %String) As %String
{
	s json = "{""id"":""0"",""text"":"""_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.CTOrganizationSchemeItem","ItemTitle","未选择病历")_"""}"
	q:(ACTLocId = "")||(ASchemType = "")||(AEpisodeID = "")||(AUserID = "")||(AssgroupID = "") json
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(ACTLocId,AssgroupID,AEpisodeID)
	while result.%Next()
	{
		s ItemType = result.Data("ItemType")
		continue:(ItemType = "HIS")
		s categoryId = result.Data("ItemCategoryID")
		s cjson = ..GetTemplateByCategoryID(categoryId,AEpisodeID,AUserID)
		continue:(cjson = "")
		s json = json_",{"
		s json = json_"""id"":"""_categoryId_""""
		s json = json_",""text"":"""_result.Data("ItemTitle")_""""
		s json = json_",""children"":["_cjson_"]"
		s json = json_"}" 
	}
	s json = $ZSTRIP(json,"*C")
	q json
}

/// w ##Class(EMRservice.Ajax.ActionsLogs.getTemplateInfo).GetTemplateByCategoryID(3,37,359)
ClassMethod GetTemplateByCategoryID(AParentId As %String, AEpisodeID As %String, AUserID As %String) As %String
{
	s json = "",count = 0,flag = 0
	s jsonList = ##Class(%ListOfDataTypes).%New()
	q:((AParentId = "")||(AEpisodeID = "")) ""
	s priActivity = ..CheckTPrivActivity()  //权限控制
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)
	s patDept = $p($li(curPatInfo,2),$c(2),2)
	s flag = ""
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq))
		q:(seq = "")
		s curCategoryId = ""
		for
		{
			s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq,curCategoryId))
			q:(curCategoryId = "")
			s objEMRTemplateCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
			continue:(objEMRTemplateCategory.CategoryType '= "CategoryChapter")
	        s curCategoryName = objEMRTemplateCategory.CategoryName
	        s curIsMutex = objEMRTemplateCategory.IsMutex
	        s:(curIsMutex '= 1) curIsMutex = 0
	        continue:((flag = 1)&&(curIsMutex = 1))
	        s curCategoryInternalID = objEMRTemplateCategory.InternalID
	        s objEMRTemplateCategory = "" k objEMRTemplateCategory
			//初始化CategoryChapter节点时，不直接初始化CategoryChapter节点，而是直接初始化其下级中适用的挂靠界面模板的节点
			//即文档中说明的隐藏第二层
			//s curObjDocCategory = ..GetDocIDInChapter(AEpisodeID,"",curCategoryId,priActivity,curPatInfo)
			//continue:(curObjDocCategory = "")
			//获取符号权限的DOCID集合已^分隔		
			s curDocIDS = ..GetDocIDInChapter(AEpisodeID,"",curCategoryId,priActivity,curPatInfo)
			continue:(curDocIDS = "")
			for i=1:1:$l(curDocIDS,"^")
			{
				s strDocID = $p(curDocIDS,"^",i)
				//根据DOCID获取属性对象
				s curObjDocCategory = ..GetEmrCategoryPropertyByDocID(strDocID)
				s curEMRTemplategoryID = $e(curObjDocCategory.ID,3,$l(curObjDocCategory.ID))  // CategoryType="TempCate"	
				continue:(curEMRTemplategoryID = "")
				s curIsLeadframe = curObjDocCategory.IsLeadframe
				s curTempCateName = curObjDocCategory.Name
		        s curObjDocCategory = ""  k curObjDocCategory
		        s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(curEMRTemplategoryID)
			    continue:(objTemplate = "")
			    /*
			    s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, objTemplate.ID,curEMRTemplategoryID)
				if ((result '= 0) && (objTemplate.ChartItemType = "Single"))
				{
					s:(curIsMutex = 1) flag = 1
					continue
				}
				*/
				//知情同意书按照TempCate显示
				if (curCategoryInternalID ["EMR07")
				{
					s curCategoryName = curTempCateName
				}
				s quotationFlag = ##Class(EMRservice.BL.BLQuotation).GetDocQuationFlag(patDept,curEMRTemplategoryID) 
				s cjson = "{"
				s cjson = cjson_ """id"":"""_curEMRTemplategoryID_""""
				s cjson = cjson_ ",""text"":"""_curCategoryName_""""
				s cjson = cjson_ ",""attributes"":{" 
				s cjson = cjson_ """type"":""TempCate""" 
				s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
				s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
				s cjson = cjson_ ",""isLeadframe"":"""_curIsLeadframe_""""
				s cjson = cjson_ ",""isMutex"":"""_curIsMutex_""""
				s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
				s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
				s cjson = cjson_ "}"
				s cjson = cjson_ "}"
				d jsonList.Insert(curIsMutex_"^"_cjson)
			}
		}
	}
    s key = ""
    for
    {
	    s value = jsonList.GetNext(.key)
	    q:(key = "")
	    s curIsMutex = $p(value,"^",1)
	    continue:((flag = 1)&&(curIsMutex = 1))
	    s:(count '= 0) json = json_","
	    s json = json_$p(value,"^",2)
	    s count = count + 1
	}
	s json = $ZSTRIP(json,"*C")
    q json
}

/// Creator: guozongtao
/// CreatDate: 2014-1-7
/// Description：系统参数是否设置为开启模板权限控制
/// Table:
/// Input:
/// Output:
/// Return:是否开启  Y--是  N--否
ClassMethod CheckTPrivActivity() As %String
{
	s ReturnValue = "N"
	s ReturnValue = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("TPRIVACTIVITY") 
	if ReturnValue '= "Y"
	{
		s ReturnValue = "N"
	}
	q ReturnValue
}

/// Creator: guozongtao
/// CreatDate: 2014-1-7
/// Description：取出ChapterDoc节点下可用的DocID（即可用的TempCate的Doc）
/// 			 在构造病历结构树形时，处理ChapterDoc类型的节点，该类型的节点将被隐藏，其位置由TempCate类型的节点代替
/// Table:
/// Input: EpisodeID--病人就诊号;parOthers--用于扩展的信息串（未用）;parCategoryID--Chapter的ID； parPriActivity--是否开启了模板权限, parPatInfo--病人信息
/// Output:
/// Return: DocID(挂靠界面模板的目录)
ClassMethod GetDocIDInChapter(EpisodeID As %String, parOthers As %String, parCategoryID As %String, parPriActivity As %String, parPatInfo As %Library.List) As %String
{
	 s resultDocID = ""
	 
	 s resultDocID = ##class(EMRservice.DocRestLogic.PrivLogic).GetDocIDForView(EpisodeID, parOthers, parCategoryID, parPriActivity, parPatInfo)
	 q:(resultDocID = "") ""
	 q resultDocID
	 //s objEMRTemplateCategory=##Class(EMRmeta.EMRTemplateCategory).%OpenId(resultDocID)
	 //s curCategoryType = objEMRTemplateCategory.CategoryType
	 //s resultDocID = ##class(EMRservice.BOEMRTemplateCategory).TransCategoryType(curCategoryType)_resultDocID
     //s objEEMRTemplateCategory = ##Class(EMRservice.entity.EEMRCategoryProperty).%New()
     //s objEEMRTemplateCategory.ID = resultDocID
     //s objEEMRTemplateCategory.IsLeadframe = objEMRTemplateCategory.IsLeadframe
     //s objEEMRTemplateCategory.IsMutex = objEMRTemplateCategory.IsMutex
     //s objEEMRTemplateCategory.Name = objEMRTemplateCategory.CategoryName
	 //返回结果
	 //q objEEMRTemplateCategory
}

/// Creator: yejian
/// CreatDate: 2020-5-22
/// Description：取出ChapterDoc节点下可用的DocID（即可用的TempCate的Doc）
/// 			 在构造病历结构树形时，处理ChapterDoc类型的节点，该类型的节点将被隐藏，其位置由TempCate类型的节点代替
/// Table:
/// Input: DocID(挂靠界面模板的目录)
/// Output:
/// Return: EMRservice.entity.EEMRCategoryProperty(挂靠界面模板的目录)
ClassMethod GetEmrCategoryPropertyByDocID(aDocID As %String) As EMRservice.entity.EEMRCategoryProperty
{
	 q:(aDocID = "") ""
	 
	 s objEMRTemplateCategory=##Class(EMRmeta.EMRTemplateCategory).%OpenId(aDocID)
	 s curCategoryType = objEMRTemplateCategory.CategoryType
	 s resultDocID = ##class(EMRservice.BOEMRTemplateCategory).TransCategoryType(curCategoryType)_aDocID
     s objEEMRTemplateCategory = ##Class(EMRservice.entity.EEMRCategoryProperty).%New()
     s objEEMRTemplateCategory.ID = resultDocID
     s objEEMRTemplateCategory.IsLeadframe = objEMRTemplateCategory.IsLeadframe
     s objEEMRTemplateCategory.IsMutex = objEMRTemplateCategory.IsMutex
     s objEEMRTemplateCategory.Name = objEMRTemplateCategory.CategoryName
	 //返回结果
	 q objEEMRTemplateCategory
}

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

}
