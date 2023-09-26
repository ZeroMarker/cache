Class DHCEPRFS.BL.BLMRItem Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	创建归档病历项目	
ClassMethod CreateItem(ACode As %String, AName As %String, ADescription As %String, AMRSubCategoryID As %String, AType As %String, ATypeParams As %String) As %String
{
	s obj = ##Class(DHCEPRFS.META.MRItem).%New()
	s obj.Code = ACode
	s obj.Name = AName
	s obj.Description = ADescription
	s obj.MRSubCategoryID = AMRSubCategoryID
	s obj.Type = AType
	s obj.TypeParams = ATypeParams
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		s obj.Sequence = obj.%Id()
		d obj.%Save()
		
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

ClassMethod UpdateItem(ACode As %String, AName As %String, ADescription As %String, AMRSubCategoryID As %String, AType As %String, ATypeParams As %String) As %String
{
	s mrItemID = ..GetItemIDByCode(ACode)
	q:(mrItemID="") "0"
	
	s obj = ##Class(DHCEPRFS.META.MRItem).%OpenId(mrItemID)
	q:(obj="") "0"
	
	s obj.Code = ACode
	s obj.Name = AName
	s obj.Description = ADescription
	s obj.MRSubCategoryID = AMRSubCategoryID
	s obj.Type = AType
	s obj.TypeParams = ATypeParams
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

ClassMethod GetItemByID(AMRItemID As %String) As DHCEPRFS.Entity.EMRItem
{
	s obj = ##Class(DHCEPRFS.META.MRItem).%OpenId(AMRItemID)
	q:(obj="") ""
	
	s entity = ##Class(DHCEPRFS.Entity.EMRItem).%New()
	s entity.ID = obj.%Id()
	s entity.Code = obj.Code
	s entity.Name = obj.Name
	s entity.Description = obj.Description
	s entity.MRSubCategoryID = obj.MRSubCategoryID
	s entity.Type = obj.Type
	s entity.TypeParams = obj.TypeParams
	s entity.MediaType = obj.MediaType
	
	q entity
}

ClassMethod GetItemByCode(ACode As %String) As DHCEPRFS.Entity.EMRItem
{
	s rowID = ..GetItemIDByCode(ACode)
	q:(rowID = "") ""
	
	s entity = ..GetItemByID(rowID)
	q entity
}

ClassMethod GetItemIDByCode(ACode As %String) As %String
{
	q:(ACode="") ""
	s rowID = $O(^DHCEPRFS.META.MRItemI("IdxMain"," "_$zcvt(ACode,"u"),""))
	q rowID
}

/// debug: w ##class(DHCEPRFS.BL.BLMRItem).GetItemDescriptionByCode("EPRITEM006")
ClassMethod GetItemDescriptionByCode(ACode As %String) As %String
{
	q:(ACode="") ""
	s ret = ""
	s rowID = ""
	s rowID = $O(^DHCEPRFS.META.MRItemI("IdxMain"," "_$zcvt(ACode,"u"),rowID))
	if (rowID '= "")
	{
		s obj = ##class(DHCEPRFS.META.MRItem).%OpenId(rowID)
		s ret = obj.Description
	}
	q ret
}

/// Desc:	获取指定类型及类型参数的归档病历项目
/// Input:	AType 类型
/// 		ATypeParams 类型参数
/// Output:	DHCEPRFS.Entity.EMRItem 归档病历项目实体对象
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRItem).GetItemByType("07","21")
ClassMethod GetItemByType(AType As %String, ATypeParams As %String) As DHCEPRFS.Entity.EMRItem
{
	s rowID = ..GetItemIDByType(AType, ATypeParams)
	q:(rowID = "") ""
	
	s entity = ..GetItemByID(rowID)
	q entity
}

/// Debug:	w ##Class(DHCEPRFS.BL.BLMRItem).GetItemIDByType("PS","")
ClassMethod GetItemIDByType(AType As %String, ATypeParams As %String) As %String
{
	q:(AType="") ""
	
	s:(ATypeParams = $c(0)) ATypeParams = ""
	if ((AType = "PS") && (ATypeParams = ""))
	{
		s ATypeParams = "0"	
	}
	
	s rowID = $O(^DHCEPRFS.META.MRItemI("IdxType"," "_$zcvt(AType,"u")," "_$zcvt(ATypeParams,"u"),""))
	q rowID
}

/// Creator:candyxu
/// CreateDate:2013-05-06
/// Desc:获得归档目录项
/// Debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRItem","GetAll","PS","OutPatient")
Query GetAll(ItemType As %String = "", SubType As %String = "") As %Query(ROWSPEC = "MRItemID:%String,MRSubCateogryID:%String,MRCateCategoryID:%String,SubCgDesc:%String,CgDesc:%String,Code:%String,Name:%String,Description:%String,Type:%String,TypeParams:%String")
{
}

ClassMethod GetAllExecute(ByRef qHandle As %Binary, ItemType As %String = "", SubType As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s MRcgId = ""
 	for { 
	 	s MRcgId = $o(^DHCEPRFS.META.MRCategoryD(MRcgId))
	 	q:(MRcgId = "")
	 	s CgDesc = $Li(^DHCEPRFS.META.MRCategoryD(MRcgId),4)
	 	s MRscgId = ""
	 	for {
		    s MRscgId = $o(^DHCEPRFS.META.MRSubCategoryI("IdxMRCategoryID"," "_MRcgId,MRscgId))
	        q:(MRscgId = "")
	        s SubCgDesc = $Li(^DHCEPRFS.META.MRSubCategoryD(MRscgId),4)
	        s sequence = ""
	        for {
		        s sequence = $o(^DHCEPRFS.META.MRItemI("IdxSequence"," "_MRscgId,sequence))
		        q:(sequence = "")
		        
	        	s MRitemId = ""
	        	for {
		        	s MRitemId = $o(^DHCEPRFS.META.MRItemI("IdxSequence"," "_MRscgId,sequence,MRitemId))
		        	q:(MRitemId = "") 
		        	s objItem = ##Class(DHCEPRFS.META.MRItem).%OpenId(MRitemId)
		        	continue:(objItem = "")
		        	s Code = objItem.Code
		        	s Name = objItem.Name
		        	s Description = objItem.Description
		        	s Type = objItem.Type
		        	q:((ItemType '= "") && ($zcvt(ItemType,"U") '= Type ))
		        	s TypeParams = objItem.TypeParams
		        	
			        if (SubType = "OutPatient")	
			        {
				        continue:($p(TypeParams,"_",1) '= "OUT")
			        }
		        	
		        	s data = $lb(MRitemId,MRscgId,MRcgId,SubCgDesc,CgDesc,Code,Name,Description,Type,TypeParams)
	            	s ^CacheTemp(repid,ind)=data
	            	s ind=ind+1
	        	}
		    }
		}
	 }

	Quit $$$OK
}

ClassMethod GetAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:liushuang
/// CreateDate:2016-05-18
/// Desc:获得默认类型项目
/// Debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRItem","GetItemByDefaultType","SCANARRANGE")
Query GetItemByDefaultType(ASchemeType As %String = "") As %Query(ROWSPEC = "MRItemID:%String,MRSubCateogryID:%String,MRCateCategoryID:%String,SubCgDesc:%String,CgDesc:%String,Code:%String,Name:%String,Description:%String,Type:%String,TypeParams:%String")
{
}

ClassMethod GetItemByDefaultTypeExecute(ByRef qHandle As %Binary, ASchemeType As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s schemeID = ""
 	s schemeID = ##Class(DHCEPRFS.BL.BLPrintScheme).GetSchemeIDByDefault(ASchemeType)
 	q:(schemeID = "") $$$OK
 	
 	s objdefault = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(schemeID)	
 	s schemeItems = objdefault.SchemeItems
 	q:(schemeItems = "") $$$OK
 	for i = 1:1:$l(schemeItems,"^")
 	{
	 	s schemeItemID = $p(schemeItems,"^",i)
	 	s mrCGID = $p(schemeItemID,"#",1)
	 	s cgDesc = $Li(^DHCEPRFS.META.MRCategoryD(mrCGID),4)
	 	s mrSCGID = $p(schemeItemID,"#",2)
	 	s subCGDesc = $Li(^DHCEPRFS.META.MRSubCategoryD(mrSCGID),4)
	 	s mrItemID = $p(schemeItemID,"#",3)
	 	s objItem = ##Class(DHCEPRFS.META.MRItem).%OpenId(mrItemID)
		s code = objItem.Code
		s name = objItem.Name
		s description = objItem.Description
		s type = objItem.Type
		s typeParams = objItem.TypeParams

		s data = $lb(mrItemID,mrSCGID,mrCGID,subCGDesc,cgDesc,code,name,description,type,typeParams)
		s ^CacheTemp(repid,ind)=data
	    s ind=ind+1
 	}
 	
	Quit $$$OK
}

ClassMethod GetItemByDefaultTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemByDefaultTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetItemByDefaultTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemByDefaultTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod IsScanUnArrange(AMRItemID As %String) As %String
{
	//获取扫描未分类MRItemID
	s rowID = $O(^DHCEPRFS.META.MRItemI("IdxType"," PS"," 0",""))
	q:(rowID = AMRItemID) "1"
	q "0"
}

ClassMethod CheckMRItemBelong(AMRItemID As %String, AUserID As %String = "") As %String
{
	
	s ret = "0"
	
	q:(AUserID = "") "1"
 	
 	s parentRowID = ""
	s parentRowID = $o(^DHCEPRFS.META.QueryFunctionI("IdxFuncName"," SCAN_OPERATION_ARRANGE",parentRowID))
	q:(parentRowID = "") "1"
 	
 	s queryUserID = ""
 	s queryUserID = ##class(DHCEPRFS.BL.BLQueryUser).GetQueryUserID(AUserID)

 	q:(queryUserID = "") "1"
 	
 	
 	S userRoleRowID = ""
 	s userRoleRowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_queryUserID,userRoleRowID))
 	q:(userRoleRowID = "") "1"
 	s userRoleObj = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userRoleRowID)
 	s roleID = userRoleObj.RoleID
 	q:(roleID = "") "1"
 	s queryRoleObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 	s ParentID = queryRoleObj.ParentID
 	if (ParentID '= "")&&(ParentID '= $c(0))
 	{
	 	s roleID = roleID_"^"_ParentID
 	}
 	s schemeID = ""
 	for index=1:1:$l(roleID,"^")
	{
		s roleIDOne = $p(roleID,"^",index)
		s roleFunRowID = ""
 		s roleFunRowID = $o(^DHCEPRFS.META.QueryRoleFunI("IdxRoleID", " "_roleIDOne,roleFunRowID))
 		q:(roleFunRowID = "")
 		s roleFunObj = ##class(DHCEPRFS.META.QueryRoleFun).%OpenId(roleFunRowID)
 		s funcIDs = roleFunObj.FuncID
 		s:(funcIDs = $c(0)) funcIDs = ""
 		continue:(funcIDs = "")
 		
 		for i=1:1:$l(funcIDs,"^")
 		{
	 		s rowID = $p(funcIDs,"^",i)
	 		s:(rowID = $c(0)) rowID = ""
	 		continue:(rowID = "")
			s obj = ##Class(DHCEPRFS.META.QueryFunction).%OpenId(rowID) 
			s parentID = obj.ParentID
			if (parentRowID = parentID)
			{
				if (schemeID = "")
				{
					s schemeID = obj.Notes
				}
				else
				{
					s schemeID = schemeID_"^"_obj.Notes
				}
			}			
 		}
	}	
	
	//b "s"
	q:(schemeID = "") "1"
	
 	for idx=1:1:$l(schemeID,"^")
 	{
	 	s schemeOneID = $p(schemeID,"^",idx)
 		s objdefault = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(schemeOneID)	
 		
 		s schemeItems = objdefault.SchemeItems
 		//b "s"
 		continue:(schemeItems = "") 
 		for i = 1:1:$l(schemeItems,"^")
 		{
	 		s schemeItemID = $p(schemeItems,"^",i)
	 		if ($p(schemeItemID,"#",3) = AMRItemID)
	 		{
		 		s ret = "1"
		 		q
		 	}
 		}
 		q:(ret = "1")
 	}	
 	q ret
}

