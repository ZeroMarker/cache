Class web.DHCCM.EMRservice.Ajax.vitalsigns Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s item =  $Get(%request.Data("Item",1),"")
 	s Id = $Get(%request.Data("EpisodeID",1),"")
 	s startDateTime = $Get(%request.Data("StartDateTime",1),"")
 	s endDateTime = $Get(%request.Data("EndDateTime",1),"")
 	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	s json = ..GetVitalsigns(Id,item,startDateTime,endDateTime,idxStart,idxLast)
	w json
		
	Quit $$$OK
}

/// Desc:       生命体征信息
/// Creaotr：   Candy
/// Createdate: 2014-8-14
/// Input:
/// D ##Class(web.DHCCM.EMRservice.Ajax.vitalsigns).GetVitalsigns(503,"ITEM1^ITEM2","2014-5-1","2014-8-19",1,10)
ClassMethod GetVitalsigns(AEpisodeID As %String, AItem As %String, AStDate As %String, AEdDate As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	s json = ""
	q:((AEpisodeID = "")||(AItem = "")) "{""total"":0,""rows"":["_json_"]}"
	s AStDate = $Case(AStDate,"":"",:$zdh(AStDate,3))
	s AEdDate = $Case(AEdDate,"":"",:$zdh(AEdDate,3))
	s episodeDate = $ZD($p($g(^PAADM(AEpisodeID)),"^",6),3)
	s ret=##class(web.DHCCM.EMRservice.BL.BLVitalsigns).GetVitalsignsInfo(AEpisodeID,AItem,AStDate,AEdDate)
	for
	{
		s objItm = ret.GetNext(.date)
		q:(date = "")
		s json = json_"{"

		s json = json_"""EpisodeDate"":"""_episodeDate_""","	
		s json = json_"""WriteDate"":"""_date_""""
		for
		{
			s value = objItm.GetNext(.key)
			q:(key = "")
			s json = json_","
			s json = json_""""_key_""":"""_value_"""" 		
		}		
		
		s json = json_"}"
		s json =json_","
	}
	
	s json = $e(json,1,$l(json)-1)
	s json = "{""total"":"_ret.Count()_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

}
