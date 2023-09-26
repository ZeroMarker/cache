Class DHCEPRRBAC.web.eprajax.FavoritesCategory Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	s userID = $g(%request.Data("UserID",1),"")
	s desc = $g(%request.Data("Desc",1),"")
	s favoritesCategoryID = $g(%request.Data("FavoritesCategoryID",1),"")
	
	if (action = "getcategorylist")
	{
		d ..GetCategoryListJSON(userID)
	}
	elseif (action = "addcategory")
	{
		w ..AddCategory(userID,desc)
	}
	elseif (action = "deletecategory")
	{
		w ..DeleteCategory(favoritesCategoryID)
	}
	
	Quit $$$OK
}

/// Debug: w ##class(DHCEPRRBAC.web.eprajax.FavoritesCategory).DeleteCategory("1")
ClassMethod DeleteCategory(AFavoritesCategoryID As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLFavoritesCategory).DeleteCategory(AFavoritesCategoryID)
	q ret
}

/// Debug: w ##class(DHCEPRRBAC.web.eprajax.FavoritesCategory).AddCategory("159","收藏分类1")
ClassMethod AddCategory(AUserID As %String, ADesc As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLFavoritesCategory).AddCategory(AUserID,ADesc)
	q ret
}

/// Debug: d ##Class(DHCEPRRBAC.web.eprajax.FavoritesCategory).GetCategoryListJSON("159")
ClassMethod GetCategoryListJSON(AUserID As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLFavoritesCategory:GetCategoryList")
	s sc = result.Execute(AUserID)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""FavoritesCategoryID"":"""_$g(result.Data("FavoritesCategoryID"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""CategoryDesc"":"""_$g(result.Data("CategoryDesc"))_"""")
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

}
