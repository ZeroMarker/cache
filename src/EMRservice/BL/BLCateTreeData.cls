/// 名称:EMRservice.BLL.CateTreeData
/// 描述:目录展现结构信息服务
/// 编写者：Guozongtao
/// 编写日期: 2014-01-06
Class EMRservice.BL.BLCateTreeData Extends %RegisteredObject
{

/// Desc:       病历目录
/// Modify:     Candyxu
/// DateTime:   2014-5-5
/// Input:      AparentID,AepisodeID,AworkGroupID
/// OutPut:     json             
/// d ##Class(EMRservice.BL.BLCateTreeData).GetCategory("0","76","100")
ClassMethod GetCategory(AparentID As %String, AepisodeID As %String, AworkGroupID As %String) As %String
{
	s json = "",count = 0
	q:(AepisodeID = "")||(AworkGroupID = "") "[]"
	s isPrivActive = ..CheckCatePrivActivity()           //是否启用目录查看权限
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AparentID,seq))
		q:(seq = "")
		s curCategoryId = ""
		for
		{
			s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AparentID,seq,curCategoryId))
			q:(curCategoryId = "")
			s ssGroupRuleRowID = $o(^DHCEMRM.DocRes.CatalogSSGroupI("IdxCatalogSSGroup"," "_curCategoryId," "_AworkGroupID, 0))
			continue:((isPrivActive = "Y")&&(ssGroupRuleRowID = ""))
			s objEMRTemplateCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
			s curCategoryName = objEMRTemplateCategory.CategoryName
			s curCategoryType = objEMRTemplateCategory.CategoryType
			s:(count '= 0) json = json_","
			s json = json_"{"
			s json = json_"'id':'"_curCategoryId_"'"
			s json = json_",'text':'"_curCategoryName_"'" 
			s json = json_ ",'attributes':{" 
			s json = json_ "'image':'../scripts/emr/image/icon/"_curCategoryName_".png'" 
			s json = json_ ",'type':'Category'" 
			s json = json_ "}"
			s json = json_ ",'isParent':'"_"true"_"'"
			s json = json_ "}"
            s count = count + 1
		}
	}
	q json
}

/// Desc:       病历模板目录
/// Modify:     Candyxu
/// DateTime:   2014-5-5
/// Input:      AparentID:目录Id
///             AepisodeID:就诊号
/// OutPut:     json    
/// d ##Class(EMRservice.BL.BLCateTreeData).GetTempCate(1,76)
ClassMethod GetTempCate(AparentId As %String, AepisodeID As %String) As %String
{
	s json = "",count = 0
	q:((AparentId = "")||(AepisodeID = "")) "[]"
	s priActivity = ..CheckTPrivActivity()  //权限控制
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AepisodeID)
	s flag = ""
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AparentId,seq))
		q:(seq = "")
		s curCategoryId = ""
		for
		{
			s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AparentId,seq,curCategoryId))
			q:(curCategoryId = "")
			s objEMRTemplateCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
			continue:(objEMRTemplateCategory.CategoryType '= "CategoryChapter")
	        s curCategoryName = objEMRTemplateCategory.CategoryName
	        s curIsMutex = objEMRTemplateCategory.IsMutex
	        s objEMRTemplateCategory = "" k objEMRTemplateCategory
			//初始化CategoryChapter节点时，不直接初始化CategoryChapter节点，而是直接初始化其下级中适用的挂靠界面模板的节点
			//即文档中说明的隐藏第二层
			s curObjDocCategory = ..GetDocIDInChapter(AepisodeID,"",curCategoryId,priActivity,curPatInfo)
			continue:(curObjDocCategory = "")
			s curEMRTemplategoryID = $e(curObjDocCategory.ID,3,$l(curObjDocCategory.ID))  // CategoryType="TempCate"	
			continue:(curEMRTemplategoryID = "")
			s curIsLeadframe = curObjDocCategory.IsLeadframe
	        s curObjDocCategory = ""  k curObjDocCategory
	        s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(curEMRTemplategoryID)
		    continue:(objTemplate = "")
		    s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AepisodeID, objTemplate.ID,curEMRTemplategoryID)
			if ((result '= 0) && (objTemplate.ChartItemType = "Single"))
			{
				if (curIsMutex = 1) 
				{
					s flag = 1,json = ""
					q
				}
			 continue	
			}else
			{
				d SetJson
			}
		}
		q:(flag = 1)
	}
    q json
