Class DHCEPRFS.web.eprajax.AjaxConfigMRViewItem Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod %OnPreHTTP() As %Boolean
{
	#dim %response As %CSP.Response
    Do %response.SetHeader("Content-Type","application/json;charset=utf-8")
    Quit 1
}

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"")
	s mrItemID =$Get(%request.Data("MRItemID",1),"")
	s description =$Get(%request.Data("Description",1),"")
	s parentCode =$Get(%request.Data("ParentCode",1),"")
	s id = $g(%request.Data("ID",1),"")
	s code = $g(%request.Data("Code",1),"")
	s sequence = $g(%request.Data("Sequence",1),"")
	s name = $g(%request.Data("Name",1),"")
	s episodeID = $g(%request.Data("EpisodeID",1),"")
	s dataserviceurl = $g(%request.Data("DataServiceUrl",1),"")
	
	if (action="mrViewCategorylist")
	{
		d ..GetMRViewCategoryList()
	}
	elseif (action="mrViewSubCategorylist")
	{
		d ..GetMRViewSubCategoryList(parentCode)
	}
	elseif (action="mrViewItemlist")
	{
		d ..GetMRViewItemList(parentCode)
	}
	elseif (action="AddCategory")
	{
		d ..AddOrUpdateMRViewCategory(id,code,name,description,sequence)
	}
	elseif (action="DelCategory")
	{
		d ..DelMRViewCategory(id)
	}
	elseif (action="AddSubCategory")
	{
		d ..AddOrUpdateMRViewSubCategory(id,parentCode,code,name,description,sequence)
	}
	elseif (action="DelSubCategory")
	{
		d ..DelMRViewSubCategory(id)
	}
	elseif (action="AddMRItem")
	{
		d ..AddOrUpdateMRViewItem(id,parentCode,name,mrItemID,sequence)
	}
	elseif (action="DelMRItem")
	{
		d ..DelMRViewMRItem(id)
	}
	elseif (action="CategoryTree")
	{
		d ..GetCategoryTree()
	}
	elseif (action="mrItemlist")
	{
		d ..GetMRItemList(parentCode)
	}
	elseif (action="SimilaryTree")
	{
		d ..GetMRItemTree(description)
	}
	elseif (action="addmritembatch")
	{
		d ..AddMRViewItemBatch(parentCode,mrItemID)
	}
	elseif (action="GetMRViewTreeByEpisodeID")
	{
		d ..GetMRViewTreeByEpisodeID(episodeID,dataserviceurl)
	}
	Quit $$$OK
}

