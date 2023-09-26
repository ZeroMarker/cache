Class EMRservice.Ajax.getActionsLogsForBrowser Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s StartDate = $Get(%request.Data("StartDate",1),"")
	s EndDate = $Get(%request.Data("EndDate",1),"")
	s UserCode = $Get(%request.Data("UserCode",1),"")
	s UserID = $Get(%request.Data("UserID",1),"")
	s AuditFlag = $Get(%request.Data("AuditFlag",1),"")
	s Model = $Get(%request.Data("Model",1),"")
	s Type = $Get(%request.Data("Type",1),"")
	s Conditions = $Get(%request.Data("Conditions",1),"")
	
	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s:(page = 1) idxStart = page,idxLast = idxStart + rows -1	
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	
	w ..getActionsLogsForBrowser(StartDate,EndDate,UserCode,UserID,AuditFlag,Model,Type,Conditions,idxStart,idxLast)
	Quit $$$OK
}

/// w ##Class(EMRservice.Ajax.getActionsLogsForBrowser).getActionsLogsForBrowser("2015-04-17","2015-04-17","","","N","","","","1","10")
ClassMethod getActionsLogsForBrowser(AStartDate As %String, AEndDate As %String, AUserCode As %String, AUserID As %String, AuditFlag As %String, AModel As %String, AType As %String, AConditions As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	if (AUserCode '= "")&&(AUserID = "")
	{
		s UserID = ""
		for
		{
			s UserID = $O(^SSU("SSUSR",0,"SSUSR_Initials",AUserCode,UserID))
			q:UserID=""
			s AUserID = UserID
		}
	}
	//s ^tempncc("0") = "123^"_AStartDate_"^"_AEndDate_"^"_AUserID_"^"_AuditFlag_"^"_AModel_"^"_AType_"^"_AConditions_"^"_AIdxStart_"^"_AIdxLast
	s result = ##Class(%ResultSet).%New("EMRservice.BL.BLActionsLogsInfo:GetActionsLogsList")
	s sc = result.Execute(AStartDate,AEndDate,AUserID,AuditFlag,AModel,AType,AConditions)
 	
 	s json = ""
 	s count = 0
	While (result.Next())
 	{
	 	if ( AIdxStart-1 <= count) && (AIdxLast > count )
		{
		 	s json = json_"{""EventLogRowID"":"""_$g(result.Data("EventLogRowID"))_""","
		 	s json = json_"""PatName"":"""_$g(result.Data("PatName"))_""","
		 	s json = json_"""PapmiNo"":"""_$g(result.Data("PapmiNo"))_""","
		 	s json = json_"""MedicareNo"":"""_$g(result.Data("MedicareNo"))_""","
		 	s json = json_"""LogModelDr"":"""_$g(result.Data("LogModelDr"))_""","
		 	s json = json_"""LogModelDesc"":"""_$g(result.Data("LogModelDesc"))_""","
		 	s json = json_"""LogModelCode"":"""_$g(result.Data("LogModelCode"))_""","
		 	s json = json_"""DetComputerIP"":"""_$g(result.Data("DetComputerIP"))_""","
		 	s json = json_"""DetComputerMac"":"""_$g(result.Data("DetComputerMac"))_""","
		 	s json = json_"""DetComputerName"":"""_$g(result.Data("DetComputerName"))_""","
		 	s json = json_"""DetGroupDr"":"""_$g(result.Data("DetGroupDr"))_""","
		 	s json = json_"""DetGroupDesc"":"""_$g(result.Data("DetGroupDesc"))_""","
		 	s json = json_"""DetLocDr"":"""_$g(result.Data("DetLocDr"))_""","
		 	s json = json_"""DetLocDesc"":"""_$g(result.Data("DetLocDesc"))_""","
		 	s json = json_"""DetDate"":"""_$g(result.Data("DetDate"))_""","
		 	s json = json_"""DetTime"":"""_$g(result.Data("DetTime"))_""","
		 	s json = json_"""DetUserDr"":"""_$g(result.Data("DetUserDr"))_""","
		 	s json = json_"""DetUserName"":"""_$g(result.Data("DetUserName"))_""","
		 	s json = json_"""DetConditions"":"_$g(result.Data("DetConditions"))_"}"
		 	s json = json_"," 
		 }
		 s count = count + 1
	}
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s json = $e(json,1,$l(json)-1)
	
	s ret = "{""total"":"_count_",""rows"":["_json_"]}"
	q ret
}

}
