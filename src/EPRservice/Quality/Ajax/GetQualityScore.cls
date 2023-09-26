Class EPRservice.Quality.Ajax.GetQualityScore Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
 s EpisodeID = $Get(%request.Data("EpisodeID",1),"-1")
 s Action = $Get(%request.Data("Action",1),"-1")
 s ARuleIDs = $Get(%request.Data("ARuleIDs",1),"-1")
 //s:(Action="D") ARuleIDs="1"
 //s:(Action="A") ARuleIDs="1"
 d ..GetResultScore(EpisodeID,ARuleIDs,Action)
 Quit $$$OK
}

/*
/// d ##class(EPRservice.Quality.Ajax.GetQualityScore).GetResultScoreJson(281,118,400,"A")
ClassMethod GetResultScoreJson(AEpisodeID As %String, ARuleIDs As %String, AAction As %String) As %String
{
	
	q:(AEpisodeID="")||(ARuleIDs="") "[]"
	s json = "["
	s isFirstNode = 1
	s TotalCount = 0
	
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetDocQualityScore")
	d result.Execute(AEpisodeID,ARuleIDs,AAction)
	
	while result.Next()
		{
			if (isFirstNode = 0 ) {s json = json_","}
	 		s json = json_"{""Score"":"""_(result.Data("FinalScore"))_""","

	  		s json = json_"""Grade"":"""_result.Data("FinalGrade")_"""}"
	 		s isFirstNode = 0
			s TotalCount = TotalCount+1
		}
	s json = json_"]"
	w json
}
*/
/// d ##class(EPRservice.Quality.Ajax.GetQualityScore).GetResultScore(281,118,400,"A")
ClassMethod GetResultScore(AEpisodeID As %String, ARuleIDs As %String, AAction As %String) As %String
{
	s result=""
	q:(AEpisodeID="")||(ARuleIDs="") result
	
	
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality:GetDocQualityScore")
	d result.Execute(AEpisodeID,ARuleIDs,AAction)
	
	while result.Next()
		{
			 s Score=result.Data("FinalScore")
		}
	s result=Score
	w result
}

}
