Class DHCEPRFS.BL.BLMRSubCategory Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetTypeParamByMRItemID(AMRItemID As %String) As %String
{
	q:(AMRItemID = "") "-1"
	s objItem = ##class(DHCEPRFS.META.MRItem).%OpenId(AMRItemID)
	s subCategoryID = objItem.MRSubCategoryID
	q:(subCategoryID = "") "-1"
	s obj = ##class(DHCEPRFS.META.MRSubCategory).%OpenId(subCategoryID)
	s ret = obj.TypeParam
	q ret
}

/// Desc:	创建归档病历大类	
ClassMethod CreateSubCategory(ACode As %String, AName As %String, ADescription As %String, AMRCategoryID As %String, ATypeParam As %String = "") As %String
{
	s obj = ##Class(DHCEPRFS.META.MRSubCategory).%New()
	s obj.Code = ACode
	s obj.Name = AName
	s obj.Description = ADescription
	s obj.MRCategoryID = AMRCategoryID
	s obj.TypeParam = ATypeParam
	
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

ClassMethod UpdateSubCategory(ACode As %String, AName As %String, ADescription As %String, AMRCategoryID As %String) As %String
{
	s mrSubCategoryID = ..GetSubCategoryIDByCode(ACode)
	q:(mrSubCategoryID="") "0"
	
	s obj = ##Class(DHCEPRFS.META.MRSubCategory).%OpenId(mrSubCategoryID)
	q:(obj="") "0"
	
	s obj.Code = ACode
	s obj.Name = AName
	s obj.Description = ADescription
	s obj.MRCategoryID = AMRCategoryID
	
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

ClassMethod GetSubCatetoryByCode(ACode As %String) As DHCEPRFS.META.MRCategory
{
	s rowID = ..GetSubCategoryIDByCode(ACode)
	q:(rowID = "") ""
	
	s obj = ##Class(DHCEPRFS.META.MRSubCategory).%OpenId(rowID)
	q:(obj="") ""
	
	s entity = ##Class(DHCEPRFS.Entity.EMRSubCategory).%New()
	s entity.Code = obj.Code
	s entity.Name = obj.Name
	s entity.Description = obj.Descprition
	s entity.MRCategoryID = obj.MRCategoryID
	
	q entity
}

ClassMethod GetSubCategoryIDByCode(ACode As %String) As %String
{
	q:(ACode="") ""
	s rowID = $O(^DHCEPRFS.META.MRSubCategoryI("IdxMain"," "_$zcvt(ACode,"u"),""))
	q rowID
}

Query GetAll() As %Query(ROWSPEC = "MRSubCateogryID:%String,MRCateogryID:%String,Code:%String,Name:%String,Description:%String")
{
}

ClassMethod GetAllExecute(ByRef qHandle As %Binary) As %Status
{
	Quit $$$OK
}

ClassMethod GetAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllExecute ]
{
	Quit $$$OK
}

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Quit $$$OK
}

}