/// Creator:liushuang
/// CreateDate:2016-06-03
/// Desc:获得继承方案的项目
/// Debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRItem","GetItemByScheme","159")
Query GetItemByScheme(AUserID As %String = "", ALocID As %String = "") As %Query(ROWSPEC = "MRItemID:%String,MRSubCateogryID:%String,MRCateCategoryID:%String,SubCgDesc:%String,CgDesc:%String,Code:%String,Name:%String,Description:%String,Type:%String,TypeParams:%String")
{
}

ClassMethod GetItemBySchemeExecute(ByRef qHandle As %Binary, AUserID As %String = "", ALocID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	k ^CacheTemp(repid,"DHCEPRFS.BL.BLMRItem","GetItemByScheme")
 	q:(AUserID = "") $$$OK
 	
 	
 	s parentRowID = ""
	s parentRowID = $o(^DHCEPRFS.META.QueryFunctionI("IdxFuncName"," SCAN_OPERATION_ARRANGE",parentRowID))
	q:(parentRowID = "") $$$OK
 	
 	s queryUserID = ""
 	s queryUserID = ##class(DHCEPRFS.BL.BLQueryUser).GetQueryUserID(AUserID)

 	q:(queryUserID = "") $$$OK
 	
 	
 	S userRoleRowID = ""
 	s userRoleRowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_queryUserID,userRoleRowID))
 	q:(userRoleRowID = "") $$$OK
 	s userRoleObj = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userRoleRowID)
 	s roleID = userRoleObj.RoleID
 	q:(roleID = "") $$$OK
 	s queryRoleObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 	s ParentID = queryRoleObj.ParentID
 	if (ParentID '= "")&&(ParentID '= $c(0))
 	{
	 	s roleID = roleID_"^"_ParentID
 	}
 	s schemeID = ""
 	for index=1:1:$l(roleID,"^")
	{
		s roleIDOne = $p(roleID,"^",index)
		s roleFunRowID = ""
 		s roleFunRowID = $o(^DHCEPRFS.META.QueryRoleFunI("IdxRoleID", " "_roleIDOne,roleFunRowID))
 		q:(roleFunRowID = "")
 		s roleFunObj = ##class(DHCEPRFS.META.QueryRoleFun).%OpenId(roleFunRowID)
 		s funcIDs = roleFunObj.FuncID
 		s:(funcIDs = $c(0)) funcIDs = ""
 		continue:(funcIDs = "")
 		
 		for i=1:1:$l(funcIDs,"^")
 		{
	 		s rowID = $p(funcIDs,"^",i)
	 		s:(rowID = $c(0)) rowID = ""
	 		continue:(rowID = "")
			s obj = ##Class(DHCEPRFS.META.QueryFunction).%OpenId(rowID) 
			s parentID = obj.ParentID
			if (parentRowID = parentID)
			{
				if (schemeID = "")
				{
					s schemeID = obj.Notes
				}
				else
				{
					s schemeID = schemeID_"^"_obj.Notes
				}
			}			
 		}
	}	
	
	q:(schemeID = "") $$$OK
	
	//获取科室排除的MRItem
	s ExcludeMRItems = ""
	if ((ALocID '= "") || (ALocID '= $c(0)))	//科室不为空时取科室排除项 2021.5.25
	{
		for idx=1:1:$l(schemeID,"^")
		{
			s schemeOneID = $p(schemeID,"^",idx)
			s PrintSchemeLocID = ""
			s PrintSchemeLocID=$o(^DHCEPRFS.META.PrintSchemeLocI("idxPrintSchemeLoc"," "_schemeOneID," "_ALocID,""))
			if (PrintSchemeLocID '="")
			{
				s objPrintSchemeLoc = ##class(DHCEPRFS.META.PrintSchemeLoc).%OpenId(PrintSchemeLocID)
				s ExcludeMRItems = ExcludeMRItems _"^"_objPrintSchemeLoc.ExSchemeItems_"^"
			}
		}
	}
	
 	for idx=1:1:$l(schemeID,"^")
 	{
	 	s schemeOneID = $p(schemeID,"^",idx)
 		s objdefault = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(schemeOneID)	
 		s schemeItems = objdefault.SchemeItems
 		//b "s"
 		continue:(schemeItems = "") 
 		for i = 1:1:$l(schemeItems,"^")
 		{
	 		s schemeItemID = $p(schemeItems,"^",i)
	 		s mrCGID = $p(schemeItemID,"#",1)
	 		s cgDesc = $Li(^DHCEPRFS.META.MRCategoryD(mrCGID),4)
	 		s mrSCGID = $p(schemeItemID,"#",2)
	 		s subCGDesc = $Li(^DHCEPRFS.META.MRSubCategoryD(mrSCGID),4)
	 		s mrItemID = $p(schemeItemID,"#",3)
	 		s objItem = ##Class(DHCEPRFS.META.MRItem).%OpenId(mrItemID)
			s code = objItem.Code
			s name = objItem.Name
			s description = objItem.Description
			s type = objItem.Type
			s typeParams = objItem.TypeParams
			
			if ('$d(^CacheTemp(repid,"DHCEPRFS.BL.BLMRItem","GetItemByScheme",mrItemID)))
			{
				//b ;a
				if (ExcludeMRItems '[ ("#"_mrItemID_"^"))	//不包含排除项目
				{
					s ^CacheTemp(repid,"DHCEPRFS.BL.BLMRItem","GetItemByScheme",mrItemID) = mrItemID_"^"_mrSCGID_"^"_mrCGID_"^"_subCGDesc_"^"_cgDesc_"^"_code_"^"_name_"^"_description_"^"_type_"^"_typeParams
					s data = $lb(mrItemID,mrSCGID,mrCGID,subCGDesc,cgDesc,code,name,description,type,typeParams)
					s ^CacheTemp(repid,ind)=data
		    		s ind=ind+1
	    		}
			}
 		}
 	}
 	
 	k ^CacheTemp(repid,"DHCEPRFS.BL.BLMRItem","GetItemByScheme")
	Quit $$$OK
}

ClassMethod GetItemBySchemeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemBySchemeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetItemBySchemeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemBySchemeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Debuger:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLPrintScheme","GetAllSchemeList","")
Query GetMedRecordScanList() As %Query(ROWSPEC = "MRItemID:%String,MRItemDesc:%String,IsDefault:%String")
{
}

ClassMethod GetMedRecordScanListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	//全部
 	s data = $lb("all","全部","Y")
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
 	
 	s typeParam = ""
 	for {
		s typeParam = $o(^DHCEPRFS.META.MRItemI("IdxType"," MS",typeParam))	
		q:(typeParam = "")
		continue:(typeParam = " 0")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.META.MRItemI("IdxType"," MS",typeParam,rowID))
			q:(rowID = "")
			s obj = ##class(DHCEPRFS.META.MRItem).%OpenId(rowID)
			s mrItemID = rowID
			s mrItemDesc = obj.Description
			s data = $lb(mrItemID,mrItemDesc,"")
	    	s ^CacheTemp(repid,ind)=data
	    	s ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod GetMedRecordScanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMedRecordScanListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetMedRecordScanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMedRecordScanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:liushuang
/// CreateDate:2017-05-23
/// Desc:获得继承方案的项目
/// Debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRItem","GetSchemeItems","TEMP^1","SCAN_OPERATION_ARRANGE")
Query GetSchemeItems(AUserID As %String = "", ASchemeName As %String = "") As %Query(ROWSPEC = "MRItemID:%String,MRSubCateogryID:%String,MRCateCategoryID:%String,SubCgDesc:%String,CgDesc:%String,Code:%String,Name:%String,Description:%String,Type:%String,TypeParams:%String,Shortcut:%String")
{
}

ClassMethod GetSchemeItemsExecute(ByRef qHandle As %Binary, AUserID As %String = "", ASchemeName As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	k ^CacheTemp(repid,"DHCEPRFS.BL.BLMRItem","GetSchemeItems")
 	q:(AUserID = "") $$$OK
 	
 	s parentRowID = ""
	s parentRowID = $o(^DHCEPRFS.META.QueryFunctionI("IdxFuncName"," "_ASchemeName,parentRowID))
	q:(parentRowID = "") $$$OK
 	
 	s queryUserID = ""
 	s queryUserID = ##class(DHCEPRFS.BL.BLQueryUser).GetQueryUserID(AUserID)

 	q:(queryUserID = "") $$$OK
 	
 	
 	S userRoleRowID = ""
 	s userRoleRowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_queryUserID,userRoleRowID))
 	q:(userRoleRowID = "") $$$OK
 	s userRoleObj = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userRoleRowID)
 	s roleID = userRoleObj.RoleID
 	q:(roleID = "") $$$OK
 	s queryRoleObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 	s ParentID = queryRoleObj.ParentID
 	if (ParentID '= "")&&(ParentID '= $c(0))
 	{
	 	s roleID = roleID_"^"_ParentID
 	}
 	s schemeID = ""
 	for index=1:1:$l(roleID,"^")
	{
		s roleIDOne = $p(roleID,"^",index)
		s roleFunRowID = ""
 		s roleFunRowID = $o(^DHCEPRFS.META.QueryRoleFunI("IdxRoleID", " "_roleIDOne,roleFunRowID))
 		q:(roleFunRowID = "")
 		s roleFunObj = ##class(DHCEPRFS.META.QueryRoleFun).%OpenId(roleFunRowID)
 		s funcIDs = roleFunObj.FuncID
 		s:(funcIDs = $c(0)) funcIDs = ""
 		continue:(funcIDs = "")
 		
 		for i=1:1:$l(funcIDs,"^")
 		{
	 		s rowID = $p(funcIDs,"^",i)
	 		s:(rowID = $c(0)) rowID = ""
	 		continue:(rowID = "")
			s obj = ##Class(DHCEPRFS.META.QueryFunction).%OpenId(rowID) 
			s parentID = obj.ParentID
			if (parentRowID = parentID)
			{
				if (schemeID = "")
				{
					s schemeID = obj.Notes
				}
				else
				{
					s schemeID = schemeID_"^"_obj.Notes
				}
			}			
 		}
	}	
	
	q:(schemeID = "") $$$OK
	
 	for idx=1:1:$l(schemeID,"^")
 	{
	 	s schemeOneID = $p(schemeID,"^",idx)
 		s objdefault = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(schemeOneID)	
 		s schemeItems = objdefault.SchemeItems

 		//b "s"
 		continue:(schemeItems = "") 
 		s HDCItemShortcut=..GetHDCScanItemsShortcut(schemeOneID)
 		
 		for i = 1:1:$l(schemeItems,"^")
 		{
	 		s schemeItemID = $p(schemeItems,"^",i)
	 		s mrCGID = $p(schemeItemID,"#",1)
	 		s cgDesc = $Li(^DHCEPRFS.META.MRCategoryD(mrCGID),4)
	 		s mrSCGID = $p(schemeItemID,"#",2)
	 		s subCGDesc = $Li(^DHCEPRFS.META.MRSubCategoryD(mrSCGID),4)
	 		s mrItemID = $p(schemeItemID,"#",3)
	 		s objItem = ##Class(DHCEPRFS.META.MRItem).%OpenId(mrItemID)
			s code = objItem.Code
			s name = objItem.Name
			s description = objItem.Description
			s type = objItem.Type
			s typeParams = objItem.TypeParams
			s shortcut=$p(HDCItemShortcut,"^",i)
			
			if ('$d(^CacheTemp(repid,"DHCEPRFS.BL.BLMRItem","GetSchemeItems",mrItemID)))
			{
				s ^CacheTemp(repid,"DHCEPRFS.BL.BLMRItem","GetSchemeItems",mrItemID) = mrItemID_"^"_mrSCGID_"^"_mrCGID_"^"_subCGDesc_"^"_cgDesc_"^"_code_"^"_name_"^"_description_"^"_type_"^"_typeParams
				s data = $lb(mrItemID,mrSCGID,mrCGID,subCGDesc,cgDesc,code,name,description,type,typeParams,shortcut)
				s ^CacheTemp(repid,ind)=data
	    		s ind=ind+1
			}
 		}
 	}
 	
 	k ^CacheTemp(repid,"DHCEPRFS.BL.BLMRItem","GetSchemeItems")
	Quit $$$OK
}

