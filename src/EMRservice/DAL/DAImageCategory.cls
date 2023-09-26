Class EMRservice.DAL.DAImageCategory Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.DAL.DAImageCategory","GetAllImageCategories")
Query GetAllImageCategories() As %Query(CONTAINID = 0, ROWSPEC = "ID:%Integer,Name:%String,Description:%String,ParentID:%String,ChildCount:%Integer")
{
}

ClassMethod GetAllImageCategoriesExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.ImageCategoryD(rowID))
		q:(rowID = "")
		
		s objCategory = ##Class(EMRmeta.ImageCategory).%OpenId(rowID)
		
		s name = objCategory.Name
		s desc = objCategory.Description
		s parentID = objCategory.ParentID
		s childCount = ##Class(EMRservice.BOImageLib).GetLibCountByCateID(rowID)
		
		s Data = $lb(rowID,name,desc,parentID,childCount)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	q $$$OK
}

ClassMethod GetAllImageCategoriesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllImageCategoriesExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetAllImageCategoriesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllImageCategoriesExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