SetJson	
	s:(count '= 0) json = json_","
	s json = json_"{"
	s json = json_ "'id':'"_curEMRTemplategoryID_"'"
	s json = json_ ",'text':'"_curCategoryName_"'"
	s json = json_ ",'attributes':{" 
	s json = json_ "'type':'TempCate'" 
	s json = json_ ",'chartItemType':'"_objTemplate.ChartItemType_"'" 
	s json = json_ ",'documentType':'"_objTemplate.DocumentType_"'" 
	s json = json_ ",'isLeadframe':'"_curIsLeadframe_"'"
	s json = json_ ",'isMutex':'"_curIsMutex_"'"
	s json = json_ "}"
	s json = json_ ",'isParent':'false'"
	s json = json_ "}"
	s count = count + 1 
	q
}

/// Desc:       病历实例数据
/// Modify:     Candyxu
/// DateTime:   2014-5-5
/// Input:      AparentID:目录Id
///             AepisodeID:就诊号
/// OutPut:     json  
/// w ##Class(EMRservice.BL.BLCateTreeData).GetInstance("107","76")
ClassMethod GetInstance(AParentId As %String, AEpisodeId As %String) As %String
{
	s json = ""
	s docIds = ..GetDocIds(AParentId,AEpisodeId)	
	q:(docIds = "") json
	s liDocIds = ##Class(EMRservice.Tools.Tool).GetListFromString(docIds,",")
    for i=1:1:$listlength(liDocIds)
    {
	    s curCategoryId = $listget(liDocIds,i)
	    continue:(curCategoryId = "")
		s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeId," "_curCategoryId,""))
		continue:(ecrecordId = "")
		s objCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
	    s IsLeadframe = objCategory.IsLeadframe
	    s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(curCategoryId)
		s chartItemType = objTemplate.ChartItemType
		s documentType = objTemplate.DocumentType
		s parentId = objCategory.ParentCategoryID
		s objParent = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(parentId)
		continue:(objParent = "")
		s curisMutex = objParent.IsMutex
		k objParent,objCategory
		s reader = ..GetDirectoryData(ecrecordId)
		s cjson = ""
		While reader.Next(.obj,.sc) 
		{
			s count = obj.InstanceIndex.Count()
			for j=1:1:count 
			{
				s InstanceDataID = obj.InstanceIndex.GetAt(j).ID
				s Notes = $REPLACE(obj.InstanceIndex.GetAt(j).Notes,":"_$c(10),":")
				s Notes = $REPLACE(Notes,$c(10),",")
				s pages = (+obj.InstanceIndex.GetAt(j).EndPageNum)
				s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceDataID)
			    continue:(objInstance = "")
				s happenDateTime = ""
				s:((objInstance.HappenDate '= "") && ($zcvt(objInstance.Status,"U") = "SAVE")) happenDateTime = $zd(objInstance.HappenDate,3)_" "_$zt(objInstance.HappenTime)
				s:(cjson '= "") cjson = cjson_","
				s cjson = cjson_"{"
				s cjson = cjson_"'id':'"_InstanceDataID_"'"
				s cjson = cjson_",'text':'"_objInstance.Title_"'"
				s cjson = cjson_",'attributes':{" 
				s cjson = cjson_"'chartItemType':'"_chartItemType_"'" 
				s cjson = cjson_",'documentType':'"_documentType_"'" 
				s cjson = cjson_",'emrDocId':'"_curCategoryId_"'"
				s cjson = cjson_",'isLeadframe':'"_IsLeadframe_"'" 
				s cjson = cjson_",'isMutex':'"_curisMutex_"'" 
				s cjson = cjson_",'happendatetime':'"_happenDateTime_"'"
				s cjson = cjson_",'summary':'"_Notes_"'"
				s cjson = cjson_",'pages':'共"_pages_"页'"
				s cjson = cjson_"}"
				s cjson = cjson_"}"
			}
		}
		s json = json_cjson
		s:(cjson '= "") json = json_","
	}
	s json = $e(json,1,$l(json)-1)
	q json
}

/// Desc:       根据目录展现结构DocID取目录索引数据
/// Creator：   Candy
/// CreateDate: 2014-4-8
/// Input:      AParentId 目录展现结构ID,取所有的为0
///             AEpisodeId 就诊ID
/// OutPut:     InstanceDataID 实例数据ID
///             name 标题
///             happendatetime 发生时间
///             summery 摘要
///             pages 页数  
/// Debug       d ##Class(EMRservice.BL.BLCateTreeData).GetSummeryByCategory(0,76)
ClassMethod GetSummeryByCategory(AParentId As %String, AEpisodeId As %String) As %String
{
	s json = ""
    s docIds = ..GetDocIds(AParentId,AEpisodeId)
    s liDocIds = ##Class(EMRservice.Tools.Tool).GetListFromString(docIds,",")
    for i=1:1:$listlength(liDocIds)
    {
	    s curCategoryId = $listget(liDocIds,i)
	    continue:(curCategoryId = "")
		s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeId," "_curCategoryId,""))
		continue:(ecrecordId = "")
		s reader = ..GetDirectoryData(ecrecordId)
		s cjson = ""
		While reader.Next(.obj,.sc) 
		{
			s count = obj.InstanceIndex.Count()
			s InstanceDataID = obj.InstanceIndex.GetAt(count).ID
			s Notes = $REPLACE(obj.InstanceIndex.GetAt(count).Notes,":"_$c(10),":")
			s Notes = $REPLACE(Notes,$c(10),",")
			s pages = (+obj.InstanceIndex.GetAt(count).EndPageNum)
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceDataID)
		    continue:(objInstance = "")
			s happenDateTime = ""
			s:((objInstance.HappenDate '= "") && ($zcvt(objInstance.Status,"U") = "SAVE")) happenDateTime = $zd(objInstance.HappenDate,3)_" "_$zt(objInstance.HappenTime)
			s cjson = cjson_"{"
			s cjson = cjson_"""id"":"""_InstanceDataID_""""
			s cjson = cjson_",""name"":"""_objInstance.Title_""""
			s cjson = cjson_",""happendatetime"":"""_happenDateTime_""""
			s cjson = cjson_",""summery"":"""_Notes_""""
			s cjson = cjson_",""pages"":""共"_pages_"页"""
			s cjson = cjson_"}"
		}
		s json = json_cjson
		s:(cjson '= "") json = json_","
	}
	s json = $e(json,1,$l(json)-1)
	q json
}

/// d ##Class(EMRservice.BL.BLCateTreeData).GetRecordTree(0,76,"1||1")
ClassMethod GetRecordTree(AParentId As %String, AEpisodeId As %String, AInstanceId As %String) As %String
{
	s json = ""
    s docIds = ..GetDocIds(AParentId,AEpisodeId)
    s liDocIds = ##Class(EMRservice.Tools.Tool).GetListFromString(docIds,",")
    s count = 0
    for i=1:1:$listlength(liDocIds)
    {
	    s curCategoryId = $listget(liDocIds,i)
	    continue:(curCategoryId = "")
		s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeId," "_curCategoryId,""))
		continue:((ecrecordId = ""))
		continue:(($d(^DHCEMRI.DirectoryInformationI("IdxECRecordID"," "_ecrecordId))<=0)&&(AInstanceId '="")&&($p(AInstanceId,"||",1)'=ecrecordId))
		s objDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
		continue:(objDoc = "")
		s isLeadframe = objDoc.IsLeadframe
		s parentId = objDoc.ParentCategoryID
		s objCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(parentId)
		continue:(objCategory = "")
		s isMutex = objCategory.IsMutex
		s emrTemplateId = $o(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_curCategoryId,""))
		continue:(emrTemplateId = "")
		s objEmrtemplate = ##Class(EMRmeta.EMRTemplate).%OpenId(emrTemplateId)
		continue:(objEmrtemplate = "")
		s objTemplate = ##Class(EMRmeta.Template).%OpenId(objEmrtemplate.BindTemplateID)
		continue:(objTemplate = "")
		s chartItemType = objTemplate.ChartItemType
		s documentType = objTemplate.DocumentType
		s result = ..GetInstanceInfo(ecrecordId,AInstanceId,chartItemType,documentType,curCategoryId,isLeadframe,isMutex)
		if (chartItemType = "Multiple")
		{
			s:((json '="")) json = json_","
			s json = json_"{"
			s json = json_"'id':"_"'"_curCategoryId_"'"
			s json = json_",'text':"_"'"_objDoc.CategoryName_"'"
			s json = json_",'state':'open'"
			s json = json_",'children':"_"["_result_"]"
			s json = json_"}"
		}
		else
		{
			s:((json '="") && (result '= "")) json = json_","
			s json = json_result
		}
    }
    q json
}

