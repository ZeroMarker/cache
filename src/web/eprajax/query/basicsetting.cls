Class web.eprajax.query.basicsetting Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"null")
	q:(action = "null") $$$OK
	s frameType = $g(%request.Data("frameType",1),"")
	s filterValue = $g(%request.Data("FilterValue",1),"")
	
	s ^CacheTemp("EPRQuery","web.eprajax.query.basicsetting","action") = action
	if (action = "getDefaultHISItems")
	{
		d ..GetDefaultHISItems()		
	}
	elseif (action = "getDefaultHISCM")
	{
		d ..GetDefaultHISCM()
	}
	elseif (action = "getStoreFields")
	{
		d ..GetStoreFields()
	}
	elseif (action = "getCategoryTree")
	{
		s nodeID = $g(%request.Data("node",1),"-1")	
		s parentID = $e(nodeID,3,$l(nodeID))
		s flag	= $g(%request.Data("flag",1),"-1")
		if (frameType = "HISUI")
		{
			d ..GetCategorys(parentID,flag)
		}
		else
		{
			d ..GetQueryCategories(parentID)
		}
	}
	elseif (action = "getCategoryItems")
	{
		if (frameType = "HISUI")
		{
			s page = $g(%request.Data("page",1),"1")
			s rows = $g(%request.Data("rows",1),"12")
			s idxStart = (page - 1) * rows
			s pageSize = rows	
		}
		else
		{
			s idxStart = $g(%request.Data("start",1),"0")
			s pageSize = $g(%request.Data("limit",1),"15")
		}
		s idxLast = idxStart + pageSize - 1	
		
		s categoryID = $g(%request.Data("CategoryID",1),"-1")
		if (categoryID = "-1") 
		{
			if (frameType = "HISUI")
			{
				w "{""total"":""0"",""rows"":[]}"
			}
			else
			{
				w "{""totalCount"":""0"",""data"":[]}"
			}
			q $$$OK 
		}
		s categoryID = $e(categoryID,3,$l(categoryID))
		s retJSON = ..GetCategoryItemsByID(categoryID,"",idxStart,idxLast,"",frameType,filterValue)
		w retJSON
	}
	elseif (action = "getOperateCategoryItems")
	{
		if (frameType = "HISUI")
		{
			s page = $g(%request.Data("page",1),"1")
			s rows = $g(%request.Data("rows",1),"12")
			s idxStart = (page - 1) * rows
			s pageSize = rows	
		}
		else
		{
			s idxStart = $g(%request.Data("start",1),"0")
			s pageSize = $g(%request.Data("limit",1),"15")
		}
		s idxLast = idxStart + pageSize - 1	
		
		s categoryID = $g(%request.Data("CategoryID",1),"-1")
		if (categoryID = "-1") 
		{
			if (frameType = "HISUI")
			{
				w "{""total"":""0"",""rows"":[]}"
			}
			else
			{
				w "{""totalCount"":""0"",""data"":[]}"
			}
			q $$$OK 
		}
		s categoryID = $e(categoryID,3,$l(categoryID))
		s retJSON = ..GetOperateCategoryItemsByID(categoryID,"",idxStart,idxLast,"",frameType)
		w retJSON
	}
	
	q $$$OK
}

/// Debug:	d ##Class(web.eprajax.query.basicsetting).GetDefaultHISItems()
ClassMethod GetDefaultHISItems()
{
	s categoryID = ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetCategoryIDByCode("HIS")
	s count = 0
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s json = "["

	s category = ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetCategoryByID(categoryID)
	s result = ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetQueryItemsByCatID(categoryID,"Y")
	While (result.Next())
	{
		s count = count + 1	
		if (count > 1) { s json = json_"," }
		
		s isActive = $s($g(result.Data("IsActive")) = "Y": "true",1:"false")
		
		s Code = category.Code_"^"_$g(result.Data("Name"))_"^"_$g(result.Data("Code"))_"^"_$g(result.Data("Title"))_"^"_$g(result.Data("TypeCode"))_"^"_$g(result.Data("StdDic"))
		s categoryName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EPRmeta.Query.QueryCategory","Name",category.Name,langid)
		s Title = categoryName_"." _$g(result.Data("Title"))
		s json = json_"{""ID"":"""_$g(result.Data("ID"))_""","
		s json = json_"""Code"":"""_Code_""","
 		s json = json_"""Title"":"""_Title_""","
 		s json = json_"""IsActive"":"""_isActive_"""}"
	}
	
	s json = json_"]"
	
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
	w json
}

