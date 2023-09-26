Class DHCEPRRBAC.BL.BLFavoritesCategory Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug: w ##class(DHCEPRRBAC.BL.BLFavoritesCategory).DeleteCategory("153")
ClassMethod DeleteCategory(AFavoritesCategoryID As %String)
{
	s return = "0"
	q:(AFavoritesCategoryID = "") return
	
	s flag = "true"
	TSTART
	s $zt = "OnDeleteErrorHandler"
	
	s return = "-1"
	s sc = ##class(DHCEPRRBAC.INST.FavoritesCategory).%DeleteId(AFavoritesCategoryID)
	if ($$$ISERR(sc))
	{
		TROLLBACK
		q return
	}
	
	s return = "-2"
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRRBAC.INST.FavorI("IdxCategoryID"," "_AFavoritesCategoryID,rowID))
		q:(rowID = "")
		s sc = ##class(DHCEPRRBAC.INST.Favorites).%DeleteId(rowID)	
		if ($$$ISERR(sc))
		{
			s flag = "false"
			q
		}
	}
	if (flag = "false")
	{
		TROLLBACK
		q return
	}
	
	TCOMMIT
	s return = "1"
	q return
OnDeleteErrorHandler
	TROLLBACK
	q "-100"
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLFavoritesCategory).AddCategory("9","收藏分类1")
ClassMethod AddCategory(AUserID As %String, ADesc As %String)
{
	q:(AUserID = "")||(ADesc = "") "0"
	s obj = ##class(DHCEPRRBAC.INST.FavoritesCategory).%New()
	s obj.CategoryDesc = ADesc
	s obj.UserID = AUserID
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s sc = obj.%Save()
	q:($$$ISOK(sc)) "1"
	q "-1"
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLFavoritesCategory","GetCategoryList","159")
Query GetCategoryList(AUserID As %String) As %Query(ROWSPEC = "FavoritesCategoryID:%String,CategoryDesc:%String")
{
}

ClassMethod GetCategoryListExecute(ByRef qHandle As %Binary, AUserID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	q:(AUserID = "") $$$OK
	
	s date = ""
	for {
		s date = $o(^DHCEPRRBAC.INST.FavorCatI("IdxUserID"," "_AUserID,date))
		q:(date = "")
		
		s time = ""
		for {
			s time = $o(^DHCEPRRBAC.INST.FavorCatI("IdxUserID"," "_AUserID,date,time))
			q:(time = "")
			
			s rowID = ""
			for {
				s rowID = $o(^DHCEPRRBAC.INST.FavorCatI("IdxUserID"," "_AUserID,date,time,rowID))
				q:(rowID = "")
				
				s obj = ##class(DHCEPRRBAC.INST.FavoritesCategory).%OpenId(rowID)
				s desc = obj.CategoryDesc
				
				s ^CacheTemp(repid,ind) = $lb(rowID,desc)
				s ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod GetCategoryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCategoryListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCategoryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCategoryListExecute ]
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