ClassMethod GetSchemeItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSchemeItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetSchemeItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSchemeItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRItem","GetOCRArrangeInfo")
Query GetOCRArrangeInfo() As %Query(ROWSPEC = "MRItemID:%String,MRItemTypeParam:%String,MRItemName:%String,MRItemDesc:%String,KeyWords:%String")
{
}

ClassMethod GetOCRArrangeInfoExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
	s typeParam = ""
	for {
		s typeParam = $o(^DHCEPRFS.META.MRItemI("IdxType"," PS",typeParam))
		q:(typeParam = "")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.META.MRItemI("IdxType"," PS",typeParam,rowID))
			q:(rowID = "")
			
			s obj = ##class(DHCEPRFS.META.MRItem).%OpenId(rowID)
			s typeParamIn = obj.TypeParams
			s name = obj.Name
			s desc = obj.Description
			s keywords = obj.OCRArrangeTitle
			
			s data = $lb(rowID,typeParamIn,name,desc,keywords)
			s ^CacheTemp(repid,ind)=data
	    	s ind=ind+1
		}
	}

	Quit $$$OK
}

ClassMethod GetOCRArrangeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOCRArrangeInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetOCRArrangeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOCRArrangeInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPaperSizeByMRItemID(AMRItemID As %String) As %String
{
	q:(AMRItemID = "") ""
	s paperSize = ""
	s obj = ##class(DHCEPRFS.META.MRItem).%OpenId(AMRItemID)
	s paperSize = obj.PaperSize
	q paperSize
}

