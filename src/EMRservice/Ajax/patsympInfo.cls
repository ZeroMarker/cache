Class EMRservice.Ajax.patsympInfo Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	s Id = $Get(%request.Data("ID",1),"")
	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	s action = $Get(%request.Data("Action",1),"")
	s interface = $Get(%request.Data("InterFace",1),"")
	s interface = $zcvt($zcvt(interface,"I","URL"),"I","UTF8")
	s date = $Get(%request.Data("Date",1),"")
	if (action = "GetPatSympInfo")
	{
 		w ..GetPatSympInfo(interface,episodeId,date,idxStart,idxLast)
	}
	Quit $$$OK
}

/// Desc:       取每日症状情况
/// Creator:    Donglulu
/// Createdate: 2020-4-3
/// Input:      AInterFace 调用接口标识(默认HIS) 
///             AEpisodeID:就诊号
///             ADate:查询日期（格式：2020-04-01）
/// OutPut:     
/// debug:      w ##Class(EMRservice.Ajax.patsympInfo).GetPatSympInfo("HIS","","","","")
ClassMethod GetPatSympInfo(AInterFace As %String, AEpisodeID As %String, ADate As %String, AIdxStart As %Integer, AIdxLast As %Integer) As %String
{
	s json = ""
	s count = 0
	q:(AEpisodeID = "") "{""total"":0,""rows"":["_json_"]}"

	s result = ##class(%ResultSet).%New("web.PatSympInfoXTS:GetPatSympInfo")
	d result.Execute(AEpisodeID,ADate)
	
	s columCount = result.GetColumnCount()
	while result.%Next()
	{
		s i = count + 1
		if ((AIdxStart <= i)&(i <= AIdxLast))
		{
			s:(json'= "") json = json_","
			s json = json_"{"
			for k=1:1:columCount
			{
				s:(k '= 1) json = json_","
				s tempdata = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(result.Data(result.GetColumnName(k)))
				s json = json_""""_result.GetColumnName(k)_""":"""_tempdata_""""
			}
			s json = json_"}"
		}
		s count = count + 1
	}
	d result.Close()
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

}
