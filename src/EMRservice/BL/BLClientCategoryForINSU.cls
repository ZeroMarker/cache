/// Desc:       医保办加载病历目录类
/// Cteator:    Candy
/// CreateDate: 2016-11-16
Class EMRservice.BL.BLClientCategoryForINSU Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc: 返回病历创建或打开目录列表
/// Input:AEpisodeID 就诊ID 
///      ADocInfo 目录信息
/// Debug:w ##Class(EMRservice.BL.BLClientCategoryForINSU).GetCategoryList(76,"53^68")
ClassMethod GetCategoryList(AEpisodeID As %String, ADocInfo As %String) As %String
{
	s result = ""
	s saveJson = ""
	s unsaveJson = ""
	q:((AEpisodeID = "")||(ADocInfo = "")) result
	s length = $l(ADocInfo,"^")
	for i=1:1:length
	{
		s tempDocInfo = $p(ADocInfo,"^",i)
		s tempDocId = $p(tempDocInfo,"|",1)
		s tempTitleCode = $p(tempDocInfo,"|",2)
		s status = ##Class(EMRservice.BL.BLInstanceData).GetDocumentStatus(AEpisodeID,tempDocId,tempTitleCode)
		if (status = "UnSave")
		{
			s:(unsaveJson '= "") unsaveJson = unsaveJson_","
			s unsaveJson = unsaveJson_##Class(EMRservice.BL.BLClientCategory).GetINSUTempCateByDocID(tempDocId,AEpisodeID)
		}
		else
		{
			s instanceId = $p(status,"^",2)
			s ecrecordId = $p(instanceId,"||",1)
			s subId = $p(instanceId,"||",2) 
			s:(saveJson '= "") saveJson = saveJson_","
			s saveJson = saveJson_ ##Class(EMRservice.BL.BLClientCategory).GetInstanceJsonByID(ecrecordId,subId)
		}
	}
	s result ="{""UnSaved"":["_unsaveJson_"],""Saved"":["_saveJson_"]}"
	q result
}

ClassMethod SortingDocInfo(ADocInfo As %String) As %ArrayOfDataTypes
{
	s docIdList = ##Class(%ArrayOfDataTypes).%New()
	q:(ADocInfo = "") docIdList
	s length = $l(ADocInfo,"^")
	for i=1:1:length
	{
		s tempDocInfo = $p(ADocInfo,"^",i)
		s tempDocId = $p(tempDocInfo,"|",1)
		s tempTitleCode = $p(tempDocInfo,"|",2)
        s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(tempDocId)		
		continue:(objCategoryDoc = "") 
		s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
		continue:(objChapter = "")
		s value = docIdList.GetAt(objChapter.ParentCategoryID)
		d docIdList.SetAt(value_"^"_tempDocId,objChapter.ParentCategoryID)
	}
	q docIdList
}

}
