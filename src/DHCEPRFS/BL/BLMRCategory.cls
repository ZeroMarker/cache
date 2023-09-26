Class DHCEPRFS.BL.BLMRCategory Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	创建归档病历大类	
ClassMethod CreateCategory(ACode As %String, AName As %String, ADescription As %String) As %String
{
	s obj = ##Class(DHCEPRFS.META.MRCategory).%New()
	s obj.Code = ACode
	s obj.Name = AName
	s obj.Description = ADescription
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

ClassMethod UpdateCategory(ACode As %String, AName As %String, ADescription As %String) As %String
{
	s mrCategoryID = ..GetCategoryIDByCode(ACode)
	q:(mrCategoryID="") "0"
	
	s obj = ##Class(DHCEPRFS.META.MRCategory).%OpenId(mrCategoryID)
	q:(obj="") "0"
	
	s obj.Code = ACode
	s obj.Name = AName
	s obj.Description = ADescription
	
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

ClassMethod GetCatetoryByCode(ACode As %String) As DHCEPRFS.META.MRCategory
{
	s rowID = ..GetCategoryIDByCode(ACode)
	q:(rowID = "") ""
	
	s obj = ##Class(DHCEPRFS.META.MRCategory).%OpenId(rowID)
	q:(obj="") ""
	
	s entity = ##Class(DHCEPRFS.Entity.EMRCategory).%New()
	s entity.Code = obj.Code
	s entity.Name = obj.Name
	s entity.Description = obj.Descprition
	
	q entity
}

ClassMethod GetCategoryIDByCode(ACode As %String) As %String
{
	q:(ACode="") ""
	s rowID = $O(^DHCEPRFS.META.MRCategoryI("IdxMain"," "_$zcvt(ACode,"u"),""))
	q rowID
}

Query GetAll() As %Query(ROWSPEC = "MRCateogryID:%String,Code:%String,Name:%String,Description:%String")
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