/// Desc：获取归档项目信息
/// Debug:w ##class(DHCEPRFS.BL.BLMRItem).GetItemInfoByID("1")
ClassMethod GetItemInfoByID(AMRItemID As %String) As %String
{
	q:(AMRItemID="") "0"
	q:($d(^DHCEPRFS.META.MRItemD(AMRItemID))="0") "0"
	s itemName = $lg(^DHCEPRFS.META.MRItemD(AMRItemID),2)
	s itemCode = $lg(^DHCEPRFS.META.MRItemD(AMRItemID),3)
	s MRSubCategoryID = $lg(^DHCEPRFS.META.MRItemD(AMRItemID),5)
	s MRSubCategoryName = $lg(^DHCEPRFS.META.MRSubCategoryD(MRSubCategoryID),2)
	s MRCategoryID = $lg(^DHCEPRFS.META.MRSubCategoryD(MRSubCategoryID),5)
	s MRCategoryName = $lg(^DHCEPRFS.META.MRCategoryD(MRCategoryID),2)
	q AMRItemID_"^"_MRSubCategoryID_"^"_MRCategoryID_"^"_itemName_"^"_MRSubCategoryName_"^"_MRCategoryName_"^"_itemCode
}

/// Creator:yangpeng
/// CreateDate:20200419
/// Desc:获取高拍仪方案扫描项目快捷键
/// Debug:w ##class(DHCEPRFS.BL.BLMRItem).GetHDCScanItemsShortcut(9)
ClassMethod GetHDCScanItemsShortcut(ASchemeID As %String) As %String
{
	s ret=""
	s ConfigValue=##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HDCScanShortcut")
	for i=1:1:$l(ConfigValue,"#")
	{
		s SchemeShortcut=$p(ConfigValue,"#",i)
		if ($p(SchemeShortcut,"$",1) = ASchemeID)
		{
			s ret=$p(SchemeShortcut,"$",2)
			q
		}
	}
	q ret
}

}