/// Desc: yangshun 2022-7-19 获取相似mritem树
/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxConfigMRViewItem).GetMRItemTree("知情同意书")
ClassMethod GetMRItemTree(ADesc As %String)
{
	
	kill ^||TmpMRItemTree
	d ##class(DHCEPRFS.BL.BLMRViewItem).BuildMRViewItemTree(ADesc)
	s categoryID = ""
	s categoryID = $O(^||TmpMRItemTree(categoryID))
	w "["
	for
	{
		q:(categoryID="")
		s category = ##class(DHCEPRFS.META.MRCategory).%OpenId(categoryID)
		w "{"
		w """text"":"""_category.Name_""","
		w """state"":"""_"closed"_""","
		s subCategoryID = ""
		s subCategoryID = $O(^||TmpMRItemTree(categoryID,subCategoryID))
		w """children"":"_"["
		for
		{
			q:(subCategoryID="")
			s subcategory = ##class(DHCEPRFS.META.MRSubCategory).%OpenId(subCategoryID)
			w "{"
			w """text"":"""_subcategory.Name_""","
			w """state"":"""_"closed"_""","
			s mrItemID = ""
			s mrItemID = $O(^||TmpMRItemTree(categoryID,subCategoryID,mrItemID))
			w """children"":"_"["
			for
			{
				q:mrItemID=""
				s mrItemObj = ##class(DHCEPRFS.META.MRItem).%OpenId(mrItemID)
				w "{"
				w """text"":"""_mrItemObj.Name_""","
				w """attributes"":"
				w "{"
				w """mrItemID"":"""_mrItemID_""""
				w "}"
				w "}"
				s mrItemID = $O(^||TmpMRItemTree(categoryID,subCategoryID,mrItemID))
				if (mrItemID'="")
				{
					w ","
				}
			}
			w "]"
			w "}"
			s subCategoryID = $O(^||TmpMRItemTree(categoryID,subCategoryID))
			if (subCategoryID'="")
			{
				w ","
			}
			
		}
		w "]"
		w "}"
		s categoryID = $O(^||TmpMRItemTree(categoryID))
		if (categoryID'="")
		{
			w ","
		}
		
	}
	w "]"
	kill ^||TmpMRItemTree
}

/// Desc: yangshun 2022-7-19 获取MRViewCategory
/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxConfigMRViewItem).GetMRViewCategoryList()
ClassMethod GetMRViewCategoryList()
{
	s count = 0
	w "{""rows"":["
	s id = ""
	for
	{
		s id = $O(^DHCEPRFS.META.MRViewCategoryD(id))
		q:(id="")
		s obj = ##class(DHCEPRFS.META.MRViewCategory).%OpenId(id)
		continue:(id="")
		w:(count>0) ","
		s count = count+1
		w "{"
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ID"":"""_id_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""Name"":"""_obj.Name_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""Desc"":"""_obj.Description_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""Code"":"""_obj.Code_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""Sequence"":"""_obj.Sequence_"""")
		w "}"
	}
	
	w "],""total"":"_count_"}"
}

/// Desc: yangshun 2022-7-19 获取MRViewSubCategory
/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxConfigMRViewItem).GetMRViewSubCategoryList("NS001")
ClassMethod GetMRViewSubCategoryList(AParentCode As %String)
{
	s count = 0
	w "{""rows"":["
	s id = ""
	s:(AParentCode'="") AParentCode = " "_AParentCode
	for
	{
		q:(AParentCode="")
		s id = $O(^DHCEPRFS.META.MRViewSubCategoryI("IdxParent",AParentCode,id))
		q:(id="")
		
		s obj = ##class(DHCEPRFS.META.MRViewSubCategory).%OpenId(id)
		continue:(id="")
		w:(count>0) ","
		s count = count+1
		w "{"
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ID"":"""_id_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""Name"":"""_obj.Name_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""Desc"":"""_obj.Description_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""Code"":"""_obj.Code_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""Sequence"":"""_obj.Sequence_"""")
		w "}"
	}
	
	w "],""total"":"_count_"}"
}

/// Desc: yangshun 2022-7-19 获取MRViewItem
/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxConfigMRViewItem).GetMRViewItemList("NS002_SUB_1")
ClassMethod GetMRViewItemList(AParentCode As %String)
{
	s count = 0
	w "{""rows"":["
	s id = ""
	s:(AParentCode'="") AParentCode = " "_AParentCode
	for
	{
		q:(AParentCode="")
		s id = $O(^DHCEPRFS.META.MRViewItemI("IdxParent",AParentCode,id))
		q:(id="")
		s obj = ##class(DHCEPRFS.META.MRViewItem).%OpenId(id)
		continue:(id="")
		w:(count>0) ","
		s count = count+1
		w "{"
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ID"":"""_id_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""Name"":"""_obj.Name_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""MRItemID"":"""_obj.MRItemID_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""Sequence"":"""_obj.Sequence_"""")
		w "}"
	}
	
	w "],""total"":"_count_"}"
}

/// Desc: yangshun 2022-7-19 添加或新增MRViewCategory
/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxConfigMRViewItem).AddOrUpdateMRViewCategory("","","","","")
ClassMethod AddOrUpdateMRViewCategory(AID As %String, ACode As %String, AName As %String, ADesc As %String, ASequence As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLMRViewItem).AddOrUpdateMRViewCategory(AID,ACode,AName,ADesc,ASequence)
	w ret
}

/// Desc: yangshun 2022-7-19 删除MRViewCategory
ClassMethod DelMRViewCategory(AID As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLMRViewItem).DelMRViewCategory(AID)
	w ret
}

/// Desc: yangshun 2022-7-19 添加或新增MRViewSubCategory
/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxConfigMRViewItem).AddOrUpdateMRViewCategory("","","","","")
ClassMethod AddOrUpdateMRViewSubCategory(AID As %String, AParentCode As %String, ACode As %String, AName As %String, ADesc As %String, ASequence As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLMRViewItem).AddOrUpdateMRViewSubCategory(AID ,AParentCode, ACode, AName, ADesc,ASequence)
	w ret
}

/// Desc: yangshun 2022-7-19 删除MRViewCategory
ClassMethod DelMRViewSubCategory(AID As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLMRViewItem).DelMRViewSubCategory(AID)
	w ret
}

/// Desc: yangshun 2022-7-19 添加或新增MRViewItem
/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxConfigMRViewItem).AddOrUpdateMRViewCategory("","","","","")
ClassMethod AddOrUpdateMRViewItem(AID As %String, AParentCode As %String, AName As %String, AMRItemID As %String, ASequence As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLMRViewItem).AddOrUpdateMRViewItem(AID ,AParentCode, AName, AMRItemID, ASequence)
	w ret
}

/// Desc: yangshun 2022-7-19 删除MRViewItem
ClassMethod DelMRViewMRItem(AIDs As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLMRViewItem).DelMRViewMRItem(AIDs)
	w ret
}