ClassMethod GetInstanceInfo(AEcrecordId, AInstanceId, AChartItemType, ADocumentType, AEmrDocId, AIsLeadframe, AIsMutex) As %String
{
	s json = ""
	q:(AEcrecordId = "") json
	s count = 0
	s listNo = ""
	for
	{
		s listNo = $o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",AEcrecordId,listNo))
		q:(listNo = "")
		s subId = ""
		for
		{
			s subId = $o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",AEcrecordId,listNo,subId))
			q:(subId = "")
			s rowId = AEcrecordId_"||"_subId
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
			continue:(objInstance = "")
			continue:((objInstance.Status = "UnSave")&&(AInstanceId = ""))
			s text = objInstance.Title
			s happenDateTime = ""
			s:(objInstance.HappenDate '= "") happenDateTime = $zd(objInstance.HappenDate,3)_" "_$zt(objInstance.HappenTime)
			s:(count '= 0) json = json_","
			s json = json_"{"
			s json = json_"'id':'"_rowId_"'"
			s json = json_",'text':'"_text_" "_happenDateTime_"'"
			s json = json_",'attributes':{" 
			s json = json_"'chartItemType':'"_AChartItemType_"'" 
			s json = json_",'documentType':'"_ADocumentType_"'" 
			s json = json_",'emrDocId':'"_AEmrDocId_"'"
			s json = json_",'isLeadframe':'"_AIsLeadframe_"'" 
			s json = json_",'isMutex':'"_AIsMutex_"'" 
			s json = json_"}"
			s json = json_"}"
			s count = count + 1
		}
	}
	q json
}

/// Creator: guozongtao
/// CreatDate: 2014-1-7
/// Description：系统参数是否设置为开启目录查看权限
/// Table:
/// Input:
/// Output:
/// Return:是否开启  Y--是  N--否
ClassMethod CheckCatePrivActivity() As %String
{
	s ReturnValue = "N"
	s ReturnValue = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("CPrivActivity") 
	if ReturnValue '= "Y"
	{
		s ReturnValue = "N"
	}
	q ReturnValue
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
ClassMethod GetDocIDInChapter(EpisodeID As %String, parOthers As %String, parCategoryID As %String, parPriActivity As %String, parPatInfo As %Library.List) As EMRservice.entity.EEMRCategoryProperty
{
	 s resultDocID = ""
	 
	 s resultDocID = ##class(EMRservice.DocRestLogic.PrivLogic).GetDocIDForView(EpisodeID, parOthers, parCategoryID, parPriActivity, parPatInfo)
	 q:(resultDocID = "") ""
	 
	 s objEMRTemplateCategory=##Class(EMRmeta.EMRTemplateCategory).%OpenId(resultDocID)
	 s curCategoryType = objEMRTemplateCategory.CategoryType
	 s resultDocID = ##class(EMRservice.BOEMRTemplateCategory).TransCategoryType(curCategoryType)_resultDocID
     s objEEMRTemplateCategory = ##Class(EMRservice.entity.EEMRCategoryProperty).%New()
     s objEEMRTemplateCategory.ID = resultDocID
     s objEEMRTemplateCategory.IsLeadframe = objEMRTemplateCategory.IsLeadframe
     s objEEMRTemplateCategory.IsMutex = objEMRTemplateCategory.IsMutex
     s objEEMRTemplateCategory.Name = objEMRTemplateCategory.CategoryName
	 //返回结果
	 q objEEMRTemplateCategory
}

/// Desc:       根据目录展现结构取DocID
/// Creator：   Candy
/// CreateDate: 2014-4-8
/// Input:      AParentId 目录展现结构ID,取所有的为0
///             AEpisodeId 就诊ID
/// OutPut:     以","分隔的DOCID集合         
/// Debug d ##Class(EMRservice.BL.BLCateTreeData).GetDocIds(0,76)
ClassMethod GetDocIds(AParentId As %String, AEpisodeId As %String) As %String
{
	s docIds = ""
	q:(AParentId = "")||(AEpisodeId = "") docIds
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq))
		q:(seq = "")
		s curCategoryId	= ""
		for
		{
			s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq,curCategoryId))
			q:(curCategoryId = "")
			s objCatergory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
			continue:(objCatergory = "")
			s result = curCategoryId
			if (objCatergory.CategoryType '= "TempCate")
			{
				s result = ..GetDocIds(curCategoryId,AEpisodeId)
				q:(result = "")
			}
			s:(docIds '= "") docIds = docIds_","
            s docIds = docIds_result
		}
	}
	q docIds
}

/// Desc      取索引结构化数据
/// Creator:  Candyxu
/// DateTime: 2014-4-8
/// Input:    AEcrecordID 实例数据父表ID
/// OutPut:   索引结构化数据  
ClassMethod GetDirectoryData(AEcrecordID As %String) As %XML.Reader
{
	s reader = ##class(%XML.Reader).%New()
	q:(AEcrecordID = "") reader
	s rowID = $o(^DHCEMRI.DirectoryInformationI("IdxECRecordID"," "_AEcrecordID,""))
	q:(rowID = "") reader
	s objDocIndex = ##Class(EMRinstance.DirectoryInformation).%OpenId(rowID)
	q:(objDocIndex = "") reader
	s stream = ##Class(%GlobalBinaryStream).%New()
	d stream.CopyFrom(objDocIndex.DirInfoData)
	s sc=reader.OpenStream(stream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit  
	d reader.Correlate("NInstanceIndex","EMRservice.entity.ENInstanceIndex")
	q reader
}

}
