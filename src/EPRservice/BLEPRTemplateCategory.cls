Class EPRservice.BLEPRTemplateCategory Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod GetCategoryInfoByIDsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCategoryInfoByIDsExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCategoryInfoByIDsExecute(ByRef qHandle As %Binary, AEPRTemplateCategoryIDs As %String) As %Status
{
	Set repid=$i(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	q:(AEPRTemplateCategoryIDs = "") $$$OK
	s result = ""
	
	s count = $L(AEPRTemplateCategoryIDs, "^")
	for i = 1:1:count
	{
		s id = $P(AEPRTemplateCategoryIDs, "^", i)
		continue:(id = "")
		
		s obj = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(id)
		continue:(obj = "")
		
		s name = obj.CategoryName
		s obj = ""
		
		s fullParentName = ..GetFullParentName(id)
		s fullParentName = $tr(fullParentName, "^", "")
		
		s ^CacheTemp(repid, ind) = $LB(id, name, fullParentName)
		s ind = ind + 1
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetCategoryInfoByIDsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCategoryInfoByIDsExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 		//清空临时数据，解决被%XML.DataSet封装后无法自动清空临时数据问题[Cache Bug]
 		//kill ^CacheTemp(repid)	
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 	Desc:	获取目录名称信息
/// 	Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.BLEPRTemplateCategory","GetCategoryInfoByIDs", "1^2^3^13")		
Query GetCategoryInfoByIDs(AEPRTemplateCategoryIDs As %String) As %Query(ROWSPEC = "EPRTemplateCategoryID:%String,Name:%String,FullParentName:%String")
{
}

/// Desc:	获取父目录的名称
/// Debug:	w ##Class(EPRservice.BLEPRTemplateCategory).GetFullParentName("2")
ClassMethod GetFullParentName(AEPRTemplateCategoryID As %String) As %String
{
	q:(AEPRTemplateCategoryID = "") ""
	s fullParentName = ""
	
	s obj = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(AEPRTemplateCategoryID)
	q:(obj = "") ""
	
	s parentID = obj.ParentCategoryID
	s obj = ""
	for {
		q:(parentID = "")
		q:(parentID = "0")
		
		s objParent = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(parentID)
		q:(objParent = "")
		
		if (fullParentName = "")
		{	s fullParentName = objParent.CategoryName}
		else
		{	s fullParentName = objParent.CategoryName_"."_fullParentName}
		
		s parentID = objParent.ParentCategoryID
	}
	
	q fullParentName
}

}
