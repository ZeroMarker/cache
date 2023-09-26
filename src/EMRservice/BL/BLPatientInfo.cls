Class EMRservice.BL.BLPatientInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##Class(EMRservice.BL.BLPatientInfo).test()
ClassMethod test()
{
	s objEMRTemplateCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(121)
	s objEMRTemplateCategory.IsMutex=0
	d objEMRTemplateCategory.%Save()
}

/// 获取门诊病历信息 todo
/// W ##Class(EMRservice.BL.BLPatientInfo).GetEMRRecordOP("251","Running","9857645","2079")
ClassMethod GetEMRRecordOP(ACTLocId, ASchemType, AEpisodeID, AUserID As %String) As %String
{
	s ret=..getFirstInstance(AEpisodeID)
	q:(ret'="") ret
	
	q ..GetFirstTmpl(ACTLocId, ASchemType, AEpisodeID, AUserID)
	
	/*
	q ""
	s ecRecordID=""
 	s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_adm," 118", ecRecordID))
 	w ecRecordID,!
 	q:(ecRecordID="") ..newEMRRecordOP()
 	
 	s insID = $O(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecRecordID," 33"," SAVE", ""),-1)
	q:(insID="") ..newEMRRecordOP()
	
	s ret="{""id"":"""_ecRecordID_"||"_insID_""","
	s ret=ret_"""actionType"":""LOAD"","
	s ret=ret_"""categoryId"":""11"","
	s ret=ret_"""chartItemType"":""Single"","
	s ret=ret_"""closable"":true,"
	s ret=ret_"""emrDocId"":""118"","
	s ret=ret_"""isLeadframe"":""0"","
	s ret=ret_"""isMutex"":""0"","
	s ret=ret_"""pluginType"":""DOC"","
	s ret=ret_"""status"":""NORMAL"","
	s ret=ret_"""templateId"":""33"","
	s ret=ret_"""text"":""门诊病历""}"		
	q ret
	*/
}

/*
ClassMethod newEMRRecordOP() As %String
{
	s ret="{""id"":"""","
	s ret=ret_"""actionType"":""CREATE"","
	s ret=ret_"""categoryId"":""11"","
	s ret=ret_"""chartItemType"":""Single"","
	s ret=ret_"""closable"":true,"
	s ret=ret_"""emrDocId"":""118"","
	s ret=ret_"""isLeadframe"":""0"","
	s ret=ret_"""isMutex"":""0"","
	s ret=ret_"""pluginType"":""DOC"","
	s ret=ret_"""status"":""NORMAL"","
	s ret=ret_"""templateId"":""33"","
	s ret=ret_"""text"":""门诊病历""}"		
	q ret
}

*/
/// w ##Class(EMRservice.BL.BLPatientInfo).getFirstInstance("11411")
ClassMethod getFirstInstance(adm As %String) As %String
{
	s ret=""
	s CategoryID = ""
	for {
		s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",adm, CategoryID))
		q:(CategoryID="")
		
		s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",adm, CategoryID, ""))
		
		s id = "" 
		for {
			s id = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID",CategoryID, id))
			q:(id="")
			
			s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(id)
			s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)
			s ecID = $tr(ecRecordID," ","")
		 
			s insID = $O(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecID,emrTmpl.BindTemplateID," SAVE", ""),-1)
		 	q:(""=insID)
			s ret="{""id"":"""_ecID_"||"_insID_""","
			s ret=ret_"""actionType"":""LOAD"","
			s ret=ret_"""categoryId"":""11"","
			s ret=ret_"""chartItemType"":"""_tmpl.ChartItemType_""","
			s ret=ret_"""closable"":true,"
			s ret=ret_"""emrDocId"":"""_emrTmpl.CategoryID_""","
			s ret=ret_"""isLeadframe"":""0"","
			s ret=ret_"""isMutex"":""0"","
			s ret=ret_"""pluginType"":"""_tmpl.DocumentType_""","
			s ret=ret_"""status"":""NORMAL"","
			s ret=ret_"""templateId"":"""_emrTmpl.BindTemplateID_""","
			s ret=ret_"""text"":"""_tmpl.Name_"""}"
			q
		}	 	
	}
	
	q ret
}

