/// Creator:Candyxu
/// Create Date 2012-08
/// Desc: Template的业务层
Class EPRservice.BLL.BLTemplateCategory Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:Candyxu
/// Desc:获得扫描目录
/// Input:PProperty:目录属性 PhotoScan
/// Debug:do ##class(%ResultSet).RunQuery("EPRservice.BLL.BLTemplateCategory","GetCategoryByProperty","PHOTOSCAN") 
Query GetCategoryByProperty(PProperty As %String) As %Query(ROWSPEC = "AID:%String,AName:%String,AParentID:%String,ADescription:%String,AReschildCount:%String,ACategoryType:%String,ACategoryPropty:%String")
{
}

ClassMethod GetCategoryByPropertyExecute(ByRef qHandle As %Binary, PProperty As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	if PProperty = $c(0) s PProperty = ""
 	q:(PProperty = "") $$$OK
 	s TempIDs = ""
	s RowID = ""
	for {
		s RowID = $o(^DHCEPRM.TemplateCategoryI("IdxCategoryProperty"," "_PProperty,RowID))
		q:(RowID = "")
		s ID = RowID
		d SetData
		/*
		for {
			q:(ParentID = 0)
            s ID = ParentID
            s ParentID = $li(^DHCEPRM.TemplateCategoryD(ID),4)
            continue:($F(TempIDs,ID) '= 0)
            d SetData
		}
		*/
	}
	Quit $$$OK
SetData
	s Description = $li(^DHCEPRM.TemplateCategoryD(ID),2)		
	s Name = $li(^DHCEPRM.TemplateCategoryD(ID),3)
	s ParentID = $li(^DHCEPRM.TemplateCategoryD(ID),4)
	s ResChildCount = $li(^DHCEPRM.TemplateCategoryD(ID),5)
	s CategoryProperty = $li(^DHCEPRM.TemplateCategoryD(ID),6)
	s CategoryType = $li(^DHCEPRM.TemplateCategoryD(ID),7)
	s TempIDs = TempIDs_","_ID
  	s data = $lb(ID,Name,ParentID,Description,ResChildCount,CategoryType,CategoryProperty)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
}

ClassMethod GetCategoryByPropertyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCategoryByPropertyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCategoryByPropertyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCategoryByPropertyExecute ]
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

}
