Class EMRservice.Ajax.category Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s $zt = "ErrorHandler"
	s action = $Get(%request.Data("Action",1),"")
	s userLocId = $Get(%request.Data("CTLocID",1),"")
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	s parentId = $Get(%request.Data("ParentID",1),"")
	s userId = $Get(%request.Data("UserID",1),"")
	s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(episodeId)
	s schemType = $case(disDateTime,"":"Running",:"Archiving")
	if (action = "GetCategoryJson")
	{
		s result = ##Class(EMRservice.BL.BLClientCategory).GetCategoryJson(userLocId,schemType)
		w "["_result_"]"
	}
	elseif(action = "GetTempCateByCategoryID")  //某病历展现结构下可写模板
	{
		s result = ##Class(EMRservice.BL.BLClientCategory).GetTempCateJsonByCategoryID(parentId,episodeId,userId)
		w "["_result_"]"
	}
	elseif(action = "GetInstanceByCategoryID")  //某病历展现结构下实例
	{
		s result = ##Class(EMRservice.BL.BLClientCategory).GetInstanceJsonByCategoryID(parentId,episodeId)
		w "["_result_"]"
	} 
	elseif(action = "GetTempCate")  //全部可写模板
	{
		s result = ##Class(EMRservice.BL.BLClientCategory).GetTempCateJson(userLocId,schemType,episodeId,userId)
		w "["_result_"]"
	}
	elseif(action = "GetInstance")  //全部实例
	{
		s result = ##Class(EMRservice.BL.BLClientCategory).GetRecordCatalogByHappenDate(episodeId,"save")
		w "["_result_"]"
	}
	elseif(action = "IsExitInstance")   
	{
		s docId  = $Get(%request.Data("emrDocId",1),"")
		s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
		if (objTemplate '= "")
		{
			s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(episodeId,objTemplate.ID,docId)
		}
		else
		{
			s result = "0"
		}
		w result
	}
	elseif(action = "GetDeleteInstance") //删除的病历
	{
		s result = ##Class(EMRservice.BL.BLClientCategory).GetRecordCatalogByHappenDate(episodeId,"delete")
		w "["_result_"]"
	}
	elseif(action = "GetReferenceCategory")
	{
		s result = ##Class(EMRservice.BL.BLClientCategory).GetReferenceJson(userLocId,schemType,episodeId)
		w "["_result_"]"	
	}
	elseif(action = "SetMemo")
	{
		s instanceId  = $Get(%request.Data("InstanceID",1),"")
		s memoText  = $Get(%request.Data("MemoText",1),"")
		s result = ##Class(EMRservice.BL.BLInstanceData).SetDocumentMemo(instanceId,memoText)
		w result
	}
	elseif(action = "GetTitleByDocID")
	{
		s docId = $Get(%request.Data("DocID",1),"")
		s result = ..GetTitleByDocID(docId)
		w "["_result_"]"
	}
	Quit $$$OK
ErrorHandler
	q "[]"
}

/// Desc:       按DocID取标题信息
/// Creator:    Candy
/// CreateDate: 2015-4-15
/// Input:      ADocId 目录展现结构挂模板一层的目录ID
/// Output:     json 标题信息Json  
/// Debug:      w ##Class(EMRservice.Ajax.category).GetTitleByDocID(616)
ClassMethod GetTitleByDocID(ADocId As %String) As %String
{
	s json = ""
	s count = 0
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLTitleConfig:GetTitleByDocID")
	d ds.Execute(ADocId)
	While (ds.Next())
	{
		s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""TitleCode"":"""_ds.Data("ACode")_""""
		s json = json_",""TitleDesc"":"""_ds.Data("ADesc")_"""" 
		s json = json_"}"
		s count = count + 1
	}
	q json
}

}