/// w ##Class(EMRservice.BL.BLPatientInfo).GetFirstTmpl("251","Running","9857645","2079")
ClassMethod GetFirstTmpl(ACTLocId, ASchemType, AEpisodeID, AUserID As %String) As %String
{
	s json = "",count = 0
	q:(ACTLocId = "")||(ASchemType = "")||(AEpisodeID = "")||(AUserID = "") json
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(ACTLocId,ASchemType)
	while result.%Next()
	{
		s ItemType = result.Data("ItemType")
		continue:(ItemType = "HIS")
		s categoryId = result.Data("ItemCategoryID")
		s cjson = ..GetTempCateJsonByCategoryID(categoryId,AEpisodeID,AUserID)
 	
		continue:(cjson = "")
		s json=cjson
		q:(cjson'="")
		/*
		s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""id"":"""_categoryId_""""
		s json = json_",""text"":"""_result.Data("ItemTitle")_""""
		s json = json_",""childs"":["_cjson_"]"
		s json = json_"}" 
		s count = count + 1
		*/
	}
	s json = $ZSTRIP(json,"*C")
	q json
}

ClassMethod GetTempCateJsonByCategoryID(ACTLocId As %String, AEpisodeID As %String, AUserID As %String) As %String
{
	s quitFlag = 0
	s json = "",count = 0,flag = 0
	s jsonList = ##Class(%ListOfDataTypes).%New()
	q:((ACTLocId = "")||(AEpisodeID = "")) ""
	s priActivity = ##Class(EMRservice.BL.BLClientCategory).CheckTPrivActivity()  //权限控制
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)
	 
	s patDept = $p($li(curPatInfo,2),$c(2),2)
	s flag = ""
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_ACTLocId,seq))
		q:(seq = "")
		s curCategoryId = ""
		for
		{
			s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_ACTLocId,seq,curCategoryId))
			q:(curCategoryId = "")
			s objEMRTemplateCategory =##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
			continue:(objEMRTemplateCategory.CategoryType '= "CategoryChapter")
	        s curCategoryName = objEMRTemplateCategory.CategoryName
	        s curIsMutex = objEMRTemplateCategory.IsMutex
	        s:(curIsMutex '= 1) curIsMutex = 0
	        continue:((flag = 1)&&(curIsMutex = 1))
	       
	        s objEMRTemplateCategory = "" k objEMRTemplateCategory
			//初始化CategoryChapter节点时，不直接初始化CategoryChapter节点，而是直接初始化其下级中适用的挂靠界面模板的节点
			//即文档中说明的隐藏第二层
			//s curObjDocCategory = ##Class(EMRservice.BL.BLClientCategory).GetDocIDInChapter(AEpisodeID,"",curCategoryId,priActivity,curPatInfo)
			//continue:(curObjDocCategory = "")
			s curDocIDS = ##Class(EMRservice.BL.BLClientCategory).GetDocIDInChapter(AEpisodeID,"",curCategoryId,priActivity,curPatInfo)
			continue:(curDocIDS = "")
			for i=1:1:$l(curDocIDS,"^")
			{
				s strDocID = $p(curDocIDS,"^",i)
				//根据DOCID获取属性对象
				s curObjDocCategory = ##Class(EMRservice.BL.BLClientCategory).GetEmrCategoryPropertyByDocID(strDocID)
			    continue:(curObjDocCategory="")
				s curEMRTemplategoryID = $e(curObjDocCategory.ID,3,$l(curObjDocCategory.ID))  // CategoryType="TempCate"	
				continue:(curEMRTemplategoryID = "")
			
				s curIsLeadframe = curObjDocCategory.IsLeadframe
		        s curObjDocCategory = ""  k curObjDocCategory
		        s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(curEMRTemplategoryID)
			    continue:(objTemplate = "")
		
			    s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(AEpisodeID, objTemplate.ID,curEMRTemplategoryID)
				
				if ((result '= 0) && (objTemplate.ChartItemType = "Single"))
				{
					s:(curIsMutex = 1) flag = 1
					continue
				}
			
				s quotationFlag = $d(^DHCEMRM.QuotationSchemeI("IdxCTLocIDDocID",patDept,curEMRTemplategoryID))
				s cjson = "{"
				s cjson = cjson_ """emrDocId"":"""_curEMRTemplategoryID_""""
				s cjson = cjson_ ",""text"":"""_curCategoryName_""""
				s cjson = cjson_ ",""actionType"":""CREATE"""
				s cjson = cjson_ ",""type"":""TempCate""" 
				s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
				s cjson = cjson_ ",""pluginType"":"""_objTemplate.DocumentType_"""" 
				s cjson = cjson_ ",""isLeadframe"":"""_curIsLeadframe_""""
				s cjson = cjson_ ",""isMutex"":"""_curIsMutex_""""
				s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
				s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
				s cjson = cjson_ "}"
		
			 
				d jsonList.Insert(curIsMutex_"^"_cjson)
				s quitFlag=1
				q
			}
			q:(quitFlag=1)
		}
		q:(quitFlag=1)
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

/// w ##Class(EMRservice.BL.BLPatientInfo).getSavedRecord("11411")
ClassMethod getSavedRecord(adm As %String) As %String
{
	s idx=0
	s result=""
	s CategoryID = ""
	for {
		s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",adm, CategoryID))
		q:(CategoryID="")
		
		s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",adm, CategoryID, ""))
		
		s id = "" 
		for {
			s id = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID",CategoryID, id))
			q:(id="")
			
			s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(id)
			s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)
			//b
			s ecID = $tr(ecRecordID," ","")
		 
			s insID = $O(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecID,emrTmpl.BindTemplateID," SAVE", ""),-1)
		 	q:(""=insID)
			s ret="{""idx"":"_idx_",""id"":"""_ecID_"||"_insID_""","
			s ret=ret_"""actionType"":""LOAD"","
			s ret=ret_"""categoryId"":""11"","
			s ret=ret_"""chartItemType"":"""_tmpl.ChartItemType_""","
			s ret=ret_"""closable"":true,"
			s ret=ret_"""emrDocId"":"""_emrTmpl.CategoryID_""","
			s ret=ret_"""isLeadframe"":""0"","
			s ret=ret_"""isMutex"":""0"","
			s ret=ret_"""pluginType"":"""_tmpl.DocumentType_""","
			s ret=ret_"""status"":""NORMAL"","
			s ret=ret_"""templateId"":"""_emrTmpl.BindTemplateID_""","
			s ret=ret_"""text"":"""_tmpl.Name_"""}"

			if (result="") { s result = ret }
			else { s result = result_","_ret }
			s idx=idx+1	
		}	 	
	}
	
	q "["_result_"]"
}

Storage Default
{
<Data name="BLPatientInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EMRservice.BL.BLPatientInfoD</DataLocation>
<DefaultData>BLPatientInfoDefaultData</DefaultData>
<IdLocation>^EMRservice.BL.BLPatientInfoD</IdLocation>
<IndexLocation>^EMRservice.BL.BLPatientInfoI</IndexLocation>
<StreamLocation>^EMRservice.BL.BLPatientInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
