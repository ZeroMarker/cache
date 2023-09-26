Class DHCEPRRBAC.web.eprajax.Favorites Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	s pageSize = $g(%request.Data("rows",1),"")
	s pageNum = $g(%request.Data("page",1),"")
	s startRow = (pageNum -1)*pageSize + 1
	s endRow = startRow + pageSize -1
	
	s episodeID = $g(%request.Data("EpisodeID",1),"")
	s favoritesCategoryID = $g(%request.Data("FavoritesCategoryID",1),"")
	s userID = $g(%request.Data("UserID",1),"")
	
	s favoritesIDS = $g(%request.Data("FavoritesIDS",1),"")
	s episodeIDS = $g(%request.Data("EpisodeIDS",1),"")
	
	if (action = "add")
	{
		d ..Add(episodeID,favoritesCategoryID,userID)
	}
	elseif (action = "delete")
	{
		d ..Delete(favoritesIDS)
	}
	elseif (action = "move")
	{
		d ..Move(favoritesCategoryID,favoritesIDS,episodeIDS)
	}
	elseif (action = "getlist")
	{
		d ..GetListJSON(userID,favoritesCategoryID,startRow,endRow)
	}
	
	Quit $$$OK
}

/// Debug: d ##Class(DHCEPRRBAC.web.eprajax.Favorites).Add("573","4","159")
ClassMethod Add(AEpisodeID As %String, AFavoritesCategoryID As %String, AUserID As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLFavorites).Add(AEpisodeID,AFavoritesCategoryID,AUserID)
	w ret
}

/// Debug: d ##Class(DHCEPRRBAC.web.eprajax.Favorites).Move("4","9^10","135^137")
ClassMethod Move(AFavoritesCategoryID As %String, AFavoritesIDS As %String, AEpisodeIDS As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLFavorites).Move(AFavoritesCategoryID,AFavoritesIDS,AEpisodeIDS)
	w ret
}

/// Debug: d ##Class(DHCEPRRBAC.web.eprajax.Favorites).Delete("9^10")
ClassMethod Delete(AFavoritesIDS As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLFavorites).Delete(AFavoritesIDS)
	w ret
}

/// Debug: d ##Class(DHCEPRRBAC.web.eprajax.Favorites).GetListJSON("159","12",1,20)
ClassMethod GetListJSON(AUserID As %String, AFavoritesCategoryID As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	s result = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLFavorites:GetList")
	s sc = result.Execute(AUserID,AFavoritesCategoryID)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		if (count >= AIdxStart) && (count <= AIdxLast)
		{
			if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""FavoritesID"":"""_$g(result.Data("FavoritesID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAStatusType"":"""_$g(result.Data("PAStatusType"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAAdmType"":"""_$g(result.Data("PAAdmType"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAAdmDate"":"""_$g(result.Data("PAAdmDate"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAAdmTime"":"""_$g(result.Data("PAAdmTime"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAAdmLoc"":"""_$g(result.Data("PAAdmLoc"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PADischgeDate"":"""_$g(result.Data("PADischgeDate"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PADischgeTime"":"""_$g(result.Data("PADischgeTime"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PAAdmDoc"":"""_$g(result.Data("PAAdmDoc"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PayMode"":"""_$g(result.Data("PayMode"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""MedRecordNo"":"""_$g(result.Data("MedRecordNo"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""RegNo"":"""_$g(result.Data("RegNo"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

}
