Class EPRservice.Quality.Ajax.QualityInfoShow Extends (%RegisteredObject, %Library.DynamicAbstractObject)
{

/// w ##class(EPRservice.Quality.Ajax.QualityInfoShow).GetEmrQualityQty(3159,"2_29_110")
ClassMethod GetEmrQualityQty(EpisodeID As %String, Param As %String) As %String
{
	s JsonObj=[]
	s JsonData={}
	s QCCount=0,DQCCount=0
	s ChronergyeCount=0
	
	Set rset=##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityMessage.GetMessagesByEpisodeID")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(EpisodeID,"","A")
		If 'Status Quit
		while(rset.Next()){
			s QCCount=QCCount+1
		}
	}
	d rset.Close()
	Set rset=##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityMessage.GetMessagesByEpisodeID")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(EpisodeID,"","D")
		If 'Status Quit
		while(rset.Next()){
			s DQCCount=DQCCount+1
		}
	}
	d rset.Close()
	// EPRservice.Quality.BORunTimeQuality.GetPromptList
	Set rset=##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality.GetQualityResultList")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(EpisodeID,Param)
		If 'Status Quit
		while(rset.Next()){
			s ChronergyeCount=ChronergyeCount+1
		}
	}
	d rset.Close()
	
	/*
	s Action="A"
	s RuleID = "1^6"
	s GetDischTime2 = ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischTime2(EpisodeID)
	s:(GetDischTime2'="") Action="D"
	s:(GetDischTime2'="") RuleID = "1^7"
	s Score = ##Class(EPRservice.Quality.Ajax.GetQualityScore).GetResultScorexx(EpisodeID,RuleID,Action)
	*/
	
	do JsonData.%Set("QCCount",QCCount_"")
	do JsonData.%Set("DQCCount",DQCCount_"")
	do JsonData.%Set("ChronergyeCount",ChronergyeCount_"")
	//do JsonData.%Set("Score",Score_"")
	do JsonObj.%Push(JsonData,"")
	
	s obj=##class(%Library.GlobalCharacterStream).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	s JsonStr=$replace(JsonStr,"""","'")
	q JsonStr
}

}
