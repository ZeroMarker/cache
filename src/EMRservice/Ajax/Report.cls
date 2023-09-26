Class EMRservice.Ajax.Report Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	s json= ..GetJson(episodeId)
	w json
	Quit $$$OK
}

/// w ##Class(EMRservice.Ajax.Report).GetJson("1")
ClassMethod GetJson(AEpisodeIds As %String) As %String
{
	s json=""
	s count=0
	q:(AEpisodeIds = "") "{""total"":0,""rows"":["_json_"]}"
	
	s length = $l(AEpisodeIds,",")
	for I=1:1:length
	{
		s episodeId = $p(AEpisodeIds,",",I)
		s ds = ##Class(%Library.ResultSet).%New("Nur.Interface.Report:Scale4EPR")
		d ds.Execute(episodeId)
		While (ds.Next())
		{
			s count = count + 1
			d setJson
		}
	}
	s json = $e(json,1,$l(json)-1)
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
setJson
	s json = json_"{"
	s json = json_"""EmrDate"":"""_ds.Data("EmrDate")_""","
	s json = json_"""JSKSFPG"":"""_ds.Data("JSKSFPG")_""","
	s json = json_"""BSEPG"":"""_ds.Data("BSEPG")_"""," 
	s json = json_"""DDZCPG"":"""_ds.Data("DDZCPG")_"""," 
	s json = json_"""SJMPG"":"""_ds.Data("SJMPG")_""","
	s json = json_"""YCPG"":"""_ds.Data("YCPG")_""","
	s json = json_"""WXZXPG"":"""_ds.Data("WXZXPG")_""""
	s json = json_"}"	
	s json =json_","
}

}
