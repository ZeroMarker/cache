Class DHCEPRFS.web.eprajax.AjaxPDFView Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"")
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s roleID = $Get(%request.Data("RoleID",1),"")
	s dataServiceUrl = $Get(%request.Data("DataServiceUrl",1),"")
	
	if (action = "pdfpath")
	{
		d ..GetPDFPathByEpisodeID(episodeID,"","209")
	}
	elseif (action = "pdfpathlist")
	{
		d ..GetPDFPathInfoJSON(episodeID,dataServiceUrl)
	}
	elseif (action = "applypdfpathlist")
	{
		d ..GetApplyPDFPathInfoJSON(episodeID,roleID,"1",dataServiceUrl)
	}
	Quit $$$OK
}

ClassMethod GetPDFPathByEpisodeID(AEpisodeID As %String, ASchemeID As %String, AMRItemID As %String) As %String
{
	s ret = ##class(DHCEPRFS.BL.BLPDFView).GetPDFPathByEpisodeID(AEpisodeID,ASchemeID,AMRItemID)
	w ret
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AjaxPDFView).GetPDFPathInfoJSON("1371","http://127.0.0.1/dthealth/web/")
ClassMethod GetPDFPathInfoJSON(AEpisodeID As %String, ADataServiceUrl As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLPDFView:GetPDFPathInfo")
	s sc = result.Execute(AEpisodeID,ADataServiceUrl)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""ItemCode"":"""_$g(result.Data("ItemCode"))_""",")
		w ..TrimEnter("""ItemName"":"""_$g(result.Data("ItemName"))_""",")
		w ..TrimEnter("""ItemDesc"":"""_$g(result.Data("ItemDesc"))_""",")
		w ..TrimEnter("""FilePath"":"""_$g(result.Data("FilePath"))_"""")
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

/// Debug: d ##Class(DHCEPRFS.web.eprajax.AjaxPDFView).GetApplyPDFPathInfoJSON("1371","1","1","http://127.0.0.1/dthealth/web/")
ClassMethod GetApplyPDFPathInfoJSON(AEpisodeID As %String, ARoleID As %String, AOperationID As %String, ADataServiceUrl As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLPDFView:GetApplyPDFPathInfo")
	s sc = result.Execute(AEpisodeID,ARoleID,AOperationID,ADataServiceUrl)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""ItemCode"":"""_$g(result.Data("ItemCode"))_""",")
		w ..TrimEnter("""ItemName"":"""_$g(result.Data("ItemName"))_""",")
		w ..TrimEnter("""ItemDesc"":"""_$g(result.Data("ItemDesc"))_""",")
		w ..TrimEnter("""FilePath"":"""_$g(result.Data("FilePath"))_"""")
		w "}"
		s first = 0
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
