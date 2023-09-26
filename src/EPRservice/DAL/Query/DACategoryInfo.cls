Class EPRservice.DAL.Query.DACategoryInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	根据父节点ID取子节点集合;
/// Input:	ACategoryID为父节点ID, 根目录节点ID为0;
/// 		AIsRecursive指是否递归获取子节点;
/// 		AIsActive指是否有效,如果为空,则不判断有效性;					
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.DAL.Query.DACategoryInfo","GetSubCategoriesByID",0,"Y","Y")
Query GetSubCategoriesByID(ACategoryID As %String, AIsRecursive As %String = "Y", AIsActive As %String = "") As %Query(ROWSPEC = "ID,Code,Name,Sequence,ParentID,IsActive,Remark")
{
}

ClassMethod GetSubCategoriesByIDExecute(ByRef qHandle As %Binary, ACategoryID As %String, AIsRecursive As %String = "Y", AIsActive As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($g(ACategoryID) = "") $$$OK
	
	s UniqueKey = $i(^CacheTempDHCEPR)
	
	k ^CacheTempDHCEPR(UniqueKey)
	
	s rootCode = ..GetRootCode(ACategoryID)
	d ..RecursiveSubCategories(UniqueKey,rootCode,ACategoryID,AIsRecursive,AIsActive)
	
	s RowID = ""
	for {
		s RowID = $o(^CacheTempDHCEPR(UniqueKey,RowID))
		q:(RowID = "")
		
		s tmpCategory = $g(^CacheTempDHCEPR(UniqueKey,RowID))
		s Code = $list(tmpCategory,1)
		s Name = $list(tmpCategory,2)
		s Sequence = $list(tmpCategory,3)
		s ParentID = $list(tmpCategory,4)
		s IsActive = $list(tmpCategory,5)
		s Remark = $list(tmpCategory,6)
		
		s Data = $lb(RowID,Code,Name,Sequence,ParentID,IsActive,Remark)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	
	k ^CacheTempDHCEPR(UniqueKey)
	
	q $$$OK
}

ClassMethod GetSubCategoriesByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSubCategoriesByIDExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") {				
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} else {				
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetSubCategoriesByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSubCategoriesByIDExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:	递归获取父节点下子节点集合,并保存在一个临时Global中
/// Input:	AUniqueKey为^CacheTempDHCEPR的下一个唯一节点标识;
/// 		AParentCategoryID为父节点RowID;
/// 		AIsRecursive指是否递归获取子节点;
/// 		AIsActive指是否有效,如果为空,则不判断有效性;
/// Output:	返回值为临时Global,格式为^CacheTempDHCEPR(UniqueKey,ID)=$lb(Code,Name,Sequence,ParentID,IsActive,Remark)
/// Debug:	d ##Class(EPRservice.DAL.Query.DACategoryInfo).RecursiveSubCategories(111,"",0,"Y","Y")
ClassMethod RecursiveSubCategories(AUniqueKey As %String, ARootCategoryCode As %String, AParentCategoryID As %String, AIsRecursive As %String = "Y", AIsActive As %String = "")
{
	s ParentCode = ""
	if (AParentCategoryID '= "0")
	{
		s objParent = $g(^DHCEPRM.QueryCategoryD(AParentCategoryID))
		s ParentCode = $list(objParent,2)
	}
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s RowID = ""
	for {
		s RowID = $o(^DHCEPRM.QueryCategoryI("IdxParentID"," "_AParentCategoryID,RowID))
		q:(RowID = "")
		
		s objCategory = $g(^DHCEPRM.QueryCategoryD(RowID))
		
		s IsActive = $list(objCategory,6)
		continue:($g(AIsActive) '= "")&&(IsActive '= AIsActive)	
		
		//s Code = $s(ParentCode '= "" :ParentCode_"^"_$list(objCategory,2),1:$list(objCategory,2))
		if (ParentCode = "")
		{
			s Code = $list(objCategory,2)
			s ARootCategoryCode = Code
		}
		else
		{
			s Code = ARootCategoryCode_"^"_$list(objCategory,2)
		}
		
		s Name = $list(objCategory,3)
		s Name = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EPRmeta.Query.QueryCategory","Name",Name,langid)
		s Sequence = $list(objCategory,4)
		s ParentID = $list(objCategory,5)
		s Remark = $list(objCategory,7)
		
		s ^CacheTempDHCEPR(AUniqueKey,RowID) = $lb(Code,Name,Sequence,ParentID,IsActive,Remark)
		if ($zcvt($g(AIsRecursive),"U") = "Y")
		{
			d ..RecursiveSubCategories(AUniqueKey,ARootCategoryCode, RowID,AIsRecursive,AIsActive)	
		}
	}
}

ClassMethod GetRootCode(ACategoryID As %String) As %String
{
	q:(ACategoryID = "0") ""
	
	s objCategory = $g(^DHCEPRM.QueryCategoryD(ACategoryID))
	q:(objCategory = "") ""
	
	s parentID = $list(objCategory,5)
	q:(parentID = "0") $list(objCategory,2)
	
	q ..GetRootCode(parentID)
}

/// Debug:	w ##Class(EPRservice.DAL.Query.DACategoryInfo).GetCategoryIDByCode("HIS")
ClassMethod GetCategoryIDByCode(ACategoryCode As %String) As %String
{
	s ret = ""
	q:($g(ACategoryCode) = "") ret
	s ret = $o(^DHCEPRM.QueryCategoryI("IdxCode", " "_ACategoryCode,""))
	q ret
}

/// Debug:	s objCategory = ##Class(EPRservice.DAL.Query.DACategoryInfo).GetCategoryByID(1)
ClassMethod GetCategoryByID(ACategoryID As %String) As EPRservice.entity.Query.EQueryCategory
{
	s ret = ""
	q:($g(ACategoryID) = "") ret
	
	s objCategory = ##Class(EPRmeta.Query.QueryCategory).%OpenId(ACategoryID)
	q:(objCategory = "") ret
	
	s category = ##Class(EPRservice.entity.Query.EQueryCategory).%New()
	s category.ID = objCategory.%Id()
	s category.Code = objCategory.Code
	s category.Name = objCategory.Name
	s category.Sequence = objCategory.Sequence
	s category.ParentID = objCategory.ParentID
	s category.IsActive = objCategory.IsActive
	s category.Remark = objCategory.Remark
	
 	q category
}

}
