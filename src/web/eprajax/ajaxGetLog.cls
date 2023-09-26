Class web.eprajax.ajaxGetLog Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $Get(%request.Data("EpisodeID",1),"-1")
	s docID = $Get(%request.Data("PrintDocID",1),"-1")
	s eprNum = $Get(%request.Data("EPRNum",1),"-1")
	//w episodeID_"^"_docID_"^"_eprNum
	
	d ..GetHistoryLog(episodeID, docID, eprNum)
	
	//W "["
	//W "{Info:'endstatus1'},{Info:'endstatus2'}"
	//W "]"
	
	q $$$OK
}

/// Debug: d ##class(web.eprajax.ajaxGetLog).GetHistoryLog("201764","3","1")
ClassMethod GetHistoryLog(argEpisodeID As %String, argDocID As %String, argEPRNum As %String)
{
	s showDetailOper = ##class(EPRmeta.SysOption).GetOptionValueByName("ShowDetailOper")
	q:(showDetailOper '= "Y") 
	
	w "["
	
	s count=0
	s rset = ##class(%ResultSet).%New("EPRservice.BOEPRLogs:GetAllLogInfo")
 	s sc = rset.Execute(argEpisodeID,argDocID,argEPRNum)
 	While rset.Next()
 	{
		if (count > 0) 
	 	{	w ","}
	 	
	 	w "{OrderID:'"_rset.Data("OrderID")_"',"
	 	w "UserName:'"_rset.Data("UserName")_"',"
	 	w "OperDate:'"_rset.Data("OperDate")_"',"
		w "OperTime:'"_rset.Data("OperTime")_"',"
	 	w "MachineIP:'"_rset.Data("MachineIP")_"',"
	 	w "Action:'"_rset.Data("Action")_"',"
	 	w "TplName:'"_rset.Data("TplName")_"',"
	 	w "TplCreateDate:'"_rset.Data("TplCreateDate")_"',"
	 	w "TplCreateTime:'"_rset.Data("TplCreateTime")_"'}"
	 	
	 	s count = count + 1
	}

	w "]"
}

}
