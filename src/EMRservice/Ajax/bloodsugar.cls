Class EMRservice.Ajax.bloodsugar Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1
	s interface = $Get(%request.Data("InterFace",1),"")
	s interface = $zcvt($zcvt(interface,"I","URL"),"I","UTF8")
	s json = ..GetData(interface,episodeId,idxStart,idxLast)
	w json
	Quit $$$OK
}

/// Desc:		血糖列表
/// Creator:	Donglulu
/// CreateDate: 2019-2-13
/// Input:      AInterFace 调用接口标识(默认HIS)
///      		AEpisodeId 就诊ID
/// Output:  	json
/// Debug:		w ##Class(EMRservice.Ajax.bloodsugar).GetData("HIS",194,1,10)
ClassMethod GetData(AInterFace As %String, AEpisodeIds As %String, AIdxStart As %Integer, AIdxLast As %Integer) As %String
{
	s json = ""
	q:(AEpisodeIds = "") "{""total"":0,""rows"":["_json_"]}"
	s count = 0
	s length = $l(AEpisodeIds,",")
	for I=1:1:length
	{
		s episodeId = $p(AEpisodeIds,",",I)
		s ds = ##Class(%Library.ResultSet).%New("web.DHCNurRecComm:getBloodSugarRecord")
		d ds.Execute(episodeId)
		s columCount = ds.GetColumnCount()
		
		While (ds.Next())
		{
			s count = count + 1
			if (((AIdxStart-1)<=(count-1))&&(AIdxLast > count))
			{
				s:(count '= 1) json =json_","
				s json = json_"{"
				for k=1:1:columCount
				{
					s:(k '= 1) json = json_","
					s json = json_""""_ds.GetColumnName(k)_""":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(ds.Data(ds.GetColumnName(k)))_""""
				}
				s json = json_"}"
			}
		}
	}
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

}
