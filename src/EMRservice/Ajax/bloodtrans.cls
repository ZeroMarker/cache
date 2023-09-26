Class EMRservice.Ajax.bloodtrans Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	s interface = $Get(%request.Data("InterFace",1),"")
	s interface = $zcvt($zcvt(interface,"I","URL"),"I","UTF8")
	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	s json = ..GetBloodTransInfo(interface,episodeId,idxStart,idxLast)
	w json
	Quit $$$OK
}

/// Desc:       取输血情况
/// Creator:    Donglulu
/// Createdate: 2020-4-10
/// Input:      AInterFace 调用接口标识(默认HIS) 
///             AEpisodeID:就诊号
/// OutPut:     
/// debug:      w ##Class(EMRservice.Ajax.bloodtrans).GetBloodTransInfo("HIS","","","")
ClassMethod GetBloodTransInfo(AInterFace As %String, AEpisodeIds As %String, AIdxStart As %Integer, AIdxLast As %Integer) As %String
{
	
	s json = ""
	q:(AEpisodeIds = "") "{""total"":0,""rows"":["_json_"]}"
	s count = 0
	s length = $l(AEpisodeIds,",")
	for I=1:1:length
	{
		s episodeId = $p(AEpisodeIds,",",I)
		
		s result = ##class(%ResultSet).%New("DHCLIS.DHCBloodInterface:QryPackIssueInfo")
		d result.Execute(episodeId,"","","","","","","","","","","","","","")
		
		s columCount = result.GetColumnCount()
		while result.%Next()
		{
			s count = count + 1
			if ((AIdxStart <= count)&(count <= AIdxLast))
			{
				d setJson
			}
		}
	}
	d result.Close()
	s json = $e(json,1,$l(json)-1)
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
setJson
	s json = json_"{"
	for k=1:1:columCount
	{
		s:(k '= 1) json = json_","
		s tempdata = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(result.Data(result.GetColumnName(k)))
		s json = json_""""_result.GetColumnName(k)_""":"""_tempdata_""""
	}
	s json = json_"}"
	s json = json_","
}

}
