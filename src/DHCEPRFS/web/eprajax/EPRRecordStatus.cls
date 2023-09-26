Class DHCEPRFS.web.eprajax.EPRRecordStatus Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
    s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s userID = $Get(%request.Data("UserID",1),"-1")
	s ctLocID = $Get(%request.Data("CTLocID",1),"-1")
	
	d ..GetUnvalidRecord(episodeID,ctLocID)
	
	Quit $$$OK
}

/// Debug: d ##class(DHCEPRFS.web.eprajax.EPRRecordStatus).GetUnvalidRecord("201764")
ClassMethod GetUnvalidRecord(AEpisodeID As %String, ACTLocID As %String)
{
	w "["
	
	s count=0
	s rset = ##class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLEPRInfo:GetUnvalidSignRecord")
 	s sc = rset.Execute(AEpisodeID, ACTLocID)
 	While rset.Next()
 	{
	 	s count = count + 1
		if (count > 1) 
	 	{	w ","}
	 	
	 	//PrintDocID:
	 	//EPRNum:
	 	//EPRLogsID:
	 	//RecordName:
	 	//RecordStatus:
	 	//SignStatus:
	 	//PrintType:
	 	//HappenDate:
	 	//HappenTime:
	 	//RecordTitle:
	 	w "{OrderID:'"_count_"',"
	 	w "PrintDocID:'"_rset.Data("PrintDocID")_"',"
	 	w "EPRNum:'"_rset.Data("EPRNum")_"',"
		w "RecordName:'"_rset.Data("RecordName")_"',"
	 	w "RecordTitle:'"_rset.Data("RecordTitle")_"',"
	 	w "RecordStatus:'"_rset.Data("RecordStatus")_"',"
	 	w "SignStatus:'"_rset.Data("SignStatus")_"',"
	 	w "HappenDate:'"_rset.Data("HappenDate")_"',"
	 	w "HappenTime:'"_rset.Data("HappenTime")_"'}"
	}

	w "]"
}

}
