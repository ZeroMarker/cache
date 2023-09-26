Class EMRservice.BL.listdata Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc: 按AEpisodeId取实例数据
/// Input: AEpisodeId
///       AParentId
/// Output:  Json
/// Debug:  	w ##Class(EMRservice.BL.listdata).GetListData("4","441")
ClassMethod GetListData(AParentId As %String, AEpisodeId As %String) As %String
{
	s json = ""
	q:(AEpisodeId = "")||(AParentId = "") json
	s docIds = ..GetDocIdsByParent(AParentId)
	s length = $l(docIds,",")
	for I=1:1:length
	{
		s docId = $p(docIds,",",I)
		s docJson = ..DoInstanceJsonByDocID(docId,AEpisodeId,"Save")
		s:(json '= "")&&(docJson '= "") json = json_","
		s json = json_docJson
	}
	q json
}

/// Desc: 根据目录展现结构取DocID
/// Input: AParentId
/// OutPut:以","分隔的DOCID集合         
/// Debug  d ##Class(EMRservice.BL.listdata).GetDocIdsByParent(3)
ClassMethod GetDocIdsByParent(AParentId As %String) As %String
{
	s docIds = ""
	q:(AParentId = "") docIds
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
				s result = ..GetDocIdsByParent(curCategoryId)
				q:(result = "")
			}
			s:(docIds '= "") docIds = docIds_","
            s docIds = docIds_result
		}
	}
	q docIds
}

/// Desc:根据DocId取实例
/// Input: AParentId
/// 		  AEpisodeId
/// 		  AUniqueKey
/// OutPut: result 1成功，0错误
/// Debug：w ##Class(EMRservice.BL.listdata).DoInstanceJsonByDocID(4,76,"Save")
ClassMethod DoInstanceJsonByDocID(ADocId As %String, AEpisodeId As %String, AStauts As %String) As %String
{
	s $zt = "Error"
	s json = ""
	s count = 0
	q:(ADocId = "")||(AEpisodeId = "")||(AStauts = "") json
	s docId = ADocId
	s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeId," "_docId,""))
	q:(ecrecordId = "") json
	
	s objEcrecod =  ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objEcrecod = "") json
	s docId = objEcrecod.ChartItemID.%Id()
	s chartItemType = objEcrecod.ChartItemType
	s documentType = objEcrecod.DocumentType
	s objEmrTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	q:(objEmrTemplateCategoryDoc = "") json
	s isLeadframe = objEmrTemplateCategoryDoc.IsLeadframe
	s objEmrTemplateCategoryChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objEmrTemplateCategoryDoc.ParentCategoryID)
	q:(objEmrTemplateCategoryChapter = "") json
	s isMutex = objEmrTemplateCategoryChapter.IsMutex
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date,time))	
			q:(time = "")
			s subId = ""
			for
			{
				s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date,time,subId))			
				q:(subId = "")
 				s tempJson = ..GetInstanceJsonByID(ecrecordId,subId)
 				continue:(tempJson = "")
 				s:(count '= 0) json = json_","
				s json = json_tempJson
				s count = count + 1			
			}
		}
	}
	s json = $ZSTRIP(json,"*C")
	q json
Error
	q ""
}

/// Desc: 取实例数据JSon
/// Input: AEcrecordID EMRinstance.ECRecord的ID
///       ASubID EMRinstance.InstanceData的subId
/// Debug: w ##Class(EMRservice.BL.listdata).GetInstanceJsonByID(48,1)
ClassMethod GetInstanceJsonByID(AEcrecordID As %String, ASubID As %String) As %String
{
	s json = ""
	q:((AEcrecordID = "")||(ASubID = "")) json
	s rowId = AEcrecordID_"||"_ASubID
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
	q:(objInstance = "") json
	s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(AEcrecordID)
	q:(objRecord = "") json
	s docId = objRecord.ChartItemID.%Id()
	s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	q:(objCategoryDoc = "") json
	s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
	q:(objChapter = "") json
	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
	s chartItemType = objTemplate.ChartItemType
	s documentType = objTemplate.DocumentType
	//s categoryId = objChapter.ParentCategoryID
	s isLeadframe = objCategoryDoc.IsLeadframe
	s isMutex = objChapter.IsMutex
	s happendate = $zd(objInstance.HappenDate,3)
	s happentime = $zt(objInstance.HappenTime)
	s text = objInstance.Title
	s templateId = objInstance.TemplateID.%Id()
	s notes =  objInstance.Memo	
	s json = json_"{"
	s json = json_"""id"":"""_rowId_""""
	s json = json_",""text"":"""_text_""""
	s json = json_",""createdate"":"""_happendate_""""
	s json = json_",""createtime"":"""_happentime_""""
	s json = json_",""content"":"""_notes_""""
	s json = json_",""documentType"":"""_documentType_""""
	s json = json_",""chartItemType"":"""_chartItemType_""""
	s json = json_",""emrDocId"":"""_docId_""""
	s json = json_",""templateId"":"""_templateId_""""
	s json = json_",""isLeadframe"":"""_isLeadframe_"""" 
	s json = json_",""isMutex"":"""_isMutex_""""
	s json = json_"}"
	k objInstance,objRecord,objCategoryDoc,objChapter,objTemplate
	q json
}

}
