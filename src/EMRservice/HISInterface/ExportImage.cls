Class EMRservice.HISInterface.ExportImage Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      Donglulu
/// CreatDate：    2022-12-12
/// Description:   判断目录展现结构下，模板有没有实例化
/// Table：        
/// Input: 	       EpisodeId 就诊rowid
/// 		       TemplateId 界面模板id
///                DocID 目录展现结构id
/// Output         
/// Return：       函数返回值的说明
/// Others：       其它说明
/// w ##Class(EMRservice.HISInterface.ExportImage).IsHasInstance("793592",66,"EMR100007")
ClassMethod IsHasInstance(EpisodeId As %String, DocID As %String, TitleCode As %String) As %String
{
	s result = ""
	q:(EpisodeId="")||(DocID="") result 
	s ChartItemID = DocID
	s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",EpisodeId,ChartItemID,""))
	s:(ECRecordID = "") ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_EpisodeId," "_ChartItemID,""))
    q:(ECRecordID = "") result
    s date = ""
    for
    {
	    s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",date),-1)
	    q:(date = "")
	    s time = ""
	    for
	    {
		    s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",date,time),-1)
		    q:(time = "")
		    s instanceSubId = ""
		    for
		    {
			    s instanceSubId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",date,time,instanceSubId),-1)  
			    q:(instanceSubId = "")
		    	s instanceID = ECRecordID_"||"_instanceSubId
		    	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(instanceID)
	    		q:(objInstance = "")
	    		continue:((TitleCode '= "")&&(TitleCode '= objInstance.TitleCode))
	    		
		    	s result = instanceID
		    	q:(result '= "")
		    }
		    q:(result '= "")
	    }
	    q:(result '= "")	
    }  
      
	q result
}

/// Desc:       返回加载病历相关参数 
/// CreateDate: 2022-12-12
/// Creator:    Donglulu
/// Input:      AInstanceId 实例ID
/// w ##Class(EMRservice.HISInterface.ExportImage).GetLoadRecordParam("4791||93")
ClassMethod GetLoadRecordParam(AInstanceId As %String) As %String
{
	s result = ""
	q:(AInstanceId = "") result
	s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceId)
    q:(objInstanceData = "") result
    s docID = objInstanceData.TheECRecord.ChartItemID
    s:($isobject(docID)) docID = docID.%Id()
    s result = "{"
    s result = result_"""id"":"""_AInstanceId_""""
    s result = result_",""text"":"""_objInstanceData.Title_""""
    s result = result_",""chartItemType"":"""_objInstanceData.TheECRecord.ChartItemType_""""
    s result = result_",""pluginType"":"""_objInstanceData.TheECRecord.DocumentType_""""
    s result = result_",""emrDocId"":"""_docID_""""
    s result = result_"}"
    q result
}

ClassMethod GetRecodeParamByInsID(AInstanceID As %String) As %String
{
	s ret=""
	q:(AInstanceID = "") ret
	
	s InstanceData = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(InstanceData = "") ret
	s ECrecordID = $p(AInstanceID,"||",1)
	q:(ECrecordID = "") ret

	s TemplateID = InstanceData.RealTemplateID
	q:(TemplateID = "") ret
	s TemplateData = ##Class(EMRmeta.Template).%OpenId(TemplateID)
	q:(TemplateData = "") ret
	
	s ECRecordData = ##Class(EMRinstance.ECRecord).%OpenId(ECrecordID)
	q:(ECRecordData = "") ret
	s categoryId = ECRecordData.RealChartItemID
	s chapterdata = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(categoryId)
	q:(chapterdata = "") ret
	s cate = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(chapterdata.ParentCategoryID)
	q:(cate = "") ret

	s ret = "{""id"":"""_AInstanceID_""",""actionType"":""LOAD"",""categoryId"":"""_cate.ParentCategoryID_""","
	s ret = ret_"""chartItemType"":"""_TemplateData.ChartItemType_""",""closable"":true,"
	s ret = ret_"""emrDocId"":"""_categoryId_""",""isLeadframe"":"""_chapterdata.IsLeadframe_""","
	s ret = ret_"""isMutex"":"""_cate.IsMutex_""",""pluginType"":"""_TemplateData.DocumentType_""","
	s ret = ret_"""status"":""NORMAL"",""templateId"":"""_TemplateID_""",""text"":"""_InstanceData.Title_"""}"
	q ret
}

}
