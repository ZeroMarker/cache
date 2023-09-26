Class EMRservice.Ajax.patcureinfo Extends %CSP.Page
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
 	w ..GetCureInfoByAdm(interface,episodeId,idxStart,idxLast)
	Quit $$$OK
}

/// Desc:       取治疗记录
/// Creator:    Donglulu
/// Createdate: 2020-6-23
/// Input:      AInterFace 调用接口标识(默认HIS) 
///             AEpisodeIds:就诊号
/// OutPut:     
/// debug:      w ##Class(EMRservice.Ajax.patcureinfo).GetCureInfoByAdm("HIS","","","")
ClassMethod GetCureInfoByAdm(AInterFace As %String, AEpisodeIds As %String, AIdxStart As %Integer, AIdxLast As %Integer) As %String
{
	s json = ""
	s count = 0
	q:(AEpisodeIds = "") "{""total"":0,""rows"":["_json_"]}"
	
	s length = $l(AEpisodeIds,",")
	for I=1:1:length
	{
		s episodeId = $p(AEpisodeIds,",",I)

		s result = ##class(%ResultSet).%New("web.GetDocCure:GetCureInfoByAdm")
		d result.Execute(episodeId)
		
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
	}
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

}