/// Desc: yangshun 2022-7-21 获取归档全部mritem树
/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxConfigMRViewItem).GetCategoryTree()
ClassMethod GetCategoryTree()
{
	w "["
	s categoryID = ""
	for
	{
		s oldCategoryID = categoryID
		s categoryID = $O(^DHCEPRFS.META.MRCategoryD(categoryID))
		w:((oldCategoryID'="")&&(categoryID'="")) ","
		q:(categoryID="")
		w "{"
		s categoryObj = ##class(DHCEPRFS.META.MRCategory).%OpenId(categoryID)
		w """text"":"""_categoryObj.Name_""","
		w """state"":"""_"closed"_""","
		s subCategoryID = ""
		w """children"":"_"["
		for
		{
			s oldSubCategoryID = subCategoryID
			
			s subCategoryID = $O(^DHCEPRFS.META.MRSubCategoryI("IdxMRCategoryID"," "_categoryID,subCategoryID))
			w:((subCategoryID'="")&&(oldSubCategoryID'="")) ","
			q:(subCategoryID="")
			s subCategoryObj = ##class(DHCEPRFS.META.MRSubCategory).%OpenId(subCategoryID)
			w "{"
			w """text"":"""_subCategoryObj.Name_""","
			w """attributes"":"
			w "{"
			w """ID"":"""_subCategoryID_""""
			w "}"
			w "}"
		}
		w "]"
		w "}"
	}
	
	w "]"
}

/// Desc: yangshun 2022-7-19 获取mrviewsubcategory关联的mrviewitem
/// d ##class(DHCEPRFS.web.eprajax.AjaxConfigMRViewItem).GetMRItemList("1")
ClassMethod GetMRItemList(ASubCategoryID As %String)
{
	w "["
	s mrItemID = ""
	s ASubCategoryID = " "_ASubCategoryID
	for
	{
		s oldMrItemID = mrItemID
		s mrItemID = $O(^DHCEPRFS.META.MRItemI("IdxMRSubCategoryID",ASubCategoryID,mrItemID))
		q:(mrItemID="")
		w:((oldMrItemID'="")&&(mrItemID'="")) ","
		s mrItemObj = ##class(DHCEPRFS.META.MRItem).%OpenId(mrItemID)
		w "{"
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ID"":"""_mrItemID_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""Name"":"""_mrItemObj.Name_"""")
		w "}"
		
	}
	w "]"
}

/// Desc: yangshun 2022-7-19 批量添加mrviewitem
ClassMethod AddMRViewItemBatch(AParentCode As %String, AMRItems As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLMRViewItem).AddMRViewItemBatch(AParentCode,AMRItems)
	w ret
}

/// Desc: yangshun 2022-7-19 获取患者的病历浏览树目录
/// Debug: d ##class(DHCEPRFS.web.eprajax.AjaxConfigMRViewItem).GetMRViewTreeByEpisodeID("82323453","")
ClassMethod GetMRViewTreeByEpisodeID(AEpisodeID As %String, ADataServiceUrl As %String)
{
	d ##class(DHCEPRFS.BL.BLMRViewItem).GetMRViewTreeByEpisodeID(AEpisodeID,ADataServiceUrl)
	w "["
	s parentSequence = ""
	s count = 0
	for
	{
		s parentSequence = $O(^||DHCEPRFSMRViewItemTree(parentSequence))
		q:(parentSequence="")
		w:(count'=0) ","
		s count = count+1
		w "{"
		w """text"":"""_$P(^||DHCEPRFSMRViewItemTree(parentSequence),"^",2)_""","
		w """state"":"""_"closed"_""","
		w """attributes"":"
		w "{"
		w """Code"":"""_$P(^||DHCEPRFSMRViewItemTree(parentSequence),"^",1)_""""
		w "},"
		s subCategorySequence = ""
		s subCategoryCount = 0
		w """children"":"_"["
		for
		{
			s subCategorySequence = $O(^||DHCEPRFSMRViewItemTree(parentSequence,subCategorySequence))
			q:(subCategorySequence="")
			w:(subCategoryCount'=0) ","
			s subCategoryCount = subCategoryCount+1
			w "{"
			w """text"":"""_$P(^||DHCEPRFSMRViewItemTree(parentSequence,subCategorySequence),"^",2)_""","
			w """state"":"""_"closed"_""","
			w """attributes"":"
			w "{"
			w """Code"":"""_$P(^||DHCEPRFSMRViewItemTree(parentSequence,subCategorySequence),"^",1)_""""
			w "},"
			s mrviewItemSequence = ""
			s mrViewItemCount = 0
			w """children"":"_"["
			for
			{
				s mrviewItemSequence = $O(^||DHCEPRFSMRViewItemTree(parentSequence,subCategorySequence,mrviewItemSequence))
				q:(mrviewItemSequence="")
				w:(mrViewItemCount'=0) ","
				s mrViewItemCount = mrViewItemCount+1
				s tmpData = ^||DHCEPRFSMRViewItemTree(parentSequence,subCategorySequence,mrviewItemSequence)
				w "{"
				w """text"":"""_$LG(tmpData,1)_""","
				w """attributes"":"
				w "{"
				w """mritemId"":"""_$LG(tmpData,2)_""","
				w """url"":"""_$LG(tmpData,3)_""""
				w "}"
				w "}"
			}
			
			w "]"
			w "}"
		}
		
		w "]"
		w "}"
	}
	
	w "]"
	kill ^||DHCEPRFSMRViewItemTree
}

}
