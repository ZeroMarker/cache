Class EPRservice.Quality.GetQualityResult Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s RuleID = $Get(%request.Data("RuleID",1),"-1")
	s EpisodeID = $Get(%request.Data("EpisodeID",1),"-1")
	s SSGroupID = $Get(%request.Data("SSGroupID",1),"-1")
	s CTLocatID = $Get(%request.Data("CTLocatID",1),"-1")
	s Action = $Get(%request.Data("Action",1),"-1")
    q:(EpisodeID = -1) $$$OK 
    //s ^tempyhy("GetQualityResult")=EpisodeID_"^"_SSGroupID_"^"_CTLocatID_"^"_Action
	d ..GetResultJson(EpisodeID,SSGroupID,CTLocatID,Action)
	Quit $$$OK
}

/// d ##class(EPRservice.Quality.GetQualityResult).GetResultJson(76,"100","6")
ClassMethod GetResultJson(AEpisodeID As %String, ASSGroupID As %String, ACTLocatID As %String, AAction As %String) As %String
{
	q:AEpisodeID="" $$$OK
	s json = "["
	s isFirstNode = 1
	s TotalCount = 0
	//s ^tempyhy("GetQualityResult")=EpisodeID_"^"_SSGroupID_"^"_CTLocatID_"^"_AAction
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BOManualCheck:GetManualResult")
	d result.Execute(AEpisodeID,ASSGroupID,ACTLocatID,AAction)
	
	while result.Next()
		{
			if (isFirstNode = 0 ) {s json = json_","}
	 		s json = json_"{CtLocName:'"_(result.Data("CtLocName"))_"',"
	 		s json = json_"EmployeeName:'"_(result.Data("EmployeeName"))_"',"
	  		s json = json_"EntryName:'"_result.Data("EntryTitle")_"',"
	  		s json = json_"SignUserName:'"_result.Data("SignUserName")_"',"
	  		s json = json_"EntryID:'"_result.Data("EntryDR")_"',"
	  		s json = json_"EntryScore:'"_result.Data("EntryScore")_"',"
	  		s json = json_"ReportDate:'"_result.Data("ExamineDate")_"',"
	  		s json = json_"LocID:'"_result.Data("CtLocDr")_"',"
	  		s json = json_"EmployeeID:'"_result.Data("EmployeeDr")_"',"
	  		s json = json_"ResultID:'"_result.Data("ResultID")_"',"
	  		s json = json_"DetailID:'"_result.Data("DetailID")_"',"
			s json = json_"ResultDetailID:'"_result.Data("ResultDetailID")_"',"
			s json = json_"MessageFlag:'"_result.Data("MessageFlag")_"',"
	  		s json = json_"ResumeText:'"_result.Data("ResumeText")_"',"
	  		s json = json_"InstanceId:'"_result.Data("InstanceId")_"',"
	  		s json = json_"EmrDocId:'"_result.Data("EmrDocId")_"',"
	  		s json = json_"ExamCount:'"_result.Data("ExamCount")_"',"
	  		s json = json_"Path:'"_result.Data("Path")_"',"
			s json = json_"SignUserID:'"_result.Data("SignUserDR")_"'}"
	 		s isFirstNode = 0
			s TotalCount = TotalCount+1
		}
	s json = json_"]"
	w "{"
    w "TotalCount:'"_TotalCount_"'"
    w ",data:"_json_"}"
}

}