/// Debug:	d ##Class(web.eprajax.query.basicsetting).GetDefaultHISCM()
ClassMethod GetDefaultHISCM()
{
	s count = 0
	s json = "["
	
	s categoryID = ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetCategoryIDByCode("HIS")
	s result = ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetQueryItemsByCatID(categoryID,"")
	While (result.Next())
	{
		s count = count + 1
		if (count > 1) { s json = json_"," }
		s json = json_"{header:'"_$g(result.Data("Title"))_"',"
		s json = json_"dataIndex:'"_$g(result.Data("Name"))_"',"
		s json = json_"width:70}"	
	}
	
	s json = json_"]"
	
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
	w json
}

/// Debug:	d ##Class(web.eprajax.query.basicsetting).GetStoreFields()
ClassMethod GetStoreFields()
{
	s count = 0
	s json = "["
	
	s categoryID = ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetCategoryIDByCode("HIS")
	s result = ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetQueryItemsByCatID(categoryID,"")
	While (result.Next())
	{
		s count = count + 1
		if (count > 1) { s json = json_"," }
		s json = json_"{name:'"_$g(result.Data("Name"))_"'}"
	}
	
	s json = json_"]"
	
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
	w json
}

/// Debug:	d ##Class(web.eprajax.query.basicsetting).GetQueryCategories(1)
ClassMethod GetQueryCategories(AParentID As %String)
{
	s count = 0
	w "["
	s result = ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetSubCategoriesByID(AParentID,"N","Y")
	While (result.Next())
	{
		s count = count + 1	
		
		if (count > 1) { w "," }
		w "{"
		w """id"":""CG"_$g(result.Data("ID"))_""""
		w ",""text"":"""_$g(result.Data("Name"))_""""
		w ",""cls"":""folder"""
		w ",""code"":"""_$g(result.Data("Code"))_""""
		w ",""rcode"":"""_$p($g(result.Data("Code")),"^",1)_""""
		w "}"	
	}
	
	w "]"
}

ClassMethod GetCategorys(AParentID As %String, Aflag As %String = "")
{
	s count = 0
	w "["
	s result = ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetSubCategoriesByID(AParentID,"N","Y")
	While (result.Next())
	{
		if (Aflag = "1")
		{
			continue:($g(result.Data("ID"))="4")
		}
		s count = count + 1	
		
		if (count > 1) { w "," }
		w "{"
		w """id"":""CG"_$g(result.Data("ID"))_""""
		w ",""text"":"""_$g(result.Data("Name"))_""""
		w ",""cls"":""folder"""
		w ",""code"":"""_$g(result.Data("Code"))_""""
		w ",""rcode"":"""_$p($g(result.Data("Code")),"^",1)_""""
		w ",""attributes"":{""RowID"":"""_$g(result.Data("ID"))_""",""text"":"""_$g(result.Data("Name"))_""",""Sequence"":"""_$g(result.Data("Sequence"))_""",""ParentID"":"""_$g(result.Data("ParentID"))_""",""IsActive"":"""_$g(result.Data("IsActive"))_""",""Remark"":"""_$g(result.Data("Remark"))_""",""Itemcode"":"""_$p($g(result.Data("Code")),"^",2)_"""}"
		w ",""children"":"
		d ..GetCategorys($g(result.Data("ID")))
		w "}"		
	}
	w "]"
}

/// Debug:	w ##Class(web.eprajax.query.basicsetting).GetCategoryItemsByID("1","Y",1,10,"Y")
ClassMethod GetCategoryItemsByID(ACategoryID As %String, AIsActive As %String, AIdxStart As %Integer, AIdxLast As %Integer, AFlag As %String = "N", AFrameType As %String = "", AFilterValue As %String = "")
{
	s CategoryID = ACategoryID
	s count = 0
	s json = ""
	s isFirstRecord = 1
	
	s category = ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetCategoryByID(ACategoryID)
	s result = ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetQueryItemsByCatID(ACategoryID,AIsActive)
	While (result.Next())
 	{
		continue:($g(result.Data("IsActive")) = "N")

		if ( AFilterValue'="" )
		{
			continue:'( result.Data("Title") [ AFilterValue )
		}
	 	s count = count + 1	
	 	
	 	if ( count-1 >= AIdxStart) && (count-1 <= AIdxLast)
		{
			if (isFirstRecord = 0) { s json = json_"," }
			
		 	s isActive = $s($g(result.Data("IsActive")) = "Y": "true",1:"false")
		 	s ItemIsActive = $s($g(result.Data("IsActive")) = "Y": "启用",1:"禁用")
		 	
		 	s stdDic = $g(result.Data("StdDic"))
		 	s RowID = ""
		 	s stdDicDesc = "默认"
		 	for
		 	{
			 	s RowID = $o(^DHCEMRM.StdDictionaryI("IdxCode"," "_stdDic,RowID))
				q:(RowID = "")
				s objStdDictionary = $g(^DHCEMRM.StdDictionaryD(RowID))
				q:(objStdDictionary = "")
				s stdDicDesc = $list(objStdDictionary,3)
			}
		 	
		
			if ($zcvt(AFlag,"U") = "Y")
			{
				s Code = category.Code_"^"_$g(result.Data("Name"))_"^"_$g(result.Data("Code"))_"^"_$g(result.Data("Title"))_"^"_$g(result.Data("TypeCode"))_"^"_$g(result.Data("StdDic"))_"^"_$g(result.Data("Rules"))
				s Title = category.Name_"." _$g(result.Data("Title"))
				s json = json_"{""ID"":"""_$g(result.Data("ID"))_""","
				s json = json_"""Code"":"""_Code_""","
		 		s json = json_"""Title"":"""_Title_""","
		 		s json = json_"""IsActive"":"""_isActive_"""}"
			}
			else
			{
				s json = json_"{""ID"":"""_$g(result.Data("ID"))_""","
				s json = json_"""Code"":"""_$g(result.Data("Name"))_"^"_$g(result.Data("Code"))_"^"_$g(result.Data("Title"))_"^"_$g(result.Data("TypeCode"))_"^"_$g(result.Data("StdDic"))_"^"_$g(result.Data("Rules"))_""","
				s json = json_"""IsActive"":"""_isActive_""","
		 		s json = json_"""Title"":"""_$g(result.Data("Title"))_""","
		 		
		 		
		 		s json = json_"""ItemCode"":"""_$g(result.Data("Code"))_""","
		 		s json = json_"""Name"":"""_$g(result.Data("Name"))_""","
		 		s json = json_"""CategoryID"":"""_CategoryID_""","
		 		s json = json_"""Remark"":"""_$g(result.Data("Remark"))_""","
		 		s json = json_"""Sequence"":"""_$g(result.Data("Sequence"))_""","
		 		s json = json_"""TypeCode"":"""_$g(result.Data("TypeCode"))_""","
		 		s json = json_"""stdDicDesc"":"""_stdDicDesc_""","
		 		
		 		s json = json_"""ItemIsActive"":"""_ItemIsActive_"""}"	
			}
		 	
		 	s isFirstRecord = 0
		}
	}
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	if (AFrameType = "HISUI")
	{
		s ret = "{""total"":"""_count_""",""rows"":["_json_"]}"
	}
	else
	{
		s ret = "{""totalCount"":"""_count_""",""data"":["_json_"]}"
	}
	q ret
}

/// Debug:	w ##Class(web.eprajax.query.basicsetting).GetOperateCategoryItemsByID("1","Y",1,10,"Y")
ClassMethod GetOperateCategoryItemsByID(ACategoryID As %String, AIsActive As %String, AIdxStart As %Integer, AIdxLast As %Integer, AFlag As %String = "N", AFrameType As %String = "")
{
	s CategoryID = ACategoryID
	s count = 0
	s json = ""
	s isFirstRecord = 1
	
	s category = ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetCategoryByID(ACategoryID)
	s result = ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetQueryItemsByCatID(ACategoryID,AIsActive)
	While (result.Next())
 	{
	 	s count = count + 1	
	 	
	 	if ( count-1 >= AIdxStart) && (count-1 <= AIdxLast)
		{
			if (isFirstRecord = 0) { s json = json_"," }
			
		 	s isActive = $s($g(result.Data("IsActive")) = "Y": "true",1:"false")
		 	s ItemIsActive = $s($g(result.Data("IsActive")) = "Y": "启用",1:"禁用")
		 	
		 	s stdDic = $g(result.Data("StdDic"))
		 	s RowID = ""
		 	s stdDicDesc = "默认"
		 	for
		 	{
			 	s RowID = $o(^DHCEMRM.StdDictionaryI("IdxCode"," "_stdDic,RowID))
				q:(RowID = "")
				s objStdDictionary = $g(^DHCEMRM.StdDictionaryD(RowID))
				q:(objStdDictionary = "")
				s stdDicDesc = $list(objStdDictionary,3)
			}
		 	
		
			if ($zcvt(AFlag,"U") = "Y")
			{
				s Code = category.Code_"^"_$g(result.Data("Name"))_"^"_$g(result.Data("Code"))_"^"_$g(result.Data("Title"))_"^"_$g(result.Data("TypeCode"))_"^"_$g(result.Data("StdDic"))_"^"_$g(result.Data("Rules"))
				s Title = category.Name_"." _$g(result.Data("Title"))
				s json = json_"{""ID"":"""_$g(result.Data("ID"))_""","
				s json = json_"""Code"":"""_Code_""","
		 		s json = json_"""Title"":"""_Title_""","
		 		s json = json_"""IsActive"":"""_isActive_"""}"
			}
			else
			{
				s json = json_"{""ID"":"""_$g(result.Data("ID"))_""","
				s json = json_"""Code"":"""_$g(result.Data("Name"))_"^"_$g(result.Data("Code"))_"^"_$g(result.Data("Title"))_"^"_$g(result.Data("TypeCode"))_"^"_$g(result.Data("StdDic"))_"^"_$g(result.Data("Rules"))_""","
				s json = json_"""IsActive"":"""_isActive_""","
		 		s json = json_"""Title"":"""_$g(result.Data("Title"))_""","
		 		
		 		
		 		s json = json_"""ItemCode"":"""_$g(result.Data("Code"))_""","
		 		s json = json_"""Name"":"""_$g(result.Data("Name"))_""","
		 		s json = json_"""CategoryID"":"""_CategoryID_""","
		 		s json = json_"""Remark"":"""_$g(result.Data("Remark"))_""","
		 		s json = json_"""Sequence"":"""_$g(result.Data("Sequence"))_""","
		 		s json = json_"""TypeCode"":"""_$g(result.Data("TypeCode"))_""","
		 		s json = json_"""stdDicDesc"":"""_stdDicDesc_""","
		 		
		 		s json = json_"""ItemIsActive"":"""_ItemIsActive_"""}"	
			}
		 	
		 	s isFirstRecord = 0
		}
	}
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	if (AFrameType = "HISUI")
	{
		s ret = "{""total"":"""_count_""",""rows"":["_json_"]}"
	}
	else
	{
		s ret = "{""totalCount"":"""_count_""",""data"":["_json_"]}"
	}
	q ret
}

}
