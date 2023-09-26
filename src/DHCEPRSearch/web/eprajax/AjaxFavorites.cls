Class DHCEPRSearch.web.eprajax.AjaxFavorites Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s mrEpisodeID = $Get(%request.Data("MREpisodeID",1),"-1")
	s mrVerItemsID = $Get(%request.Data("MRVerItemsID",1),"-1")
	s userID = $Get(%request.Data("UserID",1),"-1")
	s docName = $Get(%request.Data("DocName",1),"-1")
	s notes = $Get(%request.Data("Notes",1),"-1")
	s tags = $Get(%request.Data("Tags",1),"-1")
	s action = $Get(%request.Data("Action",1),"-1")
	s favoritesID = $g(%request.Data("FavoritesID",1),"")
	
	if (action = "add")
	{	
		d ..Add(mrEpisodeID,mrVerItemsID,userID,docName,notes,tags)
	}
	elseif (action = "delete")
	{	
		d ..DeleteFavorites(favoritesID)
	}
	elseif (action="getmydoc")
	{
		d ..GetMyDoc(userID)
	}
	
	Quit $$$OK
}

/// debug: w ##class(DHCEPRSearch.web.eprajax.AjaxFavorites).Add(3,6,159,"adsf","adf","zv")
ClassMethod Add(AMREpisodeID As %String, AMRVerItemsID As %String, AUserID As %String, ADocName As %String, ANotes As %String, ATags As %String) As %String
{
	s ret = ##class(DHCEPRSearch.BL.BLFavorites).Create(AMREpisodeID,AMRVerItemsID,AUserID,ADocName,ANotes,ATags)
	w ret
}

/// debug: d ##class(DHCEPRSearch.web.eprajax.AjaxFavorites).DeleteFavorites("7")
ClassMethod DeleteFavorites(AFavoritesID As %String) As %String
{
	s ret = ##class(DHCEPRSearch.BL.BLFavorites).DeleteFavorites(AFavoritesID)
	w ret
}

/// debug: d ##class(DHCEPRSearch.web.eprajax.AjaxFavorites).GetMyDoc(159)
ClassMethod GetMyDoc(AUserID As %String) As %String
{
	q:(AUserID = "") ""
	
	w "{""rows"":["
	
	s count = 0
		
	s rowID = ""
	for {
		s rowID = $O(^DHCEPRSearch.INST.FavoritesI("IdxUserID", " "_AUserID,rowID))
		//b "s"
		q:(rowID = "")
		s obj = ##class(DHCEPRSearch.INST.Favorites).%OpenId(rowID)
		s DocName = obj.DocName
		s Tags = obj.Tags
		s Notes = obj.Notes
		s MREpisodeID = obj.MREpisodeID
		s MRVerItemID = obj.MRVerItemID
		s AddDate = $zd(obj.AddDate,3)
		s AddTime = $zt(obj.AddTime,3)
		s count = count + 1
		if (count > 1) w ","
		w "{"
		w ..TrimEnter("""FavoritesID"":"""_rowID_""",")
		w ..TrimEnter("""DocName"":"""_DocName_""",")
		w ..TrimEnter("""Tags"":"""_Tags_""",")
		w ..TrimEnter("""Notes"":"""_Notes_""",")
		w ..TrimEnter("""MREpisodeID"":"""_MREpisodeID_""",")
		w ..TrimEnter("""MRVerItemID"":"""_MRVerItemID_""",")
		w ..TrimEnter("""AddDateTime"":"""_AddDate_" "_AddTime_"""")
		w "}"
	}
	w "],""total"":"_count_"}"
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

}
